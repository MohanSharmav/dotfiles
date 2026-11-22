#!/usr/bin/env bash
# Ubuntu (and Debian-family) setup for these dotfiles. Safe to re-run.
# Works without sudo: apt packages are the only step that needs it, and every
# tool after that installs under $HOME.
#
#   1. apt packages (build tools, zsh, python3-pip; clipboard tools and fonts on
#      a desktop). Skipped with a warning when there is no sudo.
#   2. zsh: built under ~/.local when apt couldn't install it
#   3. Config links (backing up whatever was there) incl. Linux-only configs
#   4. User-space tools: rustup, uv, bun, mise + its tools, pixi extras (tig,
#      chafa, poppler, ...), Oh My Zsh, zsh plugins, Rust tools, Neovim
#      plugins, tmux plugins, terminfo, Claude Code
#   5. Desktop only: JetBrainsMono Nerd Font in ~/.local/share/fonts
#   6. zsh as the login shell (chsh, or exec zsh from ~/.bashrc without it)
#   7. Verification
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_TAG="setup_ubuntu"
DRY_RUN=0
SKIP_NETWORK=0
NO_APT=0
NO_CHSH=0
MODE=auto # desktop | server | auto (desktop when a display session is present)
PRINT_LINKS=0

usage() {
	cat <<'EOF'
Usage: ./setup_ubuntu.sh [options]

Sets up these dotfiles on Ubuntu/Debian: apt packages, config links (existing
files are backed up to ~/.dotfiles_backup_<time>), user-space tools under
$HOME, Neovim and tmux plugins, Rust tools, terminfo, Claude Code, and zsh as
the login shell. Safe to re-run.

Options:
  --desktop        Treat as a desktop: clipboard tools + Nerd Font (default when
                   $DISPLAY, $WAYLAND_DISPLAY or $XDG_CURRENT_DESKTOP is set)
  --server         Treat as a headless server: no fonts or clipboard tools
                   (copying works over OSC 52 from tmux/nvim)
  --no-apt         Don't use apt/sudo at all (zsh is then built under ~/.local)
  --no-chsh        Don't change the login shell
  --skip-network   Offline: only relink configs and verify (used by update.sh)
  --dry-run        Print every change instead of making it
  -h, --help       Show this help

Updating later: ./update.sh
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--desktop) MODE=desktop ;;
	--server) MODE=server ;;
	--no-apt) NO_APT=1 ;;
	--no-chsh) NO_CHSH=1 ;;
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

# Configs only Linux uses (keep in sync with mise.toml [dotfiles], os = "linux").
LINUX_LINKS=(
	"autokey/data:$HOME/.config/autokey/data"
)

if [[ $PRINT_LINKS -eq 1 ]]; then
	print_links "${COMMON_LINKS[@]}" "${LINUX_LINKS[@]}"
	exit 0
fi

if [[ "$(uname -s)" != "Linux" ]]; then
	echo "setup_ubuntu.sh is for Ubuntu/Debian; on macOS run ./setup_mac.sh" >&2
	exit 1
fi

if [[ $MODE == auto ]]; then
	if [[ -n ${DISPLAY:-}${WAYLAND_DISPLAY:-}${XDG_CURRENT_DESKTOP:-} ]]; then
		MODE=desktop
	else
		MODE=server
	fi
fi

# ---------------------------------------------------------------------------
# Ubuntu-only steps
# ---------------------------------------------------------------------------

APT_PACKAGES=(
	build-essential # cc/make: Treesitter parsers, cargo builds, zsh from source
	ca-certificates curl wget git unzip xz-utils
	zsh
	python3-pip python3-venv # pynvim + libtmux for /usr/bin/python3 (treemux, tmux-window-name)
	fontconfig               # fc-list / fc-cache
	tmux                     # fallback until mise installs the latest
)
APT_DESKTOP_PACKAGES=(
	xclip wl-clipboard     # tmux/nvim copy to the system clipboard
	fonts-noto-color-emoji # kitty.conf symbol_map points emoji at it
	fonts-firacode         # plain Fira Code: rich export_svg -> PDF
)

# Run as root, through sudo, or not at all.
as_root() {
	if [[ $EUID -eq 0 ]]; then
		"$@"
	else
		sudo "$@"
	fi
}

can_sudo() {
	[[ $EUID -eq 0 ]] && return 0
	have sudo || return 1
	sudo -n true 2>/dev/null && return 0
	# Ask for the password only when someone is there to type it.
	[[ -t 0 ]] && sudo -v
}

step_apt() {
	section "apt packages ($MODE)"
	if [[ $SKIP_NETWORK -eq 1 || $NO_APT -eq 1 ]]; then
		log "Skipped ($([[ $NO_APT -eq 1 ]] && echo --no-apt || echo --skip-network))"
		return 0
	fi
	if ! have apt-get; then
		warn "apt-get not found (not Debian/Ubuntu?); install the equivalent of: ${APT_PACKAGES[*]}"
		return 0
	fi

	local -a wanted=("${APT_PACKAGES[@]}") missing=()
	[[ $MODE == desktop ]] && wanted+=("${APT_DESKTOP_PACKAGES[@]}")
	local pkg
	for pkg in "${wanted[@]}"; do
		dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q 'install ok installed' || missing+=("$pkg")
	done
	if [[ ${#missing[@]} -eq 0 ]]; then
		log "OK all ${#wanted[@]} packages installed"
		return 0
	fi

	log "Missing: ${missing[*]}"
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] apt-get update && apt-get install -y %s\n' "${missing[*]}"
		return 0
	fi
	if ! can_sudo; then
		warn "No sudo: skipping apt. Ask an admin for: ${missing[*]} (everything else installs under \$HOME)"
		return 0
	fi
	run_step "apt-get update" as_root env DEBIAN_FRONTEND=noninteractive apt-get update -q || true
	run_step "apt-get install" as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y -q "${missing[@]}" || true
}

# Without apt (no sudo, or --no-apt), build zsh + ncurses under ~/.local.
step_zsh() {
	section "zsh"
	if have zsh; then
		log "OK $(zsh --version)"
		return 0
	fi
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		warn "zsh missing; run without --skip-network to build it under ~/.local"
		HAD_ERRORS=1
		return 0
	fi
	if ! have make || ! have cc; then
		warn "zsh is missing and there is no compiler to build it; install zsh (or build-essential) and re-run"
		HAD_ERRORS=1
		return 0
	fi
	log "Building zsh under ~/.local (a few minutes)..."
	run_step "oh-my-zsh/zsh-local-install.sh" bash "$DOTFILES_DIR/oh-my-zsh/zsh-local-install.sh" || true
	load_path
}

# tig, pv, chafa, poppler from conda-forge via pixi (no sudo); macOS gets the
# same from the Brewfile. Defined as a mise task in mise-config/config.toml.
step_extras() {
	section "Extras (pixi)"
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipped (--skip-network)"
		return 0
	fi
	if [[ -z $MISE_BIN && $DRY_RUN -eq 0 ]]; then
		warn "mise not found; skipping mise run install-extras"
		HAD_ERRORS=1
		return 0
	fi
	run_step "mise run install-extras" "${MISE_BIN:-mise}" -C "$HOME" run install-extras || true
}

# JetBrainsMono Nerd Font for the terminal (icons in nvim, the prompt, tmux).
step_fonts() {
	[[ $MODE == desktop ]] || return 0
	section "Fonts"
	if have fc-list && fc-list | grep -q 'JetBrainsMono Nerd Font'; then
		log "OK JetBrainsMono Nerd Font"
		return 0
	fi
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipped (--skip-network)"
		return 0
	fi
	local fontdir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] download JetBrainsMono.zip (nerd-fonts latest) into %s; fc-cache\n' "$fontdir"
		return 0
	fi
	local tmp
	tmp="$(mktemp -d)"
	if curl -fsSL -o "$tmp/JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip &&
		mkdir -p "$fontdir" && unzip -oq "$tmp/JetBrainsMono.zip" '*.ttf' -d "$fontdir"; then
		if have fc-cache; then fc-cache -f "$fontdir" >/dev/null; fi
		log "Installed JetBrainsMono Nerd Font into $fontdir"
	else
		warn "JetBrainsMono Nerd Font download failed"
		HAD_ERRORS=1
	fi
	rm -rf "$tmp"
}

# chsh needs the password and zsh listed in /etc/shells; otherwise (no tty, or
# zsh built under ~/.local) launch zsh from ~/.bashrc instead.
step_login_shell() {
	section "Login shell"
	local zsh_bin current
	zsh_bin="$(command -v zsh || true)"
	current="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
	if [[ -z $zsh_bin ]]; then
		[[ $DRY_RUN -eq 1 ]] || warn "zsh not installed; login shell left as $current"
		return 0
	fi
	if [[ $(basename "$current") == zsh ]]; then
		log "OK $current"
		return 0
	fi
	if [[ $NO_CHSH -eq 1 ]]; then
		log "Skipped (--no-chsh); login shell is $current"
		return 0
	fi
	if grep -qx "$zsh_bin" /etc/shells 2>/dev/null && [[ -t 0 ]]; then
		log "Changing login shell to $zsh_bin (asks for your password)..."
		if run_step "chsh" chsh -s "$zsh_bin"; then
			return 0
		fi
	fi
	log "Launching zsh from ~/.bashrc instead (chsh unavailable here)"
	run_step "oh-my-zsh/launch-zsh-in-bash.sh" bash "$DOTFILES_DIR/oh-my-zsh/launch-zsh-in-bash.sh" || true
}

verify_ubuntu() {
	local os
	os="$(. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME")"
	check os "${os:-unknown} ($MODE)"
	check shell "login shell: $(getent passwd "$USER" 2>/dev/null | cut -d: -f7)$(grep -q '# Launch ZSH in Bash' "$HOME/.bashrc" 2>/dev/null && echo ' (zsh launched from ~/.bashrc)')"
	if [[ $MODE == desktop ]]; then
		if have fc-list && fc-list | grep -q 'JetBrainsMono Nerd Font'; then
			check font "JetBrainsMono Nerd Font OK"
		else
			check font "JetBrainsMono Nerd Font MISSING"
			[[ $DRY_RUN -eq 1 || $SKIP_NETWORK -eq 1 ]] || HAD_ERRORS=1
		fi
		if have xclip || have wl-copy; then check clipboard "OK"; else check clipboard "no xclip/wl-copy (OSC 52 still works)"; fi
	fi
}

# ---------------------------------------------------------------------------

main() {
	local os
	os="$(. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME")"
	log "${os:-Linux} ($(uname -m)), $MODE mode, dotfiles at $DOTFILES_DIR"
	[[ $DRY_RUN -eq 1 ]] && log "Dry run: nothing will be changed"

	step_apt
	step_zsh
	load_path

	step_cleanup_legacy
	step_links "${LINUX_LINKS[@]}"

	step_user_tools
	step_mise
	step_extras
	step_submodules
	step_rust
	step_nvim
	step_tmux
	step_terminfo
	step_claude

	step_fonts
	step_login_shell

	verify_common
	verify_ubuntu
	finish
}

main
