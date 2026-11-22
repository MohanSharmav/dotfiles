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

-- zw: toggle highlighting every match of the word under the cursor (follows the
-- cursor once it stops moving).
local auto_hl_group = vim.api.nvim_create_augroup("auto_highlight", { clear = true })
local auto_hl_on = false
vim.keymap.set("n", "zw", function()
  vim.fn.setreg("/", "")
  vim.api.nvim_clear_autocmds({ group = auto_hl_group })
  auto_hl_on = not auto_hl_on
  if auto_hl_on then
    vim.api.nvim_create_autocmd("CursorHold", {
      group = auto_hl_group,
      callback = function()
        local word = vim.fn.expand("<cword>")
        if word ~= "" then
          vim.fn.setreg("/", "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>")
        end
      end,
    })
    vim.o.hlsearch = true
  end
  vim.notify("Highlight current word: " .. (auto_hl_on and "ON" or "off"))
end, { desc = "Toggle highlighting the word under the cursor" })

-- Highlight groups under the cursor. Treesitter replaces most vim syntax here, so
-- these use :Inspect / vim.inspect_pos() rather than synID().
local function hl_chain(name)
  local chain, seen = { name }, {}
  while not seen[name] do
    seen[name] = true
    local hl = vim.api.nvim_get_hl(0, { name = name, link = true })
    if not hl.link then
      break
    end
    name = hl.link
    table.insert(chain, name)
  end
  return table.concat(chain, " -> ")
end

local function show_hl_groups()
  local pos = vim.inspect_pos()
  local lines = {}
  for _, item in ipairs(pos.treesitter) do
    table.insert(lines, hl_chain(item.hl_group))
  end
  for _, item in ipairs(pos.syntax) do
    table.insert(lines, hl_chain(item.hl_group))
  end
  for _, item in ipairs(pos.semantic_tokens) do
    table.insert(lines, hl_chain(item.opts.hl_group))
  end
  vim.notify(#lines > 0 and table.concat(lines, "\n") or "No highlight group under cursor")
end

vim.keymap.set("n", "<F3>", "<cmd>Inspect<CR>", { desc = "Show highlight info under cursor" })
vim.keymap.set("n", "<leader>ss", "<cmd>Inspect<CR>", { desc = "Show highlight stack under cursor" })
vim.keymap.set("n", "<leader>sg", show_hl_groups, { desc = "Show highlight group -> linked group" })

-- fly: run rust-analyzer's check (cargo check / clippy) in Rust buffers.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_keymaps_rust", { clear = true }),
  pattern = "rust",
  callback = function(args)
    vim.keymap.set("n", "fly", "<cmd>RustLsp flyCheck<CR>", { buffer = args.buf, desc = "rust-analyzer flycheck" })
  end,
})
