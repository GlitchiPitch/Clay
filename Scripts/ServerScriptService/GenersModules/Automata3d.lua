
local parts = {}
local grid = {}

local dim = 20

local cols = dim
local rows = dim
local stacks = dim
local f = Instance.new('Folder', workspace)

function part(x, y, z)
	local p = script.Part:Clone()
	p.Parent = f
	p.Position = Vector3.new(x, y, z) * 2
	
	p.Transparency = .5
	
	return p
end

function countNeighbours(x, y, z)

	local sum = 0
	for i = -1, 1 do
		for j = -1, 1 do
			for k = -1, 1 do

				local col = ((x + i + cols) % cols) + 1
				local row = ((y + j + rows) % rows) + 1
				local stack = ((z + k + stacks) % stacks) + 1

				sum += grid[col][row][stack]
			end			
		end
	end

	sum -= grid[x][y][z]

	return sum
end

function setup()
	for i = 1, cols do
		parts[i] = {}
		grid[i] = {}
		for j = 1, rows do
			grid[i][j] = {}
			parts[i][j] = {}
			for k = 1, stacks do
				grid[i][j][k] = math.random(0, 1)
				parts[i][j][k] = part(i, j, k)
			end
		end
	end	
end

function draw()
	for i = 1, cols do
		for j = 1, rows do	
			for k = 1, stacks do
				local part: Part = parts[i][j][k]
				part.BrickColor = grid[i][j][k] == 0 and BrickColor.new('Gold') or BrickColor.new('Persimmon')
			end
		end
	end
end

function update()

	local nextGrid = {}

	for i = 1, cols do
		nextGrid[i] = {}
		for j = 1, rows do
			nextGrid[i][j] = {}
			for k = 1, stacks do
				local sum = 0
				local neighbours = countNeighbours(i, j, k)
								
				local state = grid[i][j][k]
				if (state == 0 and neighbours == 5) then
					nextGrid[i][j][k] = 1
				elseif (state == 1 and (neighbours < 4 or neighbours > 5)) then
					nextGrid[i][j][k] = 0
				else
					nextGrid[i][j][k] = grid[i][j][k]
				end
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