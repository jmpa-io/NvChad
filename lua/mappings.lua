require "nvchad.mappings"

local map = vim.keymap.set

-- Command mode shortcut.
map("n", ";", ":", { desc = "CMD enter command mode" })
-- jk -> ESC handled by better-escape.nvim

-- File operations.
map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>",  { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })

-- File explorer.
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Diagnostic navigation.
map("n", "[d", vim.diagnostic.goto_prev,  { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic float" })

-- Buffer navigation.
map("n", "<Tab>",   "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Move selected lines up/down in visual mode.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centred when scrolling / searching.
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centred)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centred)" })
map("n", "n",     "nzzzv",   { desc = "Next search result (centred)" })
map("n", "N",     "Nzzzv",   { desc = "Prev search result (centred)" })

-- Paste without losing register.
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Yank to system clipboard.
map({ "n", "v" }, "<leader>y", [["+y]],  { desc = "Yank to clipboard" })
map("n",          "<leader>Y", [["+Y]],  { desc = "Yank line to clipboard" })

-- DAP (debugger) — requires nvim-dap.
map("n", "<F5>",       "<cmd>lua require('dap').continue()<CR>",          { desc = "DAP: Continue" })
map("n", "<F10>",      "<cmd>lua require('dap').step_over()<CR>",         { desc = "DAP: Step over" })
map("n", "<F11>",      "<cmd>lua require('dap').step_into()<CR>",         { desc = "DAP: Step into" })
map("n", "<F12>",      "<cmd>lua require('dap').step_out()<CR>",          { desc = "DAP: Step out" })
map("n", "<leader>b",  "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "DAP: Toggle breakpoint" })
map("n", "<leader>B",  "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<CR>", { desc = "DAP: Conditional breakpoint" })
map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>",          { desc = "DAP: Toggle UI" })

-- Git (gitsigns — set in gitsigns on_attach).
-- ]c / [c     — next/prev hunk
-- <leader>hs  — stage hunk
-- <leader>hr  — reset hunk
-- <leader>hp  — preview hunk
-- <leader>hb  — blame line
-- <leader>hd  — diff this
-- <leader>tb  — toggle line blame
