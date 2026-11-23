#!/usr/bin/env bash
# install.sh: put the toad-macs config files where they belong.
#
#   ./install.sh          copy the files into place
#   ./install.sh --link   symlink them instead, so edits in this repo take
#                         effect directly (handy if you hack on the config)
#
# This script only copies local files.  It never uses sudo and never
# downloads anything: see README.md for the packages, fonts and tools to
# install first.  Existing files that would be replaced are moved to
# ~/.toad-macs-backup/<date-time>/ first, and running it again is safe.

set -euo pipefail

usage() { sed -n '2,11s/^# \{0,1\}//p' "$0"; }

mode=copy
case "${1:-}" in
    "")        ;;
    --link)    mode=link ;;
    -h|--help) usage; exit 0 ;;
    *)         usage >&2; exit 1 ;;
esac

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
config=${XDG_CONFIG_HOME:-$HOME/.config}
backup=$HOME/.toad-macs-backup/$(date +%Y%m%d-%H%M%S)
backed_up=0

say()  { printf '  %-10s %s\n' "$1" "${2/#$HOME/\~}"; }
warn() { printf '\n  ! %s\n' "$*"; }

# Move an existing file (or link) out of the way into the backup folder.
backup_file() {
    local dest=$1 rel
    case $dest in
        "$HOME"/*) rel=${dest#"$HOME"/} ;;
        *)         rel=${dest#/} ;;
    esac
    mkdir -p -- "$(dirname -- "$backup/$rel")"
    mv -- "$dest" "$backup/$rel"
    backed_up=1
}

# install_file SOURCE-IN-REPO DESTINATION
install_file() {
    local src=$repo/$1 dest=$2
    if [[ $mode == link ]]; then
        if [[ -L $dest && $(readlink -- "$dest") == "$src" ]]; then
            say unchanged "$dest"; return
        fi
    elif [[ -f $dest && ! -L $dest ]] && cmp -s -- "$src" "$dest"; then
        say unchanged "$dest"; return
    fi

    [[ -e $dest || -L $dest ]] && backup_file "$dest"
    mkdir -p -- "$(dirname -- "$dest")"
    if [[ $mode == link ]]; then
        ln -s -- "$src" "$dest"; say linked "$dest"
    else
        cp -- "$src" "$dest"; say installed "$dest"
    fi
}

echo "toad-macs: installing from ${repo/#$HOME/\~} ($mode mode)"

# ── Emacs ────────────────────────────────────────────────────────────────────
echo; echo "Emacs"
install_file emacs.d/early-init.el "$HOME/.emacs.d/early-init.el"
install_file emacs.d/init.el       "$HOME/.emacs.d/init.el"
for f in "$repo"/emacs.d/lisp/*.el; do
    install_file "emacs.d/lisp/${f##*/}" "$HOME/.emacs.d/lisp/${f##*/}"
done

# The Emacs config loads its themes from ~/toad-macs.  If the repo lives
# somewhere else, point ~/toad-macs at it.
if [[ $(readlink -f -- "$HOME/toad-macs" 2>/dev/null) != "$repo" ]]; then
    if [[ -e $HOME/toad-macs || -L $HOME/toad-macs ]]; then
        warn "~/toad-macs is not this repo, so Emacs won't find the themes.
    Move the repo there, or fix the paths in ~/.emacs.d/lisp/init-appearance.el."
    else
        ln -s -- "$repo" "$HOME/toad-macs"; say linked "$HOME/toad-macs"
    fi
fi

for f in "$HOME/.emacs" "$HOME/.emacs.el"; do
    [[ -e $f ]] && warn "${f/#$HOME/\~} exists and Emacs loads it instead of ~/.emacs.d/init.el.
    Remove or rename it to use this config."
done

# ── Desktop (sway, waybar, alacritty, ble.sh) ────────────────────────────────
echo; echo "Desktop"
install_file system-colors/sway/config            "$config/sway/config"
install_file system-colors/waybar/config          "$config/waybar/config"
install_file system-colors/waybar/style.css       "$config/waybar/style.css"
install_file system-colors/alacritty/alacritty.toml "$config/alacritty/alacritty.toml"
install_file system-colors/blerc                  "$HOME/.blerc"

# ── Shell (~/.bashrc) ────────────────────────────────────────────────────────
# Add only the lines that aren't there already.
echo; echo "Shell"
bashrc=$HOME/.bashrc
lines=()
grep -qs 'blesh/ble.sh' "$bashrc" ||
    lines+=('[[ $- == *i* && -f ~/.local/share/blesh/ble.sh ]] && source -- ~/.local/share/blesh/ble.sh')
grep -qsF 'emacsclient -t' "$bashrc" ||
    lines+=("alias e='emacsclient -t -a \"\"'   # open files in the Emacs server, starting it if needed")
if ((${#lines[@]})); then
    [[ -e $bashrc ]] && { mkdir -p -- "$backup"; cp -- "$bashrc" "$backup/.bashrc"; backed_up=1; }
    { echo; echo '# >>> toad-macs >>>'; printf '%s\n' "${lines[@]}"; echo '# <<< toad-macs <<<'; } >> "$bashrc"
    say updated "$bashrc"
else
    say unchanged "$bashrc"
fi

# ── Apply to the running session ─────────────────────────────────────────────
echo; echo "Reloading"
if command -v sway >/dev/null; then
    if ! sway -C -c "$config/sway/config" >/dev/null 2>&1; then
        warn "sway says the config has errors; not reloading.  Check: sway -C"
    elif [[ -n ${SWAYSOCK:-} ]] && swaymsg reload >/dev/null 2>&1; then
        say reloaded sway
    fi
fi
if pkill -USR2 -x waybar 2>/dev/null; then say reloaded waybar; fi
say note "Alacritty picks up its new colours on its own; new shells load ~/.blerc."
if emacsclient -e t >/dev/null 2>&1; then
    say note "An Emacs server is running: save your work, then restart it with"
    say ""   "emacsclient -e '(kill-emacs)'"
fi

# ── Anything missing? ────────────────────────────────────────────────────────
missing=()
for cmd in emacs sway swayidle swaylock waybar alacritty bemenu-run nm-applet dex \
           brightnessctl pactl git clangd rust-analyzer racket guile; do
    command -v "$cmd" >/dev/null || missing+=("$cmd")
done
for font in Lilex "Inclusive Sans" FontAwesome; do
    fc-list "$font" 2>/dev/null | grep -q . || missing+=("font: $font")
done
[[ -f $HOME/.local/share/blesh/ble.sh ]] || missing+=("ble.sh")

echo
if ((${#missing[@]})); then
    echo "Not installed yet (see Dependencies in README.md):"
    printf '    %s\n' "${missing[@]}"
else
    echo "All dependencies found."
fi
((backed_up)) && echo "Replaced files were backed up to ${backup/#$HOME/\~}"
echo "First Emacs start downloads its packages from MELPA/GNU ELPA (needs internet)."
