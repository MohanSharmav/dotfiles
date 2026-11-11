-- Personal shortcuts ported from git_nvim_tmux_config.

-- Toggle search highlight
vim.keymap.set("n", "<F2>", "<cmd>set hlsearch!<CR>", { silent = true, desc = "Toggle search highlight" })

-- Seamless previous split / tmux pane navigation (<C-\>)
vim.keymap.set("n", "<C-\\>", function()
  local cur = vim.fn.winnr()
  local prev = vim.fn.winnr("#")
  if vim.fn.winnr("$") > 1 and prev ~= 0 and prev ~= cur then
    vim.cmd("wincmd p")
  elseif vim.env.TMUX then
    vim.fn.system("tmux select-pane -l")
  end
end, { silent = true, desc = "Navigate to previous window or tmux pane" })

