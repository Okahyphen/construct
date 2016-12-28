local next, List = next, require 'construct.List'

return require 'base' : derive(function (fn)
	function fn:get (key)
		return self.data[key]
	end

	function fn:has (key)
		return self.data[key] ~= nil
	end

	function fn:set (key, value)
		if not self:has(key) then
			self._size = self._size + 1
		end

		if value == nil then
			self._size = self._size - 1
		end

		self.data[key] = value
	end

	function fn:delete (key)
		self:set(key, nil)
	end

	function fn:size ()
		return self._size
	end

	function fn:each (operation)
		for key, value in next, self.data do
			operation(key, value)
		end

		return self
	end

	function fn:each_key (operation)
		for key in next, self.data do
			operation(key)
		end
	end

	function fn:each_value (operation)
		for _, value in next, self.data do
			operation(value)
		end
	end

	function fn:all (test)
		for key, value in next, self.data do
			if not test(value, key) then
				return false
			end
		end

		return true
	end

	function fn:any (test)
		for key, value in next, self.data do
			if test(value, key) then
				return true
			end
		end

		return false
	end

	function fn:has_key (search)
		return self:any(function (_, key)
			return key == search
		end)
	end

	function fn:has_value (search)
		return self:any(function (value)
			return value == search
		end)
	end

	function fn:key (search)
		for key, value in next, self.data do
			if value == search then
				return key
			end
		end
	end

	function fn:keys ()
		local list = List()

		for key in next, self.data do
			list:append(key)
		end

		return list
	end

	function fn:values ()
		local list = List()

		for _, value in next, self.data do
			list:append(value)
		end

		return list
	end

	function fn:invert ()
		local map = Map()

		for key, value in next, self.data do
			map:set(value, key)
		end

		return map
	end

	return function (self, ...)
		self.data = {}
		self._size = 0

		for _, pair in next, { ... } do
			self:set(pair[1], pair[2])
		end
	end
end)

