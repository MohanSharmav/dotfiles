local nvim_tree = require("nvim-tree")

local icons = require("mohan.icons")

local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "<F1>", api.node.show_info_popup, opts("Info"))
  vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))

  vim.keymap.set("n", "-", "", { buffer = bufnr })
  vim.keymap.del("n", "-", { buffer = bufnr })
  vim.keymap.set("n", "<C-k>", "", { buffer = bufnr })
  vim.keymap.del("n", "<C-k>", { buffer = bufnr })
  -- As in git_nvim_tmux_config: `i` replaces <C-x> (horizontal split), and <C-e>
  -- (open in place) is dropped.
  vim.keymap.set("n", "<C-x>", "", { buffer = bufnr })
  vim.keymap.del("n", "<C-x>", { buffer = bufnr })
  vim.keymap.set("n", "<C-e>", "", { buffer = bufnr })
  vim.keymap.del("n", "<C-e>", { buffer = bufnr })
  vim.keymap.set("n", "O", "", { buffer = bufnr })
  vim.keymap.del("n", "O", { buffer = bufnr })

  -- Double-click: open as usual; Markdown files also get the browser preview.
  -- (<space>mp on a tree node is the global key in settings/markdown_keymaps.lua;
  -- everything else is in lua/mohan/markdown_preview.lua.)
  vim.keymap.set("n", "<2-LeftMouse>", function()
    local node = api.tree.get_node_under_cursor()
    api.node.open.edit()
    local ext = node and node.type == "file" and (node.name:match("%.([%w]+)$") or ""):lower() or ""
    if ext == "md" or ext == "markdown" or ext == "mdx" then
      require("mohan.markdown_preview").preview()
    end
  end, opts("Open (Markdown: + browser preview)"))
end

nvim_tree.setup({
  on_attach = nvim_tree_on_attach,
  hijack_netrw = false,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    --root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = icons.Hint,
      info = icons.Info,
      warning = icons.Warn,
      error = icons.Error,
    },
  },
  view = {
    width = 30,
    side = "left",
  },
  filters = {
    custom = { ".git" },
  },
})

-- Close NvimTree automatically when quitting the last normal window in the tab.
vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("nvim_tree_auto_close", { clear = true }),
  callback = function()
    local api = require("nvim-tree.api")
    local cur_win = vim.api.nvim_get_current_win()
    if api.tree.is_tree_buf(vim.api.nvim_win_get_buf(cur_win)) then
      return
    end

    local normal_wins = 0
    local tree_wins = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(win).relative == "" then
        if api.tree.is_tree_buf(vim.api.nvim_win_get_buf(win)) then
          table.insert(tree_wins, win)
        else
          normal_wins = normal_wins + 1
        end
      end
    end

    if normal_wins <= 1 then
      for _, win in ipairs(tree_wins) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})
