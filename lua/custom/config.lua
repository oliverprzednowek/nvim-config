-- Loosely based on set.lua from https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/set.lua
-- autocommands
-- sets the terminal cursor back to | after exiting nvim
-- this is the sequence for the windows terminal spacebar \x1b[4 q
-- the one currently in there is for konsole

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
        vim.opt_local.spelllang = "en_us" -- Change to your preferred language
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

-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- set auto-completion menu height
vim.opt.pumheight = 10

-- vim.opt.termguicolors = true

vim.opt.scrolloff = 3
-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")

-- vim.opt.updatetime = 50


-- Enable spell check on markdown and text files
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "python", "cpp", "c", "java", "lua", "javascript", "typescript", "go", "rust", "sh" },
    callback = function()
        vim.opt.colorcolumn = "80"
    end,
})
