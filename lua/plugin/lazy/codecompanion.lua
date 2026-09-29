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
                        return require("codecompanion.adapters").extend(
                            "openai_compatible",
                            {
                                env = {
                                    url = "http://127.0.0.1:8080",
                                    api_key = "local",
                                    chat_url = "/v1/chat/completions",
                                },

                                headers = {
                                    ["Content-Type"] = "application/json",
                                    ["Authorization"] = "Bearer ${api_key}",
                                },

                                parameters = {
                                    sync = true,
                                },
                            }
                        )
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
                "<leader>ac",
                "<cmd>CodeCompanionChat Toggle<cr>",
                desc = "AI Chat",
            },

            {
                "<leader>aa",
                "<cmd>CodeCompanionActions<cr>",
                desc = "AI Actions",
                mode = { "n", "v" },
            },

            {
                "<leader>ai",
                "<cmd>CodeCompanion<cr>",
                desc = "AI Inline",
                mode = { "n", "v" },
            },
        },
    },
}
