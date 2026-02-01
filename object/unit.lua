local items = {}

function items:draw(texts)
	local header = self.stack:gsr('head')
 	local bufnr = header.bufnr
	
	vim.bo[bufnr].modifiable = true

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, texts)
  	
  	vim.bo[bufnr].modified = false
  	vim.bo[bufnr].modifiable = header.modifiable
end

function items:sync(stack)
	self.stack = stack
	return self
end

return items
