local bufnr = vim.api.nvim_get_current_buf()
-- vim.keymap.set("n", "<leader>a", function()
--   vim.cmd.RustLsp "codeAction" -- supports rust-analyzer's grouping
--   -- or vim.lsp.buf.codeAction() if you don't want grouping.
-- end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "<C-space>", function()
  vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr })

-- NOTE: rust doesn't use nvim-lspconfig, so we need to set keymaps manually
local lsp_handler = require("mohan.lsp.handlers")
lsp_handler.setup()
lsp_handler.lsp_keymaps(bufnr)

-- Reading docs. K (rendered rustdoc hover) comes from lsp_keymaps above.
local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end
map("gK", function()
  vim.cmd.RustLsp("openDocs")
end, "Open docs.rs for symbol under cursor")
map("<space>re", function()
  vim.cmd.RustLsp("explainError")
end, "Rust: [E]xplain error (rustc --explain)")
map("<space>rd", function()
  vim.cmd.RustLsp("renderDiagnostic")
end, "Rust: render [D]iagnostic like cargo")
map("<space>rc", function()
  vim.cmd.RustLsp("openCargo")
end, "Rust: open [C]argo.toml")
map("<space>rp", function()
  vim.cmd.RustLsp("parentModule")
end, "Rust: [P]arent module")
map("<space>rm", function()
  vim.cmd.RustLsp("expandMacro")
end, "Rust: expand [M]acro")
map("<space>rr", function()
  vim.cmd.RustLsp("runnables")
end, "Rust: [R]unnables")
map("<space>rt", function()
  vim.cmd.RustLsp("testables")
end, "Rust: [T]estables")
