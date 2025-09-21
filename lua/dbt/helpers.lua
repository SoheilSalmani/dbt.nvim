local M = {}

local state = {
	preview = nil,
}

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
	-- Return existing preview window if it exists
	if state.preview then
		return state.preview
	end

	-- Create new preview window
	state.preview = {
		bufnr = vim.api.nvim_create_buf(false, true),
		winid = vim.api.nvim_get_current_win(),
	}
	vim.cmd("vsplit")
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = state.preview.bufnr })
	vim.api.nvim_set_option_value("filetype", "sql", { buf = state.preview.bufnr })
	vim.api.nvim_win_set_buf(state.preview.winid, state.preview.bufnr)

	-- Set autocmd to clear state.preview when the buffer is wiped out
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = state.preview.bufnr,
		callback = function()
			state.preview = nil
		end,
	})

	return state.preview
end

function M.run_dbt_command(args, config)
	local result = vim.system({ config.dbt_executable, unpack(args) }, { text = true }):wait()
	return result.stdout, result.stderr
end

return M
