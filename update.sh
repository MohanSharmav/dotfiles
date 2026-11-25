#!/usr/bin/env bash
# Update an existing setup: pull the repo (or switch to a tag/branch), relink
# configs via this OS's setup script, then upgrade Homebrew packages (macOS),
# mise tools, the Rust toolchain, Neovim plugins, tmux plugins and Oh My Zsh.
# First-time setup is ./setup_mac.sh or ./setup_ubuntu.sh.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_TAG="dotupdate"
DRY_RUN=0
SKIP_GIT=0
SKIP_PLUGINS=0
FORCE_STASH=0
REF=""

usage() {
	cat <<'EOF'
Usage: ./update.sh [options] [tag-or-branch]

Pulls the dotfiles repo (or checks out tag-or-branch, e.g. `stable`), relinks
configs, and upgrades Homebrew packages (macOS), mise tools, Rust tools, Neovim
and tmux plugins, and Oh My Zsh.

Options:
  --dry-run        Show what would run without changing anything
  --skip-git       Don't pull or check out anything
  --skip-plugins   Skip every download (packages, tools, plugins)
  --force          Stash uncommitted changes before pulling (restored after)
  -h, --help       Show this help
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--dry-run) DRY_RUN=1 ;;
	--skip-git) SKIP_GIT=1 ;;
	--skip-plugins) SKIP_PLUGINS=1 ;;
	--force) FORCE_STASH=1 ;;
	-h | --help)
		usage
		exit 0
		;;
	-*)
		echo "Unknown option: $1" >&2
		usage >&2
		exit 2
		;;
	*) REF="$1" ;;
	esac
	shift
done

SKIP_NETWORK=$SKIP_PLUGINS
# The shell sets this so typing commands never goes online; updating must.
unset MISE_PREFER_OFFLINE
# shellcheck source=scripts/setup-common.sh
source "$DOTFILES_DIR/scripts/setup-common.sh"

case "$(uname -s)" in
Darwin) SETUP_SCRIPT="$DOTFILES_DIR/setup_mac.sh" ;;
*) SETUP_SCRIPT="$DOTFILES_DIR/setup_ubuntu.sh" ;;
esac

update_git_repo() {
	section "Dotfiles repo"
	if [[ $SKIP_GIT -eq 1 ]]; then
		log "Skipped (--skip-git)"
		return 0
	fi
	if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
		warn "$DOTFILES_DIR is not a git repository; skipping"
		return 0
	fi

	local stashed=0
	if [[ -n "$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null || true)" ]]; then
		if [[ $FORCE_STASH -eq 0 ]]; then
			warn "Uncommitted changes: not pulling. Commit them, or pass --force to stash them meanwhile."
			return 0
		fi
		log "Stashing local changes (--force)..."
		run_cmd git -C "$DOTFILES_DIR" stash push -m "dotupdate $(date +%Y%m%d_%H%M%S)"
		stashed=1
	fi

	# Every machine follows master unless a tag/branch is named, so all of them
	# look the same (a machine left on an old feature branch looked different).
	if [[ -z $REF ]]; then
		local cur
		cur="$(git -C "$DOTFILES_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
		if [[ $cur != master ]]; then
			log "On '$cur'; switching to master so this machine matches the others"
			REF=master
		fi
	fi
	if [[ -n $REF ]]; then
		run_step "git fetch" git -C "$DOTFILES_DIR" fetch --tags --quiet || true
		run_step "git checkout $REF" git -C "$DOTFILES_DIR" checkout --quiet "$REF" || true
	fi
	if git -C "$DOTFILES_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
		run_step "git pull" git -C "$DOTFILES_DIR" pull --ff-only --quiet || true
	else
		log "No upstream branch (tag or detached HEAD); not pulling"
	fi
	if [[ $stashed -eq 1 ]]; then
		run_step "git stash pop" git -C "$DOTFILES_DIR" stash pop --quiet || true
	fi
	log "At $(git -C "$DOTFILES_DIR" log -1 --format='%h %s')"
	step_submodules
}

# Relink configs (new ones included) and verify, using this OS's setup script.
relink() {
	section "Config links ($(basename "$SETUP_SCRIPT"))"
	if [[ $DRY_RUN -eq 1 ]]; then
		"$SETUP_SCRIPT" --skip-network --dry-run || true
	else
		run_step "$(basename "$SETUP_SCRIPT") --skip-network" "$SETUP_SCRIPT" --skip-network || true
	fi
}

# macOS: upgrade what the Brewfiles list (setup installs without upgrading).
update_brew() {
	if [[ "$(uname -s)" != Darwin || $SKIP_PLUGINS -eq 1 ]] || ! have brew; then
		return 0
	fi
	section "Homebrew"
	run_step "brew update" brew update --quiet || true
	run_step "brew bundle Brewfile" brew bundle install --file="$DOTFILES_DIR/Brewfile" || true
	# The window-manager stack only if it was set up (setup_mac.sh --with-wm).
	if brew list --cask aerospace >/dev/null 2>&1; then
		run_step "brew bundle Brewfile.wm" brew bundle install --file="$DOTFILES_DIR/Brewfile.wm" || true
	fi
}

# Linux: the pixi extras (macOS gets the same from the Brewfile above).
update_extras() {
	if [[ "$(uname -s)" != Linux || $SKIP_PLUGINS -eq 1 || -z $MISE_BIN ]]; then
		return 0
	fi
	section "Extras (pixi)"
	run_step "mise run install-extras" "$MISE_BIN" -C "$HOME" run install-extras || true
}

update_rust() {
	section "Rust tools"
	if [[ $SKIP_PLUGINS -eq 1 ]] || ! have rustup; then
		log "Skipped"
		return 0
	fi
	run_step "cargo/install-rust-tools.sh --update" bash "$DOTFILES_DIR/cargo/install-rust-tools.sh" --update || true
}

update_nvim() {
	section "Neovim"
	if [[ $SKIP_PLUGINS -eq 1 ]]; then
		log "Skipped (--skip-plugins)"
		return 0
	fi
	if have uv && have bun; then
		run_step "nvim/install-dependencies.sh" bash "$DOTFILES_DIR/nvim/install-dependencies.sh" || true
	fi
	if have nvim; then
		# Install exactly the versions in nvim/lazy-lock.json (same on every
		# machine) and delete plugins that are no longer used or are disabled.
		# To move to newer versions: nvim "+Lazy sync" on one machine, commit the lockfile.
		run_step "nvim Lazy restore (lockfile versions)" nvim --headless "+Lazy! restore" +qa || true
		run_step "nvim Lazy clean" nvim --headless "+Lazy! clean" +qa || true
		run_step "nvim TSUpdate" nvim --headless "+TSUpdateSync" +qa || true
	fi
}

update_tmux() {
	section "tmux"
	local tpm_dir="$HOME/.tmux/plugins/tpm"
	if [[ $SKIP_PLUGINS -eq 0 && -d $tpm_dir/.git ]]; then
		run_step "update TPM" git -C "$tpm_dir" pull --ff-only --quiet || true
		# TPM's bin scripts start a server to read the config; it must not
		# restore saved sessions.
		[[ $DRY_RUN -eq 1 ]] || tmux_pause_auto_restore
		# install first: update only touches plugins that are already installed.
		run_step "TPM install_plugins" "$tpm_dir/bin/install_plugins" || true
		run_step "TPM update_plugins" "$tpm_dir/bin/update_plugins" all || true
		# Remove plugins that were taken out of .tmux.conf.
		run_step "TPM clean_plugins" "$tpm_dir/bin/clean_plugins" || true
	fi
	if have tmux && tmux list-sessions >/dev/null 2>&1; then
		run_step "reload tmux config" tmux source-file "$HOME/.tmux.conf" || true
		tmux display-message "Dotfiles updated, config reloaded" >/dev/null 2>&1 || true
	fi
	if [[ $SKIP_PLUGINS -eq 0 ]] && /usr/bin/python3 -m pip --version >/dev/null 2>&1; then
		local -a args=(install --quiet --upgrade pynvim libtmux)
		if /usr/bin/python3 -m pip install --help 2>/dev/null | grep -q -- '--break-system-packages'; then
			args+=(--break-system-packages)
		fi
		run_step "pip upgrade pynvim libtmux" bash -c '/usr/bin/python3 -m pip "$@" 2>/dev/null || /usr/bin/python3 -m pip "$@" --user' _ "${args[@]}" || true
	fi
}

# Make the terminal windows look the same on every machine.
update_terminals() {
	section "Terminals"
	# kitty re-reads kitty.conf on SIGUSR1; WezTerm reloads wezterm.lua by itself.
	if pgrep -x kitty >/dev/null 2>&1; then
		run_step "reload kitty config" pkill -USR1 -x kitty || true
	fi
	# Ubuntu's default GNOME Terminal: give its default profile the same Monokai
	# colours and font as kitty/WezTerm, so it matches even without kitty.
	if have gsettings && have gnome-terminal; then
		local id path
		id="$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'")"
		if [[ -n $id ]]; then
			path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$id/"
			local palette="['#272822', '#f92672', '#a6e22e', '#f4bf75', '#66d9ef', '#ae81ff', '#a1efe4', '#f8f8f2', '#75715e', '#f92672', '#a6e22e', '#f4bf75', '#66d9ef', '#ae81ff', '#a1efe4', '#f9f8f5']"
			if [[ $DRY_RUN -eq 1 ]]; then
				log "[dry-run] would set GNOME Terminal profile $id to Monokai"
			else
				gsettings set "$path" use-theme-colors false
				gsettings set "$path" background-color '#272822'
				gsettings set "$path" foreground-color '#f8f8f2'
				gsettings set "$path" palette "$palette"
				gsettings set "$path" use-transparent-background false
				gsettings set "$path" cursor-blink-mode 'off'
				if fc-list 2>/dev/null | grep -q 'JetBrainsMono Nerd Font'; then
					gsettings set "$path" use-system-font false
					gsettings set "$path" font 'JetBrainsMono Nerd Font Mono 13'
				fi
				log "GNOME Terminal profile $id set to Monokai"
			fi
		fi
	fi
}

update_omz() {
	section "Oh My Zsh"
	if [[ $SKIP_PLUGINS -eq 0 && -d "$HOME/.oh-my-zsh/.git" ]]; then
		run_step "oh-my-zsh update" git -C "$HOME/.oh-my-zsh" pull --ff-only --quiet || true
	else
		log "Skipped"
	fi
}

main() {
	load_path
	log "Updating $DOTFILES_DIR ($(uname -s))"
	update_git_repo
	relink
	update_brew
	step_mise
	update_extras
	update_rust
	update_nvim
	update_tmux
	update_terminals
	update_omz
	finish
}

main
