return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					-- Enable syntax highlighting (with protected call fallback)
					pcall(vim.treesitter.start)

					-- Enable Treesitter folds
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"

					-- Enable Treesitter indentation
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
		config = function()
			require("nvim-treesitter").install({ "rust", "javascript", "python", "c_sharp", "typescript" })
		end,
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = {
				enabled = true,
				window = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpSignature,FloatBorder:BlinkCmpSignatureBorder",
				},
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			-- Initialize dependencies
			dapui.setup({
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
			})
			require("nvim-dap-virtual-text").setup()
			require("mason-nvim-dap").setup({
				ensure_installed = {}, -- add debuggers here, e.g., "python", "codelldb"
				automatic_installation = true,
				handlers = {},
			})

			-- Automatically open/close DAP UI when debugging starts/ends
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Keymaps
			local map = vim.keymap.set

			-- Stepping / Execution (<F5> family + <leader>d)
			map("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			map("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
			map("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
			map("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
			map("n", "<F7>", dapui.toggle, { desc = "Debug: Toggle UI" })

			map("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
			map("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
			map("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
			map("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })

			-- Breakpoints
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			map("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })

			-- Session & UI Controls
			map("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
			map("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
			map("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate Session" })
			map("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

			-- Evaluate variables/expressions (works in normal & visual mode)
			map({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Debug: Evaluate Expression" })
		end,
	},
}
