# Ranger Config

File manager config in [`rc.conf`](rc.conf), plus [`commands.py`](commands.py) and [`scope.sh`](scope.sh).

- Enables terminal image previews using `viu` (`preview_images true`, `preview_images_method viu`).
- Note in [`../mise-config/config.toml`](../mise-config/config.toml): `viu` previews require Pillow in Ranger's Python environment.

## Keybindings (`rc.conf`)

| Key | Command | Effect |
|---|---|---|
| `xd` | `set column_ratios 1,1,8` | Maximize preview column |
| `xc` | `set column_ratios 1,3,6` | Balanced 3-column layout |

