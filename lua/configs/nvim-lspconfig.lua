local lspconfig = require "lspconfig"
local util = require "lspconfig/util"
local nvlsp = require "nvchad.configs.lspconfig"

-- Go.
-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
lspconfig.gopls.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.mod", "go.work", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      analyses = {
        fieldalignment = true,
        shadow = true,
        unusedvariable = true,
        useany = true
      },
    },
  },
}

-- C++.
--
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = nvlsp.capabilities,
}


-- Lua.
--
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      format = {
        enable = true, -- Enable formatting from lua_ls
      },
      diagnostics = {
        globals = { "vim" }, -- Recognize 'vim' as a global variable
      },
    },
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})


-- load the default configs.
local servers = { "html", "cssls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end
