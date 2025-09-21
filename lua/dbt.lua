local M = {
	actions = require("dbt.actions"),
	config = require("dbt.config"),
	helpers = require("dbt.helpers"),
}

function M.setup(config)
	M.config.update(config)
	M.config.validate()
	vim.keymap.set("n", "<leader>dr", M.actions.print_project_root, { desc = "dbt.nvim: Print dbt project root" })
	vim.keymap.set("n", "<leader>ds", M.actions.show_compiled_sql, { desc = "dbt.nvim: Show compiled SQL" })
end

return M
