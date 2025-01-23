return {
  {
    -- Formatting.
    "stevearc/conform.nvim",
    event = {
      "BufWritePre",
    },
    config = function()
      require("configs.conform")
    end,
  },

  {
    -- Formatting (backup).
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.nvim-lspconfig")
    end,
  },

  {
    -- Dependency management.
    "williamboman/mason.nvim",
    opts = function()
      require("configs.mason")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = require("configs.treesitter"),
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
    event = "InsertEnter",
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
    "nvimtools/none-ls.nvim",
    ft = "go",
    opts = function()
      require("configs.null-ls")
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    ft = "cpp",
    event = "VeryLazy",
    opts = function()
      require("configs.null-ls")
    end,
  },

  {
    -- Setup Go for neovim.
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    --@type gopher.Config
    opts = {},
  },

  {
    -- Linting.
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      require("configs.lint").setup()
    end,
  },


  --
  -- Git
  --

  {
    -- A 'git diff' viewer.
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("diffview").setup(opts)
    end,
  },

  -- {
  --   -- git intergration.
  --   "lewis6991/gitsigns.nvim",
  --   config = function(_, opts)
  --     require("configs.gitsigns").setup(opts)
  --   end,
  -- },


  {
    -- inlay hints.
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup {
        commands = { enable = true }, -- Enable InlayHints commands, include `InlayHintsToggle`, `InlayHintsEnable` and `InlayHintsDisable`
        autocmd = { enable = true },
      }
    end,
  },


}
