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

-- Rust — use clippy instead of cargo check for richer diagnostics.
vim.lsp.config("rust_analyzer", vim.tbl_extend("force", defaults, {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
    },
  },
}))
vim.lsp.enable "rust_analyzer"

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

-- Groovy (Gradle build scripts).
-- Skipped silently if groovy-language-server is not installed (requires Java).
local groovyls_bin = vim.fn.stdpath "data" .. "/mason/bin/groovy-language-server"
if vim.fn.executable(groovyls_bin) == 1 then
  vim.lsp.config("groovyls", vim.tbl_extend("force", defaults, {
    filetypes = { "groovy" },
    root_markers = { "build.gradle", "build.gradle.kts", "settings.gradle", ".git" },
    cmd = { groovyls_bin },
  }))
  vim.lsp.enable "groovyls"
end

-- Ansible.
-- ansiblels activates on yaml.ansible filetype — set by detecting ansible keywords
-- in the file or being inside a known ansible directory structure (roles/, tasks/, etc).
vim.lsp.config("ansiblels", vim.tbl_extend("force", defaults, {
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".ansible-lint", "playbook.yml", "playbooks/", "roles/" },
  settings = {
    ansible = {
      ansible = {
        useFullyQualifiedCollectionNames = true,
      },
      executionEnvironment = { enabled = false },
      python = { interpreterPath = vim.fn.exepath "python3" },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = vim.fn.exepath "ansible-lint",
        },
      },
    },
  },
}))
vim.lsp.enable "ansiblels"

-- Java (jdtls).
-- Skipped silently if jdtls is not installed (requires Java/mason install).
-- jdtls needs a per-project data directory to store its workspace index.
-- We derive it from the project root so each project gets its own cache.
local jdtls_bin = vim.fn.stdpath "data" .. "/mason/bin/jdtls"
if vim.fn.executable(jdtls_bin) == 1 then
  vim.lsp.config("jdtls", vim.tbl_extend("force", defaults, {
    cmd = {
      jdtls_bin,
      "--jvm-arg=-Xmx2g",
      "-data", vim.fn.expand "~/.cache/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
    },
    filetypes = { "java" },
    root_markers = {
      "build.gradle",
      "build.gradle.kts",
      "settings.gradle",
      "settings.gradle.kts",
      "pom.xml",
      ".git",
    },
    settings = {
      java = {
        eclipse = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        maven = { downloadSources = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        inlayHints = { parameterNames = { enabled = "all" } },
        format = { enabled = true },
      },
    },
    init_options = {
      bundles = (function()
        -- Include java-debug-adapter and java-test bundles if installed by mason.
        local mason_data = vim.fn.stdpath "data" .. "/mason/packages"
        local bundles = {}
        local debug_jar = vim.fn.glob(mason_data .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
        if debug_jar ~= "" then
          table.insert(bundles, debug_jar)
        end
        for _, jar in ipairs(vim.fn.glob(mason_data .. "/java-test/extension/server/*.jar", true, true)) do
          table.insert(bundles, jar)
        end
        return bundles
      end)(),
    },
  }))
  vim.lsp.enable "jdtls"
end
