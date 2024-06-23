
local parts = {}
local grid = {}

local cols = 100
local rows = 100
local f = Instance.new('Folder', workspace)

function part(x, z)
	local p = script.Part:Clone()
	p.Parent = f
	p.Position = Vector3.new(x, 5, z)
	return p
end

function countNeighbours(x, z)

	local sum = 0
	for i = -1, 1 do
		for j = -1, 1 do	

			local col = ((x + i + cols) % cols) + 1
			local row = ((z + j + rows) % rows) + 1
						
			sum += grid[col][row]
		end
	end

	sum -= grid[x][z]

	return sum
end

function setup()
	for i = 1, cols do
		parts[i] = {}
		grid[i] = {}
		for j = 1, rows do
			grid[i][j] = math.random(0, 1)
			parts[i][j] = part(i, j)
		end
	end	
end

function draw()

	--print(grid)

	for i = 1, cols do
		for j = 1, rows do			
			local part: Part = parts[i][j]
			part.BrickColor = grid[i][j] == 0 and BrickColor.new('Gold') or BrickColor.new('Persimmon')
		end
	end
end

function update()

	local nextGrid = {}

	for i = 1, cols do
		nextGrid[i] = {}
		for j = 1, rows do
			local sum = 0
			local neighbours = countNeighbours(i, j)
			local state = grid[i][j]
			if (state == 0 and neighbours == 3) then
				nextGrid[i][j] = 1
			elseif (state == 1 and (neighbours < 2 or neighbours > 3)) then
				nextGrid[i][j] = 0
			else
				nextGrid[i][j] = grid[i][j]
			end



		end
	end

	grid = nextGrid
end

setup()

while wait(1) do
	draw()
	update()
end