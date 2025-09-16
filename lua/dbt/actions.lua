local M = {}

local helpers = require("dbt.helpers")

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
	local preview_bufnr = helpers.create_preview_win().bufnr
	vim.api.nvim_buf_set_lines(
		preview_bufnr,
		0,
		-1,
		false,
		{ "select *", "from my_database.my_schema.my_table", "order by 1, 2, 3" }
	)
end

return M
