# shellcheck shell=bash
# Sourced by setup scripts (scripts/setup-common.sh, so setup_mac.sh, setup_ubuntu.sh
# and update.sh; and tmux/*-plugins.sh)
# before they start tmux servers of their own.
#
# .tmux.conf sets @continuum-restore 'on', so any tmux server that starts with
# that config, including the one TPM's helpers start with `tmux start-server`
# and throwaway verification servers, would restore the last saved sessions
# (and relaunch Neovim in them) when no other tmux server is running.
# tmux-continuum skips the restore while ~/tmux_no_auto_restore exists; create
# it for the duration of the script, and only remove it if we created it.

TMUX_NO_AUTO_RESTORE_FILE="$HOME/tmux_no_auto_restore"
_TMUX_NO_AUTO_RESTORE_CREATED=0

tmux_pause_auto_restore() {
	if [[ ! -e $TMUX_NO_AUTO_RESTORE_FILE ]]; then
		: >"$TMUX_NO_AUTO_RESTORE_FILE"
		_TMUX_NO_AUTO_RESTORE_CREATED=1
	fi
}

tmux_resume_auto_restore() {
	if [[ $_TMUX_NO_AUTO_RESTORE_CREATED -eq 1 ]]; then
		rm -f "$TMUX_NO_AUTO_RESTORE_FILE"
		_TMUX_NO_AUTO_RESTORE_CREATED=0
	fi
}
