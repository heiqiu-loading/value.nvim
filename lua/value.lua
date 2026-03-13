--- @class Value_Ui_CLASS
local private = {}

--- @class Value_Ui_FUN
local api = {}

private.state = 0
private.home = private.home or {}
private.keymap = private.keymap or require('value.unit.keymap')
private.stack = private.stack or require('value.object.stack')
private.cfgs = {}

api.setup = api.setup or function(cfgs)
    private.cfgs = cfgs
end

api.sync = api.sync or function()
	if ( vim.api.nvim_get_mode().mode == 'i' ) or vim.bo.modified then return end

	if private.state == 1 then
		vim.api.nvim_win_set_buf(private.home.winid, private.home.bufnr)
        private.update()
		return
	end

    local config = private.cfgs
	local opts = {
		null = private.keymap.opts(false, false, 0),
		ntim = private.keymap.opts(false, true, 0),
		rpce = private.keymap.opts(true, false, 0),
		rpnt = private.keymap.opts(true, true, 0),
	}

	private.state = 1
	private.home.winid = vim.api.nvim_get_current_win()
  	private.home.bufnr = vim.api.nvim_create_buf(false, true)
	private.home.keymap = {
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
  	vim.bo[private.home.bufnr].filetype = 'value.nvim'
    vim.bo[private.home.bufnr].buftype = ''

    vim.api.nvim_buf_set_name(private.home.bufnr, "value_undefined")
    vim.api.nvim_buf_set_var(private.home.bufnr, "Value", true)
  	vim.api.nvim_win_set_buf(private.home.winid, private.home.bufnr)
	private.stack.cal(type(config) == 'function' and config or function(data) return config end)
	private.update()
end

private.update = private.update or function()
	local _text = private.stack.get('text') or {}
	local _data = private.stack.get('data') or nil
    local modified = vim.bo[private.home.bufnr].modified

	vim.bo[private.home.bufnr].modifiable = true

	vim.api.nvim_buf_set_lines(private.home.bufnr, 0, -1, false, _text.display or {})

	vim.bo[private.home.bufnr].modified = modified
  	vim.bo[private.home.bufnr].modifiable = false
    vim.bo[private.home.bufnr].filetype = 'value.nvim'

    vim.api.nvim_buf_set_name(private.home.bufnr, "value_undefined")
	private.keymap.reset(private.home.bufnr)
    private.keymap.meap(private.home.keymap)

	if _data then
        if _data.filename then vim.api.nvim_buf_set_name(private.home.bufnr, _data.filename) end

        if _data.filetype then vim.bo[private.home.bufnr].filetype = _data.filetype end

        if _data.modifiable then vim.bo[private.home.bufnr].modifiable = _data.modifiable end

		if _data.keymap then private.keymap.meap(_data.keymap) end
	end
end


vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()

        if vim.api.nvim_buf_get_name(bufnr) == '' then
           require('value').sync()
           vim.api.nvim_buf_delete(bufnr, {})
        end
    end,
})

vim.api.nvim_create_user_command('Value', function()
	require('value').sync()
end, {})

return api
