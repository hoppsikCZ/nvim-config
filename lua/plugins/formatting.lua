return {

	{
		"zapling/mason-conform.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"stevearc/conform.nvim",
		},
		config = function()
			local conform = require("conform")

			-- 1. Setup conform options and format_on_save logic
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					rust = { "rustfmt", lsp_format = "fallback" },
				},
				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_format = "fallback" }
				end,
			})

			-- 2. Setup mason-conform AFTER conform.setup
			require("mason-conform").setup({
				ignore_install = { "rustfmt" },
			})

			-- 3. Register the user command to toggle format-on-save on/off (:FormatToggle)
			vim.api.nvim_create_user_command("FormatToggle", function(args)
				if vim.g.disable_autoformat or vim.b.disable_autoformat then
					vim.g.disable_autoformat = false
					vim.b.disable_autoformat = false
					print("Format-on-save ENABLED")
				else
					vim.g.disable_autoformat = true
					print("Format-on-save DISABLED")
				end
			end, { desc = "Toggle format-on-save" })

			-- 4. Register a command to Format any text, works with selections
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line and #end_line or 0 },
					}
				end
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true })

			-- 5. Bind the :Format command to a keymap
			vim.keymap.set(
				{ "n", "v" },
				"<leader>mp",
				":Format<CR>",
				{ desc = "Format file or visual selection", silent = true }
			)
		end,
	},
}
