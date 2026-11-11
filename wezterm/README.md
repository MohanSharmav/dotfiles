# WezTerm Config & Shortcuts

Config: [`wezterm.lua`](wezterm.lua). Symlinked to `~/.config/wezterm`.

> [!WARNING]
> With `config.term = "wezterm"`, run `bash terminfo.sh` locally and `bash terminfo.sh <server>` on remote SSH hosts (or switch `config.term = "xterm-256color"`).

---

## Shortcuts (`wezterm.lua`)

| Key | Action | Notes |
|---|---|---|
| `Ctrl + Shift + Space` | Quick Select mode | Copy URLs, paths, hashes, numbers (`Shift+<label>` pastes) |
| `Cmd + Shift + R` | Reload config | Reloads `wezterm.lua` |
| `Cmd + Shift + F2` / `F3` | Previous tab | Activate tab to the left |
| `Cmd + Shift + F6` | Next tab | Activate tab to the right |
| `Ctrl + Shift + Left` / `Right` | Move tab | Reorder current tab left / right |
| `Cmd + Shift + D` | Detach pane to new window | `pane:move_to_new_window()` |
| `Cmd + Shift + C` | Detach pane to new tab | `pane:move_to_new_tab()` |
| `Ctrl + Shift + Alt + \|` | Split pane right (50%) | — |
| `Ctrl + Shift + Alt + _` | Split pane down (50%) | — |
| `Shift + Up` / `Down` | Scroll to previous / next prompt | Requires OSC 133 shell integration (outside Tmux) |
| `Alt + Enter` | Disabled default | Passed through cleanly to Neovim (`python-import.nvim`) |
| `Ctrl + Shift + +` / `_` | Disabled on macOS | Use `Cmd + =` / `Cmd + -` for font zoom |

Features configured in `wezterm.lua`: Kitty keyboard protocol (`enable_kitty_keyboard = true`), Kitty graphics protocol, 30,000-line scrollback, semi-transparent background (`0.85` opacity, macOS blur `20`), and custom clickable hyperlink regexes (GitHub `ssh://`, parenthesized/bracketed URLs).

---

## Settings for Ubuntu

Add `Open with Wezterm` context menu and make `Ctrl+Alt+t` open WezTerm via [nautilus-open-any-terminal](https://github.com/Stunkymonkey/nautilus-open-any-terminal):

```bash
sudo apt update && sudo apt install -y python3-nautilus
pip install --user nautilus-open-any-terminal
nautilus -q
glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal wezterm
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
```

If needed, set default terminal:

```bash
sudo update-alternatives --config x-terminal-emulator
```
