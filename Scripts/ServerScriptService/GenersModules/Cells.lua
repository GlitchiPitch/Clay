--x = .4
--y = .1

--for n = 1, 1000 do

--	x_ = y * x * (1 - x)
--	x = x_
--	y += .01
--	wait(.1)




--	print(x, y)



--end

local w = 50
local h = 50
local particles = {}
local parts = {}

function part()
	local p = script.Part:Clone()
	p.Parent = workspace	
	return p
end

function particle(x, z, c) return {x = x, z = z, vx = 0, vz = 0, color = c} end
function random() return math.random(w) end

function create(num, color)
	local group = {}
	for i = 1, num do
		local particle_ = particle(random(), random(), color)
		table.insert(group, particle_)
		table.insert(parts, part())
		table.insert(particles, particle_)
	end
	return group
end

function rule(ps1, ps2, g)
	for i = 1, #ps1 do
		local fx = 0
		local fz = 0
		
		local a, b
		
		for j = 1, #ps2 do

			a = ps1[i]
			b = ps2[j]

			local dx = a.x - b.x
			local dz = a.z - b.z

			local d = math.sqrt(dx ^ 2 + dz ^ 2)

			local F

			if (d > 0 and d < 80) then
				F = g * 1 / d
				fx += (F * dx)
				fz += (F * dz)
			end
		end
		a.vx = (a.vx + fx) * .5
		a.vz = (a.vz + fz) * .5
		a.x += a.vx
		a.z += a.vz
		
		if (a.x <= -w or a.x >= w) then a.vx *= -1 end -- frame restrictions
		if (a.z <= -h or a.z >= h) then a.vz *= -1 end -- frame restrictions
	end
end

local yellow = create(200, BrickColor.new('New Yeller'))
local red = create(200, BrickColor.new('Really red'))
local green = create(200, BrickColor.new('Bright green'))

function update()

	rule(red, red, .01)
	rule(yellow, red, .015)
	rule(green, green, -.05)
	rule(green, red, -.02)
	rule(red, green, .01)
	
	for i = 1, #particles do
		parts[i].Position = Vector3.new(particles[i].x, 5, particles[i].z)
		parts[i].BrickColor = particles[i].color
	end
end

while wait(1) do
	update()
	
end