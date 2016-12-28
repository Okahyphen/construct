local error, rawset, tostring, type, unpack =
	error, rawset, tostring, type, table.unpack or unpack

local function iter (instance, index)
	index = index + 1

	local item = instance.data[index]

	if item ~= nil then
		return index, item
	end
end

local function iterate (instance)
	return iter, instance, 0
end

local function getwrap (inst)
	local fn = inst.__index

	return function (instance, index)
		if type(index) == 'number' then
			return instance:nth(index)
		else
			return fn[index]
		end
	end
end

local function set (instance, index, value)
	if type(index) == 'number' then
		instance:nth(index, value)
	else
		rawset(instance, index, value)
	end
end

return require 'base' : derive(function (fn, Collection)
	function Collection:from (...)
		return self(unpack(...))
	end

	function Collection:bounds_check (max, ...)
		local args = { ... }

		for i = 1, #args do
			local value = args[i]

			if value < 1 or value > max then
				error('Index out of bounds.', 0)
			end
		end
	end

	function Collection:order_check (start, final)
		if start > final then
			error('Starting index greater than ending index.', 0)
		end
	end

	function Collection:nil_index_check (index)
		if index == nil then
			error('Cannot access a nil index.', 0)
		end

		return index
	end

	function Collection:nil_value_check (value)
		if value == nil then
			error('Values in a collection cannot be nil.')
		end

		return value
	end

	function fn:length ()
		return #self.data
	end

	function fn:nth (index, value)
		Collection:bounds_check(self:length(), Collection:nil_index_check(index))

		if value == nil then
			return self.data[index]
		else
			self.data[index] = value
			return value
		end
	end

	function fn:each (operation)
		for index = 1, self:length() do
			operation(self.data[index], index)
		end

		return self
	end

	function fn:has (value, start, final)
		local len = self:length()

		if len == 0 then
			return false
		end

		local index = start or 1

		final = final or len

		Collection:order_check(index, final)
		Collection:bounds_check(len, index, final)

		while index <= final do
			if self.data[index] == value then
				return true
			end

			index = index + 1
		end

		return false
	end

	function fn:index (...)
		local argv = { ... }
		local argc = #argv

		if argc == 0 then
			Collection:nil_value_check(nil)
		elseif argc == 1 then
			local arg = argv[1]

			for index = 1, self:length() do
				if self.data[index] == arg then
					return index
				end
			end
		else
			local index = self:length() + 1
			local inverse, results = {}, argv

			while index > 1 do
				index = index - 1
				inverse[self.data[index]] = index
			end

			while index <= argc do
				results[index] = inverse[argv[index]]
				index = index + 1
			end

			return unpack(results)
		end
	end

	function fn:indices (target)
		local results = {}
		local insert = 1

		for index = 1, self:length() do
			if self.data[index] == target then
				results[insert] = index
				insert = insert + 1
			end
		end

		return unpack(results)
	end

	function fn:all (test)
		for index = 1, self:length() do
			if not test(self.data[index], index) then
				return false
			end
		end

		return true
	end

	function fn:any (test)
		for index = 1, self:length () do
			if test(self.data[index], index) then
				return true
			end
		end

		return false
	end

	function fn:reduce (operation, initial)
		local result = initial or self.data[1]
		local start = initial == nil and 0 or 1

		for index = 1, self:length() do
			result = operation(result, self.data[index], index)
		end

		return result
	end

	function fn:count (test)
		local result = 0

		for index = 1, self:length() do
			if test(self.data[index], index) then
			result = result + 1
			end
		end

		return result
	end

	function fn:join (separator)
		separator = separator ~= nil and tostring(separator) or ''

		local len = self:length()

		if len == 0 then
			return ''
		end

		local result = tostring(self.data[1])

		for index = 2, self:length() do
			result = result .. separator .. tostring(self.data[index])
		end

		return result
	end

	function fn:unpack (from, to)
		return unpack(self.data, from, to)
	end

	return function (self, ...)
		local data = { ... }

		for index = 1, #data do
			Collection:nil_value_check(data[index])
		end

		self.data = data
		self.__call = iterate
		self.__index = getwrap(self)
		self.__newindex = set
		self.__len = self.length
	end
end)
