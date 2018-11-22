local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local Rodux = require(ReplicatedStorage.Rodux)
local Game = require(script.Components.Game)
local Reducers = require(script.Reducers)

local module = {}


function module.Run()
	local store = Rodux.Store.new(
		Reducers,
		nil,
		{
--	    	Rodux.loggerMiddleware,
		}
	)

	local localPlayer = Players.LocalPlayer
	localPlayer:WaitForChild("PlayerGui")

	local app = Roact.createElement(
		RoactRodux.StoreProvider,
		{
			store = store,
		},
		{
			ScreenGui = Roact.createElement(
				"ScreenGui",
				{
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				},
				{
					Game = Roact.createElement(Game, {}),
				}
			),
		}
	)

	Roact.mount(app, Players.LocalPlayer.PlayerGui)
end


return module
