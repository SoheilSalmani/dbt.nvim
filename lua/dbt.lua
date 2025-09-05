local M = {
	config = require("dbt.config"),
}

function M.setup(config)
	local merged_config = M.config.merge_with_defaults(config)
	config.validate(merged_config)
end

return M
