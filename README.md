# the vyevdfiles

komputah komputah is this an epstein reference

## palette

```
pale pink  #D27389   primary thingymajiggy
dark pink  #8A3F52   literally just for my username on the starship prompt iirc
gold       #E6D47B   highlights and labels
steel gray #6a7a8a   info stuff
text gray  #cdd3e0   readable text
black      #000000   base
```

## what's here

| thing | what it does |
|-------|-------------|
| `hypr/` | window manager config |
| `hypr/hyprlock.conf` | lock screen... dumahh... |
| `kitty/kitty.conf` | terminal with pxplus ibm vga8 font, monochrome palette, pink accent, crtty |
| `waybar/` | status bar with a vga font, bracketed workspaces `[1] [2] [3]`, cava vis, terminal-style |
| `starship.toml` | prompt with pink backbone, dark crimson username, gold @hostname and ❯ |
| `fastfetch/` | system info with pink section boxes, gold labels, lain ascii art |
| `rofi/` | app launcher and emoji picker and cliphist viewer; vga font, no icons, `❯` prompt, steel gray selection |
| `swaync/` | notification daemon |
| `wlogout/` | powermenu grahhhh, looks kinda ugly but i dont care cus its tuff |
| `nvim/init.lua` | editor with a pink smear cursor :3 |
| `mpv/mpv.conf` | video player settings |
| `.bashrc` | shell setup (ble.sh) |
| `.local/bin/rofi-wifi-menu.sh` | wifi menu script if u need it but i use ethernet so i havent even tested if it works |
| `.local/share/sddm/themes/lain/` | login screen |

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
- awww-daemon for the wallpaper (previously known as swww)
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
- fastfetch logo is just lain colored pink.
- sddm theme is at `/usr/share/sddm/themes/lain/` on my system (symlinked from the tracked path). needs sudo to set up.
- custom GRUB theme at `/boot/grub/themes/lain/` Lain ascii art, fastfetch 'mockup', terminal-style boot menu. not tracked in this repo cus it lives in /boot
- font stack is `"PxPlus IBM VGA8"` → `"JetBrainsMono Nerd Font"` → `"Hina Mincho"` (all in monospace if possible).
- the `config` alias is a bare git repo at `~/.cfg` with `work-tree=$HOME`. nothing fancy.
