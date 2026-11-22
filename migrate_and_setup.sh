#!/usr/bin/env bash
# One command for any machine: migrate existing configs (backed up to
# ~/.dotfiles_backup_<time>) and set up these dotfiles, by running this OS's
# setup script with the same options:
#   macOS          -> setup_mac.sh     (e.g. --with-wm)
#   Ubuntu/Debian  -> setup_ubuntu.sh  (e.g. --server, --no-apt, --no-chsh)
# Both accept --dry-run and --skip-network; see their --help.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
Darwin) exec "$DOTFILES_DIR/setup_mac.sh" "$@" ;;
Linux) exec "$DOTFILES_DIR/setup_ubuntu.sh" "$@" ;;
*)
	echo "migrate_and_setup.sh: unsupported OS $(uname -s) (macOS and Ubuntu/Debian only)" >&2
	exit 1
	;;
esac
