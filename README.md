# the vyevdfiles

komputah komputah is this an epstein reference

Lain-only Hyprland rice on Arch btw. pink terminals, VGA fonts, bracketed workspaces `[1] [2] [3]`.

## install

```bash
git clone https://github.com/vyevd22/vyevd-dotfiles ~/dotfiles
cd ~/dotfiles
sudo pacman -S stow
stow bash calcurse fastfetch hypr kitty mpv nvim rofi scripts sddm starship swaync systemd waybar wlogout
```

per-package if you only want pieces: `stow hypr kitty` etc. verify with `ls -l ~/.config/<thing>/` — stowed files show as symlinks (`->`) into `~/dotfiles`.

after stowing hypr: `hyprctl reload`. after waybar: `pkill waybar; waybar & waybar -c ~/.config/waybar/config-dp3.jsonc & disown`.

**manual steps stow can't do:**
- sddm theme deploys with sudo: `sudo cp ~/dotfiles/sddm/.local/share/sddm/themes/lain/* /usr/share/sddm/themes/lain/`
- secrets live outside the repo: `~/.parallel-env` (mode 600), sourced from `.bashrc` if present. never commit it.
- GRUB theme lives in `/boot/grub/themes/lain/`, not tracked here cause im lazy

## what's here

| package | what it does |
|-------|-------------|
| `hypr/` | window manager + lock screen, lua configs (`hyprland.lua`, `hyprlock.lua`) |
| `kitty/` | terminal with pxplus ibm vga8 font, monochrome palette, pink accent |
| `waybar/` | status bar, vga font, bracketed workspaces, cava vis, terminal-style. `config-dp3.jsonc` is the left-monitor bar |
| `rofi/` | app launcher, emoji picker, clipboard picker and powermenu; vga font, no icons, `❯` prompt, steel gray selection |
| `scripts/` | `kp-rofi` (keepassxc picker, `SUPER+K`), `rofi-wifi-menu.sh`, `screensaver`, `waybar-gpu` (bar helper), `kitty-plain`, `false9` + `spoti-*` launchers (thin wrappers into `~/Projects/`) |
| `swaync/` | notification daemon |
| `calcurse/` | calendar/organizer config, notify-daemon wrapper + morning digest scripts, ding sound. the actual calendar data (`~/.local/share/calcurse`) is deliberately NOT tracked — appointments are personal and the daemon log is runtime junk |
| `wlogout/` | powermenu grahhhh, looks kinda ugly but i dont care cus its tuff |
| `nvim/` | editor with a pink smear cursor :3 (`init.lua` + `lazy-lock.json`) |
| `mpv/` | video player settings |
| `bash/` | shell setup (ble.sh, starship hook, aliases) |
| `starship/` | prompt with pink backbone, dark crimson username, steel @hostname, gold directory and ❯ |
| `fastfetch/` | system info with pink section boxes, steel labels, lain ascii art |
| `systemd/` | user services: gpu-screen-recorder replay capture, calcurse notification daemon + 08:00 digest timer |
| `sddm/` | login screen theme sources (deploy with sudo, see above) |

## personal bits (won't work as-is elsewhere)

- `hypr/`: monitor names/rates (DP-3, HDMI-A-1), keyboard layouts (us,gr,de), mouse sensitivity. edit to taste.
- `bash/`: android SDK paths, spicetify. my tools... just delete what you don't use.
- `systemd/`: mic device string is my USB mic. replace with yours (`pactl list sources`).
- wallpaper `~/Pictures/Wallpapers/Lets_All_Love_Lain.jpeg` isn't tracked. bring your own.
- `fastfetch/`: GPU string is hardcoded to mine as a terrible little workaround to a nitpick i had, dont ask 👅

## palette

```
pale pink  #D27389   primary thingymajiggy
dark pink  #8A3F52   literally just for my username on the starship prompt iirc
gold       #E6D47B   highlights and labels
steel gray #6a7a8a   info stuff
text gray  #cdd3e0   readable text
black      #000000   base
```

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
- stow + git (to install this repo at all dumahh)

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
- yazi (file manager, launched inside kitty)
- ble.sh (better bash completion)
- keepassxc + keepassxc-cli (password picker backend)
- discord-mpris-rs (media info for the bar)

**fonts**
- PxPlus IBM VGA8 (retro terminal font, main everywhere — has Greek/Cyrillic)
- JetBrainsMono Nerd Font (nerd font fallback for icons, cava blocks)
- Hina Mincho (Japanese kanji fallback)

## notes (mostly for... myself... cus im forgetful...)

- 1px borders, pink gradient when active (`#D27389` -> `#BB607B`), dark when inactive
- fastfetch logo is lain with a pink colour, i would show but im lazy
- monitors are hardcoded, DP-3 (Philips 273B9, 75Hz) left, HDMI-A-1 (some ASUS monitor, 100Hz) right. dual `waybar` instances, one per screen.
- custom GRUB theme at `/boot/grub/themes/lain/` Lain ascii art, fastfetch 'mockup', terminal-style boot menu. not tracked in this repo cus it lives in /boot, ill CONSIDER including it.
- font stack is `"PxPlus IBM VGA8"`, `"JetBrainsMono Nerd Font"` and `"Hina Mincho"` (all in monospace if possible).
- repo is stow-based which i still dont quite get how it works or what it means but real files live in `~/dotfiles/<package>/`, system paths hold symlinks. edit either end, same file.
