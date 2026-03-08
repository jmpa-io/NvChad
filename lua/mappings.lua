require "nvchad.mappings"

--
-- Mappings for GitHub Copilot.
--

-- Accept current suggestion.
vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', {
  expr = true,
  silent = true,
  noremap = true,
})

-- Accept next suggestion and insert a new line.
vim.api.nvim_set_keymap("i", "<C-n>", 'copilot#Next()', {
  expr = true,
  silent = true,
  noremap = true,
})

-- Accept previous suggestion and insert a new line
vim.api.nvim_set_keymap("i", "<C-p>", 'copilot#Previous()', {
  expr = true,
  silent = true,
  noremap = true,
})

-- Dismiss current suggestion.
vim.api.nvim_set_keymap("i", "<C-x>", 'copilot#Dismiss()', {
  expr = true,
  silent = true,
  noremap = true,
})


--
-- Mappings for navigating text.
--

vim.keymap.set({ 'n', 'v' }, '<C-Left>', '^', { desc = 'first non-blank on line' })
vim.keymap.set('i', '<C-Left>', '<C-o>^', { desc = 'first non-blank (insert)' })

vim.keymap.set({ 'n', 'v' }, '<C-Right>', 'g_', { desc = 'last non-blank on line' })
vim.keymap.set('i', '<C-Right>', '<C-o>g_', { desc = 'last non-blank (insert)' })

--
-- Mappings for DAP.
--

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
