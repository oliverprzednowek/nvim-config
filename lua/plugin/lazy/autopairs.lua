return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
    config = function()
        require("nvim-autopairs").setup({})
    end
}
