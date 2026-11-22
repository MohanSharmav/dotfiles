# macOS packages for these dotfiles (setup_mac.sh runs `brew bundle` on this).
# Only what Homebrew is the right source for: CLI tools come from mise
# (mise-config/config.toml), and the window-manager stack is opt-in (Brewfile.wm).

# Runtimes kept outside mise (see oh-my-zsh/install-installers.sh).
brew "rustup"         # keg-only; .zshrc adds /opt/homebrew/opt/rustup/bin to PATH
brew "cargo-binstall" # prebuilt cargo tools (bacon)
brew "uv"
brew "bun"

# Unix utilities that need Homebrew's libraries (on Linux, `mise run
# install-extras` gets the same ones from conda-forge via pixi).
brew "wget"
brew "coreutils" # GNU tools used by Zsh helpers and the local install scripts
brew "gnu-sed"
brew "gnu-tar"
brew "grep"
brew "eza"     # Zsh ls/ll aliases; eza has no macOS release binaries for mise
brew "tig"     # Zsh tig plugin (tis, ...)
brew "pv"      # archive/transfer progress in Zsh helpers
brew "chafa"   # fzf/fzf-tab and Yazi image previews
brew "poppler" # pdftoppm: Yazi and fzf-tab PDF previews

# Terminal and fonts (kitty/kitty.conf, nvim icons, the prompt).
cask "kitty"
cask "font-jetbrains-mono-nerd-font"
cask "font-fira-code"        # plain Fira Code: rich export_svg -> PDF
cask "font-noto-color-emoji" # kitty.conf symbol_map points emoji at it, like wezterm
