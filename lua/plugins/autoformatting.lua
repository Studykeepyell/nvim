return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters
		local cpplint = require("none-ls.diagnostics.cpplint")
		-- Formatters & linters for mason to install
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier", -- ts/js formatter
				"stylua", -- lua formatter
				"eslint_d", -- ts/js linter
				"shfmt", -- Shell formatter
				"checkmake", -- linter for Makefiles
				"ruff", -- Python linter and formatter

				-- ✨ add these for C / C++
				"clang-format", -- ← auto-formatter
				"shellcheck",
				"actionlint",
				"jsonlint",
				"yamllint",
				"markdownlint",
				"htmlhint",

				"mypy",
				"pylint",
				"clang-tidy",
			},
			automatic_installation = true,
		})

		local sources = {

			formatting.clang_format,
			cpplint.with({
				args = { "--filter=-legal/copyright", "$FILENAME" }, -- example: silence header-guard nit
			}),
			diagnostics.checkmake,
			formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),
			diagnostics.shellcheck,
			diagnostics.actionlint,
			diagnostics.yamllint,
			diagnostics.markdownlint,
			diagnostics.mypy,
			diagnostics.pylint,
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			-- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
			sources = sources,
			-- you can reuse a shared lspconfig on_attach callback here
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●", -- You can use ">>", "→", or "" for no symbol
				spacing = 2,
				source = "always",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Show diagnostic message in a floating window on hover
		vim.o.updatetime = 250
		vim.cmd([[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false, border = "rounded", source = "always" })
]])
	end,
}
