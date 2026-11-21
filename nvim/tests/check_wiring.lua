-- Checks that features this config relies on are actually wired up.
-- Usage (from the repo root, config installed as ~/.config/nvim):
--   nvim --headless some.sh -c "luafile nvim/tests/check_wiring.lua"
-- Exits 0 and prints "wiring OK", or exits 1 with the failed check.

vim.defer_fn(function()
  local ok, err = pcall(function()
    -- tmux-resurrect restores Neovim from Session.vim kept by vim-obsession.
    assert(vim.fn.exists(":Obsession") == 2, "vim-obsession is not loaded")
    assert(
      not vim.tbl_contains(vim.opt.sessionoptions:get(), "blank"),
      "sessionoptions contains 'blank' (tree/dashboard windows would be restored empty)"
    )

    -- Formatting
    assert(vim.fn.exists(":FormatDisable") == 2, ":FormatDisable is missing")
    local by_ft = require("conform").formatters_by_ft
    assert(by_ft.sh and by_ft.sh[1] == "shfmt", "sh files are not formatted with shfmt")
    assert(by_ft.bash and by_ft.bash[1] == "shfmt", "bash files are not formatted with shfmt")

    -- Language servers
    for _, server in ipairs({ "bashls", "yamlls", "vimls", "dockerls", "marksman", "taplo", "clangd" }) do
      local config = vim.lsp.config[server]
      assert(config and config.cmd, server .. " has no LSP config")
    end
  end)

  if not ok then
    io.stderr:write("FAIL: " .. tostring(err) .. "\n")
    vim.cmd("cquit 1")
    return
  end
  io.stdout:write("wiring OK\n")
  vim.cmd("qa!")
end, 5000)
