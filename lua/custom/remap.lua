vim.g.mapleader = " "

-- insert mode remaps
vim.keymap.set("i", "jj", "<Esc>")

-- setting up plugin remaps
vim.keymap.set("n", "<leader>e", ":Oil<CR>")

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>wq", ":wq<CR>")

-- setup copy/pasting behaviour
vim.api.nvim_set_keymap("n", "<leader>y", '"+y', { noremap = true, silent = true }) -- Copy to system clipboard
vim.api.nvim_set_keymap("v", "<leader>y", '"+y', { noremap = true, silent = true }) -- Copy to system clipboard in visual mode

vim.api.nvim_set_keymap("n", "<leader>p", '"+p', { noremap = true, silent = true }) -- Paste from system clipboard
vim.api.nvim_set_keymap("v", "<leader>p", '"+p', { noremap = true, silent = true }) -- Paste from system clipboard in visual mode
