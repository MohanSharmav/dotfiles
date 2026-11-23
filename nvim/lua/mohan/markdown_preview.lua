-- Markdown live preview in the browser (selimacerbas/markdown-preview.nvim,
-- module "mdkite"). Every entry point goes through here:
--   <space>mp      show the preview (start / switch to this file / reopen a
--                  closed browser tab). Never turns it off.
--   <space>mP      stop the preview
--   double-click   a .md file in the file tree
--   :MdKite ...    the plugin's own command (start is routed through here too)
--
-- Why this exists (each was a real failure):
-- * instance_mode "takeover" shares one server between every Neovim. With
--   several Neovims open, whichever started first owns it; the others join
--   silently and never open a browser, and the preview dies with the owner.
--   "multi" gives each Neovim its own server on a free port.
-- * mdkite previews the *current* buffer; for anything that isn't Markdown it
--   only looks for a ```mermaid block and fails with "No ```mermaid fenced
--   code block found". Starting from the file tree or a code window hit that.
-- * mdkite's toggle stops a running preview, so pressing the key "again to
--   be sure" turned it off.
local M = {}

local MARKDOWN_EXTS = { md = true, markdown = true, mdx = true }

local function is_markdown_buf(buf)
  -- mdkite's own rule: "markdown", or a compound filetype containing it.
  return vim.tbl_contains(vim.split(vim.bo[buf].filetype, ".", { plain = true }), "markdown")
end

local function is_mermaid_buf(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name:match("%.mmd$") or name:match("%.mermaid$") then
    return true
  end
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line:match("^%s*```+%s*mermaid") then
      return true
    end
  end
  return false
end

-- The Markdown buffer the user means, opening it if it only exists in the tree.
local function target_buffer()
  local cur = vim.api.nvim_get_current_buf()
  if is_markdown_buf(cur) then
    return cur
  end

  if vim.bo[cur].filetype == "NvimTree" then
    local ok, api = pcall(require, "nvim-tree.api")
    local node = ok and api.tree.get_node_under_cursor() or nil
    if node and node.type == "file" then
      local ext = (node.name:match("%.([%w]+)$") or ""):lower()
      if MARKDOWN_EXTS[ext] then
        -- Load it ourselves rather than via nvim-tree's open: with split
        -- windows that asks "Pick window:" first. bufload runs BufRead, so the
        -- filetype is detected.
        local buf = vim.fn.bufadd(node.absolute_path)
        vim.fn.bufload(buf)
        vim.bo[buf].buflisted = true
        -- Show it in the window used before the tree; focus stays in the tree.
        local prev = vim.fn.win_getid(vim.fn.winnr("#"))
        if prev ~= 0 and vim.bo[vim.api.nvim_win_get_buf(prev)].filetype ~= "NvimTree" then
          vim.api.nvim_win_set_buf(prev, buf)
        end
        return buf
      end
    end
  end

  -- A Markdown file visible in another window of this tab.
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if is_markdown_buf(buf) then
      return buf
    end
  end
end

function M.setup()
  local mdkite = require("mdkite")
  mdkite.setup({
    instance_mode = "multi", -- own server per Neovim (see the top of this file)
    port = 0, -- OS-assigned free port
    open_browser = true,
    debounce_ms = 300,
    browser = vim.env.TERM_PROGRAM == "graffitty" and vim.env.GRAFFITTY_BIN and {
      vim.env.GRAFFITTY_BIN,
      "chromium",
      "new",
      "--url",
    } or nil,
    hooks = {
      -- Always say where it is: over SSH / without a browser you open it yourself
      -- (forward the port: ssh -L <port>:127.0.0.1:<port> host).
      on_start = function(url)
        vim.notify("Preview: " .. url, vim.log.levels.INFO, { title = "Markdown preview" })
      end,
    },
  })

  -- Route every start (keys, :MdKite, :MdKite toggle) through target_buffer().
  local plugin_start = mdkite.start
  mdkite.start = function()
    local buf = target_buffer()
    if buf then
      return vim.api.nvim_buf_call(buf, plugin_start)
    end
    if is_mermaid_buf(0) then
      return plugin_start() -- mdkite's Mermaid-diagram preview
    end
    vim.notify(
      "Open a Markdown file (or put the cursor on one in the file tree), then press <space>mp",
      vim.log.levels.WARN,
      { title = "Markdown preview" }
    )
  end
end

-- Show the preview: start it, switch it to this file, or reopen a closed tab.
function M.preview()
  require("mdkite").start()
end

function M.stop()
  local mdkite = require("mdkite")
  if mdkite._server_instance or mdkite._is_primary == false then
    mdkite.stop()
    vim.notify("Preview stopped", vim.log.levels.INFO, { title = "Markdown preview" })
  end
end

return M
