#!/usr/bin/env bash
# Project switcher (prefix + f): pick a directory from existing tmux sessions and
# zoxide's history, then switch to its session, creating it there if needed.
set -euo pipefail

dir=$(
	{
		tmux list-sessions -F '#{session_path}' 2>/dev/null || true
		zoxide query -l 2>/dev/null || true
	} | awk 'NF && !seen[$0]++' |
		fzf --reverse --prompt='project> ' --preview 'ls -A {}' --preview-window=right,40%
) || exit 0
[[ -d $dir ]] || exit 0

# tmux session names can't contain '.' or ':'.
name=$(basename "$dir" | tr '.:' '__')
# Same basename but a different project (e.g. two "api" dirs): add the parent.
existing=$(tmux display-message -p -t "=$name" '#{session_path}' 2>/dev/null || true)
if [[ -n $existing && $existing != "$dir" ]]; then
	name="$(basename "$(dirname "$dir")" | tr '.:' '__')_$name"
fi

if ! tmux has-session -t "=$name" 2>/dev/null; then
	tmux new-session -d -s "$name" -c "$dir"
fi
tmux switch-client -t "=$name"
