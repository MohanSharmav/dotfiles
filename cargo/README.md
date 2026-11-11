# Cargo Config

Symlinked by `mise` to `~/.cargo/config.toml` (`cargo/config.toml`).

- Sets `net.git-fetch-with-cli = true` so Cargo delegates Git fetches to the system `git` CLI (useful for SSH keys, credential helpers, and private repos).

