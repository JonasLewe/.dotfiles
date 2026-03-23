return {
  "epwalsh/pomo.nvim",
  version = "*",
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    { "rcarriga/nvim-notify", lazy = true },
  },
  keys = {
    { "<leader>ps", "<cmd>TimerSession pomodoro<cr>", desc = "Pomodoro session" },
    { "<leader>pw", "<cmd>TimerStart 25m Work<cr>", desc = "Work timer (25m)" },
    { "<leader>pb", "<cmd>TimerStart 5m Break<cr>", desc = "Break timer (5m)" },
    {
      "<leader>pn",
      function()
        vim.ui.input({ prompt = "Minutes: " }, function(input)
          if input and input ~= "" then
            vim.cmd("TimerStart " .. input .. "m")
          end
        end)
      end,
      desc = "New custom timer",
    },
    {
      "<leader>pp",
      function()
        local pomo = require("pomo")
        local timers = pomo.get_all_timers()
        if #timers == 0 then
          vim.notify("No active timers", vim.log.levels.WARN)
          return
        end
        local paused = timers[1].paused
        for _, timer in ipairs(timers) do
          if paused then
            timer:resume()
          else
            timer:pause()
          end
        end
      end,
      desc = "Pause/resume all timers",
    },
    { "<leader>px", "<cmd>TimerStop -1<cr>", desc = "Stop all timers" },
    {
      "<leader>pt",
      function()
        require("telescope").load_extension("pomodori")
        require("telescope").extensions.pomodori.timers()
      end,
      desc = "Manage timers (Telescope)",
    },
  },
  opts = {
    notifiers = {
      {
        name = "Default",
        opts = {
          sticky = true,
          title_icon = "󱎫",
          text_icon = "󰄉",
        },
      },
      {
        init = function(timer)
          local self = { timer = timer }
          function self:start() end
          function self:tick() end
          function self:stop() end
          function self:done()
            if vim.env.TMUX then
              vim.fn.jobstart("tmux display-message -d 0 '󱎫 Timer done!'")
            end
          end
          return self
        end,
      },
    },
    sessions = {
      pomodoro = {
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Long Break", duration = "15m" },
      },
    },
  },
}
