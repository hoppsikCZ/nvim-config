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
			vim.cmd([[colorscheme vaporwave]])
			vim.api.nvim_create_user_command("ToggleTheme", function()
				local current = vim.g.colors_name
				local new_theme = (current == "onelight") and "vaporwave" or "onelight"

				vim.cmd.colorscheme(new_theme)
				print("Switched theme to: " .. new_theme)
			end, {})
			vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTheme<CR>", { desc = "Toggle light/vaporwave theme" })
		end,
	},
}
