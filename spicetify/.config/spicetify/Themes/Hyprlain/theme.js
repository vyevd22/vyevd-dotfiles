/* Hyprlain theme.js — runtime tagging that survives spotify's hashed classnames.
 * 1. Tags big square cover imgs -> .hyprlain-vinyl (spun via user.css)
 * 2. Tags big text-less gradient layers -> [data-hyprlain-ambient] (hidden via user.css)
 * 3. Hides right-sidebar sections by header text (Credits etc.)
 */
(function () {
  var HIDE_SECTIONS = ["Credits", "About the artist", "On tour"];
  var MAX_CLIMB = 4;      // levels above the h2
  var MAX_SECTION_H = 600; // never treat anything taller as a "section"

  function hideSections() {
    var scope = document.querySelector(".Root__right-sidebar");
    if (!scope) return;
    var headers = scope.querySelectorAll("h2");
    // wait until sections have actually rendered — climbing while only one
    // h2 exists escapes into shared wrappers and hides unrelated sections
    if (headers.length < 3) return;
    for (var i = 0; i < headers.length; i++) {
      var h = headers[i];
      var text = (h.textContent || "").trim();
      if (HIDE_SECTIONS.indexOf(text) === -1) continue;
      // climb to the outermost ancestor that contains ONLY this header,
      // but never above MAX_CLIMB levels or beyond panel-sized elements
      var cur = h;
      var climbed = 0;
      while (cur.parentElement &&
             climbed < MAX_CLIMB &&
             cur.parentElement.querySelectorAll("h2").length === 1 &&
             cur.parentElement.getBoundingClientRect().height < MAX_SECTION_H) {
        cur = cur.parentElement;
        climbed++;
      }
      if (cur && cur !== h && cur.getBoundingClientRect().height < MAX_SECTION_H) {
        cur.style.display = "none";
      }
    }
  }

  function tagVinyls() {
    var imgs = document.querySelectorAll("img");
    for (var i = 0; i < imgs.length; i++) {
      var img = imgs[i];
      if (img.classList.contains("hyprlain-vinyl")) continue;
      var r = img.getBoundingClientRect();
      if (r.width < 200) continue;
      // square-ish only (covers are square, banners are not)
      if (Math.abs(r.width - r.height) > r.width * 0.15) continue;
      img.classList.add("hyprlain-vinyl");
      var frame = img.parentElement;
      if (frame && frame.getBoundingClientRect().width < r.width * 1.6) {
        frame.classList.add("hyprlain-vinyl-frame");
      }
    }
  }

  // per-element ambient check (used by the pre-paint fast path + the sweep)
  function checkAmbient(e) {
    if (!e || !e.setAttribute) return false;
    if (e.hasAttribute("data-hyprlain-ambient")) return false;
    if (e.childElementCount > 0) return false;
    if ((e.textContent || "").trim()) return false;
    var r = e.getBoundingClientRect();
    if (r.width < 300 || r.height < 200) return false;
    var cs = window.getComputedStyle(e);
    var bi = cs.backgroundImage;
    // vivid solid color (ambient washes are cover-derived, never gray)
    var isVivid = false;
    var m = cs.backgroundColor.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/);
    if (m) {
      var mx = Math.max(+m[1], +m[2], +m[3]);
      var mn = Math.min(+m[1], +m[2], +m[3]);
      isVivid = mx > 60 && mx - mn > 30;
    }
    // decorative gradient: carries an image, or a saturated color stop.
    // pure black-alpha fades (card text protection) are left alone.
    var isDecor = false;
    if (bi && bi.indexOf("gradient") !== -1) {
      if (bi.indexOf("url(") !== -1) {
        isDecor = true;
      } else {
        var stops = bi.match(/rgba?\(\s*\d+\s*,\s*\d+\s*,\s*\d+/g) || [];
        for (var s = 0; s < stops.length; s++) {
          var parts = stops[s].match(/\d+/g);
          var pmx = Math.max(+parts[0], +parts[1], +parts[2]);
          var pmn = Math.min(+parts[0], +parts[1], +parts[2]);
          if (pmx > 60 && pmx - pmn > 30) {
            isDecor = true;
            break;
          }
        }
      }
    }
    if (isVivid || isDecor) {
      e.setAttribute("data-hyprlain-ambient", "1");
      return true;
    }
    return false;
  }

  function killAmbient() {
    // whole body: the fullscreen now-playing overlay lives OUTSIDE .Root__main-view
    var divs = document.querySelectorAll("body div");
    for (var i = 0; i < divs.length; i++) {
      checkAmbient(divs[i]);
    }
  }

  function hookLyricsButton() {
    if (window.__hyprlainLyricsHooked) return;
    window.__hyprlainLyricsHooked = true;
    // new build: the Lyrics button opens the fullscreen takeover.
    // redirect it to the main-view lyrics page instead (toggle).
    document.addEventListener("click", function (e) {
      var t = e.target;
      var b = t && t.closest ? t.closest("button") : null;
      if (!b) return;
      var a = (b.getAttribute("aria-label") || "").trim().toLowerCase();
      if (a !== "lyrics") return;
      e.preventDefault();
      e.stopImmediatePropagation();
      try {
        var loc = Spicetify.Platform.History.location.pathname;
        Spicetify.Platform.History.push(loc === "/lyrics" ? "/" : "/lyrics");
      } catch (err) {}
    }, true);
  }

  // pre-paint fast path: the MutationObserver callback runs as a microtask
  // BEFORE the browser paints, so ambient layers get neutralized before a
  // single colored frame can flash
  function fastAmbient(mutations) {
    for (var i = 0; i < mutations.length; i++) {
      var mut = mutations[i];
      if (mut.type === "attributes") {
        checkAmbient(mut.target);
        // class/style changes on big containers restyle their descendants
        // (gradient applied via cascade) — scan the subtree too, pre-paint
        var tRect = mut.target.getBoundingClientRect && mut.target.getBoundingClientRect();
        if (tRect && tRect.width > 400 && mut.target.querySelectorAll) {
          var kids2 = mut.target.querySelectorAll("div");
          for (var q = 0; q < kids2.length && q < 40; q++) {
            checkAmbient(kids2[q]);
          }
        }
        continue;
      }
      if (!mut.addedNodes) continue;
      for (var j = 0; j < mut.addedNodes.length; j++) {
        var n = mut.addedNodes[j];
        if (!n || n.nodeType !== 1) continue;
        if (n.tagName === "DIV") checkAmbient(n);
        if (n.querySelectorAll) {
          var kids = n.querySelectorAll("div");
          for (var k = 0; k < kids.length && k < 40; k++) {
            checkAmbient(kids[k]);
          }
        }
      }
    }
  }

  var scheduled = false;
  function run() {
    if (scheduled) return;
    scheduled = true;
    window.setTimeout(function () {
      scheduled = false;
      try { hideSections(); } catch (e) {}
      try { tagVinyls(); } catch (e) {}
      try { killAmbient(); } catch (e) {}
    }, 100);
  }

  new MutationObserver(function (mutations) {
    try { fastAmbient(mutations); } catch (e) {}
    run();
  }).observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ["class", "style"],
  });
  hookLyricsButton();
  run();
})();
