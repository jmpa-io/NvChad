require "nvchad.options"

local opt = vim.opt
local o = vim.o

opt.wrap = false       -- don't wrap lines.
opt.colorcolumn = '80' -- add a line, when editing files, at the nth column.
opt.expandtab = true   -- use spaces instead of tabs.

o.ruler = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- add binaries installed by mason.nvim to PATH.
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- add binaries installed & compiled by Go to PATH.
vim.env.PATH = vim.fn.expand("$HOME") .. "/go/bin" .. delim .. vim.env.PATH
