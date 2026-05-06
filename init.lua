vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme (guard against missing cache on first run — run :Lazy build base46 to regenerate)
local base46_cache = vim.g.base46_cache
if vim.uv.fs_stat(base46_cache .. "defaults") then
  dofile(base46_cache .. "defaults")
end
if vim.uv.fs_stat(base46_cache .. "statusline") then
  dofile(base46_cache .. "statusline")
end

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
