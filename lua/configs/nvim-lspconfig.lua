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
  "rust_analyzer",
  "taplo",
  "terraformls",
  "sqlls",
}

for _, server in ipairs(simple_servers) do
  vim.lsp.config(server, defaults)
  vim.lsp.enable(server)
end

-- PowerShell — needs explicit bundle_path pointing to mason install dir.
vim.lsp.config("powershell_es", vim.tbl_extend("force", defaults, {
  bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
  filetypes = { "ps1", "psm1", "psd1" },
}))
vim.lsp.enable "powershell_es"

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

-- C / C++.
vim.lsp.config("clangd", vim.tbl_extend("force", defaults, {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
}))
vim.lsp.enable "clangd"

-- C# (OmniSharp).
vim.lsp.config("omnisharp", vim.tbl_extend("force", defaults, {
  cmd = { "omnisharp" },
  filetypes = { "cs", "vb" },
  root_markers = { "*.sln", "*.csproj", ".git" },
  settings = {
    omnisharp = {
      enableRoslynAnalyzers = true,
      enableEditorConfigSupport = true,
      organizeImportsOnFormat = true,
    },
  },
}))
vim.lsp.enable "omnisharp"

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

-- JavaScript / TypeScript.
vim.lsp.config("ts_ls", vim.tbl_extend("force", defaults, {
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}))
vim.lsp.enable "ts_ls"

-- ESLint.
vim.lsp.config("eslint", vim.tbl_extend("force", defaults, {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
  settings = {
    workingDirectory = { mode = "auto" },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
    nvlsp.on_attach(client, bufnr)
  end,
}))
vim.lsp.enable "eslint"

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
