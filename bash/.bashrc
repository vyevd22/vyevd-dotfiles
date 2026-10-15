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

eval "$(starship init bash)"

# ble.sh styling
ble-face -s auto_complete fg=#D27389
ble-face -s syntax_error fg=#BB607B
ble-face -s syntax_command fg=#D27389
ble-face -s command_builtin fg=#D27389
ble-face -s syntax_comment fg=#2a3d5e
ble-face -s command_file fg=#cdd3e0
ble-face -s command_alias fg=#D27389
ble-face -s command_keyword fg=#BB607B
ble-face -s syntax_quotation fg=#5a9e6f
ble-face -s syntax_quoted fg=#5a9e6f
ble-face -s syntax_param_expansion fg=#D27389
ble-face -s syntax_varname fg=#D27389

[[ ${BLE_VERSION-} ]] && ble-attach

export PATH=$PATH:/home/vyevd/.spicetify
export EDITOR=nvim
export VISUAL=nvim
export PATH="$HOME/.npm-global/bin:$PATH"
[ -f "$HOME/.parallel-env" ] && . "$HOME/.parallel-env"
export QT_STYLE_OVERRIDE=kvantum
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
