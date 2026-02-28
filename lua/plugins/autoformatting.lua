return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics
		local code_actions = null_ls.builtins.code_actions

		-- 1. IMPORT EXTRAS
		local eslint_d_diag = require("none-ls.diagnostics.eslint_d")
		local eslint_d_actions = require("none-ls.code_actions.eslint_d")
		local cpplint = require("none-ls.diagnostics.cpplint")

		-- Python Extras (Ruff only)
		local ruff_d = require("none-ls.diagnostics.ruff")
		local ruff_fmt = require("none-ls.formatting.ruff_format")

		-- 2. MASON AUTO-INSTALLER (Removed unwanted tools)
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettierd",
				"eslint_d", -- JS/TS
				"stylua", -- Lua
				"shfmt", -- Shell formatting (kept shfmt, removed shellcheck)
				"actionlint", -- GitHub Actions
				"yamllint",
				"markdownlint",
				"ruff",
				"black", -- Python
				"google-java-format", -- Java
				"clang-format", -- C/C++
			},
			automatic_installation = true,
		})

		-- 3. SOURCES
		local sources = {
			-- JS/TS
			formatting.prettierd.with({
				filetypes = { "javascript", "typescript", "json", "yaml", "html", "css", "markdown" },
			}),
			eslint_d_diag,
			eslint_d_actions,

			-- Python
			ruff_d,
			ruff_fmt,
			formatting.black,

			-- Java
			formatting.google_java_format,

			-- C/C++
			formatting.clang_format,
			cpplint.with({ args = { "--filter=-legal/copyright", "$FILENAME" } }),

			-- Lua / Misc
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			diagnostics.actionlint,
			diagnostics.yamllint,
			diagnostics.markdownlint,
			formatting.terraform_fmt,
		}

		-- 4. SETUP & FORMATTING ON SAVE
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								async = false,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})

		vim.diagnostic.config({ virtual_text = { prefix = "●", source = "always" } })
	end,
}
