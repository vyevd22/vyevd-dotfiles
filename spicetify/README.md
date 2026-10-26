# spicetify — the Hyprlain setup

spotify client customized to match the rest of the rice: pitch black,
pink (`#ce7688`) accents, VGA-ish mono fonts, spinning vinyl cover art,
romaji lyrics. built for spotify `1.3.4.258` + spicetify `2.46.4`.

**not tracked here** (runtime junk, reinstall via marketplace if needed):
`CustomApps/` (marketplace), `Extensions/` except `romaji_lyrics.js`
(adblock.js was removed on purpose — premium; lastfm/volumePercentage are
marketplace-standard). reinstall order: spicetify → marketplace →
lastfm.js + volumePercentage.js → `spicetify apply`.

## the three layers

spotify re-hashes its CSS classnames **every build**, so hardcoded
selectors rot. this setup is built to survive that:

| layer | file | job |
|-------|------|-----|
| static CSS | `Themes/Hyprlain/user.css` | everything class-stable: homepage shelf hiding, lyric color variables, vinyl animation, fonts |
| runtime tagger | `Themes/Hyprlain/theme.js` | everything class-unstable. tags elements by *behavior* and lets CSS style the tags |
| pattern matcher | `Extensions/romaji_lyrics.js` | finds lyric lines by *pattern* (repeated leaf-text-div class), translates via kuroshiro |

### theme.js — the runtime tagger

runs on every DOM mutation. two-phase:

- **pre-paint fast path** (in the MutationObserver callback, before the
  browser paints): any added/changed big empty div with a vivid or
  gradient background gets `[data-hyprlain-ambient]` → CSS neutralizes it.
  this is what stops the color flash when leaving the lyrics page.
- **100ms debounced sweep**: vinyl tagging (big square imgs →
  `.hyprlain-vinyl`), sidebar section hiding by h2 **text** (`HIDE_SECTIONS`
  at the top of the file), ambient sweep as safety net.

it also redirects the bottom-bar **Lyrics button** to the main-view
`/lyrics` page (toggle) instead of spotify's fullscreen takeover.

### romaji_lyrics.js — the lyrics engine

- resolves the current build's lyric-line class by counting repeated
  leaf-text-div classes inside whichever lyrics view is open (gated: only
  when a lyrics view exists, so tracklists/queue rows can't match)
- translates via kuroshiro + kuromoji (loaded from jsdelivr CDN at runtime)
- **localStorage cache** (`romaji:<line>`): translations survive restarts —
  already-played songs display instantly, even before kuroshiro loads
- when the translator finishes initializing it re-scans any lyrics
  already on screen (no trickle-in)
- `ctrl+tab` toggles romaji on/off

### user.css — the instant rules that matter

- `[data-testid='home-page'] .main-home-content > section:not(.view-homeShortcutsGrid-shortcuts)` — hides every recommendation shelf, keeps your shortcuts (the green/blue gradient cards live inside those shelves and die with them)
- `* { --lyrics-color-*: … }` — spotify derives lyric colors from cover art (Monstruo = mint green wall of text). forced to the palette: active `#ce7688`, inactive/passed `#804654`, messaging `#c1b48e`
- `[style*="--lyrics-color"] div` — instant lyric font (20px, tight rows) the frame they render, no JS wait
- `div:has(> .hyprlain-lyric)` — lyric row margin 4px (spotify default is 28.8px)
- belt-and-suspenders: this build's known ambient classnames neutralized
  directly (`StXaJR8ueLDRsntBN79Y` fullscreen gradient, `nqmjceMqTFCSMXlnquLP`
  lyrics-page wash, `jjYvT9hB5E7h_ej5qzyw` vinyl radial glow,
  `dqwQhIudKoD98eWJzj5E` home hero card) — zero-race instant kill; theme.js
  covers any *new* layers future builds invent

## when a spotify update breaks things

| symptom | cause | fix |
|---------|-------|-----|
| vinyl stops spinning | cover img class/testid changed | theme.js tags by size+shape — usually self-heals. if the cover is no longer an `<img>`, extend `tagVinyls()` |
| color flash / ambient glow returns | new ambient layer class | add the class to the belt-and-suspenders list in `user.css`; verify the tagger catches it with `spotify-probe` |
| romaji dead | lyric line class changed | the pattern resolver handles it; if not, check `spotify-probe lyrics` output and the `resolveLyricSelector()` gates |
| sidebar shows unwanted sections | new section type | add its exact h2 text to `HIDE_SECTIONS` in `theme.js` |
| lyrics open fullscreen again | Lyrics button aria-label changed | check the label match in `hookLyricsButton()` in `theme.js` |
| whole panel/sidebar blank | a broken extension crash-looping | check the console (`spotify-probe`) for a spamming extension, remove it from `config-xpui.ini`, `spicetify apply` |

after fixing: `spicetify apply`, fully restart spotify.

## debugging: `spotify-probe`

spotify is chromium — launch it with `--remote-debugging-port=9222
--remote-allow-origins='*'` and you can interrogate the live DOM from a
terminal (needs `python-websocket-client`, a.k.a. `pip install --user
--break-system-packages websocket-client`). `spotify-probe` (in
`scripts/`) wraps it:

```
spotify-probe launch            # restart spotify WITH the debug port
spotify-probe state             # view/panel/button state overview
spotify-probe lyrics            # lyric lines, tags, font, cache state
spotify-probe ambient           # every painted gradient/vivid element
spotify-probe covers            # cover-art elements + animation status
spotify-probe sections          # right-sidebar sections + visibility
spotify-probe exec '<js>'       # evaluate arbitrary JS in the page
spotify-probe close             # restart spotify clean (no debug port)
```

the classic loop: `spotify-probe launch` → poke with the canned probes
or `exec` → find what the element actually is now → fix the matching
layer → `spicetify apply` → `spotify-probe close`.

the fullscreen now-playing view lives **outside** `.Root__main-view`
(body-level overlay) and its cover is a plain `<img>` with only a hashed
class, no testid/aria — that's why probes scoped to main-view or
filtered on "cover" classnames kept missing it. remember that.
