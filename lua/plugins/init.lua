return {

  -- Formatting (conform.nvim)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup(require "configs.conform")
    end,
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" },
    config = function()
      require "configs.nvim-lspconfig"
    end,
  },

  -- schemastore.nvim: provides JSON/YAML schemas for LSP validation.
  -- Covers GitHub Actions, AWS CloudFormation, docker-compose, package.json, etc.
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- mason-tool-installer: auto-install all tools listed in configs/mason.lua.
  -- mason.nvim itself doesn't support ensure_installed; this plugin handles it.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup {
        ensure_installed = require("configs.mason").ensure_installed,
        auto_update = false,
        run_on_start = true,
      }
    end,
  },

  -- Mason <-> lspconfig bridge: auto-configures installed LSP servers.
  -- Keep for compatibility with NvChad's lspconfig setup.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-lspconfig").setup {
        automatic_installation = true,
      }
    end,
  },

  -- Treesitter: only install grammars for languages actually used.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "html",
        "json",
        "jsonc",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- LSP signature hints while typing.
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },

  -- Better escape (jk -> ESC).
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- Sort lines/selections.
  {
    "sQVe/sort.nvim",
    config = function()
      require("sort").setup()
    end,
  },

  -- none-ls: cppcheck diagnostics for C++.
  {
    "nvimtools/none-ls.nvim",
    ft = { "cpp" },
    event = "VeryLazy",
    config = function()
      local null_ls = require "null-ls"
      null_ls.setup(require "configs.null-ls")
    end,
  },

  -- gopher.nvim: Go-specific helpers (add tags, generate tests, etc).
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    opts = {},
  },

  -- nvim-lint: linting on save/insert leave.
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.lint").setup()
    end,
  },

  -- diffview: git diff/merge tool.
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("diffview").setup(opts)
    end,
  },

  -- inlay-hints: show inlay hints from LSP.
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup {
        commands = { enable = true },
        autocmd = { enable = true },
      }
    end,
  },

  -- peek.nvim: Markdown preview in browser.
  {
    "toppair/peek.nvim",
    event = "VeryLazy",
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup { update_on_change = true, auto_load = true }
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },

  -- GitHub Copilot: AI code suggestions via cmp (copilot-cmp handles completions).
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        -- Disable inline ghost text and panel — copilot-cmp handles completions instead.
        -- Running both simultaneously causes duplicate suggestions and Tab key conflicts.
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          -- disable in sensitive files (use filetype names, not globs).
          dotenv = false,
          ["gitcommit"] = false,
          ["secret"] = false,
        },
      }
    end,
  },

  -- Copilot as a cmp source (shows suggestions in completion menu too).
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
      require("configs.cmp").setup()
    end,
  },

  -- opencode.nvim: run OpenCode AI assistant inside a Neovim terminal split.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>oc", desc = "Toggle OpenCode terminal" },
    },
    config = function()
      require("toggleterm").setup {
        size = function(term)
          if term.direction == "horizontal" then
            return 20
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = nil,
        shade_terminals = false,
        persist_mode = true,
        direction = "vertical",
        close_on_exit = false,
      }

      -- OpenCode terminal instance.
      local Terminal = require("toggleterm.terminal").Terminal
      local opencode = Terminal:new {
        cmd = "opencode",
        direction = "vertical",
        hidden = true,
        on_open = function(term)
          vim.cmd "startinsert!"
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
        end,
      }

      vim.keymap.set("n", "<leader>oc", function()
        opencode:toggle()
      end, { desc = "Toggle OpenCode terminal", noremap = true, silent = true })
    end,
  },
}
