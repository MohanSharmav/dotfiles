#!/usr/bin/env bash
# macOS setup script for dotfiles
# Replaces legacy configs, creates symlinks, and runs all installers for macOS.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "[setup_mac][error] This script is intended for macOS (Darwin). Detected: $(uname -s)" >&2
	echo "For Ubuntu / Linux, run: ./setup_ubuntu.sh or ./setup_linux.sh" >&2
	exit 1
fi

echo "========================================="
echo "   Starting macOS Dotfiles Setup         "
echo "========================================="

if ! command -v brew >/dev/null 2>&1; then
	echo "[setup_mac][warn] Homebrew not found. For full GUI/CLI tools, install Homebrew at https://brew.sh"
else
	echo "[setup_mac] Found Homebrew: $(command -v brew)"
fi

exec "$DOTFILES_DIR/migrate_and_setup.sh" --with-installers "$@"
