local CellModel = {}
CellModel.__index = CellModel

local cloneTable = require(script.Parent.Parent.Utils.cloneTable)

function CellModel.new(initialState)
    local instance = initialState or {
        isMine = false,
        isFlag = false,
        isRevealed = false,
        numMines = 0,
    }
    setmetatable(instance, CellModel)

    return instance
end

function CellModel:clone()
    return CellModel.new(cloneTable(self))
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

return CellModel