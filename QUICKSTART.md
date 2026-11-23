# Quick Start (Terminal -> IDE -> Copilot -> Save & Run)

A zero-fluff workflow guide to open your terminal, browse project files, edit code, use Copilot/AI, save, format, run, and push with Git.

> Full reference of every shell function, alias, and command: [docs/FUNCTIONS.md](docs/FUNCTIONS.md)  
> Full setup guide and repo index: [README.md](README.md)

---

## 0. First-Time Setup (Choose Your OS)

```bash
cd ~/Developer/dotfiles # or ~/.config/dotfiles

# On either OS (picks the right script below):
./migrate_and_setup.sh

# On macOS (add --with-wm for the AeroSpace/SketchyBar window-manager stack):
./setup_mac.sh

# On Ubuntu / Debian (--server on a headless machine, --no-apt without sudo):
./setup_ubuntu.sh
```

These scripts back up any existing old files, create all symlinks, install packages (Homebrew on macOS, apt on Ubuntu) and `mise` toolchains, configure Neovim's Python 3.12 virtualenv and plugins, install Tmux TPM plugins, Rust tools and Claude Code, and configure terminfo. Both are safe to re-run; `--dry-run` shows what they would do.

Enable GitHub Copilot once inside Neovim:

```vim
:Copilot setup
:Copilot enable
```

---

## 1. Open Terminal & Tmux Workspace

| Step | Command / Key | What it does |
|---|---|---|
| Open terminal | `Alt + 3` (macOS AeroSpace) | Focus/open `kitty` (`Alt + Shift + 3` for new window) |
| Start or attach Tmux | `tmux` / `ta` / `ts` | New session / attach (`ta`) / new named session (`ts`) |
| Split screen side-by-side (code + runner) | `Ctrl+b` then `\|` | Vertical split in current directory (`Ctrl+b` then `\` for home dir) |
| Split screen top/bottom | `Ctrl+b` then `-` (or `_`) | Horizontal split in current directory |
| Switch panes seamlessly | `Ctrl + h / j / k / l` | Move between Neovim splits and Tmux panes |
| Toggle back to last pane | `Ctrl + \` | Jump to previous split / Tmux pane |
| Resize panes | `Ctrl+b` then `H / J / K / L` | Resize by 5 (`Ctrl+Alt+y/u/i/o` also works) |
| Zoom / unzoom current pane | `Ctrl+b` then `Ctrl+b` (or `z`) | Fullscreen toggle for active pane |

---

## 2. Open Project in IDE Mode & See File Structure

```bash
cd /path/to/your/project   # or `z <partial-name>` with zoxide
nvim .                     # opens Neovim with NvimTree file explorer open on the left (`v` and `vi` also launch nvim)
```

> **Default file explorer:** Neovim automatically opens the **NvimTree** file explorer sidebar by default on startup (whether opening an empty editor, a project folder, or a specific file). Press `Ctrl + n` or `Space n t` anytime to toggle it closed or open.

| Action | Shortcut | Notes |
|---|---|---|
| Toggle file explorer sidebar (NvimTree) | `Ctrl + n` or `Space n t` | Opened by default on startup; shows full folder structure |
| Jump to current file in NvimTree | `m e` | Highlights open file in the tree |
| Preview Markdown in the browser | `Space m p` (stop: `Space m P`) | Works in a `.md` file, on a `.md` in the tree, or next to one; updates as you type; shows the URL |
| Preview Markdown with the mouse | Double-click a `.md` in NvimTree | Opens it and starts the browser preview |
| Alternative file explorer (Neo-tree) | `Space n n` | Press `?` inside for help |
| Tmux-level file sidebar (Treemux) | `Ctrl+b` then `Tab` (focus: `Backspace`) | Side pane outside Neovim; `<Space>o` switches Oil / NvimTree |
| Open file from NvimTree | `Enter` / `l` / `o` | Opens file in editor (`v` vsplit, `i` horizontal split, `h` collapse dir, `u` parent dir) |
| Pretty directory listing in shell | `ls` / `ll` / `lg` | `eza` icons (`lg` respects `.gitignore`) |

---

## 3. Search, Read & Jump Around Code

| Action | Shortcut | Notes |
|---|---|---|
| Quick-open any file | `Ctrl + p` (or `\ f f`) | Telescope fuzzy file finder |
| Find git-tracked files / recent / buffers | `\ f F` / `\ f r` / `\ f b` | Git files / recent files / open buffers |
| Search text across project (grep) | `Ctrl + f` | Greps word under cursor, or opens live grep (`\ f w` searches git root) |
| Search inside current file | `/text` then `n` / `N` | Classic Vim search (`\ f s` for Telescope line search; `F2` toggles highlight) |
| Resume last search popup | `z r` | Reopens last Telescope picker |
| Go to definition / type / implementation | `g d` / `g y` / `g i` | LSP jump via Telescope |
| Find all references | `g r` | LSP references |
| Hover docs (types / docstrings) | `K` or `g h` | Rounded hover popup |
| Next / previous error or warning | `g n` / `g p` | Shows floating diagnostic (`]e` / `[e` errors only, `g l` open float) |
| Toggle inline type/parameter hints | `z e` or `Space p h` | `lsp-endhints` toggle |
| Outline of functions/classes in file | `\ a` | Toggle Aerial outline (`]r` / `[r` next/prev symbol) |
| Jump anywhere visible on screen | `s` | Flash jump; type 2 chars + label |

---

## 4. Edit Code, Autocomplete & Use Copilot / AI

### Classic Vim Editing Essentials

| Mode / Task | Keys | What it does |
|---|---|---|
| Enter Edit (Insert) mode | `i` / `a` / `o` / `O` | Before cursor / after cursor / new line below / above |
| Back to Normal mode | `Esc` (or `F1`) | Always press `Esc` before running Normal-mode shortcuts |
| Undo / Redo | `u` / `Ctrl + r` | Highlighted undo/redo |
| Copy (yank) / Paste / System clipboard | `y` / `p` / `Space y` | `Space y` copies via OSC52 / system clipboard (`p` syncs with Tmux!) |
| Comment / uncomment line or selection | `g c c` / `g c` | `g b` for block comments |
| Select function / class / argument | `v i m` / `v i l` / `v i a` | Treesitter text objects (`]m` / `[m` jump functions) |
| Open command menu for available keys | Press `Space` or `\` and pause | `which-key` popup lists all mapped shortcuts |

### Autocomplete (`nvim-cmp` & LuaSnip)

| Action | Keys (Insert mode) | Notes |
|---|---|---|
| Next / previous completion item | `Alt + j` / `Alt + k` (or `Ctrl+n` / `Ctrl+p`) | Also expands/jumps snippet placeholders when menu is closed |
| Trigger or confirm completion | `Ctrl + Space` | Opens completion menu, or confirms top item |
| Accept selected completion | `Enter` or `Ctrl + y` | Inserts selected item (`Ctrl+e` cancels) |
| Scroll completion docs | `Ctrl + f` / `Ctrl + b` | Forward / back in doc popup |
| Expand snippet | `Alt + j` | Expands LuaSnip snippet (`Alt + l/h` next/prev choice or jump) |

### GitHub Copilot (Inside Neovim)

| Action | Keys (Insert mode) | Notes |
|---|---|---|
| Accept full Copilot ghost suggestion | `Ctrl + s` or `F7` | Note: `Tab` is intentionally disabled so indent works normally |
| Accept next word from Copilot | `F5` or `F6` | Inserts one word at a time |
| Next / previous Copilot suggestion | `Alt + ]` / `Alt + [` | Cycle alternatives |
| Copilot setup / status | `:Copilot status` / `:Copilot panel` | Normal-mode commands |

### Claude Code, Copilot Chat, ChatGPT (`gp.nvim`) & Copilot CLI

| Tool | Shortcut / Command | What it does |
|---|---|---|
| Toggle Claude Code in Neovim | `\ a c` (focus: `\ a f`) | Embedded Claude terminal |
| Send file or selection to Claude | `\ a b` / Visual `\ a s` | Add buffer / send selection (`\ a a` accept diff, `\ a d` deny diff) |
| Toggle / Open Copilot Chat | `\ c c` / `\ c q` | Embedded GitHub Copilot Chat window (`CopilotChat.nvim`, Copilot's `auto` model) |
| Claude chat | `\ c a` | Claude Code panel (same as `\ a c`); needs `claude`, which `setup_mac.sh` / `setup_ubuntu.sh` install |
| Telescope Prompts / Actions menu | `\ c p` (help: `\ c h`) | Fuzzy-search all Copilot actions & prompts |
| Fix Diagnostic under cursor | `\ c d` | Sends LSP diagnostic at cursor directly to Copilot |
| Auto-generate Git commit message | `\ c m` | Generates conventional commit from staged changes |
| Select Copilot Model | `\ c M` | Switch models (only on Copilot plans that allow picking; Free plans use `auto`) |
| Review / Fix / Tests with Copilot | `\ c r` / `\ c f` / `\ c t` / `\ c x` | Review, fix, generate tests, or explain code |
| Open ChatGPT chat / rewrite selection | `\ c g` / `\ c e` | `gp.nvim` chat or inline rewrite |
| Summarize / fix selected text | Visual `Space a s` | `neoai` textify shortcut |
| Ask Copilot for a shell command (in Zsh) | `ghcs "list large files"` | `gh copilot suggest` wrapper (`oh-my-zsh/custom/copilot.zsh`) |
| Explain a shell command (in Zsh) | `ghce "tar -czf ..."` | `gh copilot explain` wrapper |

---

## 5. Format, Save & Run Your Code

| Action | Command / Shortcut | Notes |
|---|---|---|
| Format file or selection | `f m t` or `Space p f` | Runs `conform.nvim` (`ruff`, `biome`, `stylua`, `rustfmt`, `clang-format`, `prettier`) |
| Apply LSP / Ruff quick-fix | `Space p a` | Code actions (`Space p o` organizes Python imports) |
| Rename symbol across project | `Space p r` | Live LSP rename |
| **Save file** | `:w` + `Enter` | Automatically triggers `conform.nvim` format-on-save (`:wa` saves all, `:wq` saves & closes) |
| Run in your side Tmux pane (from shell pane) | Switch with `Ctrl + l`, then e.g. `python app.py` / `cargo run` | Best day-to-day workflow with `Ctrl+b \|` split |
| **Send line/selection straight to Tmux pane & run** | `-` (plain without newline: `_`) | Uses `tmux-send.nvim`: sends current line or visual selection to adjacent Tmux pane and presses Enter |
| Run a quick shell command from Neovim | `:!python %` | `%` expands to the active file path |
| Run configured build/test tasks | `:OverseerRun` (`:OverseerToggle`) | Task runner inside Neovim |
| Save & re-source current `.vim` / `.lua` config | `Space Space x` | Useful while editing `dotfiles/nvim` |
| Start / step / breakpoint Debugger (DAP) | `Space d b` (breakpoint), `Space d c` (start/continue) | `Space d n` step over, `Space d s` step into, `Space d i` toggle UI |
| Evaluate Jupyter/Python cell (`molten.nvim`) | `Space m x` / `Space m r` | Line: `Space m X`, hide output: `Space m h` (after `:MoltenInit`) |

---

## 6. Commit & Push with Git

| Task | In Zsh Terminal | Inside Neovim |
|---|---|---|
| Status | `git s` / `git st` / `git uu` | `Space g s` (Neogit), `\ h p` (preview hunk) |
| Stage all | `git a` (or `gad` in Zsh) | `\ h s` (stage hunk), `\ h S` (stage buffer) |
| Commit | `git cm "message"` (or `gc` in Zsh) | `Space g c` (Neogit commit) |
| Diff / History graph | `git gr` / `git graph` | `\ d v` (Diffview), `\ h b` (blame line) |
| Push / Pull | `git p` / `git pl` | `lazygit` in terminal for TUI |

---

## 7. Updating Dotfiles & Dependencies

To update your repository, submodules, symlinks, `mise` tools, Neovim plugins, and Tmux plugins in one command:

```bash
# From any terminal:
~/Developer/dotfiles/update.sh

# Or inside Zsh:
dotupdate

# Or via mise:
mise run update
```

| Option | What it does |
|---|---|
| `./update.sh` | Full update (pulls git, updates submodules, relinks configs, upgrades Brewfile packages on macOS / pixi extras on Linux, mise tools, Rust toolchain + rust-analyzer/bacon, Lazy plugins, Treesitter, new + existing TPM plugins, and reloads Tmux) |
| `./update.sh stable` | Check out a tag or branch (here `stable`, like `dotstable`), then update |
| `./update.sh --dry-run` | Preview all actions without modifying files |
| `./update.sh --skip-git` | Updates plugins and symlinks without pulling from git (keeps local repo branch untouched) |
| `./update.sh --force` | Auto-stashes local uncommitted changes before pulling from remote |

---

## 8. Individual Tool Guides

- [All Functions, Aliases & Commands Reference](docs/FUNCTIONS.md)
- [Neovim Shortcuts](nvim/README.md) · [CoC Fallback](nvim-coc/README.md) · [LazyVim](nvim-lazyvim/README.md)
- [Tmux Shortcuts](tmux/README.md)
- [Git Aliases & Config](git/README.md)
- [Zsh & Oh My Zsh Aliases/Functions](oh-my-zsh/README.md)
- [Kitty](kitty/README.md) · [WezTerm](wezterm/README.md) · [Kinetty](kinetty/README.md) · [Ghostty](ghostty/README.md)
- [AeroSpace](aerospace/README.md) · [skhd](skhd/README.md) · [Hammerspoon](hammerspoon/README.md) · [Karabiner](karabiner/README.md) · [SketchyBar](sketchybar/README.md) · [yabai (legacy)](yabai/README.md)
- [Helix](helix/README.md) · [Ranger](ranger/README.md) · [mise-config](mise-config/README.md) · [Cargo](cargo/README.md) · [Conda](conda/README.md) · [dprint](dprint/README.md)
- [Windows](windows/README.md) · [AutoHotKey](AutoHotKey/README.md) · [AutoKey](autokey/README.md)

