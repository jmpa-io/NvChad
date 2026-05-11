require "nvchad.options"

local opt = vim.opt

opt.wrap = false        -- don't wrap lines.
opt.colorcolumn = "80"  -- column guide at 80 chars.
opt.expandtab = true    -- use spaces instead of tabs (overridden per ft below).

-- allow h/l and arrow keys to move across line boundaries.
opt.whichwrap:append "<>[]hl"

-- add mason binaries to PATH.
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- add Go binaries to PATH.
vim.env.PATH = vim.fn.expand "$HOME" .. "/go/bin" .. delim .. vim.env.PATH

-- Per-language indentation via autocmd.
-- Go: tabs (gofmt standard).
-- Everything else: 2-space indent.
local indent_group = vim.api.nvim_create_augroup("IndentSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "go" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "lua", "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css", "json", "jsonc", "yaml", "toml", "svelte", "vue" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "python", "cpp", "c", "cs", "rust", "bash", "sh", "powershell", "terraform" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
