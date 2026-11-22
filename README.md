# dotfiles that work without sudo

Modern Neovim, Tmux, Git, Zsh, Terminal, and macOS/Linux window-management configuration built to install locally without `sudo`.

## Quick Start & Documentation Index

- **[QUICKSTART.md](QUICKSTART.md)** — Start here: open terminal -> file tree -> read/edit files -> Copilot/AI -> format, save & run -> Git
- **[docs/FUNCTIONS.md](docs/FUNCTIONS.md)** — Master dictionary of every custom function, alias, keybinding, and script

| Folder | Config For | Docs |
|---|---|---|
| [`nvim/`](nvim/) | Main Neovim IDE (Lua, Lazy, LSP, Copilot, Telescope, Treesitter, DAP) | [nvim/README.md](nvim/README.md) |
| [`tmux/`](tmux/) | Tmux (`Ctrl+b` prefix, Treemux, resurrect/continuum, pane borders) | [tmux/README.md](tmux/README.md) |
| [`git/`](git/) | `.gitconfig` aliases (`a`, `s`, `co`, `cm`, `gr`, `p`, `pl`) & global ignores | [git/README.md](git/README.md) |
| [`oh-my-zsh/`](oh-my-zsh/) | Zsh, Oh My Zsh, Starship, fzf, zoxide, Copilot CLI, aliases & functions | [oh-my-zsh/README.md](oh-my-zsh/README.md) |
| [`kitty/`](kitty/) | Upstream Kitty terminal config & shortcuts | [kitty/README.md](kitty/README.md) |
| [`wezterm/`](wezterm/) | WezTerm terminal config, keybindings & Ubuntu setup | [wezterm/README.md](wezterm/README.md) |
| [`kinetty/`](kinetty/) | Kinetty terminal config (`init.py`, vertical tabs, quick select) | [kinetty/README.md](kinetty/README.md) |
| [`ghostty/`](ghostty/) | Ghostty terminfo helper | [ghostty/README.md](ghostty/README.md) |
| [`aerospace/`](aerospace/) | macOS tiling window manager shortcuts & scripts | [aerospace/README.md](aerospace/README.md) |
| [`skhd/`](skhd/) | macOS hold-to-repeat resize & passthrough hotkeys | [skhd/README.md](skhd/README.md) |
| [`hammerspoon/`](hammerspoon/) | macOS global hotkeys (`F18` IME, TranslateScreen, prompt paste) | [hammerspoon/README.md](hammerspoon/README.md) |
| [`karabiner/`](karabiner/) | macOS low-level key remapping (`Caps Lock` -> `Ctrl`/`Esc`, etc.) | [karabiner/README.md](karabiner/README.md) |
| [`sketchybar/`](sketchybar/) | macOS menu bar integrated with AeroSpace & system meters | [sketchybar/README.md](sketchybar/README.md) |
| [`yabai/`](yabai/) | Legacy yabai config (superseded by AeroSpace) | [yabai/README.md](yabai/README.md) |
| [`helix/`](helix/) | Helix editor Vim-style keybindings & Python LSP | [helix/README.md](helix/README.md) |
| [`ranger/`](ranger/) | Ranger file manager config (`viu` previews, ratios) | [ranger/README.md](ranger/README.md) |
| [`mise-config/`](mise-config/) | Global locked CLI tools managed by `mise` | [mise-config/README.md](mise-config/README.md) |
| [`cargo/`](cargo/), [`conda/`](conda/), [`dprint/`](dprint/) | Tooling configs (`cargo`, `.condarc`, `dprint`) | [cargo](cargo/README.md) · [conda](conda/README.md) · [dprint](dprint/README.md) |
| [`nvim-coc/`](nvim-coc/), [`nvim-lazyvim/`](nvim-lazyvim/) | Fallback CoC (`vic`) & LazyVim (`lazyvim`) profiles | [nvim-coc](nvim-coc/README.md) · [nvim-lazyvim](nvim-lazyvim/README.md) |
| [`windows/`](windows/), [`AutoHotKey/`](AutoHotKey/), [`autokey/`](autokey/) | Windows PowerShell/VS & Linux AutoKey scripts | [windows](windows/README.md) · [AutoHotKey](AutoHotKey/README.md) · [autokey](autokey/README.md) |
| [`docs/`](docs/) | Benchmarks, internals & full functions reference | [docs/README.md](docs/README.md) |

> [!NOTE]
> Forked from [`kiyoon/dotfiles`](https://github.com/kiyoon/dotfiles) with custom `git_nvim_tmux_config` shortcuts (`Ctrl+b` Tmux prefix, `<C-n>` NvimTree, `<C-p>`/`<C-f>`/`zr` Telescope, `git/.gitconfig` aliases, `gh`/`gy`/`gi`/`gn`/`gp`/`ze`/`fmt`/`<F2>`/`<C-\>`).  
> Currently uses a transparent terminal background (`wezterm/wezterm.lua`, `kitty/kitty.conf`, `nvim/lua/mohan/tokyonight.lua`).

![image](https://user-images.githubusercontent.com/12980409/218476082-8c400daf-7d9d-4d15-bf7a-f6b41d919191.png)

![image](https://user-images.githubusercontent.com/12980409/218475937-c9a51b2d-b4d6-499f-8787-012770410209.png)

![image](https://user-images.githubusercontent.com/12980409/218476252-9de93e0c-ddfe-486b-979a-5ded6a9425a9.png)

## Vim Profiles

- `vi` (`v`): Main bleeding-edge Neovim config ([`nvim/`](nvim/README.md))
- `vic`: Minimal CoC fallback (`NVIM_APPNAME=nvim-coc`)
- `lazyvim`: Pre-configured [LazyVim](https://github.com/LazyVim/LazyVim) (`NVIM_APPNAME=nvim-lazyvim`)
- `vim`: Plain Vim using `.vimrc` only
- `csvi`: CSV viewer/aligner (`:CsvAlign` / `:TsvAlign`, `H` / `L` column nav)
- `vscode_init.lua`: VSCode-Neovim profile

## Features

### Zsh (`oh-my-zsh/`)

- Prompt: [Starship](https://starship.rs) + completions + autosuggestions (`Ctrl+s`) + syntax highlighting + vi-mode
- Fuzzy finder ([fzf](https://github.com/junegunn/fzf)): `Ctrl+t` (file), `Alt+c` (dir), `Ctrl+r` (history)
- Smart `cd` ([zoxide](https://github.com/ajeetdsouza/zoxide)): `z <partial-dir>` (e.g. `z dot`)
- Prompt jumps (OSC 133): `Ctrl+Alt+k/j` in Tmux, `Shift+Up/Down` outside Tmux
- Clipboard (OSC 52): `osc52copy`, `cppath`, `cpfile`, `Ctrl+o` (copy current command)
- See [oh-my-zsh/README.md](oh-my-zsh/README.md) and [docs/FUNCTIONS.md](docs/FUNCTIONS.md)

### Neovim (`nvim/`)

- Seamless split/pane navigation (`<C-h/j/k/l>`, `<C-\>`) and register sync with Tmux (`p`/`P`)
- Explorer (`<C-n>`, `me`), Telescope (`<C-p>`, `<C-f>`, `zr`), Copilot (`<C-s>`/`<F7>`, `<F5>`), Claude Code (`\ac`), LSP (`gd`/`gy`/`gi`/`gr`/`gh`/`gn`/`gp`/`ze`), format (`fmt` / `<space>pf`), clipboard (`<space>y`)
- See [nvim/README.md](nvim/README.md)

### Tmux (`tmux/`)

- `Ctrl+b` prefix (`Ctrl+b Ctrl+b` or `z` zoom), splits (`|`, `\`, `-`, `_`), `H/J/K/L` resize, `a` sync panes, `S` top-left swap, `<`/`>` window swap
- Interactive tree view ([Treemux](https://github.com/kiyoon/treemux)), resurrect/continuum session persistence, status bar ([tmux-dracula fork](https://github.com/kiyoon/tmux-dracula))
- See [tmux/README.md](tmux/README.md)

### Git (`git/`)

- `.gitconfig` aliases (`a`, `s`, `st`, `uu`, `b`, `c`, `co`, `cm`, `f`, `gr`, `graph`, `p`, `pl`) + `.gitignore_global` + Zsh git helpers
- See [git/README.md](git/README.md)

## Requirements

- Linux, macOS, Windows, WSL2
- Neovim v0.12.5
- Tmux v3.7
- Zsh v5.9

## Installation (Choose Your OS)

Clone to `~/Developer/dotfiles` (or `~/.config/dotfiles`):

```bash
git clone https://github.com/MohanSharmav/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
```

`./migrate_and_setup.sh` works on either OS: it runs the right script below with the same options. One script per OS. Both are safe to re-run, back up anything they replace to
`~/.dotfiles_backup_<time>`, and accept `--dry-run` (print every change, make none).

### On macOS
```bash
./setup_mac.sh             # add --with-wm for AeroSpace, SketchyBar, skhd, Hammerspoon, Karabiner
```
*Xcode Command Line Tools, Homebrew + [`Brewfile`](Brewfile) (rustup, uv, bun, GNU tools, eza, kitty, Nerd Fonts; [`Brewfile.wm`](Brewfile.wm) with `--with-wm`, which also starts those apps and points Hammerspoon at `~/.config/hammerspoon`), config links incl. the macOS-only ones, mise tools, Rust tools, Neovim and tmux plugins, terminfo, Claude Code, and the Terminal.app font/colours.*

### On Ubuntu / Debian
```bash
./setup_ubuntu.sh          # --server (headless), --desktop, --no-apt (no sudo), --no-chsh
```
*apt packages when sudo is available (otherwise zsh is built under `~/.local`), config links incl. AutoKey, user-space tools under `$HOME` (rustup, uv, bun, mise, pixi extras), Rust tools, Neovim and tmux plugins, terminfo, Claude Code; on a desktop also xclip/wl-clipboard and JetBrainsMono Nerd Font; finally zsh as the login shell (`chsh`, or launched from `~/.bashrc`).*

Shared steps live in [`scripts/setup-common.sh`](scripts/setup-common.sh); [`tests/test_setup_scripts.py`](tests/test_setup_scripts.py) and [`.github/workflows/setup.yml`](.github/workflows/setup.yml) (a real `setup_ubuntu.sh` run, twice) check them.

---

## Updating Later:

```bash
# From any terminal / shell:
./update.sh           # Full update: repo, submodules, links, Homebrew (macOS), mise, Rust tools, Neovim & Tmux plugins
./update.sh stable    # Switch to the `stable` tag (any tag or branch), then update
./update.sh --dry-run # Preview update steps without making changes
./update.sh --skip-git # Update plugins and tools without pulling from git

# Or inside Zsh:
dotupdate

# Or via mise:
mise run update
```

## SSH with WezTerm / Kitty

Run once before connecting to a remote SSH server so terminfo/keys work properly:

```bash
bash wezterm/terminfo.sh <ssh_server_name>   # WezTerm
# or
bash kitty/terminfo.sh <ssh_server_name>     # Kitty (or use `kitten ssh <host>`)
```

## Docker

```bash
docker pull ghcr.io/mohansharmav/dotfiles
docker run -it --rm \
    -u $UID:$UID \
    -e TERM=$TERM \
    -e TERM_PROGRAM=$TERM_PROGRAM \
    -e TERM_PROGRAM_VERSION=$TERM_PROGRAM_VERSION \
    ghcr.io/mohansharmav/dotfiles
```
