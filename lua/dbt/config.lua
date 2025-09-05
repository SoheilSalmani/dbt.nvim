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

function M.validate(config)
	vim.validate("dbt_executable", config.dbt_executable, "string")
	vim.validate("compile_on_preview", config.compile_on_preview, "boolean")
	vim.validate("select_current_only", config.select_current_only, "boolean")
	vim.validate("auto_refresh_when_open", config.auto_refresh_when_open, "boolean")
	vim.validate("window", config.window, "table")
	vim.validate("window.width", config.window.width, "number")
	vim.validate("window.height", config.window.height, "number")
	vim.validate("window.border", config.window.border, "string")
	vim.validate("profiles_dir", config.profiles_dir, "string", true)
	vim.validate("target", config.target, "string", true)
	vim.validate("vars", config.target, "table", true)
end

function M.merge_with_defaults(config)
	-- TODO: Check whether `defaults` is mutated
	return vim.tbl_deep_extend("force", M.defaults, config or {})
end

return M
