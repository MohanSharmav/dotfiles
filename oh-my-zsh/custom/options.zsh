# History
# Oh My Zsh (lib/history.zsh) already sets share_history, extended_history,
# hist_ignore_dups, hist_ignore_space and hist_verify; this file is sourced after
# it, so the settings below win.
HISTSIZE=1000
SAVEHIST=1000

# Share history between terminals (tmux panes): every command is written to
# $HISTFILE immediately and other shells pick it up.
# share_history already appends each command as it runs, so inc_append_history
# must stay off (zsh docs: having both on writes duplicate entries).
setopt share_history
unsetopt inc_append_history inc_append_history_time

setopt hist_expire_dups_first # trim duplicates first when the file is full
setopt hist_find_no_dups      # Ctrl-R / up-arrow: don't show the same command twice
setopt hist_reduce_blanks     # strip extra spaces before saving
