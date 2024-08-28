function setTheme(colour)
	colour = colour or "tokyonight"
	vim.cmd("colorscheme " .. colour)
end

return {
	{
		"folke/tokyonight.nvim",
		-- lazy = false,
		-- priority = 1000,
		-- opts = {},
		config = function()
			require("tokyonight").setup({
				style = "night",
			})
			setTheme()
		end,
	},
}
