return {
  ensure_installed = {
    -- Bash
    "bash-language-server",
    "shellcheck",
    "shfmt",

    -- Go
    "gopls",
    "golangci-lint",
    "golangci-lint-langserver",
    "goimports-reviser",
    "golines",

    -- C++
    "clangd",
    "clang-format",
    "codelldb",
    "cpplint",
    "cppcheck",

    -- Lua
    "lua-language-server",
    "stylua",

    -- HTML & CSS
    "html-lsp",
    "css-lsp",
    "prettier",

    -- Python
    "ruff",
    "mypy",
    "pyright",

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

    -- Tools
    "deno",
  },
}
