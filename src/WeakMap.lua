local setmetatable = setmetatable

local WeakMap = require('construct.Map'):derive(function (source, self, mode)
	source(self)

	self.meta = { __mode = mode or 'k' }

	setmetatable(self.data, self.meta)
end)

return WeakMap
