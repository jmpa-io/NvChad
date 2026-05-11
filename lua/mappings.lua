require "nvchad.mappings"

local map = vim.keymap.set

-- Command mode shortcut.
map("n", ";", ":", { desc = "CMD enter command mode" })
-- jk -> ESC handled by better-escape.nvim

-- File explorer.
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Diagnostic navigation.
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic float" })

-- Git (gitsigns) — set in gitsigns on_attach, but document expected bindings here:
-- ]c / [c  — next/prev hunk
-- <leader>hs — stage hunk
-- <leader>hr — reset hunk
-- <leader>hp — preview hunk
-- <leader>gb — git blame line
