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

			local cells = state.cells
			local index = action.cell.index
			local cell = cells:get(index)

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

			local cells = state.cells
			local index = action.cell.index
			local cell = cells:get(index)

			if newState.isNewGame then
				if cell.isMine then
					cell = cell:setMine(false)
					cells = cells:set(index, cell)

					local foundCell = false
					while not foundCell do
						local newIndex = math.random(cells:length())

						if newIndex ~= index then
							local newCell = cells:get(newIndex)

							if not newCell.isMine then
								newCell:setMine(true)
								cells = cells:set(newIndex, newCell)
								foundCell = true
							end
						end
					end
				end

				newState.cells = cells
				newState.isNewGame = false
			end

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

		PressCell = function(state, action)
			local newState = cloneTable(state)
			GameLogic.pressCells(newState, { action.cell }, true)
			return newState
		end,

		UnpressCell = function(state, action)
			local newState = cloneTable(state)
			GameLogic.pressCells(newState, { action.cell }, false)
			return newState
		end,

		PressCellAndNeighbors = function(state, action)
			local newState = cloneTable(state)
			local cell = action.cell
			local cells = GameLogic.getNeighbors(state, cell.index)
			table.insert(cells, cell)
			GameLogic.pressCells(newState, cells, true)
			return newState
		end,

		UnpressCellAndNeighbors = function(state, action)
			local newState = cloneTable(state)
			local cell = action.cell
			local cells = GameLogic.getNeighbors(state, cell.index)
			table.insert(cells, cell)
			GameLogic.pressCells(newState, cells, false)
			return newState
		end,
	}
)
