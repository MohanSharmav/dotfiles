#!/usr/bin/env bash
# Update dotfiles repository, submodules, symlinks, mise tools,
# Neovim plugins/dependencies, Tmux TPM plugins, and terminfo.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS_NAME="$(uname -s)"

DRY_RUN=0
SKIP_GIT=0
SKIP_PLUGINS=0
FORCE_STASH=0
HAD_ERRORS=0

usage() {
	cat <<'EOF'
Usage: update.sh [options]

Updates the dotfiles repository, submodules, symlinks, and toolchains.

Options:
  --dry-run        Show commands that would be executed without running them
  --skip-git       Skip git pull on the dotfiles repository
  --skip-plugins   Skip network-dependent Neovim and Tmux plugin updates
  --force          Auto-stash local uncommitted changes before git pull
  -h, --help       Show this help message
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
	*)
		echo "Unknown option: $1" >&2
		usage >&2
		exit 2
		;;
	esac
	shift
done

log() {
	printf '[dotupdate] %s\n' "$*"
}

warn() {
	printf '[dotupdate][warn] %s\n' "$*" >&2
}

run_step_nonfatal() {
	local label="$1"
	shift
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] (%s) %s\n' "$label" "$*"
		return 0
	fi
	if ! "$@"; then
		warn "$label failed (continuing)"
		HAD_ERRORS=1
		return 1
	fi
	return 0
}

prepend_path_if_dir() {
	local dir="$1"
	if [[ -d "$dir" ]] && [[ ":$PATH:" != *":$dir:"* ]]; then
		PATH="$dir:$PATH"
	fi
}

setup_path() {
	prepend_path_if_dir "/usr/local/bin"
	prepend_path_if_dir "/opt/homebrew/bin"
	prepend_path_if_dir "$HOME/.cargo/bin"
	prepend_path_if_dir "$HOME/.bun/bin"
	prepend_path_if_dir "$HOME/.local/bin"
	prepend_path_if_dir "$HOME/.local/share/mise/shims"
	export PATH

	MISE_BIN="$(command -v mise 2>/dev/null || true)"
	if [[ -z "$MISE_BIN" ]]; then
		for candidate in "$HOME/.local/bin/mise" "/opt/homebrew/bin/mise" "/usr/local/bin/mise"; do
			if [[ -x "$candidate" ]]; then
				MISE_BIN="$candidate"
				break
			fi
		done
	fi

	if [[ -n "$MISE_BIN" ]]; then
		local mise_env=""
		mise_env="$("$MISE_BIN" -C "$HOME" env -s bash 2>/dev/null || true)"
		if [[ -n "$mise_env" ]]; then
			eval "$mise_env"
			export PATH
		fi
	fi
}

update_git_repo() {
	if [[ $SKIP_GIT -eq 1 ]]; then
		log "Skipping git repository pull (--skip-git)"
		return 0
	fi

	if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
		warn "$DOTFILES_DIR is not a git repository; skipping git pull"
		return 0
	fi

	log "Checking dotfiles git status..."
	local has_changes=0
	if [[ -n "$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null || true)" ]]; then
		has_changes=1
	fi

	local stashed=0
	if [[ $has_changes -eq 1 ]]; then
		if [[ $FORCE_STASH -eq 1 ]]; then
			log "Stashing local changes (--force)..."
			if [[ $DRY_RUN -eq 0 ]]; then
				git -C "$DOTFILES_DIR" stash push -m "Auto-stash before dotupdate $(date +%Y%m%d_%H%M%S)"
				stashed=1
			fi
		else
			warn "Local unstaged/uncommitted changes detected; skipping git pull to preserve local work."
			warn "Pass --force to auto-stash, or commit your changes first."
		fi
	fi

	if [[ $has_changes -eq 0 ]] || [[ $stashed -eq 1 ]]; then
		local upstream
		upstream="$(git -C "$DOTFILES_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
		if [[ -n "$upstream" ]]; then
			log "Pulling latest changes from $upstream..."
			run_step_nonfatal "git pull" git -C "$DOTFILES_DIR" pull --ff-only || true
		else
			log "No upstream tracking branch configured; skipping git pull"
		fi
	fi

	if [[ $stashed -eq 1 ]]; then
		log "Restoring stashed changes..."
		run_step_nonfatal "git stash pop" git -C "$DOTFILES_DIR" stash pop || true
	fi

	if [[ -f "$DOTFILES_DIR/.gitmodules" ]]; then
		log "Updating git submodules..."
		run_step_nonfatal "git submodule update" git -C "$DOTFILES_DIR" submodule update --init --recursive || true
	fi
}

sync_symlinks() {
	if [[ -x "$DOTFILES_DIR/migrate_and_setup.sh" ]]; then
		log "Verifying/refreshing symlinks via migrate_and_setup.sh..."
		if [[ $DRY_RUN -eq 1 ]]; then
			"$DOTFILES_DIR/migrate_and_setup.sh" --dry-run
		else
			"$DOTFILES_DIR/migrate_and_setup.sh" --skip-network
		fi
	fi
}

update_mise() {
	if [[ -z "$MISE_BIN" ]]; then
		return 0
	fi

	log "Updating mise tools..."
	run_step_nonfatal "mise trust" "$MISE_BIN" trust "$DOTFILES_DIR/mise.toml" || true
	if [[ -e "$HOME/.config/mise/config.toml" ]]; then
		run_step_nonfatal "mise trust home config" "$MISE_BIN" trust "$HOME/.config/mise/config.toml" || true
	fi

	if [[ $SKIP_PLUGINS -eq 0 ]]; then
		run_step_nonfatal "mise install" "$MISE_BIN" -C "$HOME" install || true
	fi
}

update_nvim() {
	if [[ $SKIP_PLUGINS -eq 1 ]]; then
		log "Skipping Neovim plugin updates (--skip-plugins)"
		return 0
	fi

	if [[ -f "$DOTFILES_DIR/nvim/install-dependencies.sh" ]]; then
		if command -v uv >/dev/null 2>&1 && command -v bun >/dev/null 2>&1; then
			log "Updating Neovim python and node dependencies..."
			run_step_nonfatal "nvim/install-dependencies.sh" bash "$DOTFILES_DIR/nvim/install-dependencies.sh" || true
		fi
	fi

	if command -v nvim >/dev/null 2>&1; then
		log "Syncing/updating Neovim lazy.nvim plugins headlessly..."
		run_step_nonfatal "nvim Lazy sync" nvim --headless "+Lazy! sync" +qa || true
		run_step_nonfatal "nvim TSUpdate" nvim --headless "+TSUpdateSync" +qa || true
	fi
}

update_tmux() {
	local tpm_dir="$HOME/.tmux/plugins/tpm"

	if [[ $SKIP_PLUGINS -eq 0 ]] && [[ -d "$tpm_dir/.git" ]]; then
		log "Updating TPM at $tpm_dir..."
		run_step_nonfatal "update TPM" git -C "$tpm_dir" pull --ff-only || true

		if [[ -x "$tpm_dir/bin/update_plugins" ]]; then
			log "Running TPM bin/update_plugins all..."
			run_step_nonfatal "TPM update_plugins" "$tpm_dir/bin/update_plugins" all || true
		elif [[ -x "$tpm_dir/scripts/update_plugin.sh" ]]; then
			log "Running TPM update_plugin.sh all..."
			run_step_nonfatal "TPM update_plugin.sh" "$tpm_dir/scripts/update_plugin.sh" all || true
		fi
	fi

	if command -v tmux >/dev/null 2>&1; then
		if tmux list-sessions >/dev/null 2>&1; then
			log "Reloading running tmux server config (~/.tmux.conf)..."
			run_step_nonfatal "tmux reload" tmux source-file "$HOME/.tmux.conf" || true
			tmux display-message "Dotfiles updated & config reloaded" >/dev/null 2>&1 || true
		fi
	fi

	if [[ $SKIP_PLUGINS -eq 0 ]] && [[ -x "/usr/bin/python3" ]]; then
		if /usr/bin/python3 -m pip --version >/dev/null 2>&1; then
			local -a pip_args=("install" "--upgrade" "pynvim" "libtmux")
			if /usr/bin/python3 -m pip install --help 2>/dev/null | grep -q -- '--break-system-packages'; then
				pip_args+=("--break-system-packages")
			fi
			run_step_nonfatal "pip update pynvim/libtmux" /usr/bin/python3 -m pip "${pip_args[@]}" || true
		fi
	fi
}

update_omz() {
	if [[ $SKIP_PLUGINS -eq 1 ]]; then
		return 0
	fi

	if [[ -d "$HOME/.oh-my-zsh/.git" ]]; then
		log "Updating Oh My Zsh..."
		run_step_nonfatal "oh-my-zsh update" git -C "$HOME/.oh-my-zsh" pull --ff-only || true
	fi
}

print_summary() {
	log "Update summary:"
	printf '  [repo] %s\n' "$(git -C "$DOTFILES_DIR" log -1 --oneline 2>/dev/null || echo "$DOTFILES_DIR")"
	if command -v nvim >/dev/null 2>&1; then
		printf '  [nvim] %s\n' "$(nvim --version | head -n 1)"
	fi
	if command -v tmux >/dev/null 2>&1; then
		printf '  [tmux] %s\n' "$(tmux -V)"
	fi
	if [[ -n "${MISE_BIN:-}" ]]; then
		printf '  [mise] %s\n' "$("$MISE_BIN" --version 2>/dev/null || echo "installed")"
	fi
	log "All done! Run 'source ~/.zshrc' or start a new shell to load changes."
}

main() {
	setup_path
	log "Starting dotfiles update in $DOTFILES_DIR (OS=$OS_NAME)..."
	update_git_repo
	sync_symlinks
	update_mise
	update_nvim
	update_tmux
	update_omz
	print_summary

	if [[ $HAD_ERRORS -ne 0 ]]; then
		warn "Update completed with non-fatal warnings (see above)."
		exit 1
	fi
}

main "$@"

