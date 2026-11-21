#!/usr/bin/env bash
# Pick the system clipboard command for tmux copy-mode (`copy-pipe` with no
# argument uses the `copy-command` option).
#
# tmux also sends every copy to the outer terminal with OSC 52 because
# `set-clipboard on` is set, so copying keeps working over SSH or on a headless
# box even when none of the commands below is available. In that case we
# leave `copy-command` empty and rely on OSC 52 alone.

set -u

pick_copy_command() {
	case "$(uname -s)" in
	Darwin)
		command -v pbcopy >/dev/null 2>&1 && {
			echo "pbcopy"
			return
		}
		;;
	esac

	# WSL: write to the Windows clipboard.
	if command -v clip.exe >/dev/null 2>&1; then
		echo "clip.exe"
		return
	fi

	if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null 2>&1; then
		echo "wl-copy"
		return
	fi

	if [ -n "${DISPLAY:-}" ]; then
		if command -v xclip >/dev/null 2>&1; then
			echo "xclip -in -selection clipboard"
			return
		fi
		if command -v xsel >/dev/null 2>&1; then
			echo "xsel --clipboard --input"
			return
		fi
	fi

	echo ""
}

tmux set-option -s copy-command "$(pick_copy_command)"
