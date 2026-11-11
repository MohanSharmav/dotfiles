# Hammerspoon Config (macOS Automation)

Config: [`init.lua`](init.lua) and helper modules in `~/.config/hammerspoon` (symlinked by `mise`).

---

## Global Hotkeys (`init.lua`)

| Hotkey | Function | Action |
|---|---|---|
| `F18` | `toggleInputLanguage` | Smart Korean/English IME switcher (Gureum / Apple / PriType / Ongeul safe switching) |
| `Ctrl + Shift + Cmd + T` | `TranslateScreen.spoon` | Screenshot current display (`max_height = 720`) and open in Chrome Google Translate |
| `Ctrl + Shift + Cmd + M` | Mouse helper | Simulate middle mouse click at cursor position |
| `Ctrl + Shift + Cmd + C` | `PastePrompt("codex_claude")` | Paste multi-agent Codex/Claude prompt template inline |
| `Ctrl + Shift + Cmd + R` | Process suspend toggle | Pause (`SIGSTOP`) / Resume (`SIGCONT`) the frontmost application |

---

## Loaded Modules & Spoons

| File / Spoon | Role |
|---|---|
| [`Spoons/TranslateScreen.spoon`](Spoons/TranslateScreen.spoon) | Capture display & translate via Chrome |
| [`Spoons/ChatGPT.spoon`](Spoons/ChatGPT.spoon) | ChatGPT Spoon helper |
| [`Spoons/EmmyLua.spoon`](Spoons/EmmyLua.spoon) | Lua annotations for LSP in Hammerspoon |
| [`aerospace_recovery.lua`](aerospace_recovery.lua) | Display-recovery helpers for AeroSpace |
| [`terminal.lua`](terminal.lua) | Terminal focus/launch integration (Kitty/WezTerm) |
| [`tmux_restore_agents_menu.lua`](tmux_restore_agents_menu.lua) | Menubar menu for restoring Tmux/agent sessions |
| [`kitty_weather.lua`](kitty_weather.lua) | Weather integration helper |
| [`moonlight_host_ime.lua`](moonlight_host_ime.lua) | IME sync for Moonlight remote sessions |

