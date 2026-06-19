# vyevd-dotfiles

my arch linux rice. theme is serial experiments lain 🗣️

## palette

```
pale pink  #D27389   — primary accent
dark pink  #8A3F52   — ominous/menacing (username)
gold       #E6D47B   — highlights, prompt, labels
steel gray #6a7a8a   — structure, neutral info
text gray  #cdd3e0   — readable text
black      #000000   — base
```

## what's here

| thing | what it does |
|-------|-------------|
| `hypr/` | window manager config. borderless, pink-magenta gradient borders, lain wallpaper, crtty as default terminal |
| `hypr/hyprlock.conf` | lock screen — crt phosphor glow, system info, terminal login banner |
| `kitty/kitty.conf` | terminal — mx437 ibm vga 8x16 font, monochrome palette, pink accent |
| `waybar/` | status bar — vga font, bracketed workspace numbers `[1] [2] [3]`, terminal-style |
| `starship.toml` | prompt — pink backbone, dark crimson username, gold @hostname and ❯ |
| `fastfetch/` | system info — pink section boxes, gold labels, lain ascii art |
| `rofi/` | app launcher + powermenu — vga font, no icons, `❯` prompt, steel gray selection |
| `swaync/` | notification daemon — crt scanlines, solid black, pink mpris accent, terminal close button |
| `wlogout/` | powermenu — text-only buttons, steel gray borders, pink/magenta hover |
| `nvim/init.lua` | editor config (lazy, lsp-zero, etc) |
| `mpv/mpv.conf` | video player settings |
| `.bashrc` | shell setup — ble.sh, pink prompt accent |
| `.local/bin/rofi-wifi-menu.sh` | wifi menu script |
| `.local/share/sddm/themes/lain/` | login screen — lain terminal theme, vga font, blinking cursor, full-screen scanlines |

## requirements

you'll need these installed for the rice to work as intended:

**core**
- hyprland (wm)
- kitty (terminal)
- waybar (bar)
- rofi (launcher) v2.0.0+
- swaync (notifications)
- wlogout (logout menu)
- hyprlock (lock screen)
- sddm (login manager)

**utils**
- starship (prompt)
- fastfetch (system info)
- awww (wallpaper)
- pyprland (scratchpads)
- cliphist (clipboard history)
- grimblast / hyprland-contrib (screenshots)
- wl-clipboard (wayland clipboard)
- playerctl (mpris controls)
- pavucontrol / wpctl (audio)
- gpu-screen-recorder (replay capture)
- thunar (file manager)
- ble.sh (better bash completion)
- crtty (crt shader for kitty)

**fonts**
- Mx437 IBM VGA 8x16 (retro terminal font, main everywhere)
- JetBrainsMono Nerd Font (nerd font fallback for icons)

## notes

- borderless hyprland. shadow color is pink-tinted (`rgba(bb60970d)`).
- kitty has crtty for the retro scanline/phosphor look. run `kitty-plain` to bypass it. wait why did i even do that? just run SUPER+SHIFT+Q i literally added that-
- fastfetch logo is the ryo/bocchi ascii art i found somewhere, colored pink.
- sddm theme is at `/usr/share/sddm/themes/lain/` on my system (symlinked from the tracked path). needs sudo to set up.
- the `config` alias is a bare git repo at `~/.cfg` with `work-tree=$HOME`. nothing fancy.
