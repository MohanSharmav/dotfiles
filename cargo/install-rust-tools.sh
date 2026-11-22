#!/usr/bin/env bash
# Rust toolchain pieces the editor setup relies on, given rustup is installed
# (oh-my-zsh/install-installers.sh installs it). Idempotent; safe to re-run.
#   - stable as the default toolchain, if none is set
#   - rust-analyzer: LSP for rustaceanvim (hover docs, go to definition)
#   - rust-src:      std sources, so hover/definition also work for std
#   - rust-docs:     offline docs (`rustup doc std::collections::HashMap`)
#   - bacon:         background cargo check/clippy (tmux prefix + B)
# Usage: install-rust-tools.sh [--update]   (--update also runs `rustup update`)
set -euo pipefail

UPDATE=0
if [[ ${1:-} == "--update" ]]; then
	UPDATE=1
fi

# Homebrew's rustup is keg-only, so its proxies (cargo, rustc, rust-analyzer)
# are not linked into PATH; `cargo install` targets ~/.cargo/bin.
for dir in "${CARGO_HOME:-$HOME/.cargo}/bin" /opt/homebrew/opt/rustup/bin /usr/local/opt/rustup/bin; do
	if [[ -d $dir && ":$PATH:" != *":$dir:"* ]]; then
		PATH="$dir:$PATH"
	fi
done
export PATH

if ! command -v rustup >/dev/null 2>&1; then
	echo "[rust-tools] rustup not found; skipping (install it with oh-my-zsh/install-installers.sh)" >&2
	exit 0
fi

if ! rustup default >/dev/null 2>&1; then
	rustup default stable
elif [[ $UPDATE -eq 1 ]]; then
	rustup update
fi

rustup component add rust-analyzer rust-src rust-docs

# cargo-binstall downloads a prebuilt binary; fall back to building from source.
# Both skip the install when the latest version is already present.
if [[ $UPDATE -eq 1 ]] || ! command -v bacon >/dev/null 2>&1; then
	if command -v cargo-binstall >/dev/null 2>&1; then
		cargo binstall -y bacon || cargo install --locked bacon
	else
		cargo install --locked bacon
	fi
fi

echo "[rust-tools] $(rust-analyzer --version 2>/dev/null || echo 'rust-analyzer: MISSING'); $(bacon --version 2>/dev/null || echo 'bacon: MISSING')"
