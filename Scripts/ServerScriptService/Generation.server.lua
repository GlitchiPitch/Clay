local star = { -- 13 size
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

local star2 = { -- size 10
    {2, 4}, {2, 5}, 
    {2, 6}, {2, 7}, 
    {3, 4}, {3, 7}, 
    {4, 2}, {4, 3}, 
    {4, 4}, {4, 7}, 
    {4, 8}, {4, 9}, 
    {5, 2}, {5, 9}, 
    {6, 2}, {6, 9}, 
    {7, 2}, {7, 3}, 
    {7, 4}, {7, 7}, 
    {7, 8}, {7, 9}, 
    {8, 4}, {8, 7}, 
    {9, 4}, {9, 5}, 
    {9, 6}, {9, 7},
}

local frenchKiss = { -- size 10, 9
    {1, 8}, {1, 9}, 
    {2, 8}, {3, 5}, 
    {3, 6}, {3, 8}, 
    {4, 4}, {4, 7}, 
    {5, 4}, {5, 5}, 
    {6, 5}, {6, 6}, 
    {7, 3}, {7, 6}, 
    {8, 2}, {8, 4}, 
    {8, 5}, {9, 2}, 
    {10, 1}, {10, 2},
}

local s = { -- size 8
    {1, 4}, {1, 5}, 
    {2, 3}, {2, 6}, 
    {3, 2}, {3, 7}, 
    {4, 1}, {4, 8}, 
    {5, 1}, {5, 8}, 
    {6, 2}, {6, 7}, 
    {7, 3}, {7, 6}, 
    {8, 4}, {8, 5},
}

-- можно брать мин\макс значение по координатам из таблицы и использовать это для циклов

local matrixWidth = 8
local matrixHeight = 8

local parts = Instance.new('Folder')
parts.Parent = workspace

local defaultMatrix = {}

function countNeighbours(x, z)
	local sum = 0
	for i = -1, 1 do
		for j = -1, 1 do
			local col = x + i
			local row = z + j
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

function update()
	local nextGrid = {}
	for i = 1, matrixWidth do
		nextGrid[i] = {}
		for j = 1, matrixHeight do
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
    for x = 1, matrixWidth do 
        table.insert(m, {}) 
        for z = 1, matrixHeight do 
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
    for x = 1, matrixWidth do 
        for z = 1, matrixHeight do 
            if defaultMatrix[x][z] == 1 then
                createPart(Vector3.new(x, 5, z))
            end
        end
    end
end

function clearMatrix()
    parts:ClearAllChildren()
end

fillMatrix(s)

while true do
    spawnMatrix() 
    task.wait(3)
    clearMatrix()
    update()
end




-- for i = 1, 13 do
--     print(defaultMatrix[i])
-- end


