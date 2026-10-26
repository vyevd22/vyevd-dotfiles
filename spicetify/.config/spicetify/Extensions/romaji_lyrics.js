const kuroshiroPath = "https://cdn.jsdelivr.net/npm/kuroshiro@1.2.0/dist/kuroshiro.min.js";
const kuromojiPath = "https://cdn.jsdelivr.net/npm/kuroshiro-analyzer-kuromoji@1.1.0/dist/kuroshiro-analyzer-kuromoji.min.js";

const dictPath = "https:/cdn.jsdelivr.net/npm/kuromoji@0.1.2/dict";

class JapaneseTranslator {
	constructor() {
		this.includeExternal(kuroshiroPath);
		this.includeExternal(kuromojiPath);
		this.createKuroshiro();
		this.finished = false;
	}

	includeExternal(url) {
		var s = document.createElement("script");
		s.setAttribute("type", "text/javascript");
		s.setAttribute("src", url);
		var nodes = document.getElementsByTagName("*");
		var node = nodes[nodes.length - 1].parentNode;
		node.appendChild(s);
	}

	applyKuromojiFix() {
		if (typeof XMLHttpRequest.prototype.realOpen !== "undefined") return;
		XMLHttpRequest.prototype.realOpen = XMLHttpRequest.prototype.open;
		XMLHttpRequest.prototype.open = function (method, url, bool) {
			if (url.indexOf(dictPath.replace("https://", "https:/")) === 0) {
				this.realOpen(method, url.replace("https:/", "https://"), bool);
			} else {
				this.realOpen(method, url, bool);
			}
		};
	}

	async createKuroshiro() {
		if (typeof Kuroshiro === "undefined" || typeof KuromojiAnalyzer === "undefined") {
			setTimeout(this.createKuroshiro.bind(this), 50);
			return;
		}
		this.kuroshiro = new Kuroshiro.default();
		this.applyKuromojiFix();
		this.kuroshiro.init(new KuromojiAnalyzer({ dictPath: dictPath })).then(
			function () {
				this.finished = true;
				// translator just became ready — re-scan any lyrics already
				// rendered so they don't wait for line-by-line activity
				try {
					const R = Romaji_Lyrics;
					const divs = document.querySelectorAll(R.LYRIC_DIV_SELECTOR);
					for (const div of divs) R.handleElementSync(div);
					R.bulkTranslateAll();
				} catch (e) {}
			}.bind(this)
		);
	}

	async romanize(text, target = "romaji", mode = "spaced") {
		if (!this.finished) return text;
		return this.kuroshiro.convert(text, { to: target, mode: mode });
	}
}


class Romaji_Lyrics {
	// Classic selector (old builds). On new builds the real selector is
	// resolved at runtime by resolveLyricSelector() and cached here.
	static _lyricSelector = ".lyrics-lyricsContent-text";
	static get LYRIC_DIV_SELECTOR() {
		return Romaji_Lyrics._lyricSelector;
	}

	/**
	 * Resolve the lyric-line selector for the current build.
	 * New spotify builds use hashed classnames, so we detect lines by
	 * pattern: the most-repeated leaf-text-div class inside whichever
	 * lyrics view is currently open (main /lyrics page, fullscreen
	 * takeover, or right sidebar). Only runs when a lyrics view exists,
	 * so tracklists/queue rows can't false-positive.
	 */
	static resolveLyricSelector() {
		const OLD = ".lyrics-lyricsContent-text";
		if (document.querySelector(OLD)) {
			this._lyricSelector = OLD;
			return;
		}
		// current selector still matches lines -> it's valid, don't re-scan
		if (document.querySelector(this._lyricSelector)) return;
		// throttle: full scans are not free
		if (this._lastResolve && Date.now() - this._lastResolve < 400) return;
		this._lastResolve = Date.now();
		const onLyricsRoute = (function () {
			try {
				return Spicetify.Platform.History.location.pathname === "/lyrics";
			} catch (e) {
				return location.pathname === "/lyrics";
			}
		})();
		const fsOpen = !!document.querySelector(
			'button[aria-label="Minimize Now Playing view"]'
		);
		const sidebarOpen = !!document.querySelector(".Root__right-sidebar aside");
		if (!onLyricsRoute && !fsOpen && !sidebarOpen) return;

		const scopes = [];
		if (onLyricsRoute) scopes.push([".Root__main-view", false]);
		if (sidebarOpen) scopes.push([".Root__right-sidebar", false]);
		if (fsOpen) scopes.push(["body", true]); // overlay lives outside main-view

		let best = null;
		let bestCount = 0;
		for (const [sel, excludeMain] of scopes) {
			const root = document.querySelector(sel);
			if (!root) continue;
			const counts = new Map();
			for (const e of root.querySelectorAll("div")) {
				if (excludeMain && e.closest(".Root__main-view")) continue;
				if (e.children.length > 0) continue;
				const t = (e.textContent || "").trim();
				if (t.length < 2 || t.length > 120) continue;
				for (const c of e.classList) {
					if (c.startsWith("e-") || c.startsWith("encore") || c.startsWith("os-")) continue;
					counts.set(c, (counts.get(c) || 0) + 1);
				}
			}
			for (const [cls, n] of counts) {
				if (n > bestCount) {
					best = cls;
					bestCount = n;
				}
			}
		}
		if (best && bestCount >= 6) {
			const next = OLD + ", ." + best;
			if (next !== this._lyricSelector) {
				this._lyricSelector = next;
				// selector just changed -> a lyrics view appeared (possibly
				// while the translator was still loading). re-scan everything
				// so existing lines don't stay untranslated forever.
				setTimeout(() => {
					try {
						const divs = document.querySelectorAll(this.LYRIC_DIV_SELECTOR);
						for (const div of divs) this.handleElementSync(div);
						this.bulkTranslateAll();
					} catch (e) {}
				}, 60);
			}
		}
	}

	static translator = new JapaneseTranslator();
	static enabled = true;
	static mode = "romaji";
	static target = "spaced";

	// Cache: original Japanese line -> romaji line
	static lineCache = new Map();
	// Track if we're doing initial bulk translation
	static bulkTranslating = false;
	// Store the last known lyrics fingerprint to detect song changes
	static lastLyricsFingerprint = null;
	// The MutationObserver watching lyrics elements
	static lyricsObserver = null;
	// The MutationObserver watching for lyrics container to appear
	static containerObserver = null;
	static styleInjected = false;

	static injectStyle() {
		if (this.styleInjected) return;
		const style = document.createElement("style");
		style.id = "romaji-lyrics-style";
		// Hide lyrics that haven't been processed yet during Japanese songs.
		// .romaji-hide is added synchronously in the MutationObserver callback
		// BEFORE the browser paints, so the Japanese text is never visible.
		style.textContent = `
			.lyrics-lyricsContent-text.romaji-hide {
				visibility: hidden !important;
			}
		`;
		document.head.appendChild(style);
		this.styleInjected = true;
	}

	static processKatakanaMarkers(text) {
		const parts = text.split('$ KStartK $');
		if (parts.length <= 1) return text;
		let result = '';
		for (let j = 0; j < parts.length; j++) {
			const part = parts[j];
			const index = part.indexOf('$ KStopK $');
			if (index === -1) {
				result += part;
			} else {
				result += part.substring(0, index).toUpperCase();
				result += part.substring(index + '$ KStopK $'.length);
			}
		}
		return result;
	}

	static isJapanese(f) {
		return /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g.test(f);
	}

	/**
	 * Called synchronously from MutationObserver - MUST be fast.
	 * If we have a cached translation, replace the text immediately
	 * (before the browser paints). If not, hide the element until
	 * async translation completes.
	 */
	static handleElementSync(el) {
		// tag every lyric line so user.css can theme the font
		// (new builds use hashed classes; this is the reliable hook)
		el.classList.add("hyprlain-lyric");
		if (!this.enabled || !this.translator.finished) return;

		const text = el.textContent;
		if (!text || !this.isJapanese(text)) {
			// Not Japanese - make sure it's visible
			el.classList.remove("romaji-hide");
			return;
		}

	// Check cache - if we have a translation, replace SYNCHRONOUSLY
		// This happens in the same microtask as the DOM mutation,
		// so the browser never paints the Japanese text
		if (this.lineCache.has(text)) {
			el.innerHTML = this.lineCache.get(text);
			el.classList.remove("romaji-hide");
			return;
		}

		// persistent cache (localStorage) — survives restarts, makes
		// previously-translated songs instant even before kuroshiro loads
		const stored = this.lsGet(text);
		if (stored !== null) {
			this.lineCache.set(text, stored);
			el.innerHTML = stored;
			el.classList.remove("romaji-hide");
			return;
		}

		// No cache hit - hide element and translate async
		el.classList.add("romaji-hide");
		this.translateSingleElement(el, text);
	}

	/**
	 * Async translation for a single element that wasn't in cache.
	 */
	static lsGet(text) {
		try { return localStorage.getItem("romaji:" + text); } catch (e) { return null; }
	}
	static lsSet(text, val) {
		try { localStorage.setItem("romaji:" + text, val); } catch (e) {}
	}

	static async translateSingleElement(el, originalText) {
		try {
			const result = await this.translator.romanize(originalText, this.mode, this.target);
			const processed = this.processKatakanaMarkers(result);
			this.lineCache.set(originalText, processed);
			this.lsSet(originalText, processed);

			// Only update if the element still has the same original text
			// (it might have been changed again by Spotify)
			if (el.textContent === originalText || el.classList.contains("romaji-hide")) {
				el.innerHTML = processed;
				el.classList.remove("romaji-hide");
			}
		} catch (e) {
			// On error, just show the original
			el.classList.remove("romaji-hide");
		}
	}

	/**
	 * Pre-translate ALL lyrics lines when a new song loads.
	 * This populates the cache so that when Spotify re-renders
	 * individual lines (active line), we can replace synchronously.
	 */
	static async bulkTranslateAll() {
		if (this.bulkTranslating || !this.translator.finished || !this.enabled) return;
		this.bulkTranslating = true;

		try {
			const divs = document.querySelectorAll(this.LYRIC_DIV_SELECTOR);
			if (!divs || divs.length === 0) return;

			// hide every Japanese line up front, then translate all of them
			// in parallel — each line un-hides itself as its result lands
			const jobs = [];
			for (const div of divs) {
				const text = div.textContent;
				if (!text || this.lineCache.has(text) || !this.isJapanese(text)) continue;
				div.classList.add("romaji-hide");
				jobs.push(this.translateSingleElement(div, text));
			}
			await Promise.all(jobs);
		} finally {
			this.bulkTranslating = false;
		}
	}

	static startObserving() {
		// Observer for individual lyrics elements - catches Spotify re-rendering
		// lines when they become the "active" (currently sung) line
		this.lyricsObserver = new MutationObserver((mutations) => {
			if (!this.enabled || !this.translator.finished) return;

			for (const mutation of mutations) {
				if (mutation.type === 'characterData') {
					// Text content changed - find the lyrics div parent
					let el = mutation.target.parentElement;
					while (el && !el.matches(this.LYRIC_DIV_SELECTOR)) {
						el = el.parentElement;
					}
					if (el) this.handleElementSync(el);
				}

				if (mutation.type === 'childList') {
					// New nodes added - check if they're lyrics divs or contain them
					for (const node of mutation.addedNodes) {
						if (node.nodeType !== Node.ELEMENT_NODE) continue;

						if (node.matches && node.matches(this.LYRIC_DIV_SELECTOR)) {
							this.handleElementSync(node);
						}

						// Also check children
						if (node.querySelectorAll) {
							const lyricDivs = node.querySelectorAll(this.LYRIC_DIV_SELECTOR);
							for (const div of lyricDivs) {
								this.handleElementSync(div);
							}
						}
					}
				}
			}
		});

		this.watchForContainer();
	}

	static watchForContainer() {
		const attachToContainer = () => {
			// keep the selector fresh for this build/view
			this.resolveLyricSelector();
			// old-build containers, body-wide fallback for new builds
			// (the observer filters through LYRIC_DIV_SELECTOR anyway)
			const container = document.querySelector(
				".lyrics-lyricsContent-provider, .lyrics-lyrics-contentContainer, .lyrics-lyrics-contentWrapper"
			) || document.body;
			if (container && !container._romajiWatching) {
				container._romajiWatching = true;
				this.lyricsObserver.observe(container, {
					childList: true,
					subtree: true,
					characterData: true
				});

				// Initial scan: process all existing lyrics
				const divs = container.querySelectorAll(this.LYRIC_DIV_SELECTOR);
				for (const div of divs) {
					this.handleElementSync(div);
				}

				// Kick off bulk pre-translation to fill cache
				this.bulkTranslateAll();
			}
		};

		// Watch for the lyrics panel appearing
		this.containerObserver = new MutationObserver(() => { attachToContainer(); });
		this.containerObserver.observe(document.body, { childList: true, subtree: true });
		attachToContainer();
	}

	// Fallback: also watch for song changes to clear/rebuild cache
	static watchSongChanges() {
		let lastUri = null;
		const check = () => {
			try {
				const data = Spicetify.Player.data;
				// new builds may use data.track instead of data.item
				const item = data && (data.item || data.track);
				const uri = item && item.uri;
				if (uri && uri !== lastUri) {
					lastUri = uri;
					// New song - clear cache and re-translate
					this.lineCache.clear();
					// Small delay for lyrics to load
					setTimeout(() => {
						const divs = document.querySelectorAll(this.LYRIC_DIV_SELECTOR);
						for (const div of divs) this.handleElementSync(div);
						this.bulkTranslateAll();
					}, 500);
				}
			} catch (e) {}
			setTimeout(check, 1000);
		};
		check();
	}

	static addControlUI() {
		const trap = new Mousetrap();
		trap.handleKey = (character, modifiers, e) => {
			if (e.type == "keydown") {
				if (character == "tab" && modifiers.includes("ctrl")) {
					this.enabled = !this.enabled;
					this.lineCache.clear();

					if (this.enabled) {
						const divs = document.querySelectorAll(this.LYRIC_DIV_SELECTOR);
						for (const div of divs) this.handleElementSync(div);
						this.bulkTranslateAll();
					} else {
						// Disabled: show original text by reloading lyrics
						const divs = document.querySelectorAll(this.LYRIC_DIV_SELECTOR);
						for (const div of divs) div.classList.remove("romaji-hide");
					}

					Spicetify.showNotification(
						this.enabled ? "Romaji lyrics: ON" : "Romaji lyrics: OFF"
					);
				}
			}
		};
	}
}

(function romaji_lyrics() {
	new Romaji_Lyrics();
	Romaji_Lyrics.injectStyle();
	Romaji_Lyrics.addControlUI();
	Romaji_Lyrics.startObserving();
	Romaji_Lyrics.watchSongChanges();
})();
