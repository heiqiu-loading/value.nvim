local items = {}

items.keymap = {}

function items.keymap:reset()
	local modes = { 'n', 'i', 'v', 'x', 's', 'o', 'c', 't' }
	local header = self.stack:gsr('head')
	
    for _, mode in ipairs(modes) do
    	local map = vim.api.nvim_buf_get_keymap(header.bufnr, mode)
    
        for _, tb in ipairs(map) do
            vim.api.nvim_buf_del_keymap(header.bufnr, mode, tb.lhs)
        end
    end
end

-- remap, no wait, buffer
function items.keymap:opts(remap, nowait, buffer)
	return { noremap = not remap, nowait = nowait, buffer = buffer }
end

-- mode, key, do, opts
function items.keymap:meap(pMkdrnb)
    for _, mkdrnb in ipairs(pMkdrnb) do
    	for _, key in ipairs(mkdrnb) do
			vim.keymap.set(key[1], key[2], key[3], key[4])
		end
    end
end

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
