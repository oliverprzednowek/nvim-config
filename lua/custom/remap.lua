vim.g.mapleader = " "

-- insert mode remaps
vim.keymap.set("i", "jj", "<Esc>")

-- setting up plugin remaps
-- TODO: make this only work if the file has no unwritten changes
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { noremap = true, silent = true, desc = "Open file explorer (oil.nvim)"})

-- setting markdown preview remaps
vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>")
vim.keymap.set("n", "<leader>mc", ":MarkdownPreviewStop<CR>")
vim.keymap.set("n", "<leader>mt", ":MarkdownPreviewToggle<CR>")

vim.keymap.set("n", "<leader>q", ":q<CR>", {desc = "quit"})
vim.keymap.set("n", "<leader>w", ":w<CR>", {desc = "write file"})

vim.keymap.set("n", "<leader>n", ":noh<CR>", {desc = ":noh"})
vim.keymap.set("n", "<leader>td", ":Telescope diagnostics<CR>", {desc = "Telescope Diagnostics"})


-- insert new above or below current line without exiting normal mode
vim.api.nvim_set_keymap("n", "<leader>o", "o<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>O", "O<Esc>", { noremap = true, silent = true })

---------------
-- LSP-related
---------------

-- error view
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
		callback = function()
			vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
			return true
		end,
	})
end, { desc = "Show diagnostics under cursor (inline)" })

-- different error view
vim.keymap.set("n", "<leader>D", function()
    vim.diagnostic.open_float({ scope = "line" })
end, { desc = "Show diagnostics under cursor (hover)" })

-- format file
vim.keymap.set("n", "<leader>F", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })
