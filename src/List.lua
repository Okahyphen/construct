local abs, floor, sort, unpack =
	math.abs, math.floor, table.sort, table.unpack or unpack

local function list_concat (left, right)
	return left:slice():push(right:unpack())
end

return require 'construct.Collection' : derive(function (fn, List)
	function fn:append (value)
		self.data[self:length() + 1] = List:nil_value_check(value)

		return self
	end

	function fn:push (...)
		local insert = self:length()
		local argv = { ... }

		for index = 1, #argv do
			insert = insert + 1
			self.data[insert] = List:nil_value_check(argv[index])
		end

		return self
	end

	function fn:pop ()
		local len = self:length()
		local value = self.data[len]

		self.data[len] = nil

		return value
	end

	function fn:prepend (value)
		for index = self:length() + 1, 2, -1 do
			self.data[index] = self.data[index - 1]
		end

		self.data[1] = List:nil_value_check(value)

		return self
	end

	function fn:shift ()
		local first = self.data[1]

		if first ~= nil then
			local len = self:length()

			for index = 1, len do
				self.data[index] = self.data[index + 1]
			end

			self.data[len] = nil
		end

		return self
	end

	function fn:unshift (...)
		local argv = { ... }
		local argc = #argv

		if argc ~= 0 then
			for index = self:length(), 1, -1 do
				self.data[index + argc] = self.data[index]
			end

			for index = 1, argc do
				self.data[index] = List:nil_value_check(argv[index])
			end
		end

		return self
	end

	function fn:map (operation)
		for index = 1, self:length() do
			self.data[index] = List:nil_value_check(operation(self.data[index], index))
		end

		return self
	end

	function fn:select (test)
		local list = List()

		for index = 1, self:length() do
			if test(self.data[index], index) then
				list:append(value)
			end
		end

		return list
	end

	function fn:reject (test)
		return self:select(function (...) return not test(...) end)
	end

	function fn:fill (value)
		List:nil_value_check(value)

		for index = 1, self:length() do
			self.data[index] = value
		end

		return self
	end

	function fn:pad (count, value)
		List:nil_value_check(value)

		if count ~= 0 then
			local values = {}

			for index = 1, abs(count) do
				values[index] = value
			end

			if count > 0 then
				self:push(unpack(values))
			else
				self:unshift(unpack(values))
			end
		end

		return self
	end

	function fn:slice (start, final)
		local len = self:length()

		start = start or 1
		final = final or len

		List:bounds_check(len, start, final)
		List:order_check(start, final)

		return List(self:unpack(start, final))
	end

	function fn:first (count)
		return self:slice(1, count)
	end

	function fn:last (count)
		return self:slice(self:length() + 1 - (count or 1))
	end

	function fn:reverse ()
		local index, offset = 1, self:length()
		local stop = floor(offset / 2)

		while index <= stop do
			self.data[index], self.data[offset] =
			self.data[offset], self.data[index]

			index = index + 1
			offset = offset - 1
		end

		return self
	end

	function fn:sort (comp)
		sort(self.data, comp)

		return self
	end

	return function (source, self, ...)
		source(self, ...)

		self.__concat = list_concat
	end
end)

