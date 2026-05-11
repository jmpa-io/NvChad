local M = {}

M.setup = function()
  local lint = require "lint"

  -- Custom golangci-lint definition (nvim-lint doesn't bundle this).
  lint.linters.golangci_lint = {
    cmd = "golangci-lint",
    args = { "run", "--out-format", "line-number" },
    stdin = false,
    stream = "stdout",
    ignore_exitcode = true,
    parser = require("lint.parser").from_errorformat "%f:%l:%c: %t%*[^:]: %m",
  }

  lint.linters_by_ft = {
    -- Go — only run golangci-lint if it's installed.
    go = vim.fn.executable "golangci-lint" == 1 and { "golangci_lint" } or {},

    -- Python.
    python = { "ruff", "mypy" },

    -- C++: cpplint + built-in cppcheck (replaces none-ls).
    cpp = { "cpplint", "cppcheck" },

    -- JavaScript / TypeScript — eslint via LSP, no extra linter needed.
    javascript = {},
    typescript = {},
    javascriptreact = {},
    typescriptreact = {},

    -- Shell.
    sh = { "shellcheck" },
    bash = { "shellcheck" },

    -- Docker.
    dockerfile = { "hadolint" },

    -- Markdown.
    markdown = { "markdownlint" },

    -- Terraform.
    terraform = { "tflint" },
    tf = { "tflint" },

    -- SQL.
    sql = { "sqlfluff" },
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

  -- Lint on enter, save, and leaving insert mode.
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  -- actionlint: only for GitHub Actions workflow files.
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    pattern = { "*/.github/workflows/*.yml", "*/.github/workflows/*.yaml" },
    callback = function()
      lint.try_lint "actionlint"
    end,
  })

  -- Manual lint trigger.
  vim.keymap.set("n", "<leader>l", function()
    lint.try_lint()
  end, { desc = "Trigger linting for current file" })

  vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
  }

  -- Diagnostic underline colours (Dracula-friendly).
  vim.api.nvim_command "highlight DiagnosticUnderlineError gui=underline guisp=#ff5555"
  vim.api.nvim_command "highlight DiagnosticUnderlineWarn  gui=underline guisp=#ffb86c"
  vim.api.nvim_command "highlight DiagnosticUnderlineInfo  gui=underline guisp=#8be9fd"
  vim.api.nvim_command "highlight DiagnosticUnderlineHint  gui=underline guisp=#50fa7b"

  -- Show diagnostics in a float on cursor hold.
  vim.api.nvim_create_autocmd("CursorHold", {
    group = lint_augroup,
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        scope = "line",
        border = "single",
      })
    end,
  })
end

return M
