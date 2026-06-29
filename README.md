# the vyevdfiles

komputah komputah is this an epstein reference
<br>
no this is my arch linux rice
<br>
themed around the #1 LARP of 2026
<br>
serial experiments lain 🗣️
<br>
<sub>(im not a larper i swear i watched the show 😢)</sub>

## palette

```
pale pink  #D27389   — primary accent
dark pink  #8A3F52   — ominous/menacing 😱 (literally just for my username on the starship prompt iirc)
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
| `kitty/kitty.conf` | terminal — pxplus ibm vga8 font, monochrome palette, pink accent, crtty |
| `waybar/` | status bar — vga font, bracketed workspaces `[1] [2] [3]`, cava vis, terminal-style |
| `starship.toml` | prompt — pink backbone, dark crimson username, gold @hostname and ❯ |
| `fastfetch/` | system info — pink section boxes, gold labels, lain ascii art |
| `rofi/` | app launcher and emoji picker and cliphist viewer — vga font, no icons, `❯` prompt, steel gray selection |
| `swaync/` | notification daemon — crt scanlines, solid black, pink mpris accent, terminal close button |
| `wlogout/` | powermenu — text-only buttons, steel gray borders, pink/magenta hover, looks kinda ugly but i dont care cus its tuff |
| `nvim/init.lua` | editor — pink smear cursor :3 |
| `mpv/mpv.conf` | video player settings |
| `.bashrc` | shell setup — ble.sh, pink prompt accent |
| `.local/bin/rofi-wifi-menu.sh` | wifi menu script |
| `.local/share/sddm/themes/lain/` | login screen — lain terminal theme, vga font, blinking cursor, full-screen scanlines |

## requirements

you'll need these installed for the rice to work as intended

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
- fastfetch
- swww-daemon / awww-daemon for the wallpaper
- pyprland (scratchpads)
- cliphist (clipboard history)
- grimblast / hyprland-contrib (screenshots)
- wl-clipboard (wayland clipboard)
- playerctl (mpris controls)
- pavucontrol / wpctl (audio)
- gpu-screen-recorder (medal alternative nonsense thingy to clip 30 seconds, auto-compresses with ffmpeg)
- thunar (file manager)
- ble.sh (better bash completion)
- crtty (crt shader for kitty)

**fonts**
- PxPlus IBM VGA8 (retro terminal font, main everywhere — has Greek/Cyrillic)
- JetBrainsMono Nerd Font (nerd font fallback for icons, cava blocks)
- Hina Mincho (Japanese kanji fallback)

## notes

- borderless hyprland. shadow color is pink-tinted (`rgba(bb60970d)`).
- ive also been debating on whether to remove the shadows as well and just make it COMPLETELY borderless, or atleast make the shadows even harder to spot or something.
- kitty has crtty for the retro scanline/phosphor look. just run SUPER+SHIFT+Q (thats the default keybind) to run a normal kitty terminal without any of the CRT aesthetic nonsense.
- fastfetch logo is just lain colored pink.
- sddm theme is at `/usr/share/sddm/themes/lain/` on my system (symlinked from the tracked path). needs sudo to set up.
- GRUB theme at `/boot/grub/themes/lain/` — Braille Lain ascii art, fastfetch mockup, terminal-style boot menu. not tracked in this repo (lives in /boot).
- font stack: `"PxPlus IBM VGA8"` → `"JetBrainsMono Nerd Font"` → `"Hina Mincho"` → `monospace`. pxplus replaces mx437 1:1 with identical glyphs + greek/cyrillic support.
- the `config` alias is a bare git repo at `~/.cfg` with `work-tree=$HOME`. nothing fancy.
