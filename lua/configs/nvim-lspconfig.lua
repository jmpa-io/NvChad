-- nvim 0.11+ native LSP configuration via vim.lsp.config.

local nvlsp = require "nvchad.configs.lspconfig"

-- Default capabilities and handlers shared across all servers.
local defaults = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- Simple servers that need no extra settings.
local simple_servers = {
  "bashls",
  "cssls",
  "dockerls",
  "html",
  "marksman",
  "pyright",
}

for _, server in ipairs(simple_servers) do
  vim.lsp.config(server, defaults)
  vim.lsp.enable(server)
end

-- Go.
vim.lsp.config("gopls", vim.tbl_extend("force", defaults, {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work", ".git" },
  settings = {
    gopls = {
      completeUnimported = true,
      analyses = {
        shadow = true,
        unusedvariable = true,
        useany = true,
      },
    },
  },
}))
vim.lsp.enable "gopls"

-- C++.
vim.lsp.config("clangd", vim.tbl_extend("force", defaults, {
  on_attach = function(client, bufnr)
    -- Disable signature help from clangd (lsp_signature.nvim handles this).
    client.server_capabilities.signatureHelpProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
}))
vim.lsp.enable "clangd"

-- Lua.
vim.lsp.config("lua_ls", vim.tbl_extend("force", defaults, {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}))
vim.lsp.enable "lua_ls"

-- JSON (with schemastore).
vim.lsp.config("jsonls", vim.tbl_extend("force", defaults, {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}))
vim.lsp.enable "jsonls"

-- YAML (with schemastore — covers GitHub Actions, CloudFormation, etc).
-- Note: not in simple_servers to avoid duplicate registration.
vim.lsp.config("yamlls", vim.tbl_extend("force", defaults, {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
      validate = true,
      hover = true,
      completion = true,
    },
  },
}))
vim.lsp.enable "yamlls"
