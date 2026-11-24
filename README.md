```text
               ?
              / \
             / * \
            / * * \
           /_______\
             @.-.@
            (-----)
           ( >___< )
           ^^ ~~~ ^^

* ====== | TOAD-MACS | ====== *
```

A nice Emacs config with a nice theme to go with it.

Made for Debian 13 (trixie), sway, and Emacs 30 in the terminal.
The Emacs config is set up for Rust and C/C++ development.

## What's in here

[`install.sh`](install.sh) puts everything below in place.

### Emacs config: `emacs.d/` → `~/.emacs.d`

| File | What it does |
|---|---|
| `early-init.el` | startup tuning |
| `init.el` | loads the modules below |
| `lisp/init-defaults.el` | backups, history, editing basics |
| `lisp/init-packages.el` | every package, plus LSP for Rust and C (eglot/flycheck) |
| `lisp/init-appearance.el` | theme, mode line, toad dashboard |
| `lisp/init-terminal.el` | clipboard, mouse, glyphs for `emacs -nw` |
| `lisp/init-keybindings.el` | all the keys |

### Themes

| Folder | Theme |
|---|---|
| `mudpuddle-theme/` | calm toad: standard colours, warm grays (the default) |
| `magic-toad-theme/` | night toad, plus `magic-toad-light` for daytime |
| `lilypad-theme/` | lilypad |

### Desktop: `system-colors/`

The rest of the desktop, in mudpuddle colours.

| File | Installed to |
|---|---|
| `sway/config` | `~/.config/sway/config` |
| `waybar/config` | `~/.config/waybar/config` |
| `waybar/style.css` | `~/.config/waybar/style.css` |
| `alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` |
| `blerc` | `~/.blerc` (ble.sh, the bash prompt) |
| `firefox/manifest.json` | built into `~/.local/share/toad-macs/mudpuddle-firefox.xpi` ([install it in Firefox](#firefox-theme)) |

## Install

1. Install the [dependencies](#dependencies).
2. Get the repo and run the script:

   ```bash
   git clone git@github.com:fake-frog/toad-macs.git ~/toad-macs
   ~/toad-macs/install.sh
   ```

`install.sh` only copies files: no `sudo`, no downloads. It also:

- backs up any file it would replace to `~/.toad-macs-backup/` first, and is safe to run again;
- adds the ble.sh line and the `e` alias to `~/.bashrc` if they're missing;
- reloads sway and waybar if they're running.

### Firefox theme

`install.sh` builds the theme, but Firefox has to install it. Do this once:

1. Open `about:config`, set `xpinstall.signatures.required` to `false`.
   Only Firefox ESR, Developer Edition and Nightly allow this; Debian's `firefox-esr` does.
2. Open `about:addons`, click the gear icon, choose **Install Add-on From File…**
   and pick `~/.local/share/toad-macs/mudpuddle-firefox.xpi`.

After changing `system-colors/firefox/manifest.json`, run `install.sh` again, bump
`"version"` in the manifest, and reinstall the `.xpi` the same way.

To just try it without installing: `about:debugging` → **This Firefox** →
**Load Temporary Add-on…** → pick `system-colors/firefox/manifest.json`.
It goes away when Firefox restarts.

Run `./install.sh --link` to symlink instead of copy, so edits in the repo apply straight away.

Emacs loads the themes from `~/toad-macs`. If you clone the repo somewhere else, `install.sh` links `~/toad-macs` to it.

## Dependencies

Everything in this section needs the internet.

### Packages (apt)

```bash
sudo apt install emacs-pgtk git \
    sway swayidle swaylock waybar alacritty bemenu \
    network-manager-applet dex brightnessctl pulseaudio-utils \
    firefox-esr fonts-font-awesome fontconfig curl unzip make gawk python3 \
    clangd clang-format rustup
```

### Rust toolchain and LSP server (rustup)

```bash
rustup default stable
rustup component add rust-analyzer
```

### Fonts

Lilex for the terminal and Emacs, Inclusive Sans for sway and waybar.

```bash
mkdir -p ~/.local/share/fonts
curl -L -o /tmp/Lilex.zip \
    https://github.com/mishamyrt/Lilex/releases/latest/download/Lilex.zip
unzip -o -q /tmp/Lilex.zip -d /tmp/Lilex
find /tmp/Lilex -name '*.ttf' -exec cp {} ~/.local/share/fonts/ \;
curl -L -o ~/.local/share/fonts/InclusiveSans.ttf \
    'https://github.com/google/fonts/raw/main/ofl/inclusivesans/InclusiveSans%5Bwght%5D.ttf'
curl -L -o ~/.local/share/fonts/InclusiveSans-Italic.ttf \
    'https://github.com/google/fonts/raw/main/ofl/inclusivesans/InclusiveSans-Italic%5Bwght%5D.ttf'
fc-cache -f
```

### ble.sh (syntax colours in bash)

```bash
git clone --recursive --depth 1 --shallow-submodules \
    https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
make -C /tmp/ble.sh install PREFIX=~/.local
```

### Emacs packages

These download themselves from MELPA and GNU ELPA the first time Emacs starts.

After installing, log out and back in once so sway restarts swayidle with the new lock screen.

```text
         _^-^_.--* ~~~
```
