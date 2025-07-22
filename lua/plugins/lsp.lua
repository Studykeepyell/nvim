-- Neovim LSP Configuration without cpplint
return {
	-- Make Lua configuration aware of Neovim API
	{
		"folke/neodev.nvim",
		opts = {},
	},

	-- null-ls for formatting & diagnostics, no cpplint
{
  "nvimtools/none-ls.nvim",  -- ← NEW name
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
      },
    })
  end,
},


	-- Core LSP configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"j-hui/fidget.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Attach autocommands for LSP keymaps and highlights
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
					map("gr", require("telescope.builtin").lsp_references, "Find References")
					map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
					map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local hl_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd(
							{ "CursorHold", "CursorHoldI" },
							{ buffer = event.buf, group = hl_group, callback = vim.lsp.buf.document_highlight }
						)
						vim.api.nvim_create_autocmd(
							{ "CursorMoved", "CursorMovedI" },
							{ buffer = event.buf, group = hl_group, callback = vim.lsp.buf.clear_references }
						)
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(ev)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev.buf })
							end,
						})
					end
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			-- Enhance capabilities with nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Define language servers
			local servers = {
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--completion-style=detailed",
						"--header-insertion=iwyu",
					},
					capabilities = { documentFormattingProvider = false, documentRangeFormattingProvider = false },
					init_options = { clangdFileStatus = true },
				},
				tsserver = {
					capabilities = { documentFormattingProvider = false, documentRangeFormattingProvider = false },
				},
				ruff = {},
				pylsp = {
					settings = {
						pylsp = {
							plugins = {
								pyflakes = { enabled = false },
								pycodestyle = { enabled = false },
								autopep8 = { enabled = false },
								yapf = { enabled = false },
								mccabe = { enabled = false },
								pylsp_mypy = { enabled = false },
								pylsp_black = { enabled = false },
								pylsp_isort = { enabled = false },
							},
						},
					},
				},
				html = { filetypes = { "html", "twig", "hbs" } },
				cssls = {},
				tailwindcss = {},
				dockerls = {},
				sqlls = {},
				terraformls = {},
				jsonls = {},
				yamlls = {},
				lua_ls = {
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
							diagnostics = { globals = { "vim" }, disable = { "undefined-global" } },
							format = { enable = false },
						},
					},
				},
			}

			-- Ensure Mason and install tools
			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"clang-format",
					"stylua",
					"typescript-language-server",
				},
			})

			-- Setup Mason LSPConfig: only configure installed servers, omit auto-install to avoid invalid entries
			require("mason-lspconfig").setup({
				handlers = {
					function(name)
						local cfg = servers[name] or {}
						cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
						require("lspconfig")[name].setup(cfg)
					end,
				},
			})
		end,
	},
}
