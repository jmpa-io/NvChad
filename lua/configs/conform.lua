return {
  formatters_by_ft = {
    -- Lua
    lua = { "stylua" },

    -- Web
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },

    -- JavaScript / TypeScript
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },

    -- Go: gofmt -> goimports_reviser -> golines.
    go = { "gofmt", "goimports_reviser", "golines" },

    -- Python
    python = { "ruff" },

    -- C#
    cs = { "csharpier" },

    -- Rust
    rust = { "rustfmt" },

    -- Terraform
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },

    -- Shell
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },

    -- SQL
    sql = { "prettier" },

    -- TOML
    toml = { "taplo" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
}
