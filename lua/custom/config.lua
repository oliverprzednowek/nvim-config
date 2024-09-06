-- autocommands
-- sets the terminal cursor back to | after exiting nvim
vim.api.nvim_create_autocmd("VimLeave", {
    pattern = '*',
    callback = function()
        vim.cmd("set guicursor= | call chansend(v:stderr, \"\x1b[ q\")")
    end
})

-- don't show the default text on startup
vim.opt.shortmess:append "I"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
local clipboard = vim.opt.clipboard:get()
if vim.tbl_contains(clipboard, "unnamedplus") then
	vim.opt.clipboard = {}
	print("nvim clipboard selected")
else
	vim.opt.clipboard = { "unnamedplus" }
	print("system clipboard selected")
end
im.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- set auto-completion menu height
vim.opt.pumheight = 10

-- vim.opt.termguicolors = true

vim.opt.scrolloff = 5
-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")

-- vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"
