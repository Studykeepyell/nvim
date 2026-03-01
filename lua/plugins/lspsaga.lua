return {
	"nvimdev/lspsaga.nvim",
	-- Lazy load this plugin only when an LSP attaches to a buffer
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lspsaga").setup({
			ui = {
				-- Matches nicely with modern themes like Kanagawa
				border = "rounded",
				title = true,
			},
			lightbulb = {
				enable = false, -- Disable if you find the lightbulb annoying
			},
		})

		-- Set up your keymaps
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Peek Definition (The one you asked for)
		opts.desc = "Peek Definition"
		keymap("n", "mm", "<cmd>Lspsaga peek_definition<CR>", opts)

		-- Go to Definition (Jumps into the GLFW/GLM file)
		opts.desc = "Go to Definition"
		keymap("n", "md", "<cmd>Lspsaga goto_definition<CR>", opts)

		-- Hover Documentation
		opts.desc = "Hover Documentation"
		keymap("n", "ms", "<cmd>Lspsaga hover_doc<CR>", opts)
	end,
}
