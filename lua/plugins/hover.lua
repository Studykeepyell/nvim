return {
	"lewis6991/hover.nvim",
	config = function()
		require("hover").setup({
			init = function()
				-- Use LSP as hover provider
				require("hover.providers.lsp")
				-- You can add others: require('hover.providers.gh'), require('hover.providers.man'), etc.
			end,
			preview_opts = {
				border = "single",
			},
			title = true,
		})

		-- Keymap for hover (replace K if you want)
		vim.keymap.set("n", "K", require("hover").hover, { desc = "Hover documentation" })
	end,
	dependencies = {
		"neovim/nvim-lspconfig", -- required to have a working LSP (clangd, etc.)
	},
	event = "LspAttach",   -- load only when LSP is attached
}
