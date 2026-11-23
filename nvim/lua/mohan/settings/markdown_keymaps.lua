vim.api.nvim_create_augroup("markdown_mappings", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    local bufmap = function(mode, lhs, rhs, opts)
      return vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("error", { buffer = true }, opts or {}))
    end
    bufmap({ "n", "x" }, "<space>tl", function()
      require("mohan.tools.markdown").turn_to_link({ repeat_content = false })
      vim.cmd("startinsert")
    end, { remap = true, desc = "Make markdown hyperlink" })
    bufmap({ "n", "x" }, "<space>tL", function()
      require("mohan.tools.markdown").turn_to_link({ repeat_content = true })
    end, { remap = true, desc = "Make markdown hyperlink (content repeat)" })
  end,
  group = "markdown_mappings",
})

-- Markdown live preview in the browser; works from any window (a Markdown
-- file, the file tree, or a window next to one). See lua/mohan/markdown_preview.lua.
vim.keymap.set("n", "<space>mp", function()
  require("mohan.markdown_preview").preview()
end, { desc = "Markdown preview: show" })
vim.keymap.set("n", "<space>mP", function()
  require("mohan.markdown_preview").stop()
end, { desc = "Markdown preview: stop" })
