return {
  ensure_installed = {
    -- Bash
    "bash-language-server",
    "shellcheck",
    "shfmt",

    -- Ansible
    "ansible-language-server",
    "ansible-lint",

    -- Java / Gradle
    "jdtls",
    "java-debug-adapter",
    "java-test",
    "google-java-format",
    "checkstyle",

    -- Go
    "gopls",
    "golangci-lint",
    "golangci-lint-langserver",
    "goimports-reviser",
    "golines",

    -- C / C++
    "clangd",
    "clang-format",
    "codelldb",
    "cpplint",
    "cppcheck",

    -- C#
    "omnisharp",
    "csharpier",
    "netcoredbg",

    -- Lua
    "lua-language-server",
    "stylua",

    -- HTML & CSS
    "html-lsp",
    "css-lsp",
    "prettier",

    -- JavaScript & TypeScript
    "typescript-language-server",
    "eslint-lsp",
    "js-debug-adapter",

    -- Python
    "pyright",
    "ruff",
    "mypy",
    "debugpy",

    -- PowerShell
    "powershell-editor-services",

    -- Rust
    "rust-analyzer",

    -- Docker
    "hadolint",
    "dockerfile-language-server",

    -- JSON & YAML
    "json-lsp",
    "yaml-language-server",
    "actionlint",

    -- Markdown
    "marksman",
    "markdownlint",

    -- Terraform
    "terraform-ls",
    "tflint",

    -- SQL
    "sqlls",
    "sql-formatter",
    "sqlfluff",

    -- TOML
    "taplo",

    -- Groovy (Gradle build scripts)
    "groovy-language-server",

    -- Tools
    "deno",
  },
}
