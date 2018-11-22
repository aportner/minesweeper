local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Rodux)

local GameLogic = require(script.Parent.Parent.GameLogic)
local cloneTable = require(script.Parent.Parent.Utils.cloneTable)
local newGame = require(script.newGame)

return Rodux.createReducer(
	newGame(),
	{
		NewGame = function()
			return newGame()
		end,

		FlagCell = function(state, action)
			local newState = cloneTable(state)

			local cell = action.cell
			local cells = state.cells
			local index = cells:indexOf(cell)

			newState.cells = cells:set(
				index,
				cell:setFlag(
					(not cell.isFlag)
				)
			)

			return newState
		end,

		RevealCell = function(state, action)
			local newState = cloneTable(state)

			local cell = action.cell
			local cells = state.cells
			local index = cells:indexOf(cell)

			cell = cell:setRevealed(true)
			newState.cells = cells:set(index, cell)
			if not cell.isMine then
				GameLogic.reveal(newState, { cell })
			end

			newState.gameOver = newState.gameOver or cell.isMine

			return newState
		end,

		DoubleRevealCell = function(state, action)
			local newState = cloneTable(state)

			local cell = action.cell
			GameLogic.doubleReveal(newState, cell)

			return newState
		end,
	}
)
