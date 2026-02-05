--- @class Value_Ui_CLASS
local private = {}

--- @class Value_Ui_FUN
local api = {}

private.state = 0
private.home = private.home or {}
private.keymap = private.keymap or require('value.unit.keymap')
private.stack = private.stack or require('value.object.stack')

api.sync = api.sync or function(configer)
	if private.state == 1 then return end
	if ( vim.api.nvim_get_mode().mode == 'i' ) or vim.bo.modified then return end

	local opts = {
		null = private.keymap.opts(false, false, 0),
		ntim = private.keymap.opts(false, true, 0),
		rpce = private.keymap.opts(true, false, 0),
		rpnt = private.keymap.opts(true, true, 0),
	}

	private.state = 1
	private.home.main = configer or private.home.main
	private.home.winid = vim.api.nvim_get_current_win()
  	private.home.bufnr = vim.api.nvim_create_buf(false, true)
	private.home.keymap = private.home.keymap or {
		'n', 'q', function ()
			if private.stack.len() <= 1 then
				private.state = -1

    			vim.api.nvim_buf_delete(private.home.bufnr, {})

    			vim.cmd.exit()
			else
				private.stack.ret()
    			private.update()
    		end
		end, opts.null,

		'n', 'e', function ()
			local _text = private.stack.get('text')
			local i = _text.position[vim.api.nvim_win_get_cursor(0)[1]]

    		if i then
    			private.stack.cal(_text.execute[i])
    			private.update()
    		end
		end, opts.null,
	
		'n', 'd', '', opts.ntim
	}

	vim.bo[private.home.bufnr].modifiable = false
  	vim.bo[private.home.bufnr].filetype = 'value_dashboard'

  	vim.api.nvim_win_set_buf(private.home.winid, private.home.bufnr)
	private.stack.cal(configer)
	private.update()
end

private.update = private.update or function()
	local _text = private.stack.get('text') or {}
	local _data = private.stack.get('data') or nil

	vim.bo[private.home.bufnr].modifiable = true

	vim.api.nvim_buf_set_lines(private.home.bufnr, 0, -1, false, _text.display or {})

	vim.bo[private.home.bufnr].modified = false
  	vim.bo[private.home.bufnr].modifiable = false

	private.keymap.reset(private.home.bufnr)
    private.keymap.meap(private.home.keymap)

	if _data and _data.keymap then
		private.keymap.meap(private.stack.get('data').keymap)
	end
end

return api
