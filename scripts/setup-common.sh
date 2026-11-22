# shellcheck shell=bash
# Steps shared by setup_mac.sh and setup_ubuntu.sh (and helpers for update.sh).
# Sourced, not run. Only OS-agnostic steps live here; everything that differs
# between macOS and Ubuntu (package manager, fonts, login shell, apps, OS-only
# config links) lives in the two setup scripts.
#
# The caller sets DOTFILES_DIR and LOG_TAG before sourcing, and may set
# DRY_RUN=1 (print every change instead of making it) and SKIP_NETWORK=1
# (offline: relink configs and verify; nothing is downloaded).

: "${DOTFILES_DIR:?set DOTFILES_DIR before sourcing setup-common.sh}"
: "${LOG_TAG:?set LOG_TAG before sourcing setup-common.sh}"
DRY_RUN=${DRY_RUN:-0}
SKIP_NETWORK=${SKIP_NETWORK:-0}
HAD_ERRORS=0
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
MISE_BIN=""

# tmux_pause_auto_restore / tmux_resume_auto_restore: tmux servers started by
# setup must not restore saved sessions (see the file).
# shellcheck source=tmux/scripts/no-auto-restore.sh
source "$DOTFILES_DIR/tmux/scripts/no-auto-restore.sh"
trap tmux_resume_auto_restore EXIT

# Config links for every OS: "repo path:link path". OS-only links are passed
# to step_links by the setup scripts. Keep in sync with mise.toml [dotfiles]
# (tests/test_setup_scripts.py checks it).
COMMON_LINKS=(
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
	# Stable path to the repo wherever it is cloned (Dockerfile, zoxide entries).
	".:$HOME/.config/dotfiles"
)

# ---------------------------------------------------------------------------
# Output and command helpers
# ---------------------------------------------------------------------------

log() { printf '[%s] %s\n' "$LOG_TAG" "$*"; }
warn() { printf '[%s][warn] %s\n' "$LOG_TAG" "$*" >&2; }
section() { printf '\n[%s] ==== %s ====\n' "$LOG_TAG" "$*"; }

# Run a command, or print it under --dry-run.
run_cmd() {
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] %s\n' "$*"
		return 0
	fi
	"$@"
}

# Run a command whose failure should be reported but not stop the setup.
run_step() {
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
}

have() { command -v "$1" >/dev/null 2>&1; }

prepend_path_if_dir() {
	if [[ -d $1 && ":$PATH:" != *":$1:"* ]]; then
		PATH="$1:$PATH"
	fi
}

# Put every tool location this setup installs into on PATH (installs during the
# run included), then apply mise's tool selection for $HOME.
load_path() {
	prepend_path_if_dir "/usr/local/bin"
	prepend_path_if_dir "/opt/homebrew/bin"
	# Homebrew's rustup is keg-only: cargo/rustc/rust-analyzer live in its opt dir.
	prepend_path_if_dir "/usr/local/opt/rustup/bin"
	prepend_path_if_dir "/opt/homebrew/opt/rustup/bin"
	prepend_path_if_dir "$HOME/.cargo/bin"
	prepend_path_if_dir "$HOME/.bun/bin"
	prepend_path_if_dir "$HOME/.local/bin"
	export PATH

	MISE_BIN="$(command -v mise 2>/dev/null || true)"
	if [[ -z $MISE_BIN && -x "$HOME/.local/bin/mise" ]]; then
		MISE_BIN="$HOME/.local/bin/mise"
	fi
	if [[ -n $MISE_BIN ]]; then
		local mise_env
		mise_env="$("$MISE_BIN" -C "$HOME" env -s bash 2>/dev/null || true)"
		if [[ -n $mise_env ]]; then
			eval "$mise_env"
			export PATH
		fi
	fi
}

# Move an existing file/dir/link into $BACKUP_DIR, keeping its path under $HOME.
backup_and_remove() {
	local target="$1"
	[[ -e $target || -L $target ]] || return 0
	local rel="${target#"$HOME"/}"
	[[ $rel == "$target" ]] && rel="external/$(basename "$target")"
	local dest="$BACKUP_DIR/$rel"
	if [[ $DRY_RUN -eq 1 ]]; then
		printf '[dry-run] backup %s -> %s\n' "$target" "$dest"
		return 0
	fi
	mkdir -p "$(dirname "$dest")"
	mv "$target" "$dest"
	log "Backed up $target -> $dest"
}

ensure_symlink() {
	local src="$DOTFILES_DIR/$1" dest="$2"
	[[ $1 == "." ]] && src="$DOTFILES_DIR"
	if [[ ! -e $src ]]; then
		warn "Source missing, skipping link: $src -> $dest"
		return 0
	fi
	if [[ -L $dest && "$(readlink "$dest")" == "$src" ]]; then
		return 0
	fi
	run_cmd mkdir -p "$(dirname "$dest")"
	backup_and_remove "$dest"
	run_cmd ln -sfn "$src" "$dest"
	log "Linked $dest -> $src"
}

# For tests: print "repo path<TAB>link path" for the given link list.
print_links() {
	local entry src dest
	for entry in "$@"; do
		IFS=: read -r src dest <<<"$entry"
		printf '%s\t%s\n' "$src" "$dest"
	done
}

# ---------------------------------------------------------------------------
# Steps, in the order the setup scripts run them
# ---------------------------------------------------------------------------

# Move aside vim-plug, old tmux helpers and tmux plugins that .tmux.conf no
# longer lists (or that come from a different fork), so TPM installs cleanly.
step_cleanup_legacy() {
	section "Legacy configs"
	local p
	for p in "$HOME/.tmux/cpu.sh" "$HOME/.tmux/tmux-battery" \
		"$HOME/.local/share/nvim/site/autoload/plug.vim" "$HOME/.local/share/nvim/plugged" \
		"$HOME/.vim/autoload/plug.vim" "$HOME/.vim/plugged"; do
		backup_and_remove "$p"
	done

	local plugins_dir="$HOME/.tmux/plugins" specs dir name spec matched remote
	[[ -d $plugins_dir ]] || return 0
	specs="$(sed -n "s/^[[:space:]]*set -g @plugin ['\"]\([^'\"]*\)['\"].*/\1/p" "$DOTFILES_DIR/tmux/.tmux.conf")"
	for dir in "$plugins_dir"/*; do
		[[ -e $dir || -L $dir ]] || continue
		name="$(basename "$dir")"
		[[ $name == "tpm" ]] && continue
		matched=""
		while IFS= read -r spec; do
			if [[ -n $spec && "$(basename "$spec")" == "$name" ]]; then
				matched="$spec"
				break
			fi
		done <<<"$specs"
		if [[ -z $matched ]]; then
			log "Retiring tmux plugin no longer in .tmux.conf: $name"
			backup_and_remove "$dir"
		elif [[ -d $dir/.git ]]; then
			remote="$(git -C "$dir" config --get remote.origin.url 2>/dev/null || true)"
			if [[ -n $remote && $remote != *"$matched"* ]]; then
				log "Replacing tmux plugin from another fork ($name: $remote != $matched)"
				backup_and_remove "$dir"
			fi
		fi
	done
}

# Link COMMON_LINKS plus the OS-only links given as arguments.
step_links() {
	section "Config links"
	local entry src dest
	for entry in "${COMMON_LINKS[@]}" "$@"; do
		IFS=: read -r src dest <<<"$entry"
		ensure_symlink "$src" "$dest"
	done
	if [[ -d $BACKUP_DIR ]]; then
		log "Config links are in place; replaced files are in $BACKUP_DIR"
	elif [[ $DRY_RUN -eq 0 ]]; then
		log "OK all config links"
	fi
}

# rustup, uv, bun, mise, Oh My Zsh and miniforge (oh-my-zsh/install-installers.sh
# picks Homebrew or the standalone installers per OS).
step_user_tools() {
	section "User-space installers"
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipped (--skip-network)"
		return 0
	fi
	run_step "oh-my-zsh/install-installers.sh" bash "$DOTFILES_DIR/oh-my-zsh/install-installers.sh" || true
	load_path
}

# Tools from mise-config/config.toml: neovim, tmux, fzf, ripgrep, lazygit, ...
step_mise() {
	section "mise tools"
	load_path
	if [[ -z $MISE_BIN ]]; then
		if [[ $DRY_RUN -eq 1 ]]; then
			printf '[dry-run] mise trust + mise install (once the installers step has installed mise)\n'
			return 0
		fi
		warn "mise not found; skipping (it is installed by the user-space installers step)"
		[[ $SKIP_NETWORK -eq 1 ]] || HAD_ERRORS=1
		return 0
	fi
	run_step "mise trust repo" "$MISE_BIN" trust "$DOTFILES_DIR/mise.toml" || true
	if [[ -e "$HOME/.config/mise/config.toml" ]]; then
		run_step "mise trust global config" "$MISE_BIN" trust "$HOME/.config/mise/config.toml" || true
	fi
	if [[ $SKIP_NETWORK -eq 0 ]]; then
		run_step "mise install" "$MISE_BIN" -C "$HOME" install || true
	fi
	[[ $DRY_RUN -eq 1 ]] || load_path
}

# Zsh plugins are git submodules of this repo.
step_submodules() {
	section "Git submodules (zsh plugins)"
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipped (--skip-network)"
		return 0
	fi
	run_step "git submodule update" git -C "$DOTFILES_DIR" submodule update --init --recursive || true
}

step_rust() {
	section "Rust tools"
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipped (--skip-network)"
		return 0
	fi
	if ! have rustup && [[ $DRY_RUN -eq 0 ]]; then
		warn "rustup not found; skipping rust-analyzer, rust-src and bacon"
		HAD_ERRORS=1
		return 0
	fi
	run_step "cargo/install-rust-tools.sh" bash "$DOTFILES_DIR/cargo/install-rust-tools.sh" || true
	load_path
}

step_nvim() {
	section "Neovim"
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipped (--skip-network)"
		return 0
	fi
	if [[ $DRY_RUN -eq 1 ]] || { have uv && have bun; }; then
		run_step "nvim/install-dependencies.sh" bash "$DOTFILES_DIR/nvim/install-dependencies.sh" || true
	else
		warn "Skipping nvim/install-dependencies.sh (uv and/or bun not on PATH)"
		HAD_ERRORS=1
	fi
	if [[ $DRY_RUN -eq 1 ]] || have nvim; then
		# Plugin versions pinned by nvim/lazy-lock.json.
		run_step "nvim Lazy restore" nvim --headless "+Lazy! restore" +qa || true
	else
		warn "nvim not on PATH (mise installs it); skipping plugin restore"
		HAD_ERRORS=1
	fi
}

# TPM + plugins from .tmux.conf, and the /usr/bin/python3 packages treemux and
# tmux-window-name need.
step_tmux() {
	section "tmux"
	local tpm_dir="$HOME/.tmux/plugins/tpm"
	if [[ $SKIP_NETWORK -eq 0 ]]; then
		if [[ -d $tpm_dir/.git ]]; then
			run_step "update TPM" git -C "$tpm_dir" pull --ff-only --quiet || true
		else
			backup_and_remove "$tpm_dir"
			run_step "clone TPM" git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir" || true
		fi
	fi
	if [[ $DRY_RUN -eq 1 ]]; then
		if [[ $SKIP_NETWORK -eq 0 ]]; then
			printf '[dry-run] TPM install_plugins + update_plugins all; pip install pynvim libtmux\n'
		fi
		printf '[dry-run] reload the running tmux server, if any\n'
		return 0
	fi
	if ! have tmux; then
		warn "tmux not on PATH (mise installs it); skipping plugins and reload"
		HAD_ERRORS=1
		return 0
	fi

	# TPM's bin scripts start a server of their own to read the config; with no
	# server running, that one must not restore saved sessions.
	tmux_pause_auto_restore
	if [[ $SKIP_NETWORK -eq 0 && -x $tpm_dir/bin/install_plugins ]]; then
		run_step "TPM install_plugins" "$tpm_dir/bin/install_plugins" || true
		run_step "TPM update_plugins" "$tpm_dir/bin/update_plugins" all || true
	fi
	if tmux list-sessions >/dev/null 2>&1; then
		run_step "reload running tmux server" tmux source-file "$HOME/.tmux.conf" || true
	fi

	if [[ $SKIP_NETWORK -eq 0 ]]; then
		if /usr/bin/python3 -m pip --version >/dev/null 2>&1; then
			# --break-system-packages only where pip knows it (pip >= 23; not
			# Xcode's), --user where system site-packages isn't writable.
			local -a args=(install --quiet pynvim libtmux)
			if /usr/bin/python3 -m pip install --help 2>/dev/null | grep -q -- '--break-system-packages'; then
				args+=(--break-system-packages)
			fi
			/usr/bin/python3 -m pip "${args[@]}" >/dev/null 2>&1 ||
				run_step "pip install --user pynvim libtmux" /usr/bin/python3 -m pip "${args[@]}" --user || true
		else
			warn "/usr/bin/python3 has no pip; treemux and tmux-window-name need pynvim + libtmux there"
			HAD_ERRORS=1
		fi
	fi
}

# terminfo entries so TERM=xterm-kitty / wezterm / xterm-ghostty work in every
# program, including inside tmux (default-terminal is ${TERM}).
step_terminfo() {
	section "terminfo"
	run_cmd mkdir -p "$HOME/.local/share/terminfo" "$HOME/.terminfo"
	if [[ $SKIP_NETWORK -eq 0 ]]; then
		run_step "wezterm terminfo" bash "$DOTFILES_DIR/wezterm/terminfo.sh" || true
	fi
	if infocmp -a xterm-kitty >/dev/null 2>&1 || have kitty || [[ -x /Applications/kitty.app/Contents/MacOS/kitty ]]; then
		run_step "kitty terminfo" bash "$DOTFILES_DIR/kitty/terminfo.sh" || true
	fi
	if infocmp -x xterm-ghostty >/dev/null 2>&1 || [[ -d /Applications/Ghostty.app/Contents/Resources/terminfo ]]; then
		run_step "ghostty terminfo" bash "$DOTFILES_DIR/ghostty/terminfo.sh" || true
	fi
}

# Claude Code CLI (`claude`): Neovim's \ac / \cl (claudecode.nvim) and any
# terminal. The official installer puts it in ~/.local/bin.
step_claude() {
	section "Claude Code"
	if have claude; then
		log "OK claude: $(claude --version 2>/dev/null | head -n 1)"
		return 0
	fi
	if [[ $SKIP_NETWORK -eq 1 ]]; then
		log "Skipped (--skip-network)"
		return 0
	fi
	run_step "Claude Code install" bash -c 'set -o pipefail; curl -fsSL https://claude.ai/install.sh | bash' || true
	load_path
}

# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------

check() { printf '  %-14s %s\n' "[$1]" "$2"; }

verify_common() {
	section "Verification"
	local p
	for p in "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.config/nvim" "$HOME/.gitconfig" "$HOME/.config/mise" "$HOME/.config/dotfiles"; do
		if [[ -L $p ]]; then check link "$p -> $(readlink "$p")"; else check link "$p MISSING"; fi
	done

	if have nvim; then
		local err
		if [[ $DRY_RUN -eq 1 ]]; then
			check nvim "$(nvim --version | head -n 1)"
		elif err="$(nvim --headless "+qa" 2>&1 >/dev/null)" &&
			! grep -qiE '\berror\b|E[0-9]+:|stack traceback' <<<"$err"; then
			check nvim "$(nvim --version | head -n 1), starts cleanly"
		else
			check nvim "STARTUP ERRORS: $err"
			HAD_ERRORS=1
		fi
	else
		check nvim "NOT ON PATH"
		[[ $DRY_RUN -eq 1 ]] || HAD_ERRORS=1
	fi

	if have tmux; then
		if [[ $DRY_RUN -eq 1 ]]; then
			check tmux "$(tmux -V)"
		else
			# A throwaway server on its own socket: proves the config loads.
			tmux_pause_auto_restore
			if tmux -L _dotfiles_verify -f "$HOME/.tmux.conf" new-session -d 2>/dev/null; then
				check tmux "$(tmux -V), config loads"
				tmux -L _dotfiles_verify kill-server 2>/dev/null || true
			else
				check tmux "$(tmux -V), FAILED to load ~/.tmux.conf"
				HAD_ERRORS=1
			fi
		fi
	else
		check tmux "NOT ON PATH"
		[[ $DRY_RUN -eq 1 ]] || HAD_ERRORS=1
	fi

	# Tools the tmux bindings and the editor call at runtime.
	local tool
	for tool in zsh mise fzf zoxide lazygit uv bun bacon claude; do
		if have "$tool"; then check tool "$tool OK"; else check tool "$tool NOT ON PATH"; fi
	done
	# RUSTUP_AUTO_INSTALL=0: without it, rustup's proxy downloads a whole
	# toolchain when none is installed, just to answer --version.
	local ra
	if ra="$(RUSTUP_AUTO_INSTALL=0 rust-analyzer --version 2>/dev/null)"; then
		check rust "$ra"
	else
		check rust "rust-analyzer MISSING (bash cargo/install-rust-tools.sh)"
		[[ $DRY_RUN -eq 1 || $SKIP_NETWORK -eq 1 ]] || HAD_ERRORS=1
	fi
	if [[ -d $BACKUP_DIR ]]; then check backup "$BACKUP_DIR"; fi
}

# Exit status: 0 when every step succeeded, 1 when any warned.
finish() {
	echo
	if [[ $HAD_ERRORS -ne 0 ]]; then
		warn "Finished with warnings (see above). Fix them and re-run; every step is idempotent."
		exit 1
	fi
	log "Done. Open a new terminal (or: exec zsh) to load everything."
}
