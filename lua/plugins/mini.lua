return {
	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			require("mini.files").setup()
			require("mini.icons").setup()
			require("mini.surround").setup()
			require("mini.pairs").setup()
			require("mini.statusline").setup()
			require("mini.tabline").setup()
			require("mini.indentscope").setup()
			require("mini.bracketed").setup()
			require("mini.git").setup()
			require("mini.notify").setup()

			local mini_ai = require("mini.ai")

			mini_ai.setup({
				custom_textobjects = {
					F = mini_ai.gen_spec.treesitter({
						a = "@function.outer",
						i = "@function.inner",
					}),
				},
			})

			vim.keymap.set("n", "<leader>e", function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0))
			end, { desc = "Open Mini Files (current file)" })
		end,
	},
}
