local M = {}

function M.find_project_root(start_path)
	local path = start_path
	local stat = vim.uv.fs_stat(path)
	if stat and stat.type == "file" then
		path = vim.fs.dirname(path)
	end
	local hit = vim.fs.find("dbt_project.yml", { upward = true, path = path })[1]
	if not hit then
		return nil, "could not find `dbt_project.yml` in any parent directory from " .. start_path
	end
	return vim.fs.dirname(vim.fs.abspath(hit))
end

function M.create_preview_win()
	local preview = {
		bufnr = vim.api.nvim_create_buf(false, true),
		winid = vim.api.nvim_get_current_win(),
	}
	vim.cmd("vsplit")
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = preview.bufnr })
	vim.api.nvim_set_option_value("filetype", "sql", { buf = preview.bufnr })
	vim.api.nvim_win_set_buf(preview.winid, preview.bufnr)
	return preview
end

return M
