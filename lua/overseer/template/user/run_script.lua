-- ~/n.config/nvim/lua/overseer/template/user/run_script.lua
return {
	name = "run script",
	builder = function()
		local file = vim.fn.expand("%:p")
		local dir = vim.fn.expand("%:p:h")
		local base = vim.fn.expand("%:t:r")
		local ft = vim.bo.filetype
		local cmd

		if ft == "go" then
			cmd = { "go", "run", file }
		elseif ft == "python" then
			cmd = { "python3", file }
		elseif ft == "sh" then
			cmd = { file }
		elseif ft == "cpp" or ft == "c" or ft == "hpp" then
			cmd = {
				"bash",
				"-c",
				("cd %s && g++ %s -std=c++23 -O2 -I/usr/include -L/usr/lib -lsfml-graphics -lsfml-window -lsfml-system -o %s && ./%s")
					:format(
						dir,
						file,
						base,
						base
					),
			}
		elseif ft == "java" then
			cmd = {
				"bash",
				"-c",
				("cd %s && javac %s.java && java %s"):format(dir, base, base),
			}
		elseif ft == "typescript" or ft == "ts" then
			cmd = { "ts-node", file }
		else
			cmd = { file }
		end

		return {
			cmd = cmd,
			cwd = dir,
			components = {
				-- and execution log live.
				{
					"open_output",
					direction = "vertical",
					on_start = "always",
					focus = false,
				},
				"on_result_diagnostics",
				"default",
			},
		}
	end,
	condition = {
		filetype = {
			"sh",
			"python",
			"go",
			"c",
			"cpp",
			"hpp",
			"java",
			"typescript",
			"ts",
		},
	},
}
