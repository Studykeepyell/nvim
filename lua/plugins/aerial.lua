-- Example: inside lua/plugins/ui.lua
return {
	-- other plugins...

	{
		"stevearc/aerial.nvim",
		opts = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("aerial").setup({
				layout = {
					max_width = { 40, 0.2 },
					min_width = 20,
					default_direction = "right",
				},
				show_guides = true,
				filter_kind = false,
				backends = { "lsp", "treesitter", "markdown" },
				highlight_on_jump = 300,
			})

			vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial outline" })
		end,
	},
}
