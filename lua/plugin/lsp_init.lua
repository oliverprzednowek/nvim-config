local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	local opts = { buffer = bufnr }

	-- Set default keymaps provided by lsp-zero
	lsp_zero.default_keymaps(opts)

	-- Custom keybindings

	-- Rename symbol under cursor
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)

	-- Format the file
	vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)

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
			["<C-Space>"] = cmp.mapping.complete(),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "buffer" },
			{ name = "path" },
			{ name = "luasnip" },
		}),
		-- Automatically insert `()` after function or method completion
		cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done()),
	})
end)

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

-- here you can setup the language servers
