return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{ "https://github.com/ibhagwan/fzf-lua" },

	{ "https://github.com/stevearc/quicker.nvim" },

	{ "https://github.com/lewis6991/gitsigns.nvim" },

	{ "akinsho/toggleterm.nvim", version = "*", opts = {
		open_mapping = [[<c-\>]],
	} },

	{
		"willothy/flatten.nvim",
		lazy = false,
		priority = 1001,
	},

	{ "wakatime/vim-wakatime", lazy = false },
}
