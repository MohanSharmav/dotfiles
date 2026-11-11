# skhd Config (macOS Hotkey Daemon)

Symlinked to `~/.config/skhd`.

- [`skhdrc`](skhdrc) is the **active** config: handles hold-to-repeat divider resizing (`autorepeat`) for AeroSpace plus passthrough mode syncing with SketchyBar.
- [`skhdrc.yabai`](skhdrc.yabai) is the archived yabai-era config (kept for reference).

---

## Active Shortcuts (`skhdrc`)

| Shortcut | Mode | Action |
|---|---|---|
| `Shift + Alt + y / o` | default | Resize vertical divider left / right (20px, repeats while held) |
| `Shift + Alt + u / i` | default | Resize horizontal divider down / up (20px, repeats while held) |
| `Ctrl + F8 / F10` | default | Resize vertical divider left / right (40px, repeats while held) |
| `Shift + F8 / F10` | default | Resize horizontal divider up / down (20px, repeats while held) |
| `Cmd + Alt + b` | default -> passthrough | Disable resize hotkeys & sync AeroSpace/SketchyBar |
| `Cmd + Shift + Alt + b` | passthrough -> default | Restore main bindings & sync AeroSpace/SketchyBar |

