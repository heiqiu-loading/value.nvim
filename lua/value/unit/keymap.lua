---@class Keymap_FUN
local keymap = {}

---@type fun(bufnr:integer)
keymap.reset = keymap.reset or function(bufnr)
	local modes = { 'n', 'i', 'v', 'x', 's', 'o', 'c', 't' }
	
    for _, mode in ipairs(modes) do
    	local map = vim.api.nvim_buf_get_keymap(bufnr, mode)
    
        for _, tb in ipairs(map) do
            vim.api.nvim_buf_del_keymap(bufnr, mode, tb.lhs)
        end
    end
end

-- remap, no wait, buffer
keymap.opts = keymap.opts or function(remap, nowait, buffer)
	return { noremap = not remap, nowait = nowait, buffer = buffer }
end

---@type fun(mode:string|string[], before:string, after:function|string, opts?:table)
keymap.map = keymap.map or function(m, b, a, o)
	vim.keymap.set(m, b, a, o)
end

---@class Mbarnu
---@field mode string|string[]
---@field before string
---@field after function|string
---@field opts table?
---@param m Mbarnu flat array of "mbarnu"
keymap.meap = keymap.meap or function(m)
    local len = #m / 4 - 1

    for i = 0, len do
        local j = i * 4

		vim.keymap.set(m[j + 1], m[j + 2], m[j + 3], m[j + 4])
	end
end

return keymap
