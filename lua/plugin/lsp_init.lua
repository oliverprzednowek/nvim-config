local lsp_zero = require("lsp-zero")

-- configure lsp zero
lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions

    -- Set keymaps. Not using the default keymaps because I think they are dumb:)

    -- Displays hover information about the symbol under the cursor in a floating window
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "hover documentation" })

    -- Jumps to the definition of the symbol under the cursor.
    vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = bufnr, desc = "go to definition" })

    -- Jumps to the declaration of the symbol under the cursor. Some servers don't implement this feature
    vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "go to declaration" })

    -- Lists all the implementations for the symbol under the cursor in the quickfix window
    vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "go to implementation" })

    -- Jumps to the definition of the type of the symbol under the cursor
    vim.keymap.set("n", "<leader>ltd", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "go to type definition" })

    -- Lists all the references to the symbol under the cursor in the quickfix
    vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, { buffer = bufnr, desc = "go to references" })

    -- Displays signature information about the symbol under the cursor in a floating window. If a mapping
    -- already exists for this key this function is not bound
    vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "show function signature" })

    -- Renames all references to the symbol under the cursor
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "rename symbol" })

    -- Format a buffer using the LSP servers attached to it
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = bufnr, desc = "format file" })

    -- Selects a code action available at the current cursor position
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "execute code action" })

    -- Show diagnostic in a floating window
    vim.keymap.set("n", "<leader>lsd", vim.diagnostic.open_float, { buffer = bufnr, desc = "show diagnostic" })

    -- Move to the previous diagnostic in the current buffer
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "previous diagnostic" })

    -- Move to the next diagnostic
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "next diagnostic" })

    -- Keybindings for navigating autocomplete options
    local cmp = require("cmp")
    local select_behavior = { behavior = cmp.SelectBehavior.Insert }
    cmp.setup({

        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = {
            ["<Tab>"] = cmp.mapping.select_next_item(select_behavior),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(select_behavior),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
            { name = "luasnip" },
        }),
        -- Automatically insert `()` after function or method completion
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done()),

        window = {
            completion = cmp.config.window.bordered({ pumheight = 5, scrollbar = false }),
            documentation = cmp.config.window.bordered(),
        },
    })
end)

vim.api.nvim_set_hl(0, "CmpPmenuScrollbar", { bg = "NONE" })

lsp_zero.setup()

require("mason").setup({})
require("mason-lspconfig").setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { "pyright", "clangd" },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,
    },
})

require("lspconfig").lua_ls.setup({})

-- setup language servers below
