-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- in lua/config/keymaps.lua or a plugin config file
--
--
--

-- vim.api.nvim_set_keymap("i", "<C-l>", "<C-x><C-o>", { noremap = true, silent = true })
--
local function open_right_terminal()
  vim.cmd("stopinsert")
  vim.cmd("botright vsplit | term")
  vim.w.right_terminal = true
  vim.bo.bufhidden = "hide"
  vim.cmd("startinsert")
end

local function toggle_right_terminals()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.w[win].right_terminal and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
      table.insert(wins, win)
    end
  end
  table.sort(wins, function(a, b)
    return vim.api.nvim_win_get_position(a)[2] < vim.api.nvim_win_get_position(b)[2]
  end)

  vim.cmd("stopinsert")
  if #wins > 0 then
    local saved = {}
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      vim.bo[buf].bufhidden = "hide"
      table.insert(saved, { buf = buf, width = vim.api.nvim_win_get_width(win) })
    end
    vim.t.right_terminal_windows = saved
    if #wins == #vim.api.nvim_tabpage_list_wins(0) then
      vim.cmd("topleft new")
    end
    for _, win in ipairs(wins) do
      vim.api.nvim_win_close(win, true)
    end
    return
  end

  local restored = {}
  for _, entry in ipairs(vim.t.right_terminal_windows or {}) do
    if vim.api.nvim_buf_is_valid(entry.buf) and vim.bo[entry.buf].buftype == "terminal" then
      vim.cmd("botright vsplit")
      vim.api.nvim_win_set_buf(0, entry.buf)
      vim.w.right_terminal = true
      vim.bo.bufhidden = "hide"
      table.insert(restored, { win = vim.api.nvim_get_current_win(), width = entry.width })
    end
  end
  -- Retain snapshots only while hidden, so manually closed panes stay closed.
  vim.t.right_terminal_windows = nil
  if #restored == 0 then
    open_right_terminal()
  else
    for _, entry in ipairs(restored) do
      vim.api.nvim_win_set_width(entry.win, entry.width)
    end
    vim.cmd("startinsert")
  end
end

vim.keymap.set({ "n", "t" }, [[<C-\>]], open_right_terminal, { desc = "Open Right Terminal" })
vim.keymap.set({ "n", "t" }, [[<C-S-\>]], toggle_right_terminals, { desc = "Toggle Right Terminals" })

-- Keep hidden terminal sessions scoped to their tab (also survives config reloads).
local function toggle_bottom_terminals()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.w[win].bottom_terminal and vim.bo[buf].buftype == "terminal" then
      table.insert(wins, win)
    end
  end
  table.sort(wins, function(a, b)
    return vim.api.nvim_win_get_position(a)[2] < vim.api.nvim_win_get_position(b)[2]
  end)

  vim.cmd("stopinsert")
  if #wins > 0 then
    local buffers = {}
    vim.t.bottom_terminal_height = vim.api.nvim_win_get_height(wins[1])
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      vim.bo[buf].bufhidden = "hide"
      table.insert(buffers, buf)
    end
    vim.t.bottom_terminal_buffers = buffers
    -- Leave an editor window if the terminal row is all that remains.
    if #wins == #vim.api.nvim_tabpage_list_wins(0) then
      vim.cmd("topleft new")
    end
    for _, win in ipairs(wins) do
      vim.api.nvim_win_close(win, true)
    end
    return
  end

  local buffers = {}
  for _, buf in ipairs(vim.t.bottom_terminal_buffers or {}) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      table.insert(buffers, buf)
    end
  end
  vim.cmd("botright split")
  vim.cmd("resize " .. (vim.t.bottom_terminal_height or 15))
  if #buffers == 0 then
    vim.cmd("term")
    buffers = { vim.api.nvim_get_current_buf() }
  else
    vim.api.nvim_win_set_buf(0, buffers[1])
  end
  vim.w.bottom_terminal = true
  vim.bo.bufhidden = "hide"
  for i = 2, #buffers do
    vim.cmd("belowright vsplit")
    vim.api.nvim_win_set_buf(0, buffers[i])
    vim.w.bottom_terminal = true
    vim.bo.bufhidden = "hide"
  end
  -- The snapshot is only needed while hidden; closed panes must not return.
  vim.t.bottom_terminal_buffers = nil
  vim.cmd("startinsert")
end

local function add_bottom_terminal()
  local term_win
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.w[win].bottom_terminal and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
      term_win = win
    end
  end

  if not term_win then
    -- Restore hidden sessions, or create the first terminal in a new row.
    toggle_bottom_terminals()
    return
  end

  vim.cmd("stopinsert")
  vim.api.nvim_set_current_win(term_win)
  vim.cmd("belowright vsplit | term")
  vim.w.bottom_terminal = true
  vim.bo.bufhidden = "hide"
  vim.cmd("startinsert")
end

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
--vim.keymap.set("n", "<C-t>", ":botright split | term<CR>a", { desc = "Open horizontal terminal" })
vim.keymap.set({ "n", "t" }, "<C-t>", add_bottom_terminal, { desc = "Open/Split Terminal at Bottom" })
vim.keymap.set({ "n", "t" }, "<C-S-t>", toggle_bottom_terminals, { desc = "Toggle Bottom Terminals" })
