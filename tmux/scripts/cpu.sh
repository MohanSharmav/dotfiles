#!/usr/bin/env bash
# CPU usage helper ported from git_nvim_tmux_config
# Works on both macOS and Linux

if [[ "$(uname -s)" == "Darwin" ]]; then
  top -l 2 | grep -E "^CPU" | tail -1 | awk '{ printf "%d%%", $3+$5 }'
else
  top -b -n 2 -d 0.2 2>/dev/null | grep -i "cpu(s)" | tail -1 | awk '{ printf "%d%%", 100 - $8 }'
fi

