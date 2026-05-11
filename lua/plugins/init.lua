return {

  -- Formatting (conform.nvim).
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup(require "configs.conform")
    end,
  },

  -- LSP config.
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" },
    config = function()
      require "configs.nvim-lspconfig"
    end,
  },

  -- schemastore.nvim: JSON/YAML schemas for LSP validation.
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- mason-tool-installer: auto-install all tools listed in configs/mason.lua.
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

  -- mason-lspconfig: bridge for compatibility with NvChad's lspconfig setup.
  -- automatic_installation disabled — mason-tool-installer handles this explicitly.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-lspconfig").setup {
        automatic_installation = false,
      }
    end,
  },

  -- Treesitter: grammars for languages actually used.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "powershell",
        "python",
        "rust",
        "sql",
        "terraform",
        "toml",
        "tsx",
        "typescript",
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
  -- Handles all linters including cppcheck (none-ls removed — unmaintained).
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

  -- gitsigns: inline git hunks, blame, staging.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup {
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function bmap(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- Navigation.
          bmap("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, "Next git hunk")
          bmap("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, "Prev git hunk")

          -- Actions.
          bmap("n", "<leader>hs", gs.stage_hunk,   "Stage hunk")
          bmap("n", "<leader>hr", gs.reset_hunk,   "Reset hunk")
          bmap("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          bmap("n", "<leader>hb", function() gs.blame_line { full = true } end, "Blame line")
          bmap("n", "<leader>hd", gs.diffthis,     "Diff this")
          bmap("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
        end,
      }
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

  -- GitHub Copilot: AI inline completion (fallback for personal mode).
  -- In work mode, OpenCode (<leader>oc) provides the primary AI interface
  -- via GenAI Studio + all CBA MCPs. Copilot fills the inline gap.
  -- Inherits OPENCODE_CONFIG from the shell — no neovim config needed.
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        -- Disable inline ghost text and panel — copilot-cmp handles completions.
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          dotenv = false,
          ["gitcommit"] = false,
          ["secret"] = false,
        },
      }
    end,
  },

  -- Copilot as a cmp source.
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
      require("configs.cmp").setup()
    end,
  },

  -- OpenCode: AI assistant in a vertical terminal split.
  -- <leader>oc to toggle. Inherits OPENCODE_CONFIG from shell environment:
  --   work shell (~/work sourced) → GenAI Studio + CBA MCPs
  --   personal shell              → personal baseline (Copilot fills inline gap)
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

  -- nvim-dap: debugging support.
  -- Keybinds: F5 continue, F10 step over, F11 step into, F12 step out,
  --           <leader>b toggle breakpoint, <leader>du toggle UI.
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      -- UI for nvim-dap.
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap, dapui = require "dap", require "dapui"
          dapui.setup()
          -- Auto-open/close UI on debug events.
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- Virtual text showing variable values inline.
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      },
    },
    config = function()
      local dap = require "dap"

      -- Python (debugpy).
      -- Mason installs debugpy-adapter binary, not a venv python.
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath "data" .. "/mason/bin/debugpy-adapter",
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.fn.exepath "python3" or "python"
          end,
        },
      }

      -- C / C++ / Rust (codelldb).
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }
      for _, ft in ipairs { "c", "cpp", "rust" } do
        dap.configurations[ft] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
        }
      end

      -- C# (netcoredbg).
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath "data" .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          request = "launch",
          name = "Launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }

      -- JavaScript / TypeScript (js-debug-adapter).
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath "data" .. "/mason/bin/js-debug-adapter",
          args = { "${port}" },
        },
      }
      for _, ft in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact" } do
        dap.configurations[ft] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Breakpoint signs.
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◉", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "→", texthl = "DapStopped",             linehl = "DapStopped", numhl = "" })
    end,
  },
}

