# Kitty Config & Shortcuts

Config: [`kitty.conf`](kitty.conf) (migrated from `../kinetty/` for upstream Kitty, symlinked to `~/.config/kitty`).

---

## Keybindings (`kitty.conf`)

| Key | Action | Notes |
|---|---|---|
| `Ctrl + Shift + Space` | Quick Select (`quick_select.py`) | Label-pick URLs, paths, UUIDs, git hashes, numbers to clipboard (`Shift+<label>` pastes) |
| `Cmd + Shift + E` | Custom Hyperlinks (`hyperlinks.py`) | Keyboard-open `user/repo`, linter links, bracketed URLs |
| `Cmd + Shift + B` | Toggle Vertical Tabs (`toggle-tab-bar-edge.sh`) | Flips tab bar between top & left sidebar (also in macOS View menu) |
| `Cmd + Shift + R` | Reload `kitty.conf` | — |
| `Cmd + 1` .. `Cmd + 9` | Jump to tab 1..9 | Built-in `Cmd+T` new tab, `Cmd+W` close tab |
| `Cmd + Shift + F2` / `F3` | Previous tab | — |
| `Cmd + Shift + F6` | Next tab | — |
| `Ctrl + Shift + Left` / `Right` | Move tab backward / forward | — |
| `Cmd + Shift + D` | Detach pane to new window | — |
| `Cmd + Shift + C` | Detach pane to new tab | — |
| `Ctrl + Alt + Shift + \` | Vertical split (current dir) | — |
| `Ctrl + Alt + Shift + -` | Horizontal split (current dir) | — |
| `Shift + Up` / `Down` | Scroll to previous / next prompt | Requires shell prompt integration |

macOS notes: Left Option acts as `Alt` (`macos_option_as_alt left`). Remote socket listens at `unix:/tmp/kitty` (`allow_remote_control socket-only`). `Ctrl+Shift+Plus/Minus` are disabled so apps keep them while `Cmd+=`/`Cmd+-` control font size.

---

## Terminfo (Remote SSH)

Use `kitten ssh <host>` (auto-copies terminfo), or run:

```bash
bash terminfo.sh              # local
bash terminfo.sh <server>     # remote SSH server
```

