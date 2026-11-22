#!/usr/bin/env bash
# Install TPM and the plugins listed in ~/.tmux.conf, plus the /usr/bin/python3
# packages treemux and tmux-window-name need. Safe to re-run.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tmux/scripts/no-auto-restore.sh
source "$DIR/scripts/no-auto-restore.sh"
trap tmux_resume_auto_restore EXIT

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d $TPM_DIR ]]; then
	git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# TPM's bin scripts need no running server or session (they start one to read
# the config); keep that server from restoring saved sessions.
tmux_pause_auto_restore
"$TPM_DIR/bin/install_plugins"

# treemux and tmux-window-name dependencies, for /usr/bin/python3 (outside mise).
# --break-system-packages only where pip knows it (pip >= 23; not Xcode's), and
# fall back to --user where the system site-packages isn't writable.
pip_install() {
	local -a args=(install pynvim libtmux)
	if /usr/bin/python3 -m pip install --help 2>/dev/null | grep -q -- '--break-system-packages'; then
		args+=(--break-system-packages)
	fi
	/usr/bin/python3 -m pip "${args[@]}" || /usr/bin/python3 -m pip "${args[@]}" --user
}
pip_install
