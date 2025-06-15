return {
	-- other plugins …

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- load your saved theme
			local cosmicink = require("themes.evillualine")
			require("lualine").setup(vim.tbl_deep_extend("force", {
				options = {
					theme = {
						normal = cosmicink.options.theme.normal,
						inactive = cosmicink.options.theme.inactive,
					},
				},
			}, cosmicink))
		end,
	},
}
