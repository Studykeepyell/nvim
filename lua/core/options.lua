vim.wo.number = true -- Make line numbers default (default: false)
vim.o.relativenumber = true -- Set relative numbered lines (default: false)
vim.o.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim. (default: '')
vim.o.wrap = false -- Display lines as one long line (default: true)
vim.o.linebreak = true -- Companion to wrap, don't split words (default: false)
vim.o.mouse = "a" -- Enable mouse mode (default: '')
vim.o.autoindent = true -- Copy indent from current line when starting new one (default: true)
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search (default: false)
vim.o.smartcase = true -- Smart case (default: false)
vim.o.shiftwidth = 4 -- The number of spaces inserted for each indentation (default: 8)
vim.o.tabstop = 4 -- Insert n spaces for a tab (default: 8)
vim.o.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations (default: 0)
vim.o.expandtab = true -- Convert tabs to spaces (default: false)
vim.o.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor (default: 0)
vim.o.sidescrolloff = 8 -- Minimal number of screen columns either side of cursor if wrap is `false` (default: 0)
vim.o.cursorline = false -- Highlight the current line (default: false)
vim.o.splitbelow = true -- Force all horizontal splits to go below current window (default: false)
vim.o.splitright = true -- Force all vertical splits to go to the right of current window (default: false)
vim.o.hlsearch = false -- Set highlight on search (default: true)
vim.o.showmode = false -- We don't need to see things like -- INSERT -- anymore (default: true)
vim.opt.termguicolors = true -- Set termguicolors to enable highlight groups (default: false)
vim.o.whichwrap = "bs<>[]hl" -- Which "horizontal" keys are allowed to travel to prev/next line (default: 'b,s')
vim.o.numberwidth = 4 -- Set number column width to 2 {default 4} (default: 4)
vim.o.swapfile = false -- Creates a swapfile (default: true)
vim.o.smartindent = true -- Make indenting smarter again (default: false)
vim.o.showtabline = 2 -- Always show tabs (default: 1)
vim.o.backspace = "indent,eol,start" -- Allow backspace on (default: 'indent,eol,start')
vim.o.pumheight = 10 -- Pop up menu height (default: 0)
vim.o.conceallevel = 0 -- So that `` is visible in markdown files (default: 1)
vim.wo.signcolumn = "yes" -- Keep signcolumn on by default (default: 'auto')
vim.o.fileencoding = "utf-8" -- The encoding written to a file (default: 'utf-8')
vim.o.cmdheight = 1 -- More space in the Neovim command line for displaying messages (default: 1)
vim.o.breakindent = true -- Enable break indent (default: false)
vim.o.updatetime = 250 -- Decrease update time (default: 4000)
vim.o.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
vim.o.backup = false -- Creates a backup file (default: false)
vim.o.writebackup = false -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.o.undofile = true -- Save undo history (default: false)
vim.o.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience (default: 'menu,preview')
vim.opt.shortmess:append("c") -- Don't give |ins-completion-menu| messages (default: does not include 'c')
vim.opt.iskeyword:append("-") -- Hyphenated words recognized by searches (default: does not include '-')
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)

-- 1) Make sure line numbers & cursorline are on
vim.opt.number = true
vim.opt.cursorline = true

-- 2) Force-override CursorLineNr on every ColorScheme load
vim.api.nvim_create_augroup("UserHighlight", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = "UserHighlight",
	callback = function()
		-- GUI (guifg) and terminal (ctermfg) both set
		vim.api.nvim_set_hl(0, "CursorLineNr", {
			fg = "#5ef2ff", -- GUI foreground
			ctermfg = 223, -- terminal fg (223 ≈ light yellow)
			bold = true,
			bg = nil,
			ctermbg = nil,
		})
	end,
})

-- 3) Trigger it now (in case colorscheme already loaded)
vim.cmd("doautocmd ColorScheme")

-- after your `vim.o.mouse = "a"` and opts definition

local function scroll_fix(dir)
	-- dir = "up" or "down"
	local win = 0
	local cur = vim.api.nvim_win_get_cursor(win)
	if dir == "up" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-y>", true, false, true), "n", false)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
	end
	-- restore original cursor position
	vim.api.nvim_win_set_cursor(win, cur)
end

-- Normal & Visual:
vim.keymap.set({ "n", "v" }, "<ScrollWheelUp>", function()
	scroll_fix("up")
end, { silent = true })
vim.keymap.set({ "n", "v" }, "<ScrollWheelDown>", function()
	scroll_fix("down")
end, { silent = true })

-- Insert mode: use <C-o> to drop into Normal for one command
vim.keymap.set("i", "<ScrollWheelUp>", function()
	vim.cmd([[exec "normal! \<C-o>"]])
	scroll_fix("up")
end, { silent = true })
vim.keymap.set("i", "<ScrollWheelDown>", function()
	vim.cmd([[exec "normal! \<C-o>"]])
	scroll_fix("down")
end, { silent = true })

vim.api.nvim_set_hl(0, "AlphaHeaderRed", { fg = "#ff5555" })
vim.api.nvim_set_hl(0, "AlphaHeaderOrange", { fg = "#ffb86c" })
vim.api.nvim_set_hl(0, "AlphaHeaderYellow", { fg = "#f1fa8c" })
vim.api.nvim_set_hl(0, "AlphaHeaderGreen", { fg = "#50fa7b" })
vim.api.nvim_set_hl(0, "AlphaHeaderBlue", { fg = "#8be9fd" })
vim.api.nvim_set_hl(0, "AlphaHeaderPurple", { fg = "#bd93f9" })
vim.api.nvim_set_hl(0, "AlphaHeaderCyan", { fg = "#00ffff" })
