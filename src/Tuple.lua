local error, setmetatable = error, setmetatable

local Collection = require 'construct.Collection'

local store = setmetatable({}, { __mode = 'k' })

local hidden = {
	__index = function (proxy, index)
		local real = store[proxy]

		Collection:nil_index_check(index)
		Collection:bounds_check(#real, index)

		return real[index]
	end,
	__len = function (proxy)
		return #store[proxy]
	end,
	__newindex = function ()
		error('Cannot assign to an immutable tuple.', 0)
	end,
	__metatable = false
}

return Collection:derive(function (fn, Tuple)
	function Tuple.fn:nth (index)
		Collection:nil_index_check(index)
		Collection:bounds_check(self:length(), index)

		return self.data[index]
	end

	return function (source, self, ...)
		source(self, ...)

		local proxy = {}

		store[proxy] = self.data

		self.data = setmetatable(proxy, hidden)
	end
end)
