return {
	{
		-- IMPORTANT: Must use the full URL for Codeberg
		url = "https://codeberg.org/andyg/leap.nvim",
		name = "leap.nvim",
		config = function()
			local leap = require("leap")
			-- The new function that caused the error (now it will exist!)

			-- Styling
			vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "#ffffff", bg = "#ff007c", bold = true })
			vim.api.nvim_set_hl(0, "LeapLabelSecondary", { fg = "#ffffff", bg = "#5f00ff", bold = true })
			vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#555555" })
			vim.api.nvim_set_hl(0, "LeapMatch", { fg = "#00ffff", bold = true, underline = true })
		end,
	},
}
