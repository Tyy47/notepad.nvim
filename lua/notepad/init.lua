local M = {}

local defaults = {
  width = 0.6,
  height = 0.6,
  border = "rounded",
  title = " Notepad ",
  title_pos = "center",
  filetype = "markdown",
  winblend = 0,
}

local state = {
  buf = nil,
  win = nil,
  opts = vim.deepcopy(defaults),
}

local function valid_buf()
  return state.buf and vim.api.nvim_buf_is_valid(state.buf)
end

local function valid_win()
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function resolve_size(value, total)
  if type(value) == "number" and value > 0 and value < 1 then
    return math.max(1, math.floor(total * value))
  end
  return math.max(1, math.min(total, tonumber(value) or total))
end

local function window_config()
  local columns = vim.o.columns
  local lines = vim.o.lines - vim.o.cmdheight
  local width = resolve_size(state.opts.width, columns)
  local height = resolve_size(state.opts.height, lines)

  return {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((columns - width) / 2),
    row = math.floor((lines - height) / 2),
    style = "minimal",
    border = state.opts.border,
    title = state.opts.title,
    title_pos = state.opts.title_pos,
  }
end

local function ensure_buf()
  if valid_buf() then
    return state.buf
  end

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(state.buf, "Notepad")
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].bufhidden = "hide"
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].filetype = state.opts.filetype
  vim.bo[state.buf].modifiable = true
  vim.bo[state.buf].readonly = false

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, { "" })
  return state.buf
end

function M.open()
  if valid_win() then
    vim.api.nvim_set_current_win(state.win)
    return state.win
  end

  local buf = ensure_buf()
  state.win = vim.api.nvim_open_win(buf, true, window_config())

  vim.wo[state.win].winblend = state.opts.winblend
  vim.wo[state.win].wrap = true
  vim.wo[state.win].cursorline = true

  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("NotepadResize", { clear = true }),
    callback = function()
      if valid_win() then
        vim.api.nvim_win_set_config(state.win, window_config())
      end
    end,
  })

  vim.cmd("startinsert")
  return state.win
end

function M.close()
  if valid_win() then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

function M.toggle()
  if valid_win() then
    M.close()
  else
    M.open()
  end
end

function M.clear()
  if valid_buf() then
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, { "" })
  end
end

function M.setup(opts)
  state.opts = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

return M
