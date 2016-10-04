local error, require =
	error, require

local valid = {
	Collection = true,
	DataSet = true,
	List = true,
	Map = true,
	Queue = true,
	Stack = true,
	Tuple = true,
	WeakMap = true
}

return setmetatable({}, {
	__metatable = false,
	__index = function (libs, key)
		if not valid[key] then
			error(("`construct' library does not contain %q"):format(key), 0)
		end

		local lib = require('construct.' .. key)

		libs[key] = lib

		return lib
	end
})
