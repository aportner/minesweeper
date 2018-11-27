return {
	NewGame = function()
		return {
			type = 'NewGame'
		}
	end,

	FlagCell = function(cell)
		return {
			type = 'FlagCell',
			cell = cell,
		}
	end,

	DoubleRevealCell = function(cell)
		return {
			type = 'DoubleRevealCell',
			cell = cell,
		}
	end,

	RevealCell = function(cell)
		return {
			type = 'RevealCell',
			cell = cell,
		}
	end,

	PressCell = function(cell)
		return {
			type = 'PressCell',
			cell = cell,
		}
	end,

	UnpressCell = function(cell)
		return {
			type = 'UnpressCell',
			cell = cell,
		}
	end,

	PressCellAndNeighbors = function(cell)
		return {
			type = 'PressCellAndNeighbors',
			cell = cell,
		}
	end,

	UnpressCellAndNeighbors = function(cell)
		return {
			type = 'UnpressCellAndNeighbors',
			cell = cell,
		}
	end,
}
