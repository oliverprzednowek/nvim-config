-- autocommands
-- sets the terminal cursor back to | after exiting nvim
vim.api.nvim_create_autocmd("VimLeave", {
    pattern = '*',
    callback = function()
        vim.cmd("set guicursor= | call chansend(v:stderr, \"\x1b[ q\")")
    end
})


vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- vim.opt.termguicolors = true

vim.opt.scrolloff = 5
-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")

-- vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"
