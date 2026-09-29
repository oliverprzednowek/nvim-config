return {
	{
		"olimorris/codecompanion.nvim",
		version = "^19.0.0",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},

		opts = {
			adapters = {
				http = {
					["llama.cpp"] = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								url = (vim.env.LLAMA_CPP_URL or "http://127.0.0.1:8080"):gsub("/+$", ""),
								api_key = "local",
								chat_url = "/v1/chat/completions",
							},

							headers = {
								["Content-Type"] = "application/json",
								["Authorization"] = "Bearer ${api_key}",
							},

							schema = vim.env.LLAMA_CPP_MODEL and {
								model = { default = vim.env.LLAMA_CPP_MODEL },
							} or {},
						})
					end,
				},
			},

			interactions = {
				chat = {
					adapter = "llama.cpp",
				},

				inline = {
					adapter = "llama.cpp",
				},
			},
		},

		keys = {
			{
				"<leader>ag",
				function()
					require("custom.ai").comment()
				end,
				desc = "AI Run gippity comment",
			},
			{
				"<leader>ar",
				function()
					require("custom.ai").chat(true)
				end,
				desc = "AI Refresh current file in chat",
			},
			{
				"<leader>ac",
				function()
					require("custom.ai").chat()
				end,
				desc = "AI Chat with current file",
			},

			{
				"<leader>aa",
				"<cmd>CodeCompanionActions<cr>",
				desc = "AI Actions",
				mode = { "n", "v" },
			},

			{
				"<leader>ai",
				function()
					require("custom.ai").inline()
				end,
				desc = "AI Edit with current file",
				mode = { "n", "v" },
			},
		},
	},
}
