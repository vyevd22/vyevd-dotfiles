// === LIGHTWEIGHT PRIVACY (invisible only) ===
// No visual changes, no login breakage, nothing taken away

// Tracking protection — block fingerprinting & cryptominers
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);

// Disable hyperlink ping tracking
user_pref("browser.send_pings", false);

// Reduce timer precision (Spectre mitigation)
user_pref("privacy.reduceTimerPrecision", true);
user_pref("browser.search.defaultenginename", "Google");
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// less flickery feel, doesn't break anything
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
