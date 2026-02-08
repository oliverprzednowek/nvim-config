-- autocommands
-- sets the terminal cursor back to | after exiting nvim
-- this is the sequence for the windows terminal spacebar \x1b[4 q
-- the one currently in there is for konsole

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			require("telescope.builtin").find_files()
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	callback = function()
		vim.cmd('set guicursor= | call chansend(v:stderr, "\x1b[5 q")')
	end,
})

-- Remember cursor position when returning to file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local mark = vim.fn.line("'\"")
		if mark > 0 and mark <= vim.fn.line("$") then
			vim.api.nvim_win_set_cursor(0, { mark, 0 })
		end
	end,
})

-- Enable spell check on markdown and text files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

-- LSP keymaps

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
	callback = function()
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
			desc = "LSP: Go to definition",
		})

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
			desc = "LSP: Go to declaration",
		})

		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
			desc = "LSP: Go to implementation",
		})

		-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {
		-- 	desc = "LSP: References",
		-- })
	end,
})
