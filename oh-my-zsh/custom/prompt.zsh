# Prompt helpers for the two-line Starship prompt (../starship.toml).
#
#   - a blank line and a faint rule between commands
#   - finished prompts shrink to "❯ command" (transient prompt), so scrollback
#     shows only commands and their output
#   - compact first line when the terminal is narrow (< PROMPT_COMPACT_BELOW columns)
#   - orange folder pill on remote (SSH) machines
#   - desktop notification when a command ran longer than PROMPT_NOTIFY_AFTER seconds
#   - clearer colours for what you type, and a better Ctrl+R history search
#
# Settings (export before this file loads, e.g. in 01_env.zsh):
#   PROMPT_COMPACT_BELOW=110   PROMPT_NOTIFY_AFTER=60   PROMPT_TRANSIENT=1   PROMPT_SEPARATOR=1

[[ -o interactive ]] || return 0
(( $+commands[starship] )) || return 0

autoload -Uz add-zsh-hook add-zle-hook-widget
zmodload zsh/datetime 2>/dev/null   # EPOCHSECONDS

: ${PROMPT_COMPACT_BELOW:=110}
: ${PROMPT_NOTIFY_AFTER:=60}
: ${PROMPT_TRANSIENT:=1}
: ${PROMPT_SEPARATOR:=1}

# ---------------------------------------------------------------------------
# Starship config variants: full / compact  ×  local / ssh
# Generated from ~/.config/starship.toml and rebuilt whenever it changes.
# ---------------------------------------------------------------------------
typeset -g _prompt_src=${STARSHIP_CONFIG_SOURCE:-$HOME/.config/starship.toml}
typeset -g _prompt_cache=${XDG_CACHE_HOME:-$HOME/.cache}/starship-prompt
typeset -g _prompt_palette=local
[[ -n $SSH_CONNECTION || -n $SSH_TTY ]] && _prompt_palette=ssh

_prompt_build() {
	local full=$_prompt_cache/full-$_prompt_palette.toml
	local compact=$_prompt_cache/compact-$_prompt_palette.toml
	[[ -f $full && -f $compact && ! $_prompt_src -nt $full ]] && return 0
	[[ -r $_prompt_src ]] || return 1
	mkdir -p $_prompt_cache
	sed "s/^palette = \"local\"/palette = \"$_prompt_palette\"/" $_prompt_src >| $full
	# Compact: keep folder, git, contexts, status, duration and the SSH host.
	sed -E '/^\$(nodejs|bun|python|conda|rust|golang|username|time)\\$/d' $full >| $compact
}

_prompt_pick_config() {
	_prompt_build || return 0
	local variant=full
	(( COLUMNS < PROMPT_COMPACT_BELOW )) && variant=compact
	export STARSHIP_CONFIG=$_prompt_cache/$variant-$_prompt_palette.toml
}

# ---------------------------------------------------------------------------
# Command timing, separator and notifications
# ---------------------------------------------------------------------------
typeset -g _prompt_cmd= _prompt_started=0 _prompt_ran=0 _prompt_first=1

_prompt_preexec() {
	_prompt_cmd=$1
	_prompt_started=$EPOCHSECONDS
	_prompt_ran=1
}

# Programs you sit inside: no "finished" notification for these.
typeset -ga PROMPT_NOTIFY_IGNORE=(
	vi vim nvim nano less more man ssh mosh tmux ta ts top htop btop lazygit tig tis
	claude cld codex cod codr opencode ocl ocr python python3 ipython node bun deno
	watch fg git-open
)

_prompt_notify() {
	local title=$1 body=$2
	# Terminals that show notifications themselves (works over SSH too)
	if [[ $TERM_PROGRAM == (WezTerm|ghostty) || -n $KITTY_WINDOW_ID ]]; then
		printf '\e]777;notify;%s;%s\a' "$title" "$body"
	elif [[ $OSTYPE == darwin* && -z $SSH_CONNECTION ]]; then
		osascript -e "display notification \"${body//\"/\\\"}\" with title \"${title//\"/\\\"}\" sound name \"Glass\"" &>/dev/null &!
	elif (( $+commands[notify-send] )) && [[ -n $DISPLAY$WAYLAND_DISPLAY ]]; then
		notify-send "$title" "$body" &!
	else
		printf '\a'   # bell: VS Code and most terminals flag the tab
	fi
}

_prompt_human_time() {
	local s=$1
	if (( s >= 3600 )); then print -n "$((s / 3600))h $((s % 3600 / 60))m"
	elif (( s >= 60 )); then print -n "$((s / 60))m $((s % 60))s"
	else print -n "${s}s"; fi
}

_prompt_precmd() {
	local exit_code=$?

	# Long command finished?
	if (( _prompt_ran && PROMPT_NOTIFY_AFTER > 0 )); then
		local took=$(( EPOCHSECONDS - _prompt_started ))
		local first=${${(z)_prompt_cmd}[1]}
		if (( took >= PROMPT_NOTIFY_AFTER )) && (( ! ${PROMPT_NOTIFY_IGNORE[(Ie)${first:t}]} )); then
			local cmd=${_prompt_cmd//$'\n'/ }
			(( ${#cmd} > 80 )) && cmd="${cmd[1,77]}..."
			if (( exit_code == 0 )); then
				_prompt_notify "✔ Done in $(_prompt_human_time $took)" "$cmd"
			else
				_prompt_notify "✘ Failed (exit $exit_code) after $(_prompt_human_time $took)" "$cmd"
			fi
		fi
	fi

	# Spacing: blank line + faint rule after a command, nothing on the very first prompt
	# or right after clear/reset.
	if (( _prompt_first )); then
		_prompt_first=0
	elif (( _prompt_ran )) && [[ ${${(z)_prompt_cmd}[1]} != (clear|reset|c) ]]; then
		if (( PROMPT_SEPARATOR )); then
			print -P "\n%F{#3f4654}${(pl:$((COLUMNS - 1))::─:)}%f"
		else
			print
		fi
	fi
	_prompt_ran=0

	_prompt_pick_config

	# Transient prompt: remember the full prompt (with any shell-integration
	# markers already added), and put it back before each new prompt.
	if (( PROMPT_TRANSIENT )); then
		[[ -z $_prompt_full || $PROMPT != $_prompt_short ]] && typeset -g _prompt_full=$PROMPT
		PROMPT=$_prompt_full
	fi
}

typeset -g _prompt_full= _prompt_short='%(?.%F{#22c55e}.%F{#ef4444})❯%f '

_prompt_transient() {
	(( PROMPT_TRANSIENT )) && [[ -n $_prompt_full ]] || return 0
	PROMPT=$_prompt_short
	RPROMPT=
	zle .reset-prompt
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd
add-zle-hook-widget line-finish _prompt_transient
_prompt_pick_config   # so the very first prompt already uses the right variant

# ---------------------------------------------------------------------------
# Colours for what you type (fast-syntax-highlighting) and autosuggestions
# ---------------------------------------------------------------------------
if (( ${+FAST_HIGHLIGHT_STYLES} )); then
	() {
		local t=${FAST_THEME_NAME}
		FAST_HIGHLIGHT_STYLES[${t}command]='fg=#4ade80,bold'
		FAST_HIGHLIGHT_STYLES[${t}hashed-command]='fg=#4ade80,bold'
		FAST_HIGHLIGHT_STYLES[${t}builtin]='fg=#4ade80,bold'
		FAST_HIGHLIGHT_STYLES[${t}function]='fg=#4ade80,bold'
		FAST_HIGHLIGHT_STYLES[${t}alias]='fg=#2dd4bf,bold'
		FAST_HIGHLIGHT_STYLES[${t}suffix-alias]='fg=#2dd4bf,bold'
		FAST_HIGHLIGHT_STYLES[${t}global-alias]='fg=#2dd4bf,bold'
		FAST_HIGHLIGHT_STYLES[${t}precommand]='fg=#4ade80,underline'
		FAST_HIGHLIGHT_STYLES[${t}reserved-word]='fg=#c084fc,bold'
		FAST_HIGHLIGHT_STYLES[${t}unknown-token]='fg=#f87171,bold'
		FAST_HIGHLIGHT_STYLES[${t}commandseparator]='fg=#f472b6,bold'
		FAST_HIGHLIGHT_STYLES[${t}redirection]='fg=#f472b6'
		FAST_HIGHLIGHT_STYLES[${t}path]='fg=#e5e7eb,underline'
		FAST_HIGHLIGHT_STYLES[${t}path-to-dir]='fg=#93c5fd,underline'
		FAST_HIGHLIGHT_STYLES[${t}globbing]='fg=#fb923c'
		FAST_HIGHLIGHT_STYLES[${t}single-hyphen-option]='fg=#7dd3fc'
		FAST_HIGHLIGHT_STYLES[${t}double-hyphen-option]='fg=#7dd3fc'
		FAST_HIGHLIGHT_STYLES[${t}single-quoted-argument]='fg=#fde68a'
		FAST_HIGHLIGHT_STYLES[${t}double-quoted-argument]='fg=#fde68a'
		FAST_HIGHLIGHT_STYLES[${t}dollar-quoted-argument]='fg=#fde68a'
		FAST_HIGHLIGHT_STYLES[${t}variable]='fg=#c4b5fd'
		FAST_HIGHLIGHT_STYLES[${t}assign]='fg=#c4b5fd'
		FAST_HIGHLIGHT_STYLES[${t}comment]='fg=#6b7280,italic'
		FAST_HIGHLIGHT_STYLES[${t}default]='fg=#f3f4f6'
	}
fi
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6b7280,italic'

# ---------------------------------------------------------------------------
# Ctrl+R: fuzzy history search with the full command shown below the list
# ---------------------------------------------------------------------------
if (( $+commands[fzf] )); then
	() {
		local copy=
		if (( $+commands[pbcopy] )); then copy='pbcopy'
		elif (( $+commands[wl-copy] )); then copy='wl-copy'
		elif (( $+commands[xclip] )); then copy='xclip -selection clipboard'
		fi
		export FZF_CTRL_R_OPTS="--height=50% --layout=reverse --border=rounded --info=inline \
--preview='echo {2..}' --preview-window=down:3:wrap \
--header='Enter: use  ·  Ctrl-R: sort by time/relevance${copy:+  ·  Ctrl-Y: copy}' \
${copy:+--bind='ctrl-y:execute-silent(echo -n {2..} | $copy)+abort'} \
--color='header:italic:#94a3b8,border:#3f4654,pointer:#22c55e,hl:#facc15,hl+:#facc15'"
	}
fi
