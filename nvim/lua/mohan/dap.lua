local notify = require("mohan.notify").notify

local M = {}

local status, wk = pcall(require, "which-key")
if status then
  wk.add({
    { "<space>d", group = "DAP (Debugger)" },
  })
end

M.load_files_with_breakpoints = function()
  local pb_utils = require("persistent-breakpoints.utils")

  local pb_path = pb_utils.get_bps_path()
  local breakpoints = pb_utils.load_bps(pb_path)

  if breakpoints ~= nil then
    local cur_bufnr = vim.fn.bufnr()
    vim.schedule(function()
      for file_path, _ in pairs(breakpoints) do
        -- current buffer
        vim.cmd.edit(file_path)
      end
    end)

    -- switch back to current buffer
    vim.schedule(function()
      vim.cmd.buffer(cur_bufnr)
    end)
  else
    notify("No persistent-breakpoints file found for this project.", vim.log.levels.WARN)
  end
end

-- C / C++ debugging with lldb-dap (ships with Xcode Command Line Tools on macOS
-- and with LLVM on Linux). Build with -g first, e.g. `clang++ -g main.cpp -o main`.
-- Then <space>db to set a breakpoint and <space>dc to start.
local function find_lldb_dap()
  for _, name in ipairs({ "lldb-dap", "lldb-vscode" }) do
    if vim.fn.executable(name) == 1 then
      return vim.fn.exepath(name)
    end
  end
  if vim.fn.has("mac") == 1 then
    local path = vim.trim(vim.fn.system({ "xcrun", "-f", "lldb-dap" }))
    if vim.v.shell_error == 0 and vim.fn.executable(path) == 1 then
      return path
    end
  end
end

local dap_ok, dap = pcall(require, "dap")
local lldb_dap = find_lldb_dap()
if dap_ok and lldb_dap then
  dap.adapters.lldb = { type = "executable", command = lldb_dap, name = "lldb" }

  local function pick_program()
    -- Default to a binary named after the current file (main.cpp -> ./main).
    local guess = vim.fn.getcwd() .. "/" .. vim.fn.expand("%:t:r")
    return vim.fn.input("Program to debug: ", guess, "file")
  end

  local function ask_args()
    local args = vim.fn.input("Arguments: ")
    return args == "" and {} or vim.split(args, " +", { trimempty = true })
  end

  local configs = {
    {
      name = "Launch program (lldb)",
      type = "lldb",
      request = "launch",
      program = pick_program,
      args = ask_args,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
    {
      name = "Attach to running process (lldb)",
      type = "lldb",
      request = "attach",
      pid = function()
        return require("dap.utils").pick_process()
      end,
    },
  }
  dap.configurations.c = configs
  dap.configurations.cpp = configs
end

return M
