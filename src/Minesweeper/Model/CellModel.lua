local CellModel = {}
CellModel.__index = CellModel

local cloneTable = require(script.Parent.Parent.Utils.cloneTable)

function CellModel.new(initialState)
	local instance = initialState or {
		index = 0,
		isMine = false,
		isFlag = false,
		isRevealed = false,
		isPressed = false,
		numMines = 0,
	}
	setmetatable(instance, CellModel)

	return instance
end

function CellModel:clone()
	return CellModel.new(cloneTable(self))
end

function CellModel:setIndex(value)
	local newCell = self:clone()
	newCell.index = value
	return newCell
end

function CellModel:setMine(value)
	local newCell = self:clone()
	newCell.isMine = value
	return newCell
end

function CellModel:setFlag(value)
	local newCell = self:clone()
	newCell.isFlag = value
	return newCell
end

function CellModel:setPressed(value)
	local newCell = self:clone()
	newCell.isPressed = value
	return newCell
end

function CellModel:setRevealed(value)
	local newCell = self:clone()
	newCell.isRevealed = value
	return newCell
end

function CellModel:setNumMines(value)
	local newCell = self:clone()
	newCell.numMines = value
	return newCell
end

function CellModel:__eq(cell)
	return type(cell) == "table" and self.index == cell.index
end

return CellModel