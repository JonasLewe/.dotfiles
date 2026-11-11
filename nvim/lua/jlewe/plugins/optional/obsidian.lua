local vault = require("jlewe.obsidian").config

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- Follow stable releases; lazy-lock.json pins the installed one.
    enabled = vault ~= nil,
    event = vault and {
      {
        event = { "BufReadPre", "BufNewFile" },
        pattern = vim.fn.escape(vault.path, "*?[]{}\\,") .. "/**.md",
      },
    } or nil,
    cmd = "Obsidian",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search vault" },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily note" },
    },
    opts = function()
      return {
        legacy_commands = false,
        workspaces = { { name = vault.name or "personal", path = vault.path, strict = true } },
        picker = { name = "telescope.nvim" },
        frontmatter = { enabled = false },
        new_notes_location = "notes_subdir", -- With no subdir, use the vault root like the app.
        note_id_func = function(title)
          return title or require("obsidian.builtin").zettel_id()
        end,
        link = { style = "wiki", format = "shortest", auto_update = true },
        attachments = vault.attachments or { folder = "/" },
        daily_notes = vim.tbl_extend("force", {
          folder = "Daily Notes",
          date_format = "DD.MM.YYYY",
          workdays_only = false,
          default_tags = {},
        }, vault.daily_notes or {}),
        templates = { enabled = false },
        ui = { enable = false },
        footer = { enabled = false },
        statusline = { enabled = false },
        callbacks = {
          enter_note = function()
            for lhs, mapping in pairs({
              ["<leader>ob"] = { "backlinks", "Note backlinks" },
              ["<leader>oo"] = { "open", "Open in Obsidian app" },
              ["<leader>op"] = { "paste_img", "Paste image into note" },
            }) do
              vim.keymap.set("n", lhs, "<cmd>Obsidian " .. mapping[1] .. "<cr>", { buffer = true, desc = mapping[2] })
            end
          end,
        },
      }
    end,
    config = function(_, opts)
      require("obsidian").setup(opts)
      local commands = require("obsidian.commands")
      -- Keep Obsidian's alias/block navigation independent of the Markdown LSP.
      commands.register("follow_link", {
        nargs = "?",
        note_action = true,
        func = function(data)
          if not require("jlewe.obsidian").contains(0) then
            return vim.notify("Obsidian: open a vault note first", vim.log.levels.WARN)
          end
          local strategy = vim.trim(data.args)
          require("obsidian.actions").follow_link(nil, {
            open_strategy = strategy ~= "" and require("obsidian.api").get_open_strategy(strategy) or nil,
          })
        end,
      })
      -- Explicit note renames use Obsidian; normal LSP symbol renames use Marksman.
      commands.register("rename", {
        nargs = "*",
        note_action = true,
        func = function(data)
          local bufnr = vim.api.nvim_get_current_buf()
          local client = vim.lsp.get_clients({ bufnr = bufnr, name = "obsidian-ls" })[1]
          if not client or not require("jlewe.obsidian").contains(bufnr) then
            return vim.notify("Obsidian: open a vault note first", vim.log.levels.WARN)
          end
          local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
          local function rename(name)
            name = name and vim.trim(name)
            if not name or name == "" then
              return
            end
            params.newName = name
            local sent = client:request("textDocument/rename", params, function(err, edit)
              if err then
                vim.notify("Obsidian rename: " .. err.message, vim.log.levels.ERROR)
              elseif edit then
                vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding)
              end
            end, bufnr)
            if not sent then
              vim.notify("Obsidian rename: language server is unavailable", vim.log.levels.ERROR)
            end
          end
          local name = vim.trim(data.args)
          if name ~= "" then
            rename(name)
          else
            vim.ui.input({ prompt = "New note name: " }, rename)
          end
        end,
      })
      -- Filetype detection can precede lazy's BufNewFile/command handler.
      -- Register the plugin's buffer events for a note already detected as Markdown.
      if require("jlewe.obsidian").contains(0) and vim.bo.filetype == "markdown" then
        vim.api.nvim_exec_autocmds("FileType", { group = "obsidian_setup", buffer = 0 })
      end
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      if vault then
        opts.spec = opts.spec or {}
        table.insert(opts.spec, { "<leader>o", group = "obsidian" })
      end
    end,
  },
}
