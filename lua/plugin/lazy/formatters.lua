return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls") -- Use 'null-ls' here, not 'none-ls'

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }), -- Python formatter
                null_ls.builtins.formatting.stylua,                                    -- Lua formatter
                -- Add more formatters here as needed
            },
            -- on_attach = function(client, bufnr)
            -- 	if client.server_capabilities.documentFormattingProvider then
            -- 		vim.cmd([[
            --                      augroup LspFormatting
            --                          autocmd! * <buffer>
            --                          autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })
            --                      augroup END
            --                  ]])
            -- 	end
            -- end,
        })
    end,
}
