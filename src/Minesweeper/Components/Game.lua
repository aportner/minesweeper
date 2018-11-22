local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local Actions = require(script.Parent.Parent.Actions)
local Cell = require(script.Parent.Cell)

local GameLogic = require(script.Parent.Parent.GameLogic)

local Game = Roact.Component:extend("Game")

function Game:didMount()
	UserInputService.InputBegan:connect(
		function(inputObject)
			if inputObject.keyCode == Enum.KeyCode.N then
				self.props.onNewGame()
			end
		end
	)
end

function Game:getChildren()
	local cells = self.props.cells
	local width = self.props.width
	local gameOver = self.props.gameOver
	local onFlagCell = self.props.onFlagCell
	local onRevealCell = self.props.onRevealCell
	local onDoubleRevealCell = self.props.onDoubleRevealCell

	local children = {}

	cells:forEach(
		function(cell, index)
			local x, y = GameLogic.getCoords(width, index)
			children["Cell" .. index] = Roact.createElement(
				Cell,
				{
					cell = cell,
					x = x,
					y = y,
					yOffset = 50,
					onFlagCell = onFlagCell,
					onRevealCell = onRevealCell,
					onDoubleRevealCell = onDoubleRevealCell,
					gameOver = gameOver,
				}
			)
		end
	)

	return children
end

function Game:render()
	return Roact.createElement(
		"Frame",
		{
			BackgroundColor3 = Color3.new(0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
		},
		self:getChildren()
	)
end

Game = RoactRodux.UNSTABLE_connect2(
	function(state)
        return {
			height = state.minesweeperReducer.height,
			width = state.minesweeperReducer.width,
			cells = state.minesweeperReducer.cells,
			gameOver = state.minesweeperReducer.gameOver,
		}
    end,
    function(dispatch)
		return {
			onDoubleRevealCell = function(cell)
				dispatch(Actions.DoubleRevealCell(cell))
			end,
			onNewGame = function(cell)
				dispatch(Actions.NewGame(cell))
			end,
			onFlagCell = function(cell)
				dispatch(Actions.FlagCell(cell))
			end,
			onRevealCell = function(cell)
				dispatch(Actions.RevealCell(cell))
			end,
        }
    end
)(Game)

return Game