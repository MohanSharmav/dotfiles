#!/usr/bin/env bash
# Replace legacy tmux/vim/neovim/git/zsh configs & dependencies with this
# dotfiles setup, back up any overwritten files, create symlinks, and run the
# new dependency, plugin, and terminfo scripts idempotently.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles_backup_${TIMESTAMP}"
OS_NAME="$(uname -s)"

DRY_RUN=0
SKIP_NETWORK=0
WITH_INSTALLERS=0
WITH_FONTS=0
HAD_ERRORS=0

usage() {
	cat <<'EOF'
Usage: migrate_and_setup.sh [options]

Backs up and replaces legacy tmux, vim/neovim, git, and zsh configs/plugins
with symlinks from this dotfiles repository, then runs setup, dependency,
plugin, and terminfo scripts.

Options:
  --dry-run           Show planned backups, removals, links, and commands without changing files
  --skip-network      Only migrate symlinks/backups and run offline checks
  --with-installers   Also run oh-my-zsh/install-installers.sh (rustup, uv, bun, mise, miniforge3)
  --with-fonts        Also run install-nerdfont.sh
  -h, --help          Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--dry-run) DRY_RUN=1 ;;
	--skip-network) SKIP_NETWORK=1 ;;
	--with-installers) WITH_INSTALLERS=1 ;;
	--with-fonts) WITH_FONTS=1 ;;
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
	printf '[dotfiles] %s\n' "$*"
}

warn() {
	printf '[dotfiles][warn] %s\n' "$*" >&2
}

run_cmd() {
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] %s\n' "$*"
		return 0
	fi
	"$@"
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

backup_and_remove() {
	local target="$1"
	if [[ ! -e "$target" ]] && [[ ! -L "$target" ]]; then
		return 0
	fi

	local rel="${target#"$HOME"/}"
	if [[ "$rel" == "$target" ]]; then
		rel="external/$(basename "$target")"
	fi
	local backup_dest="$BACKUP_DIR/$rel"

	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] backup %s -> %s\n' "$target" "$backup_dest"
		return 0
	fi

	mkdir -p "$(dirname "$backup_dest")"
	mv "$target" "$backup_dest"
	log "Backed up $target -> $backup_dest"
}

ensure_symlink() {
	local src_rel="$1"
	local dest="$2"
	local src=""

	if [[ "$src_rel" == "." ]]; then
		src="$DOTFILES_DIR"
	elif [[ "$src_rel" == /* ]]; then
		src="$src_rel"
	else
		src="$DOTFILES_DIR/$src_rel"
	fi

	if [[ ! -e "$src" ]]; then
		warn "Source missing, skipping link: $src -> $dest"
		return 0
	fi

	if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
		log "OK symlink: $dest -> $src"
		return 0
	fi

	run_cmd mkdir -p "$(dirname "$dest")"
	backup_and_remove "$dest"
	run_cmd ln -sfn "$src" "$dest"
	log "Linked $dest -> $src"
}

apply_symlinks() {
	log "Replacing legacy configs with symlinks from $DOTFILES_DIR..."

	local mappings=(
		"nvim:$HOME/.config/nvim"
		"nvim-coc:$HOME/.config/nvim-coc"
		"nvim-lazyvim:$HOME/.config/nvim-lazyvim"
		"oh-my-zsh:$HOME/.config/oh-my-zsh"
		"oh-my-zsh/starship.toml:$HOME/.config/starship.toml"
		"wezterm:$HOME/.config/wezterm"
		"kitty:$HOME/.config/kitty"
		"dprint:$HOME/.config/dprint"
		"mise-config:$HOME/.config/mise"
		"nvim/.vimrc:$HOME/.vimrc"
		"tmux/.tmux.conf:$HOME/.tmux.conf"
		"git/.gitconfig:$HOME/.gitconfig"
		"git/.gitignore_global:$HOME/.gitignore_global"
		"oh-my-zsh/.zshrc:$HOME/.zshrc"
		"oh-my-zsh/.dircolors:$HOME/.dircolors"
		"cargo/config.toml:$HOME/.cargo/config.toml"
		"conda/.condarc:$HOME/.condarc"
		".:$HOME/.config/dotfiles"
	)

	if [[ "$OS_NAME" == "Darwin" ]]; then
		mappings+=(
			"karabiner:$HOME/.config/karabiner"
			"skhd:$HOME/.config/skhd"
			"yabai:$HOME/.config/yabai"
			"aerospace:$HOME/.config/aerospace"
			"sketchybar:$HOME/.config/sketchybar"
			"hammerspoon:$HOME/.config/hammerspoon"
		)
	elif [[ "$OS_NAME" == "Linux" ]]; then
		mappings+=(
			"autokey/data:$HOME/.config/autokey/data"
		)
	fi

	local entry src_rel dest
	for entry in "${mappings[@]}"; do
		IFS=: read -r src_rel dest <<<"$entry"
		ensure_symlink "$src_rel" "$dest"
	done
}

cleanup_legacy_vim_and_tmux_artifacts() {
	log "Cleaning up legacy vim-plug and old tmux helper files (with backup)..."
	local stale_paths=(
		"$HOME/.tmux/cpu.sh"
		"$HOME/.tmux/tmux-battery"
		"$HOME/.local/share/nvim/site/autoload/plug.vim"
		"$HOME/.local/share/nvim/plugged"
		"$HOME/.vim/autoload/plug.vim"
		"$HOME/.vim/plugged"
	)
	local p
	for p in "${stale_paths[@]}"; do
		backup_and_remove "$p"
	done

	# Move aside old/mismatched tmux plugins (e.g., tmux-plugins/tmux-yank vs kiyoon/tmux-yank,
	# or legacy plugins like tmux-copycat / tmux-open) so TPM installs the new ones cleanly.
	local plugins_dir="$HOME/.tmux/plugins"
	local tmux_conf="$DOTFILES_DIR/tmux/.tmux.conf"
	if [[ -d "$plugins_dir" ]] && [[ -f "$tmux_conf" ]]; then
		local active_specs
		active_specs="$(sed -n "s/^[[:space:]]*set -g @plugin ['\"]\([^'\"]*\)['\"].*/\1/p" "$tmux_conf")"
		local dir name spec matched remote_url
		for dir in "$plugins_dir"/*; do
			[[ -e "$dir" || -L "$dir" ]] || continue
			name="$(basename "$dir")"
			[[ "$name" == "tpm" ]] && continue

			matched=""
			while IFS= read -r spec; do
				[[ -z "$spec" ]] && continue
				if [[ "$(basename "$spec")" == "$name" ]]; then
					matched="$spec"
					break
				fi
			done <<<"$active_specs"

			if [[ -z "$matched" ]]; then
				log "Retiring unused legacy tmux plugin: $name"
				backup_and_remove "$dir"
			elif [[ -d "$dir/.git" ]]; then
				remote_url="$(git -C "$dir" config --get remote.origin.url 2>/dev/null || true)"
				if [[ -n "$remote_url" ]] && [[ "$remote_url" != *"$matched"* ]]; then
					log "Replacing forked/legacy tmux plugin ($name: $remote_url != $matched)"
					backup_and_remove "$dir"
				fi
			fi
		done
	fi
}

setup_mise() {
	if [[ -z "$MISE_BIN" ]]; then
		warn "mise not found; skipping mise trust/install steps"
		return 0
	fi

	log "Running mise trust and applying dotfiles / toolchains..."
	run_step_nonfatal "mise trust repo" "$MISE_BIN" trust "$DOTFILES_DIR/mise.toml" || true
	if [[ -e "$HOME/.config/mise/config.toml" ]]; then
		run_step_nonfatal "mise trust home config" "$MISE_BIN" trust "$HOME/.config/mise/config.toml" || true
	fi

	if [[ $SKIP_NETWORK -eq 0 ]]; then
		run_step_nonfatal "mise install" "$MISE_BIN" -C "$HOME" install || true
	fi

	if [[ $DRY_RUN -eq 0 ]]; then
		local mise_env=""
		mise_env="$("$MISE_BIN" -C "$HOME" env -s bash 2>/dev/null || true)"
		if [[ -n "$mise_env" ]]; then
			eval "$mise_env"
			export PATH
		fi
	fi
}

setup_oh_my_zsh_and_submodules() {
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipping network-dependent oh-my-zsh/submodule updates (--skip-network)"
		return 0
	fi

	if [[ $WITH_INSTALLERS -eq 1 ]] && [[ -f "$DOTFILES_DIR/oh-my-zsh/install-installers.sh" ]]; then
		log "Running oh-my-zsh/install-installers.sh..."
		run_step_nonfatal "oh-my-zsh/install-installers.sh" bash "$DOTFILES_DIR/oh-my-zsh/install-installers.sh" || true
		setup_path
	elif [[ ! -d "$HOME/.oh-my-zsh" ]]; then
		log "Installing Oh My Zsh to ~/.oh-my-zsh..."
		run_step_nonfatal "clone oh-my-zsh" env RUNZSH=no CHSH=no git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" || true
	else
		log "OK directory: $HOME/.oh-my-zsh"
	fi

	if [[ -f "$DOTFILES_DIR/.gitmodules" ]]; then
		log "Initializing/updating dotfiles git submodules (zsh plugins)..."
		run_step_nonfatal "git submodule update" git -C "$DOTFILES_DIR" submodule update --init --recursive || true
	fi
}

setup_nvim() {
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipping network-dependent Neovim dependency and plugin scripts (--skip-network)"
		return 0
	fi

	if [[ -x "$DOTFILES_DIR/nvim/install-dependencies.sh" ]] || [[ -f "$DOTFILES_DIR/nvim/install-dependencies.sh" ]]; then
		if command -v uv >/dev/null 2>&1 && command -v bun >/dev/null 2>&1; then
			log "Running nvim/install-dependencies.sh..."
			run_step_nonfatal "nvim/install-dependencies.sh" bash "$DOTFILES_DIR/nvim/install-dependencies.sh" || true
		else
			warn "Skipping nvim/install-dependencies.sh (uv and/or bun not on PATH)"
			HAD_ERRORS=1
		fi
	fi

	if command -v nvim >/dev/null 2>&1; then
		log "Syncing/restoring Neovim lazy.nvim plugins headlessly..."
		run_step_nonfatal "nvim Lazy restore" nvim --headless "+Lazy! restore" +qa || true
	else
		warn "nvim not found on PATH; skipping headless Lazy restore"
		HAD_ERRORS=1
	fi
}

setup_tmux() {
	local tpm_dir="$HOME/.tmux/plugins/tpm"

	if [[ $SKIP_NETWORK -eq 0 ]]; then
		if [[ -d "$tpm_dir/.git" ]]; then
			log "Updating TPM at $tpm_dir..."
			run_step_nonfatal "update TPM" git -C "$tpm_dir" pull --ff-only || true
		else
			if [[ -e "$tpm_dir" ]] || [[ -L "$tpm_dir" ]]; then
				backup_and_remove "$tpm_dir"
			fi
			run_cmd mkdir -p "$HOME/.tmux/plugins"
			log "Cloning TPM to $tpm_dir..."
			run_step_nonfatal "clone TPM" git clone https://github.com/tmux-plugins/tpm "$tpm_dir" || true
		fi
	fi

	if ! command -v tmux >/dev/null 2>&1; then
		warn "tmux not found on PATH; skipping TPM plugin install and config reload"
		HAD_ERRORS=1
		return 0
	fi

	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] tmux source-file ~/.tmux.conf + TPM install/update + python3 pip pynvim/libtmux\n'
		return 0
	fi

	local had_server=0
	local created_temp_session=0
	if tmux list-sessions >/dev/null 2>&1; then
		had_server=1
	fi

	if [[ $had_server -eq 0 ]]; then
		tmux start-server || true
		tmux new-session -d -s "_dotfiles_setup" || true
		created_temp_session=1
	fi

	log "Loading ~/.tmux.conf into tmux server..."
	run_step_nonfatal "tmux source-file" tmux source-file "$HOME/.tmux.conf" || true

	if [[ $SKIP_NETWORK -eq 0 ]] && [[ -d "$tpm_dir" ]]; then
		if [[ -x "$tpm_dir/scripts/install_plugins.sh" ]]; then
			log "Running TPM install_plugins.sh..."
			run_step_nonfatal "TPM install_plugins.sh" "$tpm_dir/scripts/install_plugins.sh" || true
		elif [[ -x "$tpm_dir/bin/install_plugins" ]]; then
			log "Running TPM bin/install_plugins..."
			run_step_nonfatal "TPM install_plugins" "$tpm_dir/bin/install_plugins" || true
		fi

		if [[ -x "$tpm_dir/scripts/update_plugin.sh" ]]; then
			log "Running TPM update_plugin.sh..."
			run_step_nonfatal "TPM update_plugin.sh" "$tpm_dir/scripts/update_plugin.sh" all || true
		elif [[ -x "$tpm_dir/bin/update_plugins" ]]; then
			log "Running TPM bin/update_plugins..."
			run_step_nonfatal "TPM update_plugins" "$tpm_dir/bin/update_plugins" all || true
		fi

		# Reload once plugins are on disk.
		run_step_nonfatal "tmux source-file post-TPM" tmux source-file "$HOME/.tmux.conf" || true
	fi

	if [[ $created_temp_session -eq 1 ]]; then
		tmux kill-session -t "_dotfiles_setup" >/dev/null 2>&1 || true
	fi

	if [[ $SKIP_NETWORK -eq 0 ]] && [[ -x "/usr/bin/python3" ]]; then
		if /usr/bin/python3 -m pip --version >/dev/null 2>&1; then
			log "Installing tmux/nvim python packages (pynvim, libtmux) for /usr/bin/python3..."
			local -a pip_args=("install" "pynvim" "libtmux")
			if /usr/bin/python3 -m pip install --help 2>/dev/null | grep -q -- '--break-system-packages'; then
				pip_args+=("--break-system-packages")
			fi
			if ! /usr/bin/python3 -m pip "${pip_args[@]}" >/dev/null 2>&1; then
				run_step_nonfatal "pip install --user pynvim libtmux" \
					/usr/bin/python3 -m pip install --user "${pip_args[@]:1}" || true
			fi
		else
			warn "/usr/bin/python3 pip unavailable; skipping system python pynvim/libtmux (Neovim uses ~/.virtualenvs/neovim)"
		fi
	fi
}

setup_terminfo() {
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] install wezterm/kitty/ghostty terminfo\n'
		return 0
	fi

	mkdir -p "$HOME/.local/share/terminfo" "$HOME/.terminfo"

	if [[ $SKIP_NETWORK -eq 0 ]] && [[ -f "$DOTFILES_DIR/wezterm/terminfo.sh" ]]; then
		log "Installing wezterm terminfo..."
		run_step_nonfatal "wezterm/terminfo.sh" bash "$DOTFILES_DIR/wezterm/terminfo.sh" || true
	fi

	if [[ -f "$DOTFILES_DIR/kitty/terminfo.sh" ]]; then
		if infocmp -a xterm-kitty >/dev/null 2>&1 || command -v kitty >/dev/null 2>&1 || [[ -x /Applications/kitty.app/Contents/MacOS/kitty ]]; then
			log "Installing kitty terminfo..."
			run_step_nonfatal "kitty/terminfo.sh" bash "$DOTFILES_DIR/kitty/terminfo.sh" || true
		fi
	fi

	if [[ -f "$DOTFILES_DIR/ghostty/terminfo.sh" ]]; then
		if infocmp -x xterm-ghostty >/dev/null 2>&1 || [[ -d /Applications/Ghostty.app/Contents/Resources/terminfo ]]; then
			log "Installing ghostty terminfo..."
			run_step_nonfatal "ghostty/terminfo.sh" bash "$DOTFILES_DIR/ghostty/terminfo.sh" || true
		fi
	fi
}

verify_setup() {
	log "Verification summary:"
	local links=(
		"$HOME/.tmux.conf"
		"$HOME/.vimrc"
		"$HOME/.config/nvim"
		"$HOME/.config/nvim-coc"
		"$HOME/.config/nvim-lazyvim"
		"$HOME/.gitconfig"
		"$HOME/.gitignore_global"
		"$HOME/.zshrc"
		"$HOME/.config/dotfiles"
	)
	local p
	for p in "${links[@]}"; do
		if [[ -L "$p" ]]; then
			printf '  [symlink] %s -> %s\n' "$p" "$(readlink "$p")"
		else
			printf '  [missing/non-symlink] %s\n' "$p"
		fi
	done

	if command -v nvim >/dev/null 2>&1; then
		printf '  [nvim] %s\n' "$(nvim --version | head -n 1)"
		if [[ $DRY_RUN -eq 0 ]]; then
			local nvim_err
			if nvim_err="$(nvim --headless "+qa" 2>&1 >/dev/null)"; then
				printf '  [nvim startup] OK\n'
			else
				printf '  [nvim startup] FAILED:\n%s\n' "$nvim_err"
				HAD_ERRORS=1
			fi
		fi
	else
		printf '  [nvim] NOT ON PATH\n'
	fi

	if command -v tmux >/dev/null 2>&1; then
		printf '  [tmux] %s\n' "$(tmux -V)"
		if [[ $DRY_RUN -eq 0 ]]; then
			if tmux -L "_dotfiles_verify" -f "$HOME/.tmux.conf" new-session -d >/dev/null 2>&1; then
				printf '  [tmux config] OK (loaded ~/.tmux.conf cleanly)\n'
				tmux -L "_dotfiles_verify" kill-server >/dev/null 2>&1 || true
			else
				printf '  [tmux config] FAILED to parse ~/.tmux.conf\n'
				HAD_ERRORS=1
			fi
		fi
	else
		printf '  [tmux] NOT ON PATH\n'
	fi

	if [[ -d "$BACKUP_DIR" ]]; then
		printf '  [backup] Old files saved at: %s\n' "$BACKUP_DIR"
	else
		printf '  [backup] No existing files needed replacement\n'
	fi
}

main() {
	setup_path
	log "Using DOTFILES_DIR=$DOTFILES_DIR (OS=$OS_NAME)"
	cleanup_legacy_vim_and_tmux_artifacts
	apply_symlinks
	setup_mise
	setup_oh_my_zsh_and_submodules
	setup_nvim
	setup_tmux
	setup_terminfo

	if [[ $WITH_FONTS -eq 1 ]] && [[ $SKIP_NETWORK -eq 0 ]] && [[ -f "$DOTFILES_DIR/install-nerdfont.sh" ]]; then
		log "Running install-nerdfont.sh..."
		run_step_nonfatal "install-nerdfont.sh" bash "$DOTFILES_DIR/install-nerdfont.sh" || true
	fi

	verify_setup

	if [[ $HAD_ERRORS -ne 0 ]]; then
		warn "Completed with some non-fatal warnings (see log above)."
		exit 1
	fi
	log "Done! Open a new zsh shell (exec zsh) and test nvim / tmux."
}

main "$@"
