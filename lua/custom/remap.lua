vim.g.mapleader = " "

-- insert mode remaps
vim.keymap.set("i", "jj", "<Esc>")

-- setting up plugin remaps
vim.keymap.set("n", "<leader>e", ":w<CR>:Oil<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>wq", ":wq<CR>")

-- insert new above or below current line without exiting normal mode
vim.api.nvim_set_keymap("n", "<leader>o", "o<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>O", "O<Esc>", { noremap = true, silent = true })

-- toggle nvim/system clipboard
vim.keymap.set("n", "<leader>c", function()
    local clipboard = vim.opt.clipboard:get()
    if vim.tbl_contains(clipboard, "unnamedplus") then
        vim.opt.clipboard = {}
        print("nvim clipboard selected")
    else
        vim.opt.clipboard = { "unnamedplus" }
        print("system clipboard selected")
    end
end, { noremap = true, silent = true })
