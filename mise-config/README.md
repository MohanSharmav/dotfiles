# mise Global Tool Configuration

Symlinked by the root [`../mise.toml`](../mise.toml) to `~/.config/mise` (`config.toml` + `mise.lock`).

## Managed Tools (`config.toml`)

- **Core:** `neovim`, `tmux`, `helix`, `node` (`lts`), `pixi`
- **Shell & Search:** `starship`, `eza` (Linux), `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `viu`, `coreutils` (macOS)
- **CLI Utilities:** `gh`, `jq`, `lazygit`, `bottom` (`btm`), `dust`, `procs`, `csvlens`, `difftastic`, `yazi`, `imagemagick`
- **Formatters / Parsers:** `ruff`, `biome`, `stylua`, `prettier`, `tree-sitter`, `fnox`

(`uv`, `bun`, and `rustup` stay outside `mise` via `oh-my-zsh/install-installers.sh`.)

## Commands

```bash
mise trust
mise run setup-dotfiles           # Symlink all dotfiles (`setup-nvim`, `setup-tmux`, `setup-git` also available)
mise -C "$HOME" install --locked  # Install pinned versions from mise.lock
mise -C "$HOME" run install-extras # OS extras via brew (macOS) or pixi (Linux)
mise -C "$HOME" lock --global --bump # Refresh lockfile
```

