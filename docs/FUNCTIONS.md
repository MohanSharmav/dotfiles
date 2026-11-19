# All Functions, Aliases & Commands Reference

Single-page dictionary of every custom shell function, alias, ZLE keybinding, Git alias, Tmux script/command, Neovim command, and Hammerspoon hotkey in this repository.

> Looking for the step-by-step workflow? Start at [QUICKSTART.md](../QUICKSTART.md).

---

## 1. Zsh Custom Functions (`oh-my-zsh/custom/`)

### Dotfiles & System Management (`functions.zsh`)

| Function | Arguments / Key | What it does |
|---|---|---|
| `dotfiles_dir` | — | Prints the Git root path of this dotfiles repo |
| `dotstash` | — | Runs `git stash` inside the dotfiles repo |
| `dotinstall` | — | Links dotfiles via `mise`, runs installers, restores Neovim plugins, installs/updates Tmux plugins, installs terminfo, reloads Zsh |
| `dotupdate` | `[tag/branch]` | Pulls latest repo + submodules, checks out optional ref, reloads `~/.zshrc`, runs `dotinstall` |
| `dotstable` | — | Shortcut for `dotupdate stable` |
| `license` | `[name]` | Lists GitHub open-source license keys or prints license body via GitHub API + `jq` |
| `is_gpg_cached` | — | Checks whether GPG agent currently caches the signing subkey (`true` / `false` / `nogpg`) |
| `override_term_program` | — | Forces `TERM_PROGRAM=WezTerm` (helpful for image protocols over SSH) |
| `t` | — | Inside Tmux: saves `$PWD` and detaches. Outside Tmux: `cd`s to last saved Tmux `$PWD` |
| `ssh_delete` | — | Removes `~/.ssh/id_ed25519` from `ssh-agent` (`ssh-add -d`) |

### Clipboard & Archives (`functions.zsh`)

| Function | Arguments / Key | What it does |
|---|---|---|
| `osc52copy` | `[text]` or `stdin` | Copies text to local clipboard over OSC 52 escape sequence (works over SSH/Tmux) |
| `cppath` | `[path]` (default `.`) | Copies absolute path to clipboard via `osc52copy` |
| `cpfile` | `<file>` | Copies entire file contents to clipboard via `osc52copy` |
| `cppipe` | `stdin` | Pipe helper for `osc52copy` (`cmd \| cppipe`) |
| `cpbuffer` | `Ctrl+O` (ZLE widget) | Copies the current Zsh command line buffer to clipboard |
| `get_sum_bytes` | `<paths...>` | Computes total byte size of files/directories (for progress bars) |
| `tgz` | `[out.tar.gz] <infiles...>` or `<dir>` | Creates `.tar.gz` archive with `pv` progress bar (excludes `.DS_Store`) |
| `tzst` | `[out.tar.zst] <infiles...>` or `<dir>` | Creates fast `.tar.zst` archive (`zstd -T0 -1`) with `pv` progress bar |
| `tzsti` | `[out.tar.zst] <infiles...>` or `<dir>` | Same as `tzst` plus generates `<name>.tree.txt` directory tree via `eza` |
| `dust_exclude_tarzst_dirs` | `[dir] [dust args]` | Runs `dust` excluding directories that already have a `.tar.zst` archive |
| `azcopy_exclude_tarzst_dirs` | `<source>` | Outputs semicolon-separated `--exclude-path` list of archived `.tar.zst` dirs for `azcopy` |

### Python, Git, Copilot CLI & Typo Guards

| Function | Arguments | Source | What it does |
|---|---|---|---|
| `pymv` | `[args]` | `functions.zsh` | Runs `bun` script `rename_module.ts` with `basedpyright` to rename Python modules safely |
| `gi` | `<lang...>` | `functions.zsh` | Fetches gitignore.io template prepending `.playwright-mcp/` and `.DS_Store` |
| `gc` | `[git commit args]` | `aliases_git.zsh` | Ensures `~/.ssh/id_ed25519` is added if present, then runs `git commit --verbose` (with `--gpg-sign` when signing is configured) |
| `gglr` | `[branch]` | `aliases_git.zsh` | `git pull --rebase origin <branch>` (defaults to current branch) |
| `ggpf` | `[branch]` | `aliases_git.zsh` | `git push origin <branch> --force-with-lease` (defaults to current branch) |
| `ssh_add_if_notyet` | — | `aliases_git.zsh` | Loads `~/.ssh/id_ed25519` into `ssh-agent` if the file exists and isn't already loaded |
| `ghcs` | `[-d] [-h] [-t shell\|gh\|git] <prompt>` | `copilot.zsh` | Wrapper around `gh copilot suggest` that saves and runs the suggested command |
| `ghce` | `[-d] [-h] <command>` | `copilot.zsh` | Wrapper around `gh copilot explain` to explain a shell command |
| `vi` | `[args]` | `mistakes.zsh` | Launches `nvim` and catches common double-typed mistakes like `vi vi` or `vi ls` |

### Tmux Pane Helpers & Hooks (`aliases_tmux.zsh`, `hooks.zsh`, `01_env.zsh`)

| Function | Arguments / Key | What it does |
|---|---|---|
| `stp` | `<left\|right\|top\|bottom> [file]` | Types current `$PWD` (or `realpath` of `[file]`) into the target Tmux pane |
| `stpf` | `<left\|right\|top\|bottom> [file]` | Same as `stp` and switches focus to that pane |
| `stw` | `<window_number> [file]` | Types `$PWD` (or `realpath` of `[file]`) into Tmux window `<window_number>` |
| `stwf` | `<window_number> [file]` | Same as `stw` and selects that window |
| `tmux-window-name` | `chpwd` / `precmd` hook | Updates Tmux window names (`tmux-window-name` plugin) |
| `tmux_next_window` / `tmux_previous_window` | `F5`/`F6` / `F2`/`F3` | Switches Tmux window from Zsh line editor when inside Tmux |

---

## 2. Zsh Aliases (`oh-my-zsh/custom/`)

| Alias | Expands to | Category |
|---|---|---|
| `cat` | `bat` | Core (`aliases.zsh`) |
| `ls` / `ll` / `la` / `l` / `lg` | `eza --icons auto --hyperlink auto ...` | Core (`ls`, detailed `ll`, all `la`, compact `l`, git-ignored `lg`) |
| `sl` | `eza --icons auto --hyperlink` | Typo guard (`mistakes.zsh`) |
| `v` | `nvim` | Editor (`aliases.zsh`) |
| `vimdiff` | `nvim -d` | Editor (`aliases.zsh`) |
| `vic` | `NVIM_APPNAME=nvim-coc nvim` | Minimal CoC Neovim profile |
| `lazyvim` | `NVIM_APPNAME=nvim-lazyvim nvim` | LazyVim profile |
| `csvi` | `nvim -u ~/.config/nvim/csv_init.lua` | CSV viewer/aligner profile |
| `dv` / `ng` | `nvim +DiffviewOpen` / `nvim +Neogit` | Open Neovim directly in Git Diffview / Neogit |
| `svi` | `sudo -e` | Edit root-owned files safely |
| `src` | `omz reload` | Reload Zsh config |
| `ns` / `rb` / `fx` | `nvidia-smi` / `gio trash` / `fnox exec --` | System / env runner |
| `cdg` / `groot` | `cd $(git rev-parse --show-toplevel)` / print root | Git (`aliases_git.zsh`) |
| `gad` / `gcmd` | `ga .` / `gc -m "."` | Git quick stage / commit |
| `glr` / `gurl` | `git pull --rebase` / print `remote.origin.url` | Git (`aliases_git.zsh`) |
| `ghr` / `ghb` / `ghc` | `gh repo` / `gh browse` / `gh repo clone` | GitHub CLI (`aliases_git.zsh`) |
| `ca` / `cda` / `cc` / `ci` | `mamba` (or `conda`) `activate`/`deactivate`/`create -n`/`install` | Python (`aliases_python.zsh`) |
| `ccg` / `cag` | Create/activate conda/mamba env named after current git repo root | Python (`aliases_python.zsh`) |
| `da` / `risort` | `deactivate` / `ruff check --select I --fix` | Python (`aliases_python.zsh`) |
| `tpl` / `tpr` / `tpb` / `tpt` | Print `pane_current_path` of left/right/bottom/top Tmux pane | Tmux (`aliases_tmux.zsh`) |
| `stpl` / `stpr` / `stpb` / `stpt` | `stp left\|right\|top\|bottom` | Tmux (`aliases_tmux.zsh`) |
| `stpfl` / `stpfr` / `stpfb` / `stpft` | `stpf left\|right\|top\|bottom` | Tmux (`aliases_tmux.zsh`) |
| `stplf` / `stprf` / `stpbf` / `stptf` | Send `$PWD` to pane and select it | Tmux (`aliases_tmux.zsh`) |
| `cp`/`rm`/`mv`/`mkdir`/`sed`/`tar`/`grep`/`date` | `coreutils ...` / `gsed` / `gtar` / `ggrep` / `gdate` | macOS GNU tools (`aliases_mac.zsh`) |

---

## 3. Git Config Aliases (`git/.gitconfig`)

| Command | Expands to |
|---|---|
| `git a` | `git add .` |
| `git b` / `git bh` | `git branch` |
| `git c` / `git ck` / `git co` / `git cbc` | `git checkout` |
| `git cl` | `git clean -df` |
| `git cm` | `git commit -m` |
| `git f` / `git fo` | `git fetch` / `git fetch origin` |
| `git gr` | `git log --graph --oneline --all` |
| `git graph` | Detailed colored graph with relative date & author |
| `git p` / `git ps` | `git push` |
| `git pl` | `git pull` |
| `git s` / `git st` / `git uu` | `git status` / `git status` / `git status -u` |

---

## 4. Neovim Custom Commands & Helpers (`nvim/`)

| Command / Helper | Trigger / Command | What it does |
|---|---|---|
| Toggle search highlight | `<F2>` | `set hlsearch!` |
| Toggle window / Tmux pane | `<C-\>` | Switch to previous Neovim split or previous Tmux pane |
| Toggle NvimTree / locate file | `<C-n>` or `<space>nt` / `me` | Toggle explorer / highlight current file (`i` opens horizontal split) |
| Telescope quick open / grep | `<C-p>` / `<C-f>` / `zr` | Find files / live grep `<cword>` or open prompt / resume last picker |
| Format buffer or selection | `fmt` or `<space>pf` | Runs `conform.nvim` formatters (`rustfmt`, `ruff`, `biome`, `stylua`, `shfmt`, `prettier`, etc.) |
| Format-on-save toggle | `:FormatDisable` / `:FormatDisable!` / `:FormatEnable` | Off globally / off for this buffer / back on |
| Session for tmux-resurrect | automatic in tmux + git repo; `:Obsession!` to stop | Keeps `./Session.vim` so Neovim panes are restored after reboot |
| LSP definitions / types / impls / hover | `gd` / `gy` / `gi` / `gr` / `gh` / `K` | Telescope LSP jumps & rounded hover doc |
| Diagnostics & Inlay hints | `gn` / `gp` / `gl` / `ze` / `<space>pl` | Jump next/prev diagnostic (`gn`/`gp`), float (`gl`), toggle hints (`ze`) |
| Copilot accept / word / cycle | `<C-s>` or `<F7>` / `<F5>` / `Alt+]` | Accept full completion / accept word / cycle suggestions |
| Claude Code integration | `<leader>ac` / `<leader>af` / `<leader>ab` / `<leader>as` | Open Claude terminal, focus, add file, send visual selection |
| Tmux command sender | `-` / `_` / `<space>-` / `<C-_>` | Send line or visual selection to adjacent Tmux pane (with/without newline) or buffer |
| Save & re-source config | `<space><space>x` | Writes buffer and sources Vimscript/Lua (`Tj_save_and_exec()`) |
| CSV align (`csv_init.lua`) | `:CsvAlign` / `:TsvAlign` (`H`/`L` cols) | Align columns in CSV/TSV files |
| Quickfix / Location list toggle | `<leader>l` | `ToggleList("Location List", 'l')` |
| Blank line above / below | `<space>O` / `<space>o` | `BlankUp` / `BlankDown` |
| Python tools (`python_keymaps.lua`) | `<space>tp` / `<space>tP` / `<space>tq` / `<space>ti` / `<space>tF` / `<space>tI` / `<space>i` / `<M-CR>` / `<space>tr` | `os.path` -> `pathlib.Path`, toggle `# noqa` / `# pyright: ignore`, Ruff fix, auto-import, rich traceback |
| Markdown helpers (`markdown_keymaps.lua`) | `<space>tl` / `<space>tL` | Wrap selection/word into Markdown link (`[text]` + `(url)`) |
| Claude Git commit prompt (`claude_commit_inject.lua`) | `\ag` (in gitcommit) | Generates commit message via Claude CLI |

---

## 5. Tmux Scripts & Commands (`tmux/`)

| Item | Path / Binding | What it does |
|---|---|---|
| Reload config + refresh PATH | `Ctrl+b` `r` or `R` | Sources `~/.tmux.conf` cleanly |
| Move pane to next/prev window | `Ctrl+b` `N` / `P` | Uses `tmux/scripts/get_next_window_uid.sh` / `get_prev_window_uid.sh` |
| Agent Session IDs | `tmux/scripts/agent-sid.sh`, `codex-daemon-sid.py` | Displays `cc:`, `cx:`, `gc:`, `oc:` session IDs in pane borders |
| Install / update plugins | `./tmux/install-plugins.sh`, `./tmux/update-plugins.sh` | Installs TPM plugins + `/usr/bin/python3` deps (`pynvim`, `libtmux`) |

---

## 6. Hammerspoon & Window Manager Utilities (`hammerspoon/`, `aerospace/`, `skhd/`)

| Utility | Trigger / Script | What it does |
|---|---|---|
| Korean/English IME toggle | `F18` | `toggleInputLanguage` (Gureum / Apple / PriType / Ongeul safe switcher) |
| Screenshot & Google Translate | `Ctrl+Shift+Cmd+T` | Captures active screen and opens Google Translate image tab (`TranslateScreen.spoon`) |
| Middle mouse click simulator | `Ctrl+Shift+Cmd+M` | Synthesizes center mouse click at cursor |
| Insert Codex/Claude prompt template | `Ctrl+Shift+Cmd+C` | Pastes multi-agent template via `PastePrompt("codex_claude")` |
| Pause/Resume active process | `Ctrl+Shift+Cmd+R` | Sends `SIGSTOP` / `SIGCONT` to frontmost app |
| AeroSpace helper scripts | `aerospace/scripts/*.sh` | `divider-resize.sh`, `monitor.sh`, `permute.sh`, `window_layout.sh`, `workspace.sh`, `restart.sh` |

