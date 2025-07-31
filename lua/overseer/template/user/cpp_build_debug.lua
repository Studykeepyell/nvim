return {
	name = "cpp_build_debug",
	builder = function()
		local file = vim.fn.expand("%:p")
		local dir = vim.fn.expand("%:p:h")
		local base = vim.fn.expand("%:t:r")
		return {
			cmd = {
				"bash",
				"-c",
				-- build only, with symbols, no run
				string.format("cd %s && g++ %s -std=c++23 -g -O0 -o %s", dir, file, base),
			},
			cwd = dir,
			components = { "default" },
		}
	end,
	condition = { filetype = { "cpp" } },
}
