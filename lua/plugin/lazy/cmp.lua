return {
	"saghen/blink.cmp",
	dependencies = {
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	version = "*",

	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- see the "default configuration" section below for full documentation on how to define
		-- your own keymap.
		keymap = { preset = "super-tab" },
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "path", "cmdline", "buffer" },
		},
		-- experimental signature help support
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
