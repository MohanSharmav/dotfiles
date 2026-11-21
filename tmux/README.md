# .tmux.conf

My IDE-like Tmux configuration and tutorial!

**🔑 Key features:**

- Mohan status bar theme (Monokai colours) with CPU, date/time, user & session indicator (ported from `git_nvim_tmux_config`)
- File tree viewer with [treemux](https://github.com/kiyoon/treemux)
- Seamless mouse support
- PID and pane ID viewing for all panes, helping to write scripts instantly.
- Agent session IDs in pane borders (`cc:`, `cx:`, `gc:`, `oc:`).
- More intuitive keybindings

Tmux's default keybindings are quite unintuitive, so I've changed a few.

### Quick Shortcut Table

| Key | Mode / Scope | Action |
|---|---|---|
| `Ctrl+b` | Prefix | Tmux prefix key (`Ctrl+b` then `Ctrl+b` or `z` toggles pane zoom) |
| `Ctrl+b` `\|` / `\` | Window | Vertical split (side-by-side): current dir (`\|`) / default dir (`\`) |
| `Ctrl+b` `-` / `_` | Window | Horizontal split (top/bottom) in current dir |
| `Ctrl+b` `C` / `c` | Window | New window in current dir (`C`) / default dir (`c`) |
| `Ctrl+h/j/k/l` | Global (no prefix) | Seamless pane navigation across Tmux and Neovim |
| `Ctrl+\` | Global (no prefix) | Switch to previous pane (Tmux & Neovim) |
| `Ctrl+b` `H/J/K/L` | Window (repeatable) | Resize pane by 5 (`Ctrl+Alt+y/u/i/o` without prefix) |
| `Ctrl+b` `r` / `R` | Global | Reload `~/.tmux.conf` |
| `Ctrl+b` `a` | Window | Toggle `synchronize-panes` (type in all panes at once) |
| `Ctrl+b` `S` | Pane | Swap current pane with top-left pane |
| `Ctrl+b` `<` / `>` | Window (repeatable) | Move/reorder current window left / right |
| `Ctrl+b` `N` / `P` | Pane (repeatable) | Move pane to next / previous window (`b` breaks pane out) |
| `Ctrl+b` `Tab` / `Backspace` | Global | Toggle Treemux file tree sidebar / toggle + focus |
| `Ctrl+b` `[` then `v` / `y` | Copy mode (vi) | Scroll & copy (`Ctrl+b` `]` pastes; `y`/`Y` copies shell line / `$PWD`) |
| `Ctrl+b` `x` / `X` | Pane / Session | Kill pane (`x`) / confirm kill session (`X`) |
| `Ctrl+Alt+k/j` | Global | Jump to previous / next shell prompt (OSC 133) |

## 🛠️ Installation

1. Make sure your terminal has nerd font set up
2. Put [`.tmux.conf`](.tmux.conf) in your home directory
3. Set up the root mise config (see the repository README), then run [`./install-plugins.sh`](install-plugins.sh). It clones the plugins to `~/.tmux/plugins/` and installs pynvim and libtmux for `/usr/bin/python3`, outside mise. [`./update-plugins.sh`](update-plugins.sh) updates the plugins and these Python packages.
`.tmux.conf` takes tmux's global PATH from a fresh interactive login shell at server start and on every `prefix r` reload, because hooks and `run-shell` commands otherwise keep the PATH of whatever started the server. After a mise upgrade, press `prefix r` so tmux-window-name and the other hooks find the new tool locations.
4. (If not using dotfiles entirely) Configure nvim and zsh to set hook for the tmux-window-name plugin.
This is already configured if you are using my dotfiles.
Treemux and the Neovim/Zsh hooks use `/usr/bin/python3`, with dependencies
installed by [`./install-plugins.sh`](install-plugins.sh).

```zsh
# ~/.zshrc
tmux-window-name() {
    (/usr/bin/python3 "$TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py" &)
}

add-zsh-hook chpwd tmux-window-name
```

```lua
-- ~/.config/nvim/init.lua
-- tmux/install-plugins.sh installs libtmux for system Python.
vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
  callback = function()
    if vim.env.TMUX_PLUGIN_MANAGER_PATH then
      vim.uv.spawn(
        "/usr/bin/python3",
        { args = { vim.env.TMUX_PLUGIN_MANAGER_PATH .. "/tmux-window-name/scripts/rename_session_windows.py" } }
      )
    end
  end,
})
```

> [!NOTE]
> On Mac, for the GPU status to work, add this to the sudoers file (`/etc/sudoers`), replacing the username and omitting the quotes. Be mindful of the two tabs after the username:  
> "username		ALL = (root) NOPASSWD: /usr/bin/powermetrics"

### Agent session IDs

Codex pane borders show `cx:` followed by the last eight session ID characters.
Local (`--no-daemon`) sessions are identified from the process's open rollout file.
Shared-daemon sessions use [`codex-daemon-sid.py`](scripts/codex-daemon-sid.py)
to match the pane's Codex listener to a loaded main thread, following
`godot-ghostty`'s Codex discovery. This uses `/usr/bin/python3` with no extra
packages and reads metadata from the existing daemon. Open SQLite files identify
custom account homes. If the daemon cannot supply a unique match (including
older daemons or disabled task tools), the ID stays blank. Results are cached
for 30 seconds; missing IDs are retried after five seconds.

## 💻 Useful tmux commands

First of all, launch tmux: `tmux`  
or, `tmux new -s <session_name>`

### Create window and navigate

- Ctrl+b + c: create window
- `echo $TMUX_PANE`: see pane number (%0, %1, ..)
- `echo ${TMUX_PANE##%}`: see pane number (0, 1, ..)
- `exit`: exit window
- Ctrl+b + n: next window
- Ctrl+b + p: previous window
- Ctrl+b + t: last window
- Ctrl+b + \<number\>: jump to the window number
- Ctrl+b + '\<number\>\<Enter\>: jump to the window number (use when bigger than 9)
- Ctrl+b + ,: change window title
- Ctrl+b + < / >: re-order windows
- Mouse: drag and hold a window title for 0.5 seconds; the pink `` shows the exact insertion position
- Mouse: click `󰘀` / `󰘁` around the window list to jump to the first / last window, and the `<` / `>` that appear when the list is clipped for the previous / next one

### Detach and resume

- Ctrl+b + d: detach tmux session
- `tmux ls`: list sessions
- `tmux attach` or `tmux a`: attach session
- `tmux attach -t <session_name>`: attach session (specified by the number or name)
- Ctrl+b + s: select and move session

### Divide window (create pane) and navigate

- Ctrl+b + \\: divide screen (vertical)
- Ctrl+b + |: divide screen (vertical, current dir)
- Ctrl+b + - / \_: divide screen (horizontal, current dir)
- Ctrl+b + h/j/k/l: move between panes
- Ctrl+h/j/k/l: move between tmux panes and Neovim splits seamlessly
- Ctrl+\\: switch to previous pane
- Alt + \<ArrowKey\>: move between panes
- Ctrl+b + q + \<number\>: see pane number and move between panes
- Ctrl+b + H/J/K/L: resize panes by 5
- Ctrl+b + z (or Ctrl+b + Ctrl+b): toggle pane zoom
- Ctrl+b + a: toggle synchronize-panes

You can even use mouse right click.

### Swap panes

- Ctrl+b + {: swap with the previous pane
- Ctrl+b + }: swap with the next pane
- Ctrl+b + S: swap with the first (top-left) pane
- Ctrl+b + `:swap-pane -U/-D/-L/-R`: swap with another pane
- Ctrl+b + Ctrl+o: rotate pane clockwise
- Ctrl+b + Alt+o: rotate pane anticlockwise

### Change horizontal split to vertical (and vice versa)

- Ctrl+b + `:move-pane -h -t '.{up-of}'`: horizontal split to vertical
- Ctrl+b + `:move-pane -t '.{left-of}'`: vertical split to horizontal

### Move pane to next/previous window

> [!NOTE]
> This only works if you installed the `./scripts/` dir in `~/.config/dotfiles/tmux/scripts/...`

- Ctrl+b + N: move pane to the next window (repeatable. Keep pressing N)
- Ctrl+b + P: move pane to the previous window (repeatable. Keep pressing P)

### Copy / scroll

- Ctrl+b + \[: Copy mode (use vim commands to scroll)
  - Ctrl+f: page down (front page)
  - Ctrl+b: page up (back page)
  - Ctrl+d: half page down
  - Ctrl+u: half page up
- In copy mode, `v` to select region. `y` (or `Enter`) to copy and `q` to exit copy mode. Then Ctrl+b + ] to paste.
- You can use mouse drag to copy.
- Copies go to the system clipboard on macOS (`pbcopy`), WSL (`clip.exe`), Wayland (`wl-copy`) and X11 (`xclip`/`xsel`), picked by [`scripts/set-copy-command.sh`](scripts/set-copy-command.sh). Over SSH they reach your local clipboard through OSC 52 (`set-clipboard on`).
- Ctrl+b + =: see buffer list

### Kill

- Ctrl+b + x: kill current pane
- Ctrl+b + X: kill session

### Plugins

- Ctrl+b + I: Install plugins
- Ctrl+b + U: Update plugins
- (tmux-resurrect): Ctrl+b + Ctrl+s / Ctrl+r: save / restore all sessions. tmux-continuum also saves every 15 minutes. Neovim panes come back with their files (see *Sessions* in [nvim/README.md](../nvim/README.md)).
- (tmux-yank): Ctrl+b + y: copy bash command line
- (tmux-yank): Ctrl+b + Y: copy PWD
- ([treemux](https://github.com/kiyoon/treemux)): Ctrl+b + \<Tab\>: toggle file browser on the side
- ([treemux](https://github.com/kiyoon/treemux)): Ctrl+b + \<Backspace\>: toggle file browser on the side, and focus on it
- Inside treemux, `<space>o` to toggle between Oil and Nvim-tree.

### Shell integration

OSC 133 is configured in `.zshrc` to move between prompts (commands).

```zsh
if [[ "$PROMPT" != *$'\e]133;A'* ]]; then
  PROMPT=$'%{\e]133;A;cl=m;aid='"$$"$'\a%}'"$PROMPT"$'%{\e]133;B\a%}'
fi

# Before each command, mark StartOutput
preexec() { printf '\e]133;C;\a'; }
```

Move between prompts:

- In Tmux: Ctrl + Alt + k/j
- Outside Tmux (WezTerm setting): Shift + Up/Down

### Other tips 💡

- If you press Ctrl+s by mistake, it will freeze. Ctrl+q to unfreeze.
- On a nested tmux, press `Ctrl+b` twice (`Ctrl+b` + `Ctrl+b`) or pass through command to inner session.
- `Ctrl+b` `:attach -c /new/dir`: change default directory for new windows.
- Shift + drag: bypass tmux mouse integration and select terminal.

## 📜 Advanced: scripting with tmux

- `tmux new-session -d -s <session_name>`: start a session in detached mode.
- `tmux new-window -t <session_name>:<window_index>`: create a window. You can omit the index. You can add the command at the end, but it will automatically be closed when the command finishes.
- `tmux send-keys -t <session_name>:<window_index>.<pane_index> C-u 'some -new command' Enter`: write in a pane. You can use left/right instead of the pane index.
- `tmux kill-window -t <session_name>:<window_index>`: kill window.
- `tmux kill-session -t <session_name>`: kill all windows and session.
- `tmux display -pt "${TMUX_PANE:?}" '#{pane_index}'`: get current pane index
- `tmux list-panes -s -F '#D #{pane_pid} #{pane_current_command}'`: list pane's unique identifier, pid, and the commands. (`-s` for current session, `-a` for all sessions.)

### Example: run batch job

Below will create 3 windows and run python commands like:

- `CUDA_VISIBLE_DEVICES=0 python train.py --arg 1`
- `CUDA_VISIBLE_DEVICES=1 python train.py --arg 2`
- `CUDA_VISIBLE_DEVICES=2 python train.py --arg 3`

```bash
#!/bin/bash

script_dir=$(dirname "$(realpath -s "$0")")
sess="session_name"

tmux new -d -s "$sess" -c "$script_dir"   # Use default directory as this script directory

for window in {0..2}
do
    # Window 0 or 1 may already exist so it will print error. Ignore that.
    tmux new-window -t "$sess:$window"

    command="CUDA_VISIBLE_DEVICES=$window python train.py --arg $((window+1))"
    tmux send-keys -t "$sess:$window" "$command" Enter
done
```

## References

- https://yesmeck.github.io/tmuxrc/
- https://github.com/yesmeck/tmuxrc/blob/master/tmux.conf
- https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
- https://unix.stackexchange.com/questions/318281/how-to-copy-and-paste-with-a-mouse-with-tmux
