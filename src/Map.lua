local next = next

local List = require 'construct.List'

local Map = require('base'):derive(function (_, self, ...)
	self.data = {}
	self._size = 0

	for _, pair in next, { ... } do
		self:set(pair[1], pair[2])
	end
end)

function Map.fn:get (key)
	return self.data[key]
end

function Map.fn:has (key)
	return self.data[key] ~= nil
end

function Map.fn:set (key, value)
	if not self:has(key) then
		self._size = self._size + 1
	end

	if value == nil then
		self._size = self._size - 1
	end

	self.data[key] = value
end

function Map.fn:delete (key)
	self:set(key, nil)
end

function Map.fn:size ()
	return self._size
end

function Map.fn:each (operation)
	for key, value in next, self.data do
		operation(key, value)
	end

	return self
end

function Map.fn:each_key (operation)
	for key in next, self.data do
		operation(key)
	end
end

function Map.fn:each_value (operation)
	for _, value in next, self.data do
		operation(value)
	end
end

function Map.fn:all (test)
	for key, value in next, self.data do
		if not test(value, key) then
			return false
		end
	end

	return true
end

function Map.fn:any (test)
	for key, value in next, self.data do
		if test(value, key) then
			return false
		end
	end

	return false
end

function Map.fn:has_key (search)
	return self:any(function (_, key)
		return key == search
	end)
end

function Map.fn:has_value (search)
	return self:any(function (value)
		return value == search
	end)
end

function Map.fn:key (search)
	for key, value in next, self.data do
		if value == search then
			return key
		end
	end
end

function Map.fn:keys ()
	local list = List()

	for key in next, self.data do
		list:append(key)
	end

	return list
end

function Map.fn:values ()
	local list = List()

	for _, value in next, self.data do
		list:append(value)
	end

	return list
end

function Map.fn:invert ()
	local map = Map()

	for key, value in next, self.data do
		map:set(value, key)
	end

	return map
end

return Map
