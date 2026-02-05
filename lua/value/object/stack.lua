--- @class Value_Stack_CLASS
--- @field text table<any>
--- @field data table<any>

--- @type Value_Stack_CLASS[]
local private = {}

--- @class Value_Stack_FUN
local api = {}

---@type fun():integer
api.len = api.len or function()
	return #private
end

---@type fun(label?:string, table?:table):Value_Stack_CLASS|any
api.get = api.get or function(l, t)
	t = t or private[#private]

	return not l and t or t[l]
end

---@type fun(label:string|integer|nil, v:any, table?:table, insert?:boolean)
api.mov = api.mov or function(l, v, i)
	if i then
		table.insert(private[#private][l], v)
	else
		private[#private][l] = v
	end
end

---@type fun(function:fun(stack:Value_Stack_CLASS)):boolean
api.cal = api.cal or function(f)
	if not f then return false end

	local r = f(private[#private])

	if r then
		table.insert(private, vim.tbl_deep_extend("force", private[#private] or { text = {}, data = {} }, r))
	end
	return true
end

---@type fun():boolean
api.ret = api.ret or function()
	if #private <= 1 then return false end

    private[#private] = nil

    return true
end

---@type fun(index:integer):boolean
api.jpb = api.jpb or function(i)
	if not i or i <= 0 then return false end

	while #private > i do
		private[#private] = nil
	end
	
	return true
end

return api
