return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- formats on save.
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"html-lsp",
        "bash-language-server",
        "css-lsp",
        "gh",
        "golangci-lint",
        "golangci-lint-langserver",
        "gopls",
        "hadolint",
        "jq",
        "lua-language-server",
        "prettier",
        "shellcheck",
        "stylua",
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = { ensure_installed = "all" },
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },

  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "sQVe/sort.nvim",
    config = function()
      require("sort").setup()
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = "go",
    opts = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local opts = {
        sources = {
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports_reviser,
          null_ls.builtins.formatting.golines,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      }
      return opts
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },

  {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    event = "VimEnter",
    config = function(_, opts)
      require("diffview").setup(opts)
    end,
  },
}
