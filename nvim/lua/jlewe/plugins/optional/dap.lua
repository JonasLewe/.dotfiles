local tooling = require("jlewe.tooling")

return {

  -- ---------------------------------------------------------------------------
  -- MASON-NVIM-DAP — Auto-install debug adapters via Mason
  -- ---------------------------------------------------------------------------
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = true,
    opts = {
      ensure_installed = tooling.dap_adapters,
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
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP: Toggle breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP: Conditional breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP: Start / Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "DAP: Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "DAP: Step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "DAP: Step out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "DAP: Toggle REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "DAP: Run last config",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "DAP: Terminate session",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP: Toggle UI",
      },
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
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "CursorLine" })
    end,
  },
}
