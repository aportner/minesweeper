local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Rodux)

local minesweeperReducer = require(script.MinesweeperReducer)

return Rodux.combineReducers({
	minesweeperReducer = minesweeperReducer,
})
