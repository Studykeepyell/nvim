return {
	"ggandor/leap.nvim",
	config = function()
		require("leap").add_default_mappings()
	end,
	event = "VeryLazy", -- optional: load when idle
}
