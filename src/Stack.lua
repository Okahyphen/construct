local unpack, List =
	table.unpack or unpack, require 'construct.List'

return require 'construct.DataSet' : derive(function (fn, Stack)
	function fn:push (...)
		local items = { ... }
		local insert = self:size()

		for index = 1, #items do
			insert = insert + 1
			self.data[insert] = Stack:nil_item_check(items[index], index)
		end
	end

	function fn:pop (count)
		local size = self:size()

		if size == 0 then
			return
		end

		if not count then
			local item = self.data[size]

			self.data[size] = nil

			return item
		end

		local items = {}

		for index = size, size - (count - 1), -1 do
			local item = self.data[index]

			if item == nil then
				break
			end

			items[#items + 1] = item
			self.data[index] = nil
		end

		return unpack(items)
	end

	return function (source, self, ...)
		source(self, ...)
	end
end)
