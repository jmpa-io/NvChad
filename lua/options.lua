require "nvchad.options"

local opt = vim.opt

opt.wrap = false        -- don't wrap lines.
opt.colorcolumn = "80"  -- column guide at 80 chars.
opt.expandtab = true    -- use spaces instead of tabs.

-- allow h/l and arrow keys to move across line boundaries.
opt.whichwrap:append "<>[]hl"

-- add mason binaries to PATH.
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- add Go binaries to PATH.
vim.env.PATH = vim.fn.expand "$HOME" .. "/go/bin" .. delim .. vim.env.PATH
