local Queue = require('construct.DataSet'):derive(function (source, self, ...)
	source(self, ...)
end)

function Queue.fn:enqueue (item)
	self.data[self:size() + 1] = Queue:nil_item_check(item, 1)
end

function Queue.fn:dequeue ()
	local item = self.data[1]

	if item ~= nil then
		for index = 1, self:size() do
			self.data[index] = self.data[index + 1]
		end
	end

	return item
end

return Queue
