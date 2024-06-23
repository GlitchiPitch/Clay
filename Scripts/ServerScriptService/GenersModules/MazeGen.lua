local plate = workspace.ad -- пол лабиринта

local mazeSize = plate.Size.X // 50
local cellSize = 50

local maze = Instance.new("Model")
local a = (cellSize/2 - .5)
local startPos = Vector3.new(plate.Position.X - plate.Size.X / 2, plate.Position.Y, plate.Position.Z - plate.Size.Z / 2)

function makePart(cell, pos, size)
	
	local out1 = Instance.new("Part")
	out1.Position = pos	
	out1.Anchored = true
	out1.Size = size
	out1.Parent = cell
	
end

function MakeCell(x, z, walls)
	
	local cell = Instance.new("Model")
	
	local a_ = Vector3.new((x * cellSize) - cellSize / 2, cellSize / 2, (z * cellSize) - cellSize / 2) + startPos
	local aa_ = Vector3.new(cellSize - 2, cellSize, 1) -- размер стены
	local bb_ = Vector3.new(1, cellSize, cellSize - 2) -- размер стены
	
	local pp = { -- это столбы
		Vector3.new(a, 0, -a),
		Vector3.new(a, 0, a),
		Vector3.new(-a, 0, a),
		Vector3.new(-a, 0, -a),
	}
	
	local p = { -- это стены позиция и размер 
		{Vector3.new(a, 0, 0), bb_},
		{Vector3.new(0, 0, a), aa_},
		{Vector3.new(-a, 0, 0), bb_},
		{Vector3.new(0, 0, -a), aa_},
	}
	
	for _, pos in pp do makePart(cell, a_ + pos, Vector3.new(1, cellSize, 1)) end
	
	for i, wall in walls do
		if wall then makePart(cell, a_ + p[i][1], p[i][2]) end
	end
	
	cell.Parent = maze
end 

function Check(A, B)
	for i, v in pairs(A) do
		if B[i] ~= v then return false end
	end
	return true
end

function RmvWall(CellA, CellB)
	local x = {}
	
	if CellB[CellA[1]][CellA[2]+1] then
		table.insert(x, {CellB[CellA[1]][CellA[2]+1], 2})
	end
	if CellB[CellA[1]][CellA[2]-1] then
		table.insert(x, {CellB[CellA[1]][CellA[2]-1], 4})
	end
	if CellB[CellA[1]+1] then
		table.insert(x, {CellB[CellA[1]+1][CellA[2]], 1})
	end
	if CellB[CellA[1]-1] then
		table.insert(x, {CellB[CellA[1]-1][CellA[2]], 3})
	end
	
	local AI = 0
	for i = 1, #x do
		if not Check(x[i - AI][1][2], {true, true, true, true}) then
			table.remove(x, i - AI)
			AI += 1
		end
	end
	return x
end


function createCells()

	local cells = {}
	local cellStack = {}
	local cCell = {1, mazeSize}


	for i = 1, mazeSize do
		cells[i] = {}
		for a = 1, mazeSize do 
			cells[i][a] = {{i,a}, {true, true, true, true}}
		end
	end 
	
	return cells, cellStack, cCell
end

function MakeMaze()
	
	local cells, cellStack, cCell = createCells()
	local CellsDone = 1
	
	while CellsDone < mazeSize ^ 2 do
		
		local neighbors = RmvWall(cCell, cells)
		
		if #neighbors > 0 then
			
			local chosenWall = neighbors[math.random(1, #neighbors)]
			local direcDeleting = chosenWall[2]
			
			cells[cCell[1]][cCell[2]][2][direcDeleting] = false
			
			direcDeleting = direcDeleting + 2
			
			if direcDeleting > 4 then direcDeleting = direcDeleting - 4 end
			
			cells[chosenWall[1][1][1]][chosenWall[1][1][2]][2][direcDeleting] = false
			
			table.insert(cellStack, cCell)
			
			cCell = cells[chosenWall[1][1][1]][chosenWall[1][1][2]][1]
			
			CellsDone += 1
		else
			cCell = cellStack[#cellStack]
			table.remove(cellStack, #cellStack)
		end
	end
		
	--cells[mazeSize][mazeSize][2][1] = false -- если нужен выход то вот это раскоменть
	--cells[1][1][2][3] = false -- если нужен вход то вот это
	
	
	for x = 1, #cells do 
		for z = 1, #cells[x] do 
			--wait()
			MakeCell(x, z, cells[x][z][2])
		end 
	end 
end 

maze.Parent = workspace

MakeMaze()
