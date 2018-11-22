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
	self.mouseState = {}
end

function Cell:onInputBegan(_, inputObject)
	if self.props.gameOver then
		return
	end

	if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and
		inputObject.UserInputType ~= Enum.UserInputType.MouseButton2 then
		return
	end

	self.mouseState[inputObject.UserInputType] = true

	local cell = self.props.cell

	if inputObject.UserInputType == Enum.UserInputType.MouseButton1
		and not cell.isFlag then
		self:setState({
			isPressed = true,
		})
	end

	if self.mouseState[Enum.UserInputType.MouseButton1] and
		self.mouseState[Enum.UserInputType.MouseButton2] then
		print("DOUBLE ON")
		self.mouseState['double'] = true
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

	print('ended', inputObject.UserInputType)

	self.mouseState[inputObject.UserInputType] = false

	local rbx = self.buttonRef.current
	local position = inputObject.Position
	local rbxPosition = rbx.AbsolutePosition
	local rbxSize = rbx.AbsoluteSize

	print('position', position)

	if position.X >= rbxPosition.X and position.Y >= rbxPosition.Y
		and position.X < rbxPosition.X + rbxSize.X
		and position.Y < rbxPosition.Y + rbxSize.Y then

		print('click on ', rbx)

		if self.mouseState['double'] then
			self.mouseState['double'] = false
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

	if self.mouseState['double'] and
		not self.mouseState[Enum.UserInputType.MouseButton1] and
		not self.mouseState[Enum.UserInputType.MouseButton2] then
		print("DOUBLE OFF")
		self.mouseState['double'] = false
	end

	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		spawn(
			function()
				self:setState({isPressed = false})
			end
		)
	end
end

function Cell:onDoubleClick()
	if not self.props.cell.isFlag then
		self.props.onDoubleRevealCell(self.props.cell)
	end
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
		elseif self.state.isPressed then
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

