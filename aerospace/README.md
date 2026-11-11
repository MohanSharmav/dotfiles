# AeroSpace (macOS Tiling Window Manager)

Config: [`aerospace.toml`](aerospace.toml), paired with [`../skhd/skhdrc`](../skhd/skhdrc) for hold-to-repeat resize and [`../sketchybar/`](../sketchybar/README.md) for the top status bar. Symlinked to `~/.config/aerospace`.

> Root defaults to horizontal tiling with 12px gaps (48px top on external monitors).

---

## App Launchers

| Shortcut | Launches / Focuses | Notes |
|---|---|---|
| `Alt + \`` (`Alt + Shift + \``) | Visual Studio Code | — |
| `Cmd + Alt + \`` | Unity | — |
| `Alt + 1` / `Alt + Shift + 1` | Finder / New Finder (`~`) | — |
| `Alt + 2` / `Alt + Shift + 2` | Google Chrome / New Chrome | — |
| `Alt + 3` / `Alt + Shift + 3` | Kitty / New Kitty window | — |
| `Alt + 4` / `Alt + Shift + 4` | ChatGPT Classic / New instance | — |
| `Alt + 5` / `Alt + 6` / `Alt + 7` | Telegram / Slack / Notion | — |

---

## Window Focus, Layout & Workspaces

| Shortcut | Action |
|---|---|
| `Alt + Shift + h / j / k / l` | Focus left / down / up / right (`Alt + Shift + v` prev window wrap-around) |
| `Alt + Shift + Left / Down / Up / Right` | Swap window left / down / up / right |
| `Cmd + Alt + h / j / k / l` | Join window with neighbor in direction (creates stacks/splits) |
| `Cmd + Alt + Left / Down / Up / Right` | Move window through layout tree |
| `Alt + Shift + m` | Toggle fullscreen (no outer gaps) |
| `Alt + Shift + g` / `Alt + Shift + s` | Toggle floating / tiling layout |
| `Alt + Shift + c` | Toggle floating for all windows on monitor (`window_layout.sh`) |
| `Alt + Shift + e` | Balance window sizes |
| `Alt + Shift + r` (or `Ctrl+Shift+F2/F6`) | Rotate windows CCW/CW keeping layout (`permute.sh`) |
| `Alt + Shift + z` / `x` | Mirror workspace vertically (`mirror-y`) / horizontally (`mirror-x`) |
| `Alt + Shift + w` / `q` | Focus next monitor / close focused window |
| `F8` / `F10` | Focus prev / next used workspace (`workspace.sh`) |
| `Alt + Shift + p / PgUp` | Move window to prev used workspace |
| `Alt + Shift + n / PgDn` | Move window to next used workspace |
| `Alt + Shift + Home` | Move window to workspace 1 |
| `Alt + Shift + f / End` | Move window to a new workspace |
| `Alt + Shift + Space` | Open terminal on a new workspace |
| `Alt + Shift + d / t / a` | Move window to recent monitor (`d`), main toggle (`t`), secondary toggle (`a`) |
| `F2` / `F6` (Chrome/Firefox) | Previous / next browser tab (`Alt+F2/F6` moves tab in Chrome) |

---

## Resize & Modes

| Shortcut | Mode / Action |
|---|---|
| `Alt + Shift + y / o` | Move vertical divider left / right (`Ctrl + F8 / F10` for larger step) |
| `Alt + Shift + u / i` | Move horizontal divider down / up (`Shift + F10 / F8`) |
| `Cmd + Alt + r` | Enter **resize** mode (`h/j/k/l` or Arrows resize; `Esc` exits to main) |
| `Cmd + Alt + b` | Enter **passthrough** mode (all bindings bypassed; `Cmd + Shift + Alt + b` restores main) |

