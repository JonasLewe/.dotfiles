-- Shared development-tool inventory for plugin configuration and install.lua.
return {
  lsp_servers = {
    "bashls",
    "helm_ls",
    "lua_ls",
    "marksman",
    "pyright",
    "yamlls",
  },

  mason_packages = {
    "bash-language-server",
    "black",
    "debugpy",
    "helm-ls",
    "lua-language-server",
    "marksman",
    "prettier",
    "pyright",
    "ruff",
    "shellcheck",
    "shfmt",
    "stylua",
    "yaml-language-server",
  },

  formatters_by_ft = {
    python = { "black" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    lua = { "stylua" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
  },

  linters_by_ft = {
    python = { "ruff" },
    sh = { "shellcheck" },
    bash = { "shellcheck" },
  },

  dap_adapters = { "python" },
}
