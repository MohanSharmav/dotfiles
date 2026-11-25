#!/usr/bin/env bash
# One command for any machine (macOS or Ubuntu/Debian) to end up looking and
# behaving exactly like the others:
#   1. switch this checkout to master and pull (skipped offline / --skip-git)
#   2. migrate existing configs (backed up to ~/.dotfiles_backup_<time>) and
#      install everything with this OS's setup script:
#        macOS          -> setup_mac.sh     (e.g. --with-wm)
#        Ubuntu/Debian  -> setup_ubuntu.sh  (e.g. --server, --no-apt, --no-chsh)
#   3. finish with update.sh --skip-git: Neovim plugins at the lockfile
#      versions, unused Neovim/tmux plugins removed, tmux/kitty reloaded and
#      GNOME Terminal given the same Monokai colours.
#
# Usage: ./migrate_and_setup.sh [--skip-git] [setup options...]
#   e.g. ./migrate_and_setup.sh                 # Ubuntu desktop or macOS
#        ./migrate_and_setup.sh --server        # Ubuntu without a desktop
#        ./migrate_and_setup.sh --no-apt        # Ubuntu without sudo
#        ./migrate_and_setup.sh --dry-run       # show what would happen
# Setup options are passed on unchanged; see ./setup_ubuntu.sh --help.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_GIT=0
DRY_RUN=0
SKIP_NETWORK=0
SETUP_ARGS=()
for arg in "$@"; do
	case "$arg" in
	--skip-git) SKIP_GIT=1 ;;
	-h | --help)
		sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		[[ $arg == --dry-run ]] && DRY_RUN=1
		[[ $arg == --skip-network ]] && SKIP_NETWORK=1
		SETUP_ARGS+=("$arg")
		;;
	esac
done

say() { printf '\n\033[1;32m[migrate]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[migrate] WARN:\033[0m %s\n' "$*" >&2; }

case "$(uname -s)" in
Darwin) SETUP="$DOTFILES_DIR/setup_mac.sh" ;;
Linux)
	if [[ -r /etc/os-release ]] && ! grep -qiE '^(ID|ID_LIKE)=.*(ubuntu|debian)' /etc/os-release; then
		warn "Not Ubuntu/Debian; setup_ubuntu.sh may not work here."
	fi
	SETUP="$DOTFILES_DIR/setup_ubuntu.sh"
	;;
*)
	echo "migrate_and_setup.sh: unsupported OS $(uname -s) (macOS and Ubuntu/Debian only)" >&2
	exit 1
	;;
esac

# Updating must resolve versions online; the shell setting only stops that
# while typing commands.
unset MISE_PREFER_OFFLINE

# 1. Same commit as every other machine.
if [[ $SKIP_GIT -eq 0 && -d "$DOTFILES_DIR/.git" ]]; then
	say "Switching to master and pulling"
	git_run() { if [[ $DRY_RUN -eq 1 ]]; then echo "[dry-run] git $*"; else git -C "$DOTFILES_DIR" "$@"; fi; }
	if [[ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]]; then
		warn "Uncommitted changes in $DOTFILES_DIR; not switching or pulling. Commit or stash them, then re-run."
	else
		cur="$(git -C "$DOTFILES_DIR" rev-parse --abbrev-ref HEAD)"
		if ! git_run fetch --quiet origin; then
			warn "git fetch failed (network/TLS?). Continuing with the local copy."
		fi
		if [[ $cur != master ]]; then
			git_run checkout --quiet master || warn "Could not switch from '$cur' to master."
		fi
		git_run pull --ff-only --quiet origin master || warn "git pull failed; continuing with the local copy."
		say "At $(git -C "$DOTFILES_DIR" log -1 --format='%h %s')"
	fi
fi

# 2. Install and link everything for this OS.
say "Running $(basename "$SETUP") ${SETUP_ARGS[*]:-}"
"$SETUP" "${SETUP_ARGS[@]}"

# 3. Pin plugins to the lockfile, clean leftovers, apply the terminal theme.
UPDATE_ARGS=(--skip-git)
[[ $DRY_RUN -eq 1 ]] && UPDATE_ARGS+=(--dry-run)
[[ $SKIP_NETWORK -eq 1 ]] && UPDATE_ARGS+=(--skip-plugins)
say "Finishing with update.sh ${UPDATE_ARGS[*]}"
"$DOTFILES_DIR/update.sh" "${UPDATE_ARGS[@]}" || warn "update.sh reported problems (see above)."

say "Done. Open a new terminal (or run: exec zsh) and restart Neovim and tmux."
