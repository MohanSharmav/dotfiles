-- tmux prefix resizing (Ctrl+b then H/J/K/L, repeatable) inside nvim.
--
-- tmux swallows the prefix, so nvim never sees Ctrl+b. Instead, when the
-- pane runs vim, tmux/.tmux.conf forwards prefix H/J/K/L as <C-S-F9>..<C-S-F12>
-- and this file handles them:
--   H / L  shrink / widen nvim-tree when it's open (persisted width), else
--          move the window border like tmux (tmux.nvim; at nvim's edge it
--          resizes the tmux pane itself)
--   J / K  move the window border down / up (same fallback)
local STEP = 5 -- same step as `resize-pane -L 5` in tmux/.tmux.conf

local function tree_api()
  if not package.loaded["nvim-tree"] then
    return nil
  end
  local api = require("nvim-tree.api")
  return api.tree.is_visible() and api or nil
end

local function resize(dir)
  local tree = (dir == "h" or dir == "l") and tree_api()
  if tree then
    tree.tree.resize({ relative = dir == "l" and STEP or -STEP })
    return
  end
  local tmux = require("tmux")
  local fn = ({ h = tmux.resize_left, j = tmux.resize_bottom, k = tmux.resize_top, l = tmux.resize_right })[dir]
  fn(STEP)
end

-- How nvim names the key depends on $TERM: with xterm-256color it reads
-- <C-S-F9>, but kitty's terminfo (TERM=xterm-kitty inside tmux) numbers
-- Ctrl+Shift+F1..F12 as F37..F48, so the same bytes arrive as <F45>..<F48>.
local keys = {
  ["<C-S-F9>"] = "h", ["<F45>"] = "h",
  ["<C-S-F10>"] = "j", ["<F46>"] = "j",
  ["<C-S-F11>"] = "k", ["<F47>"] = "k",
  ["<C-S-F12>"] = "l", ["<F48>"] = "l",
}

local modes = { "n", "i", "x", "s", "t" }
for key, dir in pairs(keys) do
  vim.keymap.set(modes, key, function()
    resize(dir)
  end, { desc = "tmux prefix resize " .. dir:upper() })
end
