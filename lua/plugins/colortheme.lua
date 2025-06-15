return {
	"navarasu/onedark.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- Lua
		require("onedark").setup({
			-- Main options --
			style = "warmer",    -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
			transparent = false, -- Show/hide background
			term_colors = true,  -- Change terminal color as per the selected theme style
			ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
			cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

			-- toggle theme style ---
			toggle_style_key = "<leader>ts",                                            -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
			toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

			-- Change code style ---
			-- Options are italic, bold, underline, none
			-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
			code_style = {
				comments = "italic",
				keywords = "none",
				functions = "none",
				strings = "none",
				variables = "none",
			},

			-- Lualine options --
			lualine = {
				transparent = false, -- lualine center bar transparency
			},

			-- Custom Highlights --
			colors = {
				bright_orange = "#f57b4e", -- new colour
				green = "#00ffaa", -- override existing
				teal = "#008080",
				gray = "#7d7774", -- you used `$teal`, so define it!
				magenta = "#ff00ff",
			},
			highlights = {
				-- General LSP semantic token types
				["@lsp.type.keyword"] = { fg = "$green" },
				["@lsp.type.operator"] = { fg = "$blue", fmt = "bold" },
				["@lsp.type.namespace"] = { fg = "$magenta", fmt = "italic" },
				["@lsp.type.class"] = { fg = "$yellow", fmt = "bold" },
				["@lsp.type.struct"] = { fg = "$yellow", fmt = "bold" },
				["@lsp.type.enum"] = { fg = "$purple" },
				["@lsp.type.interface"] = { fg = "$cyan", fmt = "underline" },
				["@lsp.type.type"] = { fg = "$orange" },
				["@lsp.type.function"] = { fg = "#28c8e0", sp = "$cyan", fmt = "underline,italic" },
				["@lsp.type.method"] = { fg = "#0998ab", fmt = "italic" },
				["@lsp.type.parameter"] = { fg = "$teal" },
				["@lsp.type.property"] = { fg = "$bright_orange", fmt = "bold" },
				["@lsp.type.variable"] = { fg = "$fg" },
				["@lsp.type.constant"] = { fg = "$red", fmt = "bold" },
				["@lsp.type.string"] = { fg = "$green" },
				["@lsp.type.number"] = { fg = "$orange" },
				["@lsp.type.boolean"] = { fg = "$red" },
				["@lsp.type.comment"] = { fg = "$gray", fmt = "italic" },
				["@lsp.type.macro"] = { fg = "$purple", fmt = "bold" },
				["@lsp.type.tag"] = { fg = "$blue" },

				-- Language-specific overrides
				["@lsp.type.variable.go"] = { fg = "none" }, -- disables override (inherits theme default)
				["@lsp.type.parameter.go"] = { fg = "$teal" },
				["@lsp.type.function.lua"] = { fg = "#00bcd4", fmt = "bold" },
				["@lsp.type.property.tsx"] = { fg = "$blue", fmt = "italic" },
				["@lsp.type.class.python"] = { fg = "$yellow", fmt = "bold" },
				["@lsp.type.decorator.python"] = { fg = "$purple", fmt = "italic" },

				-- Optional: UI or diagnostic-related
				DiagnosticError = { fg = "$red" },
				DiagnosticWarn = { fg = "$yellow" },
				DiagnosticInfo = { fg = "$blue" },
				DiagnosticHint = { fg = "$cyan" },
				DiagnosticUnderlineError = { sp = "$red", fmt = "underline" },
				DiagnosticUnderlineWarn = { sp = "$yellow", fmt = "underline" },
			},
			-- Plugins Config --
			diagnostics = {
				darker = true, -- darker colors for diagnostic
				undercurl = true, -- use undercurl instead of underline for diagnostics
				background = true, -- use background color for virtual text
			},
		})
		-- Enable theme
		require("onedark").load()
	end,
}
