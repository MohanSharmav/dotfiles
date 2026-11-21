# Zsh & Oh My Zsh Config

Local, rootless Zsh setup with Starship prompt, `fzf`, `fzf-tab`, `zoxide`, `zsh-vi-mode`, `zsh-autosuggestions`, and OSC 52 clipboard utilities.

> Built to install cleanly without `sudo` (works identically on macOS and remote Linux SSH servers).  
> Complete alphabetical reference of every custom function: [../docs/FUNCTIONS.md](../docs/FUNCTIONS.md)

---

## Shell Keybindings (`.zshrc`, `01_env.zsh`, `functions.zsh`)

| Key | Plugin / Custom | Action |
|---|---|---|
| `Ctrl + o` | `cpbuffer` (`functions.zsh`) | Copy current command line to system clipboard (OSC 52) |
| `Right Arrow` / `Ctrl + Space` / `Ctrl + s` | `zsh-autosuggestions` | Accept grey inline autosuggestion: your latest command starting with what you typed (else Tab completion) |
| `Alt + Right` / `Alt + l` / `Alt + f` | `01_env.zsh` | Accept next suggested word / move word forward |
| `Alt + f` / `Alt + b` / `Alt + BS` | `01_env.zsh` | Forward word / backward word / delete backward word |
| `Up` / `Down` | `zsh-history-substring-search` | Filter history matching what you already typed |
| `Ctrl + t` | `fzf` | Fuzzy find file path and paste into prompt (`fd` + preview) |
| `Alt + c` | `fzf` | Fuzzy find directory and `cd` into it |
| `Ctrl + r` | `fzf` | Fuzzy search shell command history |
| `Ctrl+s` / `Ctrl+d` / `Ctrl+t` (inside fzf) | `FZF_DEFAULT_OPTS` | Select all / deselect all / toggle all |
| `Alt + Left` / `Alt + Right` / `Alt + Up` | `dirhistory` | Back / forward / parent in directory history |
| `Ctrl + z` | `fancy-ctrl-z` | Suspend job; press `Ctrl + z` again to resume (`fg`) |
| `Ctrl + Alt + k` / `j` | Tmux + OSC 133 | Jump to previous / next prompt in Tmux |
| `Shift + Up` / `Down` | Terminal + OSC 133 | Jump to previous / next prompt outside Tmux |
| `z <query>` | `zoxide` | Jump to frecent directory (e.g. `z dot`) |
| `Ctrl+q` / `Ctrl+s` | Flow control / prompt |Note: Zsh vi mode enabled via `zsh-vi-mode` (`Esc` enters command mode) |

> [!TIP]
> Add `\` before any aliased command (e.g. `\ls`, `\cat`) to run the unaliased binary.

---

## History (`custom/options.zsh`)

1,000,000 commands are kept and shared live between all shells and tmux panes
(`share_history`). Duplicates are trimmed first and not shown twice in `Ctrl + r` / `Up`.

## Custom Aliases (`oh-my-zsh/custom/`)

### Files, Editors & General (`aliases.zsh`, `mistakes.zsh`)

| Alias | Runs | Use |
|---|---|---|
| `ls` / `ll` / `la` / `l` / `lg` | `eza --icons auto --hyperlink auto ...` | Icons + hyperlinks (`ll` long, `la` hidden, `lg` git-ignore) |
| `sl` | `eza --icons auto --hyperlink` | Typo catcher for `ls` |
| `cat` | `bat` | Syntax-highlighted file viewer |
| `v` / `vi` | `nvim` | Launch Neovim (`vi` also strips accidental `vi vi` / `vi ls` typos) |
| `vic` / `lazyvim` / `csvi` | `nvim` profiles | CoC fallback / LazyVim / CSV aligner (`:CsvAlign`) |
| `vim` / `vimdiff` / `svi` | `vim` / `nvim -d` / `sudo -e` | Plain Vim / diff / safe root edit |
| `dv` / `ng` | `nvim +DiffviewOpen` / `nvim +Neogit` | Open Neovim directly in Git Diffview or Neogit |
| `src` | `omz reload` | Reload `~/.zshrc` |
| `ns` / `rb` / `fx` | `nvidia-smi` / `gio trash` / `fnox exec --` | GPU monitor / trash / secret runner |

### Python & Conda/Mamba (`aliases_python.zsh`)

| Alias | Runs | Use |
|---|---|---|
| `ca` / `cda` / `cc` / `ci` | `mamba` (or `conda`) `activate` / `deactivate` / `create -n` / `install` | Conda/Mamba shorthand |
| `ccg` / `cag` | Create / activate env named after current Git repo root | Repo-matched Python env |
| `da` | `deactivate` | Exit Python virtualenv |
| `risort` | `ruff check --select I --fix` | Sort Python imports with Ruff |

### Git (`aliases_git.zsh`)

| Alias | Runs | Use |
|---|---|---|
| `cdg` / `groot` | `cd $(git rev-parse --show-toplevel)` / print root | Jump to / print repo root |
| `gad` / `gcmd` | `ga .` / `gc -m "."` | Stage all / quick commit `"."` |
| `glr` / `gurl` | `git pull --rebase` / print `remote.origin.url` | Rebase pull / show remote URL |
| `ghr` / `ghb` / `ghc` | `gh repo` / `gh browse` / `gh repo clone` | GitHub CLI shorthands |

*(macOS `aliases_mac.zsh` also aliases `cp`, `rm`, `mv`, `mkdir`, `sed`, `tar`, `grep`, `date` to GNU `coreutils`/`gsed`/`gtar`/`ggrep`/`gdate` when installed.)*

### Tmux Pane Helpers (`aliases_tmux.zsh`)

| Command | Action |
|---|---|
| `tpl` / `tpr` / `tpb` / `tpt` | Print current path of left / right / bottom / top Tmux pane |
| `stp <dir> [file]` / `stw <win> [file]` | Send `$PWD` (or `[file]` path) to pane/window (`stpl`..`stpt`) |
| `stpf <dir> [file]` / `stwf <win> [file]` | Same as above and switch focus (`stpfl`..`stpft`, `stplf`..`stptf`) |

---

## Custom Functions Quick Summary (`functions.zsh`, `copilot.zsh`, `aliases_git.zsh`)

| Function | Use |
|---|---|
| `dotinstall` / `dotupdate [ref]` / `dotstable` / `dotstash` | Link, update, stabilize (`stable` tag), or stash dotfiles |
| `ghcs [args] <prompt>` / `ghce <cmd>` | GitHub Copilot CLI wrappers (`gh copilot suggest` / `explain`) |
| `osc52copy`, `cppath`, `cpfile`, `cppipe` | OSC 52 clipboard helpers over terminal/SSH/Tmux |
| `tgz` / `tzst` / `tzsti` | Create `.tar.gz` / `.tar.zst` archives with `pv` progress bar (`tzsti` also writes `.tree.txt`) |
| `dust_exclude_tarzst_dirs`, `azcopy_exclude_tarzst_dirs` | Exclude already-archived `.tar.zst` dirs during disk inspection / `azcopy` |
| `t` | Save `$PWD` and detach Tmux, or `cd` back to saved `$PWD` when outside Tmux |
| `pymv` | Rename Python module via `basedpyright` script (`bun`) |
| `gi <lang...>` | Generate `.gitignore` prepending `.playwright-mcp/` and `.DS_Store` |
| `gc`, `gglr`, `ggpf` | Smart `git commit --verbose` / `pull --rebase` / `push --force-with-lease` |
| `license`, `is_gpg_cached`, `override_term_program`, `ssh_delete` | License lookup, GPG cache check, WezTerm env override, SSH key removal |

Uncommitted machine-local overrides can live in `~/.config/zsh/*.zsh` (sourced at the end of `.zshrc`).

---

## Setup (Local / Without Sudo)

1. Install Zsh locally if missing or older than v5.9:

```bash
bash oh-my-zsh/zsh-local-install.sh
```

2. From the dotfiles root, link configs and bootstrap `uv`, `bun`, `rustup`, `mise`, Oh My Zsh, and CLI tools:

```bash
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
mise trust
mise run setup-dotfiles
oh-my-zsh/install-installers.sh
eval "$(mise -C "$HOME" env -s bash)"
git submodule update --init --remote
```

3. Auto-launch Zsh from `~/.bashrc` when `chsh` isn't available:

```bash
bash oh-my-zsh/launch-zsh-in-bash.sh
```

4. Install locked CLI tools and OS extras:

```zsh
mise -C "$HOME" install --locked
mise -C "$HOME" run install-extras
```

To bump CLI versions, run `mise -C "$HOME" lock --global --bump`.
`.zshrc` activates `mise activate zsh`, keeps `PATH` deduplicated (`typeset -U path`), and leaves `uv`, `bun`, and `rustup` outside mise (`rustup update` updates Rust).
