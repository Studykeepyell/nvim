-- ~/.config/nvim/lua/plugins/overseer.lua
return {
	-- 1) plugin repo
	"stevearc/overseer.nvim",
	-- 2) make sure plenary is available
	dependencies = { "nvim-lua/plenary.nvim" },
	-- 3) only load it for these events (optional)
	event = "VeryLazy",

	-- 4) pass your setup() opts directly
	opts = {
		templates = { "builtin", "user.run_script", "user.cpp_build" },
	},
}
