# Neovim IDE Config

Main entry: [`init.lua`](init.lua) -> sources [`.vimrc`](.vimrc) -> loads plugins via `lazy.nvim` ([`lua/mohan/lazy.lua`](lua/mohan/lazy.lua)) + personal keymaps ([`lua/mohan/settings/user_keymaps.lua`](lua/mohan/settings/user_keymaps.lua)).

> Default `<leader>` is `\` (backslash), plus explicit `<space>` prefixes. Press `\` or `<space>` and pause to view popups in [which-key.nvim](https://github.com/folke/which-key.nvim).  
> Step-by-step workflow: [../QUICKSTART.md](../QUICKSTART.md)

---

## Shortcut Reference

### 1. File Tree & Explorers

> **Default file explorer:** NvimTree automatically opens on the left sidebar by default on startup (for empty editor `nvim`, folder `nvim .`, or file `nvim file.py`). Press `<C-n>` or `<space>nt` to toggle it. Quitting the last editor window (`:q`) automatically closes NvimTree as well.

| Key | Mode | Action |
|---|---|---|
| `<C-n>` / `<space>nt` | Normal | Toggle NvimTree sidebar (open by default on startup) |
| `me` | Normal | Reveal/find current file in NvimTree |
| `<space>nn` | Normal, Visual | Toggle Neo-tree (`?` for help) |
| `Enter` / `l` / `o` | NvimTree | Open file or expand folder |
| `v` / `i` | NvimTree | Open in vertical (`v`) or horizontal (`i`) split |
| `h` / `u` | NvimTree | Close directory (`h`) / go to parent root (`u`) |
| `<F1>` | NvimTree | Node info popup |

### 2. Find Files, Grep & Jump

| Key | Mode | Action |
|---|---|---|
| `<C-p>` / `\ff` | Normal | Telescope find files (`\fF` git files, `\fb` buffers, `\fr` recent) |
| `<C-f>` | Normal | Telescope live grep word under cursor (or open grep prompt) |
| `\fw` / `\fW` | Normal | Live grep in git root / cwd (`\fiw` grep inner word in git root) |
| `\fg` | Normal | Live grep with ripgrep args (`<C-y>` quote, `<C-i>` `--iglob`) |
| `\fs` | Normal | Fuzzy search current buffer |
| `zr` | Normal | Resume last Telescope picker |
| `s` / `m` | Normal, Visual, Op | Flash jump (`s`) / Flash Treesitter select (`m`); mark moved to `M` |
| `r` (op) / `R` (op, visual) | Operator / Visual | Flash remote / Treesitter search |
| `<C-s>` | Command mode | Toggle Flash search |
| `<F2>` | Normal | Toggle search highlight (`:set hlsearch!`) |
| `\a` | Normal | Toggle Aerial symbol outline (`]r` / `[r` next/prev symbol) |

### 3. Editing, Clipboard, Undo & Comments

| Key | Mode | Action |
|---|---|---|
| `i` / `a` / `o` / `O` | Normal | Insert mode (before / after cursor / new line below / above) |
| `<F1>` / `Esc` | Any | Return to Normal mode |
| `<space>y` | Normal, Visual | Copy to system clipboard (OSC 52) |
| `p` / `P` | Normal, Visual | Paste with Yanky + Tmux register sync (`\p` / `\P` blockwise) |
| `<A-n>` / `<A-p>` | Normal | Cycle Yanky paste ring forward / backward |
| `gp` / `gP` | Normal | Select last pasted text (`gp` jumps diagnostics in LSP buffers; `gP` backup) |
| `u` / `<C-r>` | Normal | Undo / Redo with highlight (`undo-glow`) |
| `<space>u` | Normal, Visual | Toggle Undotree |
| `gcc` / `gc` / `gb` | Normal / Visual | Toggle line comment (`gc`) / block comment (`gb`) |
| `<space>o` / `<space>O` | Normal | Add blank line below / above without entering insert mode |
| `<A-Up>` / `<A-Down>` | Normal, Insert, Visual | Move line or selection up / down |
| `<` / `>` | Visual | Re-indent and keep selection |
| `Y` | Normal / Visual | Yank to end of line (`y$` / `$y`) |
| `<space>s` / `<space>ss` | Normal, Visual | Substitute text object / word with register (`vim-subversive`) |
| `` ` `` / `<F4>` | Normal, Insert (`<A-`>`), Visual | Surround word/selection with backticks (`` ` ``) or parens (`<F4>`) |
| `<A-;>` / `<A-,>` / `<A-'>` | Normal, Insert | Wrap AST node with `clasp.nvim` |
| `<A-w>` / `<A-b>` | Insert | Jump out of quotes/brackets forward / back (`tabout.nvim`) |
| `<space>l` / `<space>h` | Normal | Treesitter split (`TSJSplit`) / join (`TSJJoin`) |
| `\sr` | Normal | Project-wide find & replace (`nvim-spectre`) |

### 4. Completion, Snippets, Copilot & AI Assistants

| Key | Mode | Action |
|---|---|---|
| `<M-j>` / `<M-k>` (or `<C-n>` / `<C-p>`) | Insert, Select | Next / previous completion item (or LuaSnip jump fallback) |
| `<C-Space>` | Insert, Select | Trigger completion / confirm top item |
| `<CR>` / `<C-y>` | Insert | Confirm selected completion (`<C-e>` abort) |
| `<C-f>` / `<C-b>` | Insert | Scroll completion docs |
| `<A-j>` / `<A-k>` / `<A-l>` / `<A-h>` / `<A-u>` | Insert, Select | Expand/jump snippets & cycle choices (`LuaSnip`) |
| `<C-s>` or `<F7>` | Insert | **Copilot**: accept full suggestion (`Tab` left free) |
| `<F5>` or `<F6>` | Insert | **Copilot**: accept next word |
| `<A-]>` / `<A-[>` | Insert | **Copilot**: next / previous suggestion |
| `<A-Left>` / `<A-BS>` / `<F2>` / `<F3>` | Insert | Delete previous word (`db`) |
| `\ac` / `\af` | Normal | **Claude Code**: toggle / focus terminal |
| `\ar` / `\aC` / `\am` | Normal | **Claude Code**: resume / continue / select model |
| `\ab` / `\as` (visual or tree) | Normal, Visual | **Claude Code**: add current buffer / send selection (`\aa` accept diff, `\ad` deny diff) |
| `\cc` / `\cq` | Normal, Visual | **Copilot Chat**: toggle chat / open chat window |
| `\cp` / `\ch` | Normal, Visual | **Copilot Chat**: Telescope prompt actions menu / help menu |
| `\cd` / `\cm` / `\cM` | Normal, Visual | **Copilot Chat**: fix cursor diagnostic / commit staged / select model |
| `\cr` / `\cf` / `\ct` / `\cx` | Normal, Visual | **Copilot Chat**: review / fix / tests / explain selection (`\cR` reset) |
| `\cg` / `\ce` | Normal, Visual | **gp.nvim (ChatGPT)**: open chat / rewrite selection |
| `<space>as` | Visual | **NeoAI**: summarize/rewrite selection (`\ag` in gitcommit for commit msg) |

### 5. LSP, Diagnostics & Formatting

| Key | Mode | Action |
|---|---|---|
| `gd` / `gy` (`gD`) / `gi` (`gI`) / `gr` | Normal (LSP) | Go to definition / type def / implementation / references |
| `K` / `gh` | Normal (LSP) | Hover documentation popup |
| `gn` / `gp` / `gl` | Normal (LSP) | Next / previous diagnostic float / open float under cursor |
| `<A-l>` / `<A-h>` | Normal, Visual, Op, Insert | Jump next / previous diagnostic |
| `]e` / `[e` / `]w` / `[w` | Normal, Visual, Op | Next / prev error (`e`) or warning (`w`) |
| `ze` / `<space>ph` | Normal (LSP) | Toggle inlay hints (`lsp-endhints`) |
| `<space>pl` | Normal (LSP) | Toggle virtual-line diagnostics |
| `<space>pa` | Normal (LSP) | Preview & apply code actions (Ruff / LSP) |
| `<space>pr` / `<space>pR` | Normal | Live rename (`live-rename` / `IncRename`) |
| `<space>ps` / `<space>pq` / `<space>po` | Normal (LSP) | Signature help / send diagnostics to quickfix / organize Python imports |
| `<space>pi` / `<space>pI` | Normal | `:LspInfo` / `:LspInstallInfo` |
| `fmt` / `<space>pf` | Normal, Visual | Format buffer or selection (`conform.nvim`; also runs on `:w`, except Markdown) |
| `:FormatDisable` / `:FormatDisable!` / `:FormatEnable` | Command | Turn format-on-save off everywhere / for this buffer only / back on |
| `:Obsession!` | Command | Stop the automatic `Session.vim` and delete it (see *Sessions* below) |
| `\xx` / `\xX` / `\cs` / `\cl` / `\xQ` | Normal | Trouble panels (diagnostics / buffer / symbols / LSP / quickfix) |

### 6. Splits, Tmux Integration, Run & Debug

| Key | Mode | Action |
|---|---|---|
| `<C-h/j/k/l>` | Normal | Seamless split / Tmux pane navigation |
| `<C-\>` | Normal | Jump to previous Neovim split or Tmux pane |
| `-` / `_` | Normal, Visual | Send line/selection to Tmux pane (`tmux-send.nvim`: `-` runs w/ Enter, `_` plain) |
| `<space>-` / `<space>_` | Normal, Visual | Send to Tmux pane by UID (use count) |
| `<C-_>` | Normal, Visual | Save selection to Tmux paste buffer |
| `<space><space>x` | Normal, Visual | Save & execute current `.vim` / `.lua` file |
| `:OverseerRun` / `:OverseerToggle` | Command | Run/toggle Overseer tasks |
| `<space>db` / `<space>dB` / `<space>dC` | Normal | DAP toggle breakpoint / conditional breakpoint / clear all |
| `<space>dc` / `<space>dn` / `<space>ds` / `<space>du` | Normal | DAP continue / step over / step into / step out |
| `<space>di` / `<space>dr` / `<space>dl` / `<space>dt` / `<space>do` | Normal | DAP toggle UI / REPL / run last / disconnect / load breakpoint files |

### 7. Git inside Neovim & Buffers/Folds

| Key | Mode | Action |
|---|---|---|
| `<space>gs` / `<space>gc` | Normal, Visual | Open Neogit status / Neogit commit |
| `\dv` / `\dc` / `\dq` | Normal | Open / close Diffview |
| `]h` / `[h` | Normal | Next / previous git hunk |
| `\hs` / `\hr` / `\hu` / `\hS` / `\hR` | Normal, Visual | Stage / reset / undo stage hunk or buffer (`Gitsigns`) |
| `\hp` / `\hb` / `\hB` / `\hd` / `\hD` | Normal | Preview hunk / blame line / toggle blame / diff / deleted |
| `ih` | Visual, Op | Select git hunk text object |
| `\bp` / `\bP` | Normal | Pin / close non-pinned bufferline tabs |
| `zR` / `zM` | Normal | Open / close all folds (`nvim-ufo`) |
| `]q` / `[q` / `]t` / `[t` | Normal | Next/prev quickfix (`q`) / TODO comment (`t`) |

### 8. Language-Specific & Notebook Keys

- **Python (`python_keymaps.lua`, `python-import.nvim`, `neogen`)**:
  - `<space>i` / `<M-CR>`: Add Python import (move cursor / stay in place)
  - `<space>tr`: Insert Rich traceback
  - `<space>tp` / `<space>tP`: Convert `os.path` to `pathlib.Path` (with / without `Path()` wrapper)
  - `<space>tq` / `<space>ti` / `<space>tF` / `<space>tI`: Toggle `# noqa` / `# pyright: ignore` / fix current line / fix `F401` unused imports
  - `<space>td`: Generate Google-style docstring (`neogen`)
- **Jupyter / Molten (`molten-nvim`)**:
  - `<space>mx` (eval visual or cell), `<space>mX` (eval line), `<space>mr` (re-eval), `<space>md` (delete), `<space>mh` (hide output), `<space>me` (enter output)
- **Markdown (`markdown_keymaps.lua`)**:
  - `<space>tl` / `<space>tL`: Turn word/selection into Markdown link (`[text]` + `(url)`)
- **Treesitter Text Objects (`lua/mohan/ts_textobjs.lua`)**:
  - Select (`v`/`d`/`c` +): `am`/`im` (function), `al`/`il` (class), `aa`/`ia` (parameter), `ab`/`ib` (block), `ad`/`id` (conditional), `ao`/`io` (loop), `ai`/`ii`/`aI`/`iI` (indent), `ae`/`ie` (entire file), `az`/`iz` (fold), `ac`/`ic` (comment)
  - Move: `]m`/`[m` (function), `]l`/`[l` (class), `]a`/`[a` (parameter), `;`/`,` repeat last move
  - Swap: `)a`/`(a` (parameter), `)m`/`(m` (function), `<space>.` / `<space>,` (`iswap`), `<space><space><space>.` / `,` (`sibling-swap`)

---

## Sessions (tmux-resurrect)

Inside tmux, when Neovim starts in a git repository it keeps `./Session.vim` up to date
([vim-obsession](https://github.com/tpope/vim-obsession)). After a reboot,
tmux-resurrect (`Ctrl+b` `Ctrl+r`) reopens Neovim in each pane with `nvim -S`, so your
files, splits and tabs come back. `Session.vim` is ignored globally by git.

- Skipped when Neovim is the git commit/rebase editor, the man pager, `nvim -d`, or reads stdin.
- `:Obsession!` stops tracking and deletes the file. `export NVIM_NO_AUTO_SESSION=1` turns it off.
- File trees, the dashboard and terminals are not saved (`sessionoptions` has no `blank`/`terminal`).

## Language servers

Installed by Mason on first start: `emmylua_ls`, `html`, `cssls`, `tailwindcss`, `vtsls`,
`jsonls`, `biome`, `pyrefly`, `bashls`, `yamlls`, `vimls`, `dockerls`,
`docker_compose_language_service`, `marksman`, `taplo`, `clangd` (plus `rust_analyzer` via
rustaceanvim). Edit the list in [`lua/mohan/lsp/init.lua`](lua/mohan/lsp/init.lua).

## Checks

[`.github/workflows/lint.yml`](../.github/workflows/lint.yml) starts this config headless on
every push and runs [`tests/`](tests/) (`check_wiring.lua`, `test_auto_session.py`).

## Installing & Profiles

Install mise CLI tools ([`../mise-config/config.toml`](../mise-config/config.toml)) first, then set up the Neovim Python/Node providers (`~/.virtualenvs/neovim`):

```bash
./install-dependencies.sh
```

```bash
# Optional: GitHub Copilot setup
nvim +"lua require('lazy').install({wait=true})" +qa
nvim '+Copilot setup' +q
nvim '+Copilot enable' +q

# Optional: restore pinned plugin lockfile or use stable tag
git checkout stable
nvim +"lua require('lazy').restore({wait=true})" +qa
```

Check health inside Neovim:

```vim
:checkhealth mohan
```

Alternate profiles included in [`../oh-my-zsh/custom/aliases.zsh`](../oh-my-zsh/custom/aliases.zsh):
- `v` / `vi` -> Main `nvim/` config
- `vic` -> CoC fallback ([`../nvim-coc/README.md`](../nvim-coc/README.md))
- `lazyvim` -> LazyVim starter ([`../nvim-lazyvim/README.md`](../nvim-lazyvim/README.md))
- `csvi` -> CSV column alignment ([`csv_init.lua`](csv_init.lua) with `:CsvAlign`, `:TsvAlign`, `H`/`L`)
- `vscode_init.lua` -> VSCode-Neovim entry point
- `treemux_init.lua` -> Treemux Tmux sidebar config
