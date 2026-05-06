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

    -- Go: gofmt -> goimports_reviser -> golines.
    go = { "gofmt", "goimports_reviser", "golines" },

    -- Python
    python = { "ruff" },

    -- Shell
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
}
