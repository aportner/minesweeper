local GameLogic = {}
GameLogic.__index = GameLogic

function GameLogic.getCoords(width, index)
	index = index - 1

	return index % width, math.floor(index / width)
end

function GameLogic.getCell(state, x, y)
	local width = state.width
	local height = state.height

	if x < 0 or x >= width or y < 0 or y >= height then
		return nil
	end

	return state.cells:get(1 + y * width + x)
end

function GameLogic.getNeighbors(state, index)
	local neighbors = {}
	local x, y = GameLogic.getCoords(state.width, index)

	for yOffset = -1, 1 do
		for xOffset = -1, 1 do
			local cell = GameLogic.getCell(state, x + xOffset, y + yOffset)
			if (yOffset ~= 0 or xOffset ~= 0) and cell ~= nil then
				table.insert(neighbors, cell)
			end
		end
	end

	return neighbors
end

function GameLogic.reveal(state, queue)
	local count = 0
	while #queue > 0 do
		count = count + 1
		if count > state.width * state.height then
			error('Infinite loop in reveal')
			return
		end

		local cell = queue[1]
		table.remove(queue, 1)

		local cellIndex = state.cells:indexOf(cell)
		local neighbors = GameLogic.getNeighbors(state, cellIndex)
		local mines = 0

		for _, neighbor in ipairs(neighbors) do
			if not neighbor.isRevealed and neighbor.isMine then
				mines = mines + 1
			end
		end

		cell = cell:setRevealed(true)
		state.cells = state.cells:set(cellIndex, cell)

		if mines > 0 then
			cell = cell:setNumMines(mines)
			state.cells = state.cells:set(cellIndex, cell)
		else
			for _, neighbor in ipairs(neighbors) do
				if not neighbor.isRevealed then
					table.insert(queue, neighbor)
				end
			end
		end
	end
end

function GameLogic.doubleReveal(state, cell)
	if not cell.isRevealed or cell.numMines == 0 then
		return
	end

	local index = state.cells:indexOf(cell)
	local neighbors = GameLogic.getNeighbors(state, index)
	local mines = 0
	local lose = false

	for _, neighbor in ipairs(neighbors) do
		if neighbor.isFlag then
			mines = mines + 1
		end
		lose = lose or neighbor.isFlag ~= neighbor.isMine
	end

	if mines ~= cell.numMines then
		return
	end

	if lose then
		for _, neighbor in ipairs(neighbors) do
			if neighbor.isFlag ~= neighbor.isMine then
				local neighborIndex = state.cells:indexOf(neighbor)
				neighbor = neighbor:setRevealed(true)
				state.cells = state.cells:set(neighborIndex, neighbor)
			end
		end
		state.gameOver = true
	else
		local queue = {}
		for _, neighbor in ipairs(neighbors) do
			if not neighbor.isFlag and not neighbor.isRevealed then
				table.insert(queue, neighbor)
			end
		end

		GameLogic.reveal(state, queue)
	end
end

return GameLogic