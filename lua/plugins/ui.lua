return {
	"gen740/SmoothCursor.nvim",
	config = function()
		require("smoothcursor").setup({
			type = "railgun",
			fancy = {
				enable = true,
				head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
				-- add more segments to the body if you want a longer trail
				body = {
					{ cursor = "●", texthl = "SmoothCursorRed" },
					{ cursor = "●", texthl = "SmoothCursorOrange" },
					{ cursor = "○", texthl = "SmoothCursorYellow" },
					{ cursor = "•", texthl = "SmoothCursorGreen" },
					{ cursor = "·", texthl = "SmoothCursorBlue" },
					{ cursor = "·", texthl = "SmoothCursorBlue" },
					{ cursor = "·", texthl = "SmoothCursorBlue" },
					{ cursor = "·", texthl = "SmoothCursorBlue" },
					{ cursor = "·", texthl = "SmoothCursorBlue" },
				},
				-- give your tail a character instead of `nil`
				tail = { cursor = "·", texthl = "SmoothCursorBlue" },
			},
			speed = 40, -- animation speed
			intervals = 20, -- ms between tail updates (lower is smoother)
			threshold = 0, -- <-- animate even on single-line moves
			max_threshold = 200, -- ignore huge jumps >200 lines
			priority = 10,
			autostart = true,
			always_redraw = false,
			cursor_type = "default",
		})

		-- define your highlight colors
		vim.cmd([[
      highlight SmoothCursorRed    guifg=#e95678
      highlight SmoothCursorOrange guifg=#f09383
      highlight SmoothCursorYellow guifg=#fac29a
      highlight SmoothCursorGreen  guifg=#29d398
      highlight SmoothCursorBlue   guifg=#26bbd9
    ]])

		-- stop in insert/replace, start everywhere else
		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = "*",
			callback = function()
				local m = vim.fn.mode()
				if m == "i" or m == "R" then
					vim.cmd("SmoothCursorStop")
				else
					vim.cmd("SmoothCursorStart")
				end
			end,
		})
	end,

	{
		"chentoast/marks.nvim",
		config = function()
			require("marks").setup({
				-- whether to bind default mappings (`m` to toggle, `[m`/`]m` to nav, etc)
				default_mappings = true,
				-- show a bookmark sign in the signcolumn
				signs = true,
				-- which sign to use for bookmarks
				bookmark_sign = "⚑",
				-- do you want cyclic navigation? (jump from last → first)
				cyclic = true,
			})

			-- (optional) remap if you don’t like the defaults:
			vim.keymap.set("n", "m", "<cmd>lua require('marks').toggle()<CR>", { desc = "Toggle Bookmark" })
			vim.keymap.set("n", "N[", "<cmd>lua require('marks').prev()<CR>", { desc = "Previous Bookmark" })
			vim.keymap.set("n", "N]", "<cmd>lua require('marks').next()<CR>", { desc = "Next Bookmark" })
		end,
	},
}
