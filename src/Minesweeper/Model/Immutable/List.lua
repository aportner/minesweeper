local List = {}
List.__index = List

local function clone(tbl)
    local newTable = {}

    for index, value in ipairs(tbl) do
        newTable[index] = value
    end

    return newTable
end

function List.new(initialState)
	local instance = {
        list = initialState or {}
	}

	setmetatable(instance, List)
	return instance
end

function List:clear()
    return self.new()
end

function List:clone()
    return self.new(clone(self.list))
end

function List:concat(list)
    local newList = self:clone()
    local concatList = list

    if self.isList(list) then
        concatList = list.list
    end

    for _, value in ipairs(concatList) do
        table.insert(newList.list, value)
    end

    return newList
end

function List:first()
    return self.list[1]
end

function List:forEach(fn)
    for index, value in ipairs(self.list) do
        fn(value, index)
    end
end


function List:get(index)
    return self.list[index]
end

function List:has(item)
    return self:indexOf(item) > 0
end

function List:indexOf(item)
    for index, value in ipairs(self.list) do
        if item == value then
            return index
        end
    end

    return 0
end

function List.isList(list)
    while true do
        if type(list) ~= "table" then
            return false
        end

        if list.__index == List then
            return true
        end

        list = getmetatable(list.__index)
    end
end

function List:last()
    return self.list[#self.list]
end

function List:length()
    return #self.list
end

function List:map(fn)
    local newList = {}

    for index, value in ipairs(self.list) do
        newList[index] = fn(value, index)
    end

    return self.new(newList)
end

function List:pop()
    return self.list[#self.list], self:slice(1, #self.list - 1)
end

function List:push(value)
    local newList = self:clone()

    table.insert(newList.list, value)

    return newList
end

function List:set(index, value)
    local newList = self:clone()

    newList.list[index] = value

    return newList
end

function List:shift()
	local value = self.list[1]
	local newList = self:slice(2)

	return value, newList
end

function List:shuffle()
	local shuffled = {}

	for index, value in ipairs(self.list) do
		table.insert(shuffled, math.random(index), value)
	end

	return self.new(shuffled)
end

function List:slice(first, last, step)
    local sliced = {}

    for i = first or 1, last or #self.list, step or 1 do
        sliced[#sliced + 1] = self.list[i]
    end

    return self.new(sliced)
end

function List:split(point)
	local valuesBefore = {}
	local valuesAfter = {}

	for index, value in ipairs(self.list) do
		if index < point then
			table.insert(valuesBefore, value)
		else
			table.insert(valuesAfter, value)
		end
	end

	return self.new(valuesBefore), self.new(valuesAfter)
end

function List:toTable()
    return clone(self.list)
end

return List