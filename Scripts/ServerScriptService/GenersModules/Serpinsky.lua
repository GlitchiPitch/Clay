
local points
local current
local percent = .5 -- .9 -- CIRCULES, .5 -- STANDART, .75 - RING
local previous

local ax, ay
local bx, by
local cx, cy

local x, y

local width = 100
local height = 100

local y_ = 5

local frameCount = 0

local f = Instance.new('Folder', workspace)


function lerp(a, b, t) return a + t * (b - a) end

function fromAngle(angle) return Vector3.new(math.cos(angle), 0, math.sin(angle)) end

function part(pos, color: BrickColor)
	local p = script.Part:Clone()
	p.Parent = f
	p.Position = pos
	p.BrickColor = color
end

function setup()
	ax = width / 2 --math.random(width)
	ay = 0 --math.random(height)
	bx = 0 --math.random(width)
	by = height --math.random(height)
	cx = width --math.random(width)
	cy = height --math.random(height)

	x = math.random(width)
	y = math.random(height)

	part(Vector3.new(ax, 5, ay), BrickColor.new('Really red'))
	part(Vector3.new(bx, 5, by), BrickColor.new('Really red'))
	part(Vector3.new(cx, 5, cy), BrickColor.new('Really red'))

end

function setup_()
	points = {}
	for i = 1, 3 do
		table.insert(points, Vector3.new(math.random(width), y_, math.random(height)))
	end

	reset()
end

function setup_2()
	points = {}

	local n = 15
	for i = 1, n do
		local angle = i * (math.pi * 2) / n
		table.insert(points, fromAngle(angle) * width / 2)
	end

	reset()

end

function reset()


	current = Vector3.new(math.random(width), y_, math.random(height))

	for i, p in points do
		part(p, BrickColor.new('Really red'))
	end
end

function draw()

	local r = math.random(3)
	local color

	if (r == 1) then
		color = BrickColor.new('Gold')		
		x = lerp(x, ax, .5)
		y = lerp(y, ay, .5)

	elseif (r == 2) then
		color = BrickColor.new('Camo')
		x = lerp(x, bx, .5)
		y = lerp(y, by, .5)

	elseif (r == 3) then
		color = BrickColor.new('Cyan')
		x = lerp(x, cx, .5)
		y = lerp(y, cy, .5)

	end
	part(Vector3.new(x, 5, y), color)
end

function draw_()

	--if (frameCount % 200 == 0) then
	--	reset()
	--	y_ += 10
	--end

	for i = 1, 100 do
		local next_ = points[math.random(#points)]

		if not (next_ == previous) then -- ANOTHER PIC
			current = Vector3.new(lerp(current.X, next_.X, percent), y_, lerp(current.Z, next_.Z, percent))
			part(current, BrickColor.new('Lime green'))
		end
		previous = next_	
	end
end

setup_2()

while wait() do
	draw_()
end