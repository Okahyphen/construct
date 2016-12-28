local error = error

return require 'base' : derive(function (fn, DataSet)
	function DataSet:nil_item_check (item, position)
		if item == nil then
			error('Item cannot be nil. Item position: ' .. (position or '-'), 0)
		end

		return item
	end

	function fn:size ()
		return #self.data
	end

	return function (self, ...)
		self.data = { ... }

		for index = 1, self:size() do
			DataSet:nil_item_check(self.data[index], index)
		end
	end
end)
