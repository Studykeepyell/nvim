return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- auto-install external tools for none-ls
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics
		local code_actions = null_ls.builtins.code_actions

		-- none-ls-extras sources
		local eslint_d_diag = require("none-ls.diagnostics.eslint_d")
		local eslint_d_actions = require("none-ls.code_actions.eslint_d")
		local cpplint = require("none-ls.diagnostics.cpplint")
		local ruff_d = require("none-ls.diagnostics.ruff")
		local ruff_fmt = require("none-ls.formatting.ruff_format")

		-- ----- rustfmt (custom) if builtin is missing -----
		local methods = require("null-ls.methods")
		local helpers = require("null-ls.helpers")
		local rustfmt_source = formatting.rustfmt -- try builtin first (may be nil)
		if rustfmt_source == nil then
			rustfmt_source = {
				name = "rustfmt",
				method = methods.internal.FORMATTING,
				filetypes = { "rust" },
				generator = helpers.formatter_factory({
					command = "rustfmt",
					args = { "--emit=stdout" },
					to_stdin = true,
				}),
			}
		end

		-- Tools to have Mason install (null-ls uses these binaries)
		require("mason-null-ls").setup({
			ensure_installed = {
				-- JS/TS
				"prettierd",
				"prettier",
				"eslint_d",
				-- Lua
				"stylua",
				-- Shell / misc
				"shfmt",
				"shellcheck",
				"actionlint",
				"jsonlint",
				"yamllint",
				"markdownlint",
				"htmlhint",
				"checkmake",
				-- Python
				"ruff",
				"black",
				"mypy",
				"pylint",
				-- Java
				"google-java-format",
				-- C/C++
				"clang-format",
				"clang-tidy",
			},
			automatic_installation = true,
		})

		-- Build sources (single table, used below)
		local sources = {
			------------------------------------------------------------------------
			-- JavaScript / TypeScript
			------------------------------------------------------------------------
			formatting.prettierd.with({
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"json",
					"jsonc",
					"css",
					"scss",
					"less",
					"html",
					"markdown",
					"markdown.mdx",
					"yaml",
				},
			}),
			eslint_d_diag.with({
				condition = function(utils)
					return utils.root_has_file({
						".eslintrc",
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.json",
						"eslint.config.js",
						"eslint.config.mjs",
						"eslint.config.cjs",
					})
				end,
			}),
			eslint_d_actions.with({
				condition = function(utils)
					return utils.root_has_file({
						".eslintrc",
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.json",
						"eslint.config.js",
						"eslint.config.mjs",
						"eslint.config.cjs",
					})
				end,
			}),

			------------------------------------------------------------------------
			-- Python
			------------------------------------------------------------------------
			ruff_d.with({}),
			ruff_fmt,
			formatting.black.with({
				condition = function(utils)
					return not utils.root_has_file({ "pyproject.toml" })
				end,
			}),
			diagnostics.mypy,
			diagnostics.pylint,

			------------------------------------------------------------------------
			-- Rust
			------------------------------------------------------------------------
			rustfmt_source, -- custom-safe rustfmt

			------------------------------------------------------------------------
			-- Java
			------------------------------------------------------------------------
			formatting.google_java_format,

			------------------------------------------------------------------------
			-- C / C++
			------------------------------------------------------------------------
			formatting.clang_format,
			diagnostics.clang_check,
			diagnostics.clang_tidy,
			cpplint.with({ args = { "--filter=-legal/copyright", "$FILENAME" } }),

			------------------------------------------------------------------------
			-- Lua / Shell / Infra / Docs
			------------------------------------------------------------------------
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			diagnostics.shellcheck,
			diagnostics.actionlint,
			diagnostics.yamllint,
			diagnostics.markdownlint,
			diagnostics.jsonlint,
			diagnostics.checkmake,
			formatting.terraform_fmt,
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = sources, -- ← use the single table
			on_attach = function(client, bufnr)
				-- Only use null-ls for formatting to avoid conflicts with LSPs
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								async = false,
								timeout_ms = 2000,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})

		-- Diagnostic UI (your style)
		vim.diagnostic.config({
			virtual_text = { prefix = "●", spacing = 2, source = "always" },
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Hover float on hold
		vim.o.updatetime = 20000
		vim.cmd([[
      autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false, border = "rounded", source = "always" })
    ]])
	end,
}

