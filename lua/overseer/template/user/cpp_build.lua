-- ~/.config/nvim/lua/overseer/template/user/cpp_build.lua
return {
	name = "cpp_run", -- a simple name without spaces
	builder = function()
		local file = vim.fn.expand("%:p")
		local dir = vim.fn.expand("%:p:h")
		local base = vim.fn.expand("%:t:r")
		return {
			-- compile and then run:
			cmd = {
				"bash",
				"-c",
				string.format("cd %s && g++ %s -std=c++23 -O2 -o %s && ./%s", dir, file, base, base),
			},
			cwd = dir,
			components = {
				{
					"open_output",
					direction = "vertical",
					on_start = "always",
					focus = false,
				},
				"default",
			},
		}
	end,
	condition = { filetype = { "cpp" } },
}
