# Cargo Config

Symlinked by `mise` to `~/.cargo/config.toml` (`cargo/config.toml`).

- Sets `net.git-fetch-with-cli = true` so Cargo delegates Git fetches to the system `git` CLI (useful for SSH keys, credential helpers, and private repos).

## Rust tools (`install-rust-tools.sh`)

Given rustup (installed by `oh-my-zsh/install-installers.sh`; Homebrew's is keg-only, so
`.zshrc` adds `/opt/homebrew/opt/rustup/bin` to PATH), this idempotent script sets the stable
default toolchain, adds the `rust-analyzer`, `rust-src` and `rust-docs` components (needed by
rustaceanvim's hover docs and `rustup doc`), and installs `bacon` (tmux `prefix + B`).
`--update` also runs `rustup update` and upgrades bacon.

Called by `install-installers.sh`, `setup_mac.sh` / `setup_ubuntu.sh` (so `dotinstall`), and `update.sh` (with `--update`).

