local state = {
  floating = {
    win = -1,
    buf = -1,
  }
}

local create_floating_window = function(opts)
  opts = opts or {}
  -- Default ratios for width and height
  opts.width_ratio = opts.width_ratio or 0.8
  opts.height_ratio = opts.height_ratio or 0.8

  -- Get the current window's width and height
  local width = math.floor(vim.o.columns * opts.width_ratio)
  local height = math.floor(vim.o.lines * opts.height_ratio)

  -- Calculate the position to center the floating window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create buf
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor', -- The window is relative to the entire editor
    row = row,           -- Vertical position
    col = col,           -- Horizontal position
    width = width,       -- Floating window width
    height = height,     -- Floating window height
    border = 'rounded',  -- Border style ('none', 'single', 'double', 'rounded', 'shadow')
    style = 'minimal',   -- Minimal window style
  })

  return { win = win, buf = buf }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end
-- User command
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<space>tt", toggle_terminal, { desc = "Toggle floating terminal" })
