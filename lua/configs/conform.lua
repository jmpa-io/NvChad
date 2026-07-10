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
    go = { "gofmt", "goimports-reviser", "golines" },

    -- Python
    python = { "ruff" },

    -- C#
    cs = { "csharpier" },

    -- Rust: rustfmt is NOT a mason package.
    -- Install separately: rustup component add rustfmt
    rust = { "rustfmt" },

    -- Terraform: terraform_fmt calls the terraform CLI directly.
    -- Install separately: https://developer.hashicorp.com/terraform/install
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },

    -- Ansible: prettier for YAML structure, ansible-lint --fix for best practices.
    -- ansible-lint must be installed: brew install ansible-lint
    ["yaml.ansible"] = { "prettier", "ansible_lint" },

    -- Java: google-java-format (installed via mason).
    java = { "google_java_format" },

    -- Shell
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },

    -- SQL
    sql = { "sql_formatter" },

    -- TOML
    toml = { "taplo" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
}
