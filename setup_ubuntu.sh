#!/usr/bin/env bash
# Ubuntu / Debian / Linux setup script for dotfiles
# Installs APT dependencies (if available), replaces legacy configs,
# sets up user-space tools (rustup, uv, bun, mise, miniforge3),
# installs Nerd Fonts, and bootstraps Neovim and Tmux.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != "Linux" ]]; then
	echo "[setup_ubuntu][error] This script is intended for Ubuntu / Linux. Detected: $(uname -s)" >&2
	echo "For macOS, run: ./setup_mac.sh" >&2
	exit 1
fi

echo "========================================="
echo "   Starting Ubuntu / Linux Setup         "
echo "========================================="

# 1. Check and install core Debian/Ubuntu packages if apt-get is available
if command -v apt-get >/dev/null 2>&1; then
	echo "[setup_ubuntu] Checking recommended apt packages..."
	packages=(build-essential curl git zsh tmux xclip wl-clipboard unzip wget fontconfig)
	missing=()
	for pkg in "${packages[@]}"; do
		if ! dpkg -s "$pkg" >/dev/null 2>&1; then
			missing+=("$pkg")
		fi
	done

	if [[ ${#missing[@]} -gt 0 ]]; then
		echo "[setup_ubuntu] Installing missing packages: ${missing[*]}"
		if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
			apt-get update -y && apt-get install -y "${missing[@]}"
		elif command -v sudo >/dev/null 2>&1; then
			echo "[setup_ubuntu] Requesting sudo to install apt packages..."
			sudo apt-get update -y && sudo apt-get install -y "${missing[@]}" || {
				echo "[setup_ubuntu][warn] Failed to install some apt packages; continuing with user-space install..." >&2
			}
		else
			echo "[setup_ubuntu][warn] sudo not available; skipping apt install. Please ensure required packages are installed." >&2
		fi
	else
		echo "[setup_ubuntu] All recommended apt packages are already installed."
	fi
fi

# 2. Run core migration & setup with standalone Linux installers and Nerd Fonts enabled
exec "$DOTFILES_DIR/migrate_and_setup.sh" --with-installers --with-fonts "$@"
