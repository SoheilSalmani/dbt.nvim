local M = {}

local helpers = require("dbt.helpers")
local config = require("dbt.config").get()

function M.print_project_root()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("dbt.nvim: buffer has no name", vim.log.levels.WARN)
		return
	end

	local root, err = helpers.find_project_root(file)
	if not root then
		vim.notify("dbt.nvim: " .. err, vim.log.levels.ERROR)
	else
		print("dbt project root: " .. root)
	end
end

function M.show_compiled_sql()
	local current_bufnr = vim.api.nvim_get_current_buf()
	local sql = table.concat(vim.api.nvim_buf_get_lines(current_bufnr, 0, -1, false), "\n")

	local code, stdout, stderr = helpers.run_dbt_command({ "compile", "--quiet", "--inline", sql }, config)
	if code ~= 0 then
		vim.notify(stderr, vim.log.levels.ERROR)
		return
	end

	local preview_bufnr = helpers.create_preview_win().bufnr
	vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, vim.split(stdout, "\n", { trimempty = true }))
end

return M
