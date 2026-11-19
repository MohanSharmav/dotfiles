# Git Configuration & Shortcuts

Symlinked by `mise` to `~/.gitconfig` and `~/.gitignore_global` (`git/.gitconfig`, `git/.gitignore_global`).

- Sets default `[user]` (`name = Mohan`, `email = catchmohansharma@gmail.com`).
- Sets `nvim` as `core.editor` and `sequence.editor` (interactive rebase).
- Uses GitHub CLI (`gh auth git-credential`) as credential helper.
- Loads optional machine-local overrides from `~/.gitconfig.local` (`[include]`), last so they win.
- Defaults: `init.defaultBranch=main`, `push.autoSetupRemote` (first `git push` creates the remote branch),
  `fetch.prune`, `merge.conflictStyle=diff3`, `rerere.enabled` (reuse conflict resolutions),
  `rebase.autoStash/autoSquash/updateRefs`, `diff.algorithm=histogram`, `diff.colorMoved`,
  `commit.verbose`, `branch.sort=-committerdate`, `tag.sort=version:refname`, `column.ui=auto`.
- Zsh git helpers live in [`oh-my-zsh/custom/aliases_git.zsh`](../oh-my-zsh/custom/aliases_git.zsh) (`difftastic` external diff is enabled when `difft` is installed).

---

## `.gitconfig` Aliases (`git <alias>`)

| Alias | Expands to | Use |
|---|---|---|
| `git a` | `git add .` | Stage all changes in directory |
| `git s` | `git status` | Short check working tree status |
| `git st` | `git status` | Check working tree status |
| `git uu` | `git status -u` | Show all untracked files |
| `git b` | `git branch` | List branches |
| `git bh` | `git branch` | List branches |
| `git c` / `git ck` / `git co` / `git cbc` | `git checkout` | Switch branch or restore files |
| `git cm "msg"` | `git commit -m "msg"` | Quick commit with message |
| `git cl` | `git clean -df` | Remove untracked files and directories |
| `git f` | `git fetch` | Fetch default remote |
| `git fo` | `git fetch origin` | Fetch `origin` |
| `git p` / `git ps` | `git push` | Push current branch |
| `git pl` | `git pull` | Pull current branch (`rebase = false`) |
| `git gr` | `git log --graph --oneline --all` | Compact branch graph across all refs |
| `git graph` | `git log --graph --abbrev-commit --date=relative ...` | Detailed colored graph with relative time and author |

---

## Zsh Git Aliases & Functions (`aliases_git.zsh`)

In addition to Oh My Zsh's `git` and `gh` plugins:

| Command | Action |
|---|---|
| `cdg` | `cd` to the current repository root (`git rev-parse --show-toplevel`) |
| `groot` | Print repository root path |
| `gad` | Stage all (`ga .`) |
| `gc` | Add `~/.ssh/id_ed25519` if present + `git commit --verbose` (adds `--gpg-sign` when signing is configured) |
| `gcmd` | Quick commit with `.` message (`gc -m "."`) |
| `glr` | `git pull --rebase` |
| `gglr [branch]` | `git pull --rebase origin <branch>` (defaults to current branch) |
| `ggpf [branch]` | `git push origin <branch> --force-with-lease` (defaults to current branch) |
| `gurl` | Print `remote.origin.url` |
| `gi <langs...>` | Fetch gitignore template, prepending `.playwright-mcp/` and `.DS_Store` |
| `ghr` / `ghb` / `ghc` | `gh repo` / `gh browse` / `gh repo clone` |

---

## Global Ignores (`.gitignore_global`)

Also ignores `Session.vim` (Neovim sessions kept for tmux-resurrect).

Automatically ignores across all repos:
- `.*.sw?` (Vim swap files)
- `target` (Rust build directory)

