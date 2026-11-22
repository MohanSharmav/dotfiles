#!/usr/bin/env bash
# macOS setup for these dotfiles. Safe to re-run: every step checks first.
#
#   1. Xcode Command Line Tools (git, compilers for Treesitter parsers / cargo)
#   2. Homebrew + Brewfile (rustup, uv, bun, eza, kitty, Nerd Fonts);
#      --with-wm adds Brewfile.wm (AeroSpace, SketchyBar, skhd, Hammerspoon, Karabiner)
#   3. Config links (backing up whatever was there) incl. the macOS-only configs
#   4. User-space tools: mise + its tools, Oh My Zsh, zsh plugins, Rust tools,
#      Neovim plugins, tmux plugins, terminfo, Claude Code
#   5. macOS integration: Hammerspoon config path, window-manager services,
#      Terminal.app font/colours
#   6. Verification
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_TAG="setup_mac"
DRY_RUN=0
SKIP_NETWORK=0
WITH_WM=0
PRINT_LINKS=0

usage() {
	cat <<'EOF'
Usage: ./setup_mac.sh [options]

Sets up these dotfiles on macOS: Homebrew packages, config links (existing
files are backed up to ~/.dotfiles_backup_<time>), mise tools, Neovim and tmux
plugins, Rust tools, terminfo and Claude Code. Safe to re-run.

Options:
  --with-wm        Also install and start the window-manager stack (Brewfile.wm):
                   AeroSpace, SketchyBar, skhd, Hammerspoon, Karabiner-Elements
  --skip-network   Offline: only relink configs and verify (used by update.sh)
  --dry-run        Print every change instead of making it
  -h, --help       Show this help

Updating later: ./update.sh
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--with-wm) WITH_WM=1 ;;
	--skip-network) SKIP_NETWORK=1 ;;
	--dry-run) DRY_RUN=1 ;;
	--print-links) PRINT_LINKS=1 ;; # for tests/test_setup_scripts.py
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		usage >&2
		exit 2
		;;
	esac
	shift
done

# shellcheck source=scripts/setup-common.sh
source "$DOTFILES_DIR/scripts/setup-common.sh"

# Configs only macOS uses (keep in sync with mise.toml [dotfiles], os = "macos").
MAC_LINKS=(
	"karabiner:$HOME/.config/karabiner"
	"skhd:$HOME/.config/skhd"
	"yabai:$HOME/.config/yabai"
	"aerospace:$HOME/.config/aerospace"
	"sketchybar:$HOME/.config/sketchybar"
	"hammerspoon:$HOME/.config/hammerspoon"
)

if [[ $PRINT_LINKS -eq 1 ]]; then
	print_links "${COMMON_LINKS[@]}" "${MAC_LINKS[@]}"
	exit 0
fi

BREWFILES=("$DOTFILES_DIR/Brewfile")
if [[ $WITH_WM -eq 1 ]]; then
	BREWFILES+=("$DOTFILES_DIR/Brewfile.wm")
fi

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "setup_mac.sh is for macOS; on Ubuntu run ./setup_ubuntu.sh" >&2
	exit 1
fi

# ---------------------------------------------------------------------------
# macOS-only steps
# ---------------------------------------------------------------------------

# git, clang and make come from the Command Line Tools. Their installer is a GUI
# dialog that can't be waited on from a script, so start it and stop here.
step_xcode_clt() {
	section "Xcode Command Line Tools"
	if xcode-select -p >/dev/null 2>&1; then
		log "OK $(xcode-select -p)"
		return 0
	fi
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] xcode-select --install (then re-run this script)\n'
		return 0
	fi
	xcode-select --install || true
	echo
	log "Finish the Command Line Tools install in the dialog that just opened, then re-run ./setup_mac.sh"
	exit 1
}

load_brew() {
	local brew
	for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
		if [[ -x $brew ]]; then
			eval "$("$brew" shellenv)"
			return 0
		fi
	done
	return 1
}

step_homebrew() {
	section "Homebrew"
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		load_brew || true
		log "Skipped (--skip-network)"
		return 0
	fi
	if ! load_brew; then
		if [[ $DRY_RUN -eq 1 ]]; then
			printf '[dry-run] install Homebrew (https://brew.sh installer)\n'
			return 0
		fi
		log "Installing Homebrew (it asks for your password once)..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
		if ! load_brew; then
			warn "Homebrew is required on macOS; install it from https://brew.sh and re-run"
			exit 1
		fi
	fi
	[[ $DRY_RUN -eq 1 ]] || log "OK $(brew --version | head -n 1)"

	local file
	for file in "${BREWFILES[@]}"; do
		# Install what's missing; leave installed packages at their version
		# (./update.sh upgrades them).
		if [[ $DRY_RUN -eq 0 ]] && HOMEBREW_BUNDLE_NO_UPGRADE=1 brew bundle check --file="$file" >/dev/null 2>&1; then
			log "OK everything in $(basename "$file") is installed"
		else
			run_step "brew bundle $(basename "$file")" env HOMEBREW_BUNDLE_NO_UPGRADE=1 brew bundle install --file="$file" || true
		fi
	done
}

# Hammerspoon reads ~/.hammerspoon unless told otherwise; the config is linked
# to ~/.config/hammerspoon. The other apps read ~/.config/<app> on their own.
step_hammerspoon_config() {
	[[ -d /Applications/Hammerspoon.app ]] || return 0
	local want="$HOME/.config/hammerspoon/init.lua"
	if [[ "$(defaults read org.hammerspoon.Hammerspoon MJConfigFile 2>/dev/null || true)" != "$want" ]]; then
		run_step "Hammerspoon config path" defaults write org.hammerspoon.Hammerspoon MJConfigFile "$want" || true
	fi
}

# Start the window-manager stack once; each starts at login from then on.
step_window_manager() {
	step_hammerspoon_config
	[[ $WITH_WM -eq 1 ]] || return 0
	section "Window manager"
	if [[ $SKIP_NETWORK -eq 0 && ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]]; then
		# Glyphs for SketchyBar's workspace app icons (not in Homebrew).
		run_step "sketchybar-app-font" curl -fsSL -o "$HOME/Library/Fonts/sketchybar-app-font.ttf" \
			https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf || true
	fi
	if have sketchybar && ! brew services list 2>/dev/null | grep -qE '^sketchybar +started'; then
		run_step "start SketchyBar" brew services start sketchybar || true
	fi
	if have skhd && ! launchctl list 2>/dev/null | grep -q 'com.koekeishiya.skhd'; then
		run_step "start skhd" skhd --start-service || true
	fi
	# `open` is a no-op for an app that is already running.
	local app
	for app in AeroSpace Hammerspoon "Karabiner-Elements"; do
		if [[ -d "/Applications/$app.app" ]]; then
			run_step "launch $app" open -ga "$app" || true
		fi
	done
	log "Grant Accessibility (System Settings > Privacy & Security) to AeroSpace, skhd,"
	log "SketchyBar and Hammerspoon, and approve Karabiner's driver when macOS asks."
}

# Terminal.app (for when kitty isn't running yet): Nerd Font for icons instead
# of "?" boxes, and Monokai colours matching nvim/tmux, on the default profile.
step_terminal_app() {
	if ! compgen -G "$HOME/Library/Fonts/JetBrainsMonoNerdFontMono-*.ttf" >/dev/null &&
		! compgen -G "/Library/Fonts/JetBrainsMonoNerdFontMono-*.ttf" >/dev/null; then
		return 0
	fi
	section "Terminal.app profile"
	run_step "Terminal.app font + Monokai colours" set_terminal_profile || true
}

set_terminal_profile() {
	osascript \
		-e 'tell application "Terminal"' \
		-e 'set s to default settings' \
		-e 'set font name of s to "JetBrainsMonoNFM-Regular"' \
		-e 'set font size of s to 12' \
		-e 'set background color of s to {10023, 10280, 8738}' \
		-e 'set normal text color of s to {63736, 63736, 62194}' \
		-e 'set bold text color of s to {63736, 63736, 62194}' \
		-e 'set cursor color of s to {63736, 63736, 61680}' \
		-e 'end tell' >/dev/null
}

verify_mac() {
	if have brew; then
		local file
		for file in "${BREWFILES[@]}"; do
			if HOMEBREW_BUNDLE_NO_UPGRADE=1 brew bundle check --file="$file" >/dev/null 2>&1; then
				check brew "$(basename "$file") satisfied"
			else
				check brew "$(basename "$file") has missing packages (brew bundle check --file=$file --verbose)"
				[[ $DRY_RUN -eq 1 || $SKIP_NETWORK -eq 1 ]] || HAD_ERRORS=1
			fi
		done
	else
		check brew "NOT INSTALLED"
		[[ $DRY_RUN -eq 1 ]] || HAD_ERRORS=1
	fi
	check shell "login shell: $(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"
}

# ---------------------------------------------------------------------------

main() {
	log "macOS $(sw_vers -productVersion 2>/dev/null) ($(uname -m)), dotfiles at $DOTFILES_DIR"
	[[ $DRY_RUN -eq 1 ]] && log "Dry run: nothing will be changed"

	step_xcode_clt
	step_homebrew
	load_path

	step_cleanup_legacy
	step_links "${MAC_LINKS[@]}"

	step_user_tools
	step_mise
	step_submodules
	step_rust
	step_nvim
	step_tmux
	step_terminfo
	step_claude

	step_window_manager
	step_terminal_app

	verify_common
	verify_mac
	finish
}

main
