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
	local result = vim.system({ config.dbt_executable, unpack(args) }):wait()
	return result.code, result.stdout, result.stderr
end

function M.multi_select(items, opts, on_finish)
	opts = opts or {}
	local selected = {}

	opts.format_item = function(item)
		if selected[item] then
			return item .. " (selected)"
		else
			return item
		end
	end

	local function step()
		vim.ui.select(items, opts, function(choice)
			if not choice then
				local results = {}
				for item, is_selected in pairs(selected) do
					if is_selected then
						table.insert(results, item)
					end
				end

				on_finish(results)
				return
			end

			selected[choice] = not selected[choice]
			step()
		end)
	end

	step()
end

return M
