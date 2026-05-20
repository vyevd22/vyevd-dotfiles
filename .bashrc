#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach
[[ $- != *i* ]] && return

export XDG_CACHE_HOME="$HOME/.cache"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

fastfetch

export PATH="$HOME/.local/bin:$PATH"
verse
eval "$(starship init bash)"

# ble.sh styling
ble-face -s auto_complete fg=#4061a0
ble-face -s syntax_error fg=#BB607B
ble-face -s syntax_command fg=#e6d47b
ble-face -s command_builtin fg=#e6d47b
ble-face -s syntax_comment fg=#2a3d5e
ble-face -s command_file fg=#cdd3e0
ble-face -s command_alias fg=#4061a0
ble-face -s command_keyword fg=#BB607B
ble-face -s syntax_quotation fg=#5a9e6f
ble-face -s syntax_quoted fg=#5a9e6f
ble-face -s syntax_param_expansion fg=#e6d47b
ble-face -s syntax_varname fg=#e6d47b

[[ ${BLE_VERSION-} ]] && ble-attach

export PATH=$PATH:/home/vyevd/.spicetify
export EDITOR=nvim
export VISUAL=nvim
export PATH="$HOME/.npm-global/bin:$PATH"
export PARALLEL_API_KEY=RExl9YLl3vz2UpdaebjGLrMZFwdkkOtRFZkGUA9F

alias stwindows='sudo grub-reboot "Windows Boot Manager" && reboot'
alias config='git --git-dir="$HOME/.cfg" --work-tree="$HOME"'
