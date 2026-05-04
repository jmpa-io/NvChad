local lspconfig = require "lspconfig"
local util = require "lspconfig.util"
local nvlsp = require "nvchad.configs.lspconfig"

-- Convenience: default setup for simple servers.
local function default_setup(server)
  lspconfig[server].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Go.
-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
lspconfig.gopls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.mod", "go.work", ".git"),
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
}

-- C++.
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    -- Disable signature help from clangd (lsp_signature.nvim handles this).
    client.server_capabilities.signatureHelpProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- Lua.
-- Formatting handled by conform (stylua), not lua_ls.
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

-- Python.
default_setup "pyright"

-- Bash/Shell.
default_setup "bashls"

-- Docker.
default_setup "dockerls"

-- Markdown.
default_setup "marksman"

-- JSON.
-- Schema validation via schemastore.nvim.
lspconfig.jsonls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

-- YAML.
-- Schema validation via schemastore.nvim — covers GitHub Actions, AWS CloudFormation, etc.
lspconfig.yamlls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    yaml = {
      schemaStore = {
        -- Disable built-in schemaStore so schemastore.nvim manages it.
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
      validate = true,
      hover = true,
      completion = true,
    },
  },
}

-- HTML & CSS.
for _, server in ipairs { "html", "cssls" } do
  default_setup(server)
end
