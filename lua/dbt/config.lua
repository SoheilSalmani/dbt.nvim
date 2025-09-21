local M = {}

M.defaults = {
	dbt_executable = "dbt",
	compile_on_preview = true,
	select_current_only = true,
	auto_refresh_when_open = true,
	window = { width = 0.6, height = 0.7, border = "rounded" },
	profiles_dir = nil,
	target = nil,
	vars = nil,
}

local current = vim.deepcopy(M.defaults)

M.get = function()
	return current
end

function M.validate()
	vim.validate("dbt_executable", current.dbt_executable, "string")
	vim.validate("compile_on_preview", current.compile_on_preview, "boolean")
	vim.validate("select_current_only", current.select_current_only, "boolean")
	vim.validate("auto_refresh_when_open", current.auto_refresh_when_open, "boolean")
	vim.validate("window", current.window, "table")
	vim.validate("window.width", current.window.width, "number")
	vim.validate("window.height", current.window.height, "number")
	vim.validate("window.border", current.window.border, "string")
	vim.validate("profiles_dir", current.profiles_dir, "string", true)
	vim.validate("target", current.target, "string", true)
	vim.validate("vars", current.target, "table", true)
end

function M.update(partial)
	current = vim.tbl_deep_extend("force", current, partial or {})
end

return M
