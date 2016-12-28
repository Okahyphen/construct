local setmetatable = setmetatable

return require 'construct.Map' : derive(function ()
	return function (source, self, mode)
		source(self)

		self.meta = { __mode = mode or 'k' }

		setmetatable(self.data, self.meta)
	end
end)
