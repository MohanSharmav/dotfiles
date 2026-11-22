-- Tell tmux this pane runs nvim, via the pane option @is_vim.
--
-- tmux/.tmux.conf decides whether C-h/j/k/l, the resize keys and prefix H/J/K/L
-- go to nvim or to tmux with a format check ($is_vim) instead of running `ps`
-- on every keypress. The format check sees the pane's foreground command, which
-- is "git" (not "nvim") when nvim is the editor of `git commit` and the like;
-- this option covers those cases. tmux ignores it while a shell is in the
-- foreground, so a crashed nvim can't leave the pane stuck in "vim mode".
local pane = vim.env.TMUX_PANE
-- Nested nvim (inside a :terminal) shares the pane; let the outer one own it.
if not vim.env.TMUX or not pane or pane == "" or vim.env.NVIM then
  return
end

local function set(on)
  local cmd = on and { "tmux", "set-option", "-pq", "-t", pane, "@is_vim", "1" }
    or { "tmux", "set-option", "-pqu", "-t", pane, "@is_vim" }
  -- Synchronous on exit so it finishes before nvim does.
  local job = vim.system(cmd, { text = true })
  if not on then
    job:wait(500)
  end
end

local group = vim.api.nvim_create_augroup("tmux_is_vim", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = group,
  callback = function()
    set(true)
  end,
})
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  group = group,
  callback = function()
    set(false)
  end,
})
