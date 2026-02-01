local items = {
	stack = {{
		head = {
			name = 'ui_dashboard',
			winid = 0,
			bufnr = 0,
			modifiable = false
		},
		text = {
			--[[ {
				text = {
			
				},
				hitbox = {
			
				}
			} --]]
		},
		data = {
			position = {},
			execute = {},
			display = {},
			keymap = {}
		}
	}}
}

function items:len()
	return #self.stack
end

function items:rmv()
	self.stack[self:len()] = nil
	
	return true
end

function items:gsr(i, s, r)
	local stack = self.stack[self:len()]
	local ns = s ~= nil
	
	if i then
		if r then
			stack[i] = nil
		
			return true
		end
	
		if ns then
			stack[i] = s
		
			return s
		end
	
		return stack[i]
	end
	
	if ns then
		self.stack[self:len()] = s
		
		return s
	end
	
	if r then
		self.stack[self:len()] = nil
		
		return true
	end
	
	return stack
end



function items:cal(fun)
	if not fun then return false end

    vim.notify('[value.dashboard.stack] calling', vim.log.levels.INFO)
    
	table.insert(self.stack, vim.tbl_deep_extend("force", self:gsr(), fun(self:gsr())))
	
	return true
end

function items:jpb(index)
	if not index or index <= 0 or index >= self:len() then return false end
	
    vim.notify('[value.dashboard.stack] jumping', vim.log.levels.INFO)
	
	while self:len() > index do
		self:gsr(nil, nil, true)
	end
	
	return true
end

function items:ret()
	if self:len() <= 1 then return false end

	vim.notify('[value.dashboard.stack] returning', vim.log.levels.INFO)

    self:gsr(nil, nil, true)
    
    return true
end

return items
