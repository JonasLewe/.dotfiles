-- Native, self-contained integration. Remove this file and restart Neovim to disable it.
local api = vim.api

local border_color = "#5A9CB4" -- Muted version of k9s cyan (#6BD1F7).

local function set_highlights()
  local normal_float = api.nvim_get_hl(0, { name = "NormalFloat", link = false })
  api.nvim_set_hl(0, "K9sBorder", { fg = border_color, bg = normal_float.bg })
end

set_highlights()
api.nvim_create_autocmd("ColorScheme", {
  group = api.nvim_create_augroup("K9sHighlights", { clear = true }),
  callback = set_highlights,
})

local function window_config()
  local lines = vim.o.lines - vim.o.cmdheight
  local width = math.max(1, math.floor(vim.o.columns * 0.9) - 2)
  local height = math.max(1, math.floor(lines * 0.9) - 2)
  return {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = " k9s ",
    title_pos = "center",
    width = width,
    height = height,
    row = math.max(0, math.floor((lines - height - 2) / 2)),
    col = math.max(0, math.floor((vim.o.columns - width - 2) / 2)),
  }
end

api.nvim_create_user_command("K9s", function(opts)
  if vim.fn.executable("k9s") ~= 1 then
    vim.notify("k9s is not installed. Install it with brew install k9s or sudo pacman -S k9s.", vim.log.levels.WARN)
    return
  end

  local buf = api.nvim_create_buf(false, true)
  vim.b[buf].terminal_passthrough = true
  local win = api.nvim_open_win(buf, true, window_config())
  vim.wo[win].winhighlight = "FloatBorder:K9sBorder,FloatTitle:K9sBorder"
  local group = api.nvim_create_augroup("K9sTerminal" .. buf, { clear = true })

  local function close()
    if api.nvim_win_is_valid(win) then
      api.nvim_win_close(win, true)
    end
  end

  api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      if api.nvim_win_is_valid(win) then
        api.nvim_win_set_config(win, window_config())
      end
    end,
  })
  api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = tostring(win),
    once = true,
    callback = function()
      api.nvim_del_augroup_by_id(group)
      vim.schedule(function()
        if api.nvim_buf_is_valid(buf) then
          api.nvim_buf_delete(buf, { force = true })
        end
      end)
    end,
  })
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, close, { buffer = buf, desc = "Close k9s window" })
  end

  local job = vim.fn.jobstart(vim.list_extend({ "k9s" }, opts.fargs), {
    term = true,
    on_exit = function(_, code)
      if code == 0 then
        vim.schedule(close)
      end
    end,
  })
  if job <= 0 then
    close()
    vim.notify("Could not start k9s.", vim.log.levels.ERROR)
    return
  end
  vim.bo[buf].filetype = "k9s"
  vim.cmd.startinsert()
end, { nargs = "*", desc = "Open k9s in a floating terminal" })

vim.keymap.set("n", "<leader>kk", "<cmd>K9s<CR>", { desc = "Open k9s in a floating terminal" })

-- Keep the optional which-key label here too, without loading which-key early.
api.nvim_create_autocmd("User", {
  group = api.nvim_create_augroup("K9sWhichKey", { clear = true }),
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local ok, which_key = pcall(require, "which-key")
    if ok then
      which_key.add({ { "<leader>k", group = "kubernetes" } })
    end
  end,
})
