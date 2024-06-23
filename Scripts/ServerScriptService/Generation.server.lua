local star = {
    {2, 7}, {3, 6},
    {3, 7}, {3, 8},
    {4, 4}, {4, 5},
    {4, 6}, {4, 8},
    {4, 9}, {4, 10},
    {5, 4}, {5, 10},
    {6, 3}, {6, 4},
    {6, 10}, {6, 11},
    {7, 2}, {7, 3},
    {7, 11}, {7, 12},
    {8, 3}, {8, 4}, 
    {8, 10}, {8, 11},
    {9, 4}, {9, 10},
    {10, 4}, {10, 5},
    {10, 6}, {10, 8},
    {10, 9}, {10, 10},
    {11, 6}, {11, 7},
    {11, 8}, {12, 7}
}
local parts = Instance.new('Folder')
parts.Parent = workspace

local defaultMatrix = {}

function countNeighbours(x, z)
	local sum = 0
	for i = -1, 1 do
		for j = -1, 1 do
			local col = ((x + i + 13) % 13)
			local row = ((z + j + 13) % 13)
            -- this checks from the opposite 
			-- local col = ((x + i + 13) % 13)
			-- local row = ((z + j + 13) % 13)
            if not (defaultMatrix[col] == nil) then
                if not (defaultMatrix[col][row] == nil) then
                    sum += defaultMatrix[col][row]
                end
            end
		end
	end
	sum -= defaultMatrix[x][z]

	return sum
end

--[[

Any live cell with fewer than two live neighbours dies, as if by underpopulation.
Any live cell with two or three live neighbours lives on to the next generation.
Any live cell with more than three live neighbours dies, as if by overpopulation.
Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.


]]

function update()
	local nextGrid = {}
	for i = 1, 13 do
		nextGrid[i] = {}
		for j = 1, 13 do
			local neighbours = countNeighbours(i, j)
            -- print(neighbours)
			local state = defaultMatrix[i][j]
            
			if (state == 0 and neighbours == 3) then
				nextGrid[i][j] = 1
			elseif (state == 1 and (neighbours < 2 or neighbours > 3)) then
				nextGrid[i][j] = 0
			else
				nextGrid[i][j] = defaultMatrix[i][j]
			end
		end
	end
	defaultMatrix = nextGrid
end


function createPart(pos: Vector3)
    local p = Instance.new('Part')
    p.Parent = parts
    p.Size = Vector3.new(5,1,5)
    p.Anchored = true
    p.Position = pos * p.Size
end

function createMatrix()
    local m = {}
    for x = 1, 13 do 
        table.insert(m, {}) 
        for y = 1, 13 do 
            table.insert(m[x], 0)
        end
    end
    return m
end

defaultMatrix = createMatrix()

function fillMatrix(matrixForFill: {})
    for i, v in matrixForFill do
        defaultMatrix[v[1]][v[2]] = 1
    end
end

function spawnMatrix()
    for x = 1, 13 do 
        for z = 1, 13 do 
            if defaultMatrix[x][z] == 1 then
                createPart(Vector3.new(x, 5, z))
            end
        end
    end
end

function clearMatrix()
    parts:ClearAllChildren()
end

fillMatrix(star)

while true do
    spawnMatrix() 
    task.wait(3)
    clearMatrix()
    update()
end




-- for i = 1, 13 do
--     print(defaultMatrix[i])
-- end


