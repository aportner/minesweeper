local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)

local PATH = 'rbxasset://textures/minesweeper.png'

local Cell = Roact.Component:extend("Cell")

Cell.SIZE = 16
Cell.LEFT_MARGIN = 2
Cell.TOP_MARGIN = 53
Cell.MARGIN = 1

function Cell.getSprite(x, y)
	return Vector2.new(
		Cell.LEFT_MARGIN + (Cell.SIZE + Cell.MARGIN) * (x - 1),
		Cell.TOP_MARGIN + (Cell.SIZE + Cell.MARGIN) * (y - 1)
	)
end

function Cell:init()
	self.buttonRef = Roact.createRef()

	self.boundOnInputBegan = function(rbx, inputObject)
		self:onInputBegan(rbx, inputObject)
	end
	self.boundOnInputEnded = function(rbx, inputObject)
		self:onInputEnded(rbx, inputObject)
	end
end

function Cell:didMount()
	self.state = {}
end

function Cell:onInputBegan(_, inputObject)
	if self.props.gameOver then
		return
	end

	if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and
		inputObject.UserInputType ~= Enum.UserInputType.MouseButton2 then
		return
	end

	self:setState({
		[inputObject.UserInputType] = true,
	})

	local cell = self.props.cell

	if inputObject.UserInputType == Enum.UserInputType.MouseButton1
		and not cell.isFlag then
		self.props.onPressCell(cell)
	end

	if self.state[Enum.UserInputType.MouseButton1] and
		self.state[Enum.UserInputType.MouseButton2] then
		self:setState({
			double = true,
		})
		self.props.onPressCellAndNeighbors(cell)
	end
end

function Cell:onInputEnded(_, inputObject)
	if self.props.gameOver then
		return
	end

	if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and
		inputObject.UserInputType ~= Enum.UserInputType.MouseButton2 then
		return
	end

	self:setState({
		[inputObject.UserInputType] = false,
	})

	local rbx = self.buttonRef.current
	local position = inputObject.Position
	local rbxPosition = rbx.AbsolutePosition
	local rbxSize = rbx.AbsoluteSize
	local cell = self.props.cell

	if position.X >= rbxPosition.X and position.Y >= rbxPosition.Y
		and position.X < rbxPosition.X + rbxSize.X
		and position.Y < rbxPosition.Y + rbxSize.Y then

		if self.state['double'] then
			self:onDoubleClick()
		elseif inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			if not self.props.cell.isRevealed then
				self:onLeftClick()
			end
		elseif inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
			if not self.props.cell.isRevealed then
				self:onRightClick()
			end
		end
	end

	if self.state['double'] then
		self:setState({ double = false })
	end

	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		self.props.onUnpressCell( cell )
	end
end

function Cell:onDoubleClick()
	local cell = self.props.cell

	self:setState({ double = false })

	if not self.props.cell.isFlag then
		self.props.onDoubleRevealCell(cell)
	end
	self.props.onUnpressCellAndNeighbors(cell)
end

function Cell:onLeftClick()
	if not self.props.cell.isFlag then
		self.props.onRevealCell(self.props.cell)
	end
end

function Cell:onRightClick()
	self.props.onFlagCell(self.props.cell)
end

function Cell:getImageRectOffset()
	local cell = self.props.cell

	if cell.isRevealed then
		if cell.isMine then
			return self.getSprite(7, 1)
		elseif cell.numMines > 0 then
			return self.getSprite(cell.numMines, 2)
		end

		return self.getSprite(2, 1)
	else
		if self.props.gameOver and cell.isMine then
			return self.getSprite(6, 1)
		elseif cell.isFlag then
			return self.getSprite(3, 1)
		elseif cell.isPressed then
			return self.getSprite(2, 1)
		end
	end

	return self.getSprite(1, 1)
end

function Cell:render()
	-- local cell = self.props.cell
	local x = self.props.x
	local y = self.props.y

	local xOffset = Cell.SIZE * x
	local yOffset = Cell.SIZE * y

	return Roact.createElement(
		"ImageButton",
		{
			BackgroundTransparency = 1,
			Image = PATH,
			ImageRectOffset = self:getImageRectOffset(),
			ImageRectSize = Vector2.new(Cell.SIZE, Cell.SIZE),
			-- Selected = isSelected,
			Position = UDim2.new(0, xOffset, 0, yOffset + self.props.yOffset),
			Size = UDim2.new(0, Cell.SIZE, 0, Cell.SIZE),
			[Roact.Event.InputBegan] = self.boundOnInputBegan,
			[Roact.Event.InputEnded] = self.boundOnInputEnded,
			[Roact.Ref] = self.buttonRef,
		}
	)
end

return Cell

