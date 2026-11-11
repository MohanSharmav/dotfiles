# yabai Config (Legacy macOS WM)

Symlinked to `~/.config/yabai`.

> [!NOTE]
> Superseded by [`../aerospace/`](../aerospace/README.md) (AeroSpace) and [`../skhd/skhdrc`](../skhd/skhdrc). Kept for reference with [`../skhd/skhdrc.yabai`](../skhd/skhdrc.yabai).

## Summary (`yabairc`)

- BSP layout with `second_child` placement, 12px gaps/padding, `Alt + left-drag` move, `Alt + right-drag` resize, drop-to-swap, and `mouse_follows_focus off`.
- Helper scripts in `scripts/`:
  - [`clean_empty_spaces.sh`](scripts/clean_empty_spaces.sh) — runs on `space_changed`.
  - [`rotate_without_changing_layout.sh`](scripts/rotate_without_changing_layout.sh) — rotates windows without flipping split tree.
- Excludes non-resizable windows and utility apps (Settings, Finder dialogs, media players, Karabiner-Elements, etc.) from tiling.

