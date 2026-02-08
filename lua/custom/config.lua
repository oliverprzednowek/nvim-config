-- Loosely based on set.lua from https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/set.lua


-- Start with virtual text OFF (because you'll toggle it)
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Turn ON inline errors when entering Normal mode
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:n", -- any mode → Normal mode
	callback = function()
		vim.diagnostic.config({ virtual_text = true })
	end,
})

-- Turn OFF inline errors when leaving Normal mode (going into Insert mode)
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "n:*", -- Normal mode → any other mode
	callback = function()
		vim.diagnostic.config({ virtual_text = false })
	end,
})

-- Vim opts
vim.g.mkdp_browser = "brave-browser"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.shortmess:append("I")

-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- set auto-completion menu height
vim.opt.pumheight = 10

-- vim.opt.termguicolors = true

vim.opt.scrolloff = 20
-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")

-- vim.opt.updatetime = 50

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     pattern = { "python", "cpp", "c", "java", "lua", "javascript", "typescript", "go", "rust", "sh" },
--     callback = function()
--         vim.opt.colorcolumn = "80"
--     end,
-- })
