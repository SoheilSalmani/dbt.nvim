local M = {
	actions = require("dbt.actions"),
	config = require("dbt.config"),
	helpers = require("dbt.helpers"),
}

function M.setup(config)
	local merged_config = M.config.merge_with_defaults(config)
	M.config.validate(merged_config)
	vim.keymap.set("n", "<leader>dr", M.actions.print_project_root, { desc = "dbt.nvim: Print dbt project root" })
end

return M
