require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


-- Custom Mappings for DAP
local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "Add breakpoint at line",
    },
    ["<leader>dr"] = {
      function()
        require("dap").continue()
      end,
      "Start or continue the debugger",
    },
  },
}

return M

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
