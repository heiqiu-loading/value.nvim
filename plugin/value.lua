local items = {}

items.value = require("value")

vim.api.nvim_create_user_command('Dashboard', function()
	require('value').sync()
end, {})

return items
