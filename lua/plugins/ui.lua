return {
	{
		"https://github.com/olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 1000,
		options = {
			terminal_colors = false,
		},
		config = function()
			require("onedarkpro").setup({
				options = {
					terminal_colors = false,
				},
			})
			vim.cmd([[colorscheme onedark]])
		end,
	},
}
