return {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.config("*", {})
        vim.lsp.enable({
            "lua_ls",
            "pyright",
            "clangd",
            "gopls",
        })
  end,
}
