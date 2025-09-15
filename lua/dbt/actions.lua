local M = {}

function M.print_project_root()
	local helpers = require("dbt.helpers")

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

return M
