local Model = script.Parent.Parent.Parent.Model
local Immutable = Model.Immutable
local List = require(Immutable.List)
local CellModel = require(Model.CellModel)

return function(height, width, mines)
	height = height or 16
	width = width or 30
	mines = mines or 99

	local mineTable = {}
	for i = 1, width * height do
		local mine = CellModel.new()
		if i <= mines then
			mine = mine:setMine(true)
		end
		mineTable[i] = mine
	end

	return {
		width = width,
		height = height,
		mines = mines,
		cells = List.new(mineTable):shuffle()
	}
end