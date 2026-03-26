require("core.options")
require("core.keymaps")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
	-- 1. Kanagawa Theme (Keep this here if you want, or move to plugins/kanagawa.lua)
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
			require("kanagawa").setup({
				theme = "wave",
				transparent = false,
				dimInactive = false,
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},

	-- 2. Load all plugins from separate files
	require("plugins.neotree"), -- <--- RESTORE THIS LINE
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.autocompletion"),
	require("plugins.autoformatting"),
	require("plugins.gitsigns"),
	require("plugins.alpha"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.cursor"),
	require("plugins.trouble"),
	require("plugins.overseer"),
	require("plugins.hover"),
	require("plugins.numb"),
	require("plugins.leap"),
	require("plugins.aerial"),
	require("plugins.dap"),
	require("plugins.lspsaga"),
})

-- [[ Post-Load Configuration ]]
-- Enable inlay hints for the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end
	end,
})

local function create_cpp_class(name)
	local header = name .. ".h"
	local source = name .. ".cpp"

	-- Create Header file with include guards
	local header_content = {
		"#pragma once",
		"",
		"class " .. name .. " {",
		"public:",
		"    " .. name .. "();",
		"    ~" .. name .. "();",
		"};",
	}
	vim.fn.writefile(header_content, header)

	-- Create Source file with include
	local source_content = {
		'#include "' .. header .. '"',
		"",
		name .. "::" .. name .. "() {}",
		"",
		name .. "::~" .. name .. "() {}",
	}
	vim.fn.writefile(source_content, source)

	-- Open the header file to start working
	vim.cmd("edit " .. header)
end

-- Create a user command :NewClass <Name>
vim.api.nvim_create_user_command("NewClass", function(opts)
	create_cpp_class(opts.args)
end, { nargs = 1 })
