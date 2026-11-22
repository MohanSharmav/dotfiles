-- Double-click a URL to open it in the browser.
--
-- With nvim's mouse (and tmux `mouse on`) the terminal never sees the click,
-- so its own URL detection (Cmd+click etc.) doesn't fire. Handle it here,
-- which works in any terminal and through tmux. Anywhere else, double-click
-- keeps its default behaviour (select word).
local URL_PATTERN = "%a[%w+.-]*://[^%s\"'<>%[%]{}()`]+"

local function url_at_mouse()
  local pos = vim.fn.getmousepos()
  if pos.winid == 0 or pos.line == 0 then
    return nil
  end
  local buf = vim.api.nvim_win_get_buf(pos.winid)
  local line = vim.api.nvim_buf_get_lines(buf, pos.line - 1, pos.line, false)[1]
  if not line then
    return nil
  end
  local init = 1
  while true do
    local s, e = line:find(URL_PATTERN, init)
    if not s then
      return nil
    end
    if pos.column >= s and pos.column <= e then
      -- drop trailing punctuation like "." or "," ending a sentence
      return (line:sub(s, e):gsub("[.,;:!?]+$", ""))
    end
    init = e + 1
  end
end

vim.keymap.set({ "n", "v", "i" }, "<2-LeftMouse>", function()
  local url = url_at_mouse()
  if not url then
    return "<2-LeftMouse>"
  end
  vim.schedule(function()
    vim.ui.open(url)
  end)
  return ""
end, { expr = true, desc = "Open URL under mouse, else default double-click" })
