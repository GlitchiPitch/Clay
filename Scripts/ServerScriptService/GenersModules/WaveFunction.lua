local Temps = workspace.Temps

local tiles = {}
local grid = {}
local dim = 2

local width = 100
local height = 100

local BLANK = 0
local UP = 1
local RIGHT = 2
local DOWN = 3
local LEFT = 4

local rules = {
	[BLANK] = {  
		{BLANK, UP},
		{BLANK, RIGHT},
		{BLANK, DOWN}, 
		{BLANK, LEFT},
	},
	
	[UP] = { 
		{RIGHT, LEFT, DOWN},
		{LEFT, UP, DOWN},
		{BLANK, DOWN},
		{RIGHT, UP, DOWN},
	},
	
	[RIGHT] = { 
		{RIGHT, LEFT, DOWN},
		{LEFT, UP, DOWN},
		{RIGHT, LEFT, UP},
		{BLANK, LEFT},
	},
	
	[DOWN] = { 
		{BLANK, UP},
		{LEFT, UP, DOWN},
		{RIGHT, LEFT, UP},
		{RIGHT, UP, DOWN},
	},
	
	[LEFT] = { 
		{RIGHT, LEFT, DOWN},
		{BLANK, RIGHT},
		{RIGHT, LEFT, UP},
		{UP, DOWN, RIGHT},
	},
}

function cell_(index: number, pos: Vector3)
	
	local c: Model = tiles[index]:Clone()
	c.Parent = workspace
	c:PivotTo(CFrame.new(pos.X, pos.Y, pos.Z))
end

function splice(tbl, start, deleteCount, ...)
	for i = 0, deleteCount do table.remove(tbl, start) end
end

function filter(tbl)
	
	local upd = {}
	local updIndex = 0
	
	for i = 0, #tbl do
		if not tbl[i].collapsed then
			upd[updIndex] = tbl[i]
			updIndex += 1
		end
	end
	
	return upd

end

function checkValid(options, valid)	
	for i = -(#options - 1), 0 do
		if not valid[options[math.abs(i)]] then
			table.remove(options, 1)
		end
	end
end

function preload()
	tiles[BLANK] = Temps.Blank
	tiles[UP] = Temps.Up
	tiles[RIGHT] = Temps.Right
	tiles[DOWN] = Temps.Down
	tiles[LEFT] = Temps.Left
end

function setup()
	for i = 0, (dim ^ 2) - 1 do
		grid[i] = {
			collapsed = false,
			options = {BLANK, UP, RIGHT, DOWN, LEFT}
		}
	end	

end

function draw()

	-- pick cell with least entropy
	
	local gridCopy = table.clone(grid)
	
	gridCopy = filter(gridCopy)
	
	table.sort(gridCopy, function(a, b)
		return #a.options - #b.options
	end)
		
	local len = #gridCopy[0].options 
	local stopIndex = 1
	
	for i = 1, #gridCopy do
		if (#gridCopy[i].options > len) then
			stopIndex = i
			break
		end
	end
	
	print('-------------')
	
	
	if (stopIndex > 0) then splice(gridCopy, stopIndex, #gridCopy - stopIndex) end
		
	local cell = gridCopy[#gridCopy]
	cell.collapsed = true
	
	local pick = cell.options[math.random(#cell.options)]
	cell.options = {pick}
	
	local w = width / dim
	local h = height / dim
	
	for j = 0, dim - 1 do
		for i = 0, dim - 1 do						
			local cell = grid[i + j * dim]
			
			if cell.collapsed then
				local index = cell.options[1]
				cell_(index, Vector3.new(i * w, 5, j * h))
			--else
				
			end
		end
	end
	
	local nextGrid = {}
	
	for j = 0, dim - 1 do
		for i = 0, dim - 1 do						
			local index = i + j * dim
			if (grid[index].collapsed) then
				nextGrid[index] = grid[index]
			else
				local options = {BLANK, UP, RIGHT, DOWN, LEFT}
				
				if (j > 0) then
					local up = grid[i + (j - 1) * dim]
					local validOptions = {}
					for i, option in up.options do
						local valid = rules[option][3]
						validOptions = {table.unpack(validOptions), table.unpack(valid)}						
					end
					
					checkValid(options, validOptions)
				end
				
				if (i < dim - 1) then
					local right = grid[i + 1 + j * dim]
					local validOptions = {}
					for i, option in right.options do
						local valid = rules[option][4]
						validOptions = {table.unpack(validOptions), table.unpack(valid)}
					end
					
					checkValid(options, validOptions)
				end
				
				if (j < dim - 1) then
					local down = grid[i + (j + 1) * dim]
					local validOptions = {}
					for i, option in down.options do
						local valid = rules[option][1]
						validOptions = {table.unpack(validOptions), table.unpack(valid)}
					end
					
					checkValid(options, validOptions)
				end
				
				if (i > 0) then
					local left = grid[i - 1 + j * dim]
					local validOptions = {}
					for i, option in left.options do
						local valid = rules[option][2]
						validOptions = {table.unpack(validOptions), table.unpack(valid)}
					end
					
					checkValid(options, validOptions)
				end
				
				nextGrid[index] = {
					options = options,
					collapsed = false,
				}

			end
		end
	end
	
	grid = nextGrid
	
end

preload()
setup()

draw()

wait(1)

draw()

wait(1)

draw()


wait(1)

draw()