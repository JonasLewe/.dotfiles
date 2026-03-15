-- =============================================================================
-- DAP — Debug Adapter Protocol
-- =============================================================================
-- Connects Neovim to debug adapters (same protocol as VSCode).
-- Provides breakpoints, stepping, variable inspection, watch expressions.
--
-- HOW IT WORKS:
--   1. mason-nvim-dap       — Downloads debug adapters automatically (like mason for LSP)
--   2. nvim-dap             — Core DAP client (communicates with debug adapters)
--   3. nvim-dap-ui          — IDE-like debug panels (variables, watch, call stack)
--   4. nvim-dap-virtual-text — Shows variable values inline in the code
--
-- USAGE:
--   <leader>db  → Set/remove breakpoint on current line
--   <leader>dc  → Start debugging / Continue execution
--   <leader>du  → Toggle debug UI panels
--   The UI opens automatically when a debug session starts.
--
-- ADDING A NEW LANGUAGE:
--   1. Add the adapter name to ensure_installed in mason-nvim-dap below
--   2. mason-nvim-dap auto-configures most adapters (handlers = {})
--   3. For custom configs: add dap.configurations["language"] in config below
--   Full list: https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
--
-- SUPPORTED ADAPTERS (ensure_installed):
--   "python"     → debugpy (same adapter VSCode Python uses)
--   "codelldb"   → C, C++, Rust
--   "js"         → js-debug-adapter (Node.js, Chrome, Edge)
--   "delve"      → Go (Delve debugger)
--   "bash"       → Bash scripts

return {

  -- ---------------------------------------------------------------------------
  -- MASON-NVIM-DAP — Auto-install debug adapters via Mason
  -- ---------------------------------------------------------------------------
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = true,
    opts = {
      ensure_installed = {
        "python", -- debugpy
      },
      -- Auto-install any adapter configured in dap if not already present
      automatic_installation = true,
      -- Default handlers auto-configure adapters (like mason-lspconfig for LSP)
      handlers = {},
    },
  },

  -- ---------------------------------------------------------------------------
  -- NVIM-DAP — Core Debug Client + UI + Virtual Text
  -- ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    -- Lazy-load: plugin loads only when you press a debug keybind
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "DAP: Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "DAP: Start / Continue" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "DAP: Step into" },
      { "<leader>do", function() require("dap").step_over() end,                                            desc = "DAP: Step over" },
      { "<leader>dO", function() require("dap").step_out() end,                                             desc = "DAP: Step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "DAP: Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end,                                             desc = "DAP: Run last config" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "DAP: Terminate session" },
      { "<leader>du", function() require("dapui").toggle() end,                                             desc = "DAP: Toggle UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- DAP-UI: default layout (left: scopes/breakpoints/stacks, bottom: repl/console)
      dapui.setup()

      -- Virtual text: show variable values inline next to the code
      require("nvim-dap-virtual-text").setup()

      -- Auto-open UI when debug session starts, auto-close when it ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Breakpoint signs in the gutter
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition",  { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected",   { text = "○", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped",              { text = "▶", texthl = "DiagnosticInfo", linehl = "CursorLine" })
    end,
  },
}
