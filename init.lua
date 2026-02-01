local items = nil

if items then return items end

items = {}
items.stack = require('heiqiu.mod.dashboard.object.stack')
items.unit = require('heiqiu.mod.dashboard.object.unit'):sync(items.stack)


function items:getContents()
  	local positions = {}
  	local executes = {}
  	local lines = {}
  	local data = self.stack:gsr('text')
  	
  	for i, item in ipairs(data) do
  		if item.pos then
  			positions[#lines + item.pos] = i
  		end
  		
  		if item.exec then
  			executes[i] = item.exec
  		end
  	
  		if item.text then
  			vim.list_extend(lines, item.text)
  		end
  	end

  	return lines, positions, executes
end

function items:keys()
	local fun_keys = require('heiqiu.fun.keys')
	local map = require 'heiqiu.config.vim.mappings'

	fun_keys:reset(map)

    fun_keys:meap { self.stack:gsr('data').keymap, map }
    
    fun_keys:settlement(map)
end

function items:new(config)
	if ( vim.api.nvim_get_mode().mode == 'i' ) or not vim.bo.modifiable then return end
	if vim.bo.modified then return end
	
	local fun_keys = require('heiqiu.fun.keys')
	local stack = self.stack:gsr()
	local header = stack.head
	local default = {}
	local opts = {
		null = fun_keys:opts(false, false, 0),
		ntim = fun_keys:opts(false, true, 0),
		rpce = fun_keys:opts(true, false, 0),
		rpnt = fun_keys:opts(true, true, 0),
	}
	
	default.data = {}
	default.data.keymap = {}
	
    default.data.keymap[1] = { 	
    	'n', 'q', function()
    		if not self.stack:ret() then
    			vim.api.nvim_buf_delete(self.stack:gsr('head').bufnr, {})
    			vim.cmd.exit()
    		else
    			self:sync()
    		end
    	end, opts.ntim
	}
		
	default.data.keymap[2] = { 
		'n', 'e', function()
			local data = self.stack:gsr('data')
			local i = data.position[vim.api.nvim_win_get_cursor(0)[1]]
  			
    		if i then 
    			self.stack:cal(data.execute[i])
    			self:sync()
    		end
		end, opts.null
	}
		
    default.data.keymap[3] = { 'n', 'd', '', opts.ntim }
	
	self.stack:gsr(nil, vim.tbl_deep_extend("force", stack, default, config or {}))
	
	
	
	header.winid = vim.api.nvim_get_current_win()
  	header.bufnr = vim.api.nvim_create_buf(true, false)
  	
  	vim.bo[header.bufnr].filetype = header.name
  	vim.api.nvim_win_set_buf(header.winid, header.bufnr)
end

function items:sync()
	local stack = self.stack:gsr()

  	stack.data.display, stack.data.position, stack.data.execute = self:getContents()
	self.unit:draw(stack.data.display)
	self:keys()
end

return items
