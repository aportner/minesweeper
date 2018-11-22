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
}
