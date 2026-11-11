# Helix Editor Config

Configs: [`config.toml`](config.toml) and [`languages.toml`](languages.toml) (CLI installed by `mise-config/config.toml`).

Features enabled: `dracula` theme, relative line numbers, true color, LSP inlay hints + messages, bar/block/underline cursor shapes per mode, and `ruff` + `basedpyright` Python LSP (`tab-width = 4`, auto-format enabled).

---

## Keybindings (`config.toml`)

| Key | Mode | Action |
|---|---|---|
| `Ctrl + o` / `Ctrl + r` | Normal | Open config (`:config-open`) / reload config (`:config-reload`) |
| `Ctrl + h` / `Ctrl + l` | Normal | Select previous / next AST sibling |
| `Ctrl + j` / `Ctrl + k` | Normal | Shrink / expand syntax tree selection |
| `o` / `O` | Normal | Open blank line below / above and stay in Normal mode |
| `i` / `a` | Normal | Enter insert / append mode and collapse selection |
| `w` / `W` / `e` / `E` / `b` / `B` | Normal | Vim-style word motions (collapsing selection) |
| `dd`, `dw`, `dgg`, `dG`, `dj`, `dk` | Normal | Vim-style line/motion delete & copy to system clipboard |
| `yy`, `yw`, `ygg`, `yG`, `yj`, `yk`, `Y` | Normal | Vim-style yank to system clipboard |
| `p` / `P` | Normal, Select | Paste/replace from system clipboard |
| `*` / `#` | Normal | Search word under cursor forward / backward |
| `S` / `ds` | Normal, Select | Add surrounding / delete surrounding |
| `u` / `U` | Select | Lowercase / uppercase selection |
| `Tab` / `Ctrl + a` | Select | Enter insert / append mode on cursors |
| `Esc` | Normal, Insert, Select | Collapse selection and exit to Normal mode |

