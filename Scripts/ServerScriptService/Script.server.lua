local dim = 16

local sin = math.sin
local cos = math.cos

local n = 8

local mandelbuld = {}

function createPart(x, y, z)
	local part = script.Part:Clone()
	part.Parent = workspace
	part.Position = Vector3.new(x, y, z) * part.Size + Vector3.new(0, 50, 0)
	part.Size *= .5
end

function spherical(x, y, z)
	local r = (x ^ 2 + y ^ 2 + z ^ 2) ^ .5
	local theta = math.atan2((x ^ 2 + y ^ 2) ^ .5, z)
	local phi = math.atan2(y, x)
	
	return Vector3.new(r, theta, phi)
end

local zeta = Vector3.new(0, 0, 0)

for x = 0, dim - 1 do
	for y = 0, dim - 1 do
		for z = 0, dim - 1 do

			local maxIter = 10
			local iter = 0

			while true do
				
				--print(`{x} {y} {z}`)
				
				local r = (x ^ 2 + y ^ 2 + z ^ 2) ^ .5
				
				print(r)
				
				local theta = math.atan2((x ^ 2 + y ^ 2) ^ .5, z)
				
				print(theta)
				
				local phi = math.atan2(y, x)
				
				print(phi)
				
				local c = Vector3.new(r, theta, phi)
								
				local newX = r ^ n * sin(theta * n) * cos(phi * n)
				local newY = r ^ n * sin(theta * n) * sin(phi * n)
				local newZ = r ^ n * cos(theta * n)
				
				zeta = Vector3.new(newX + x, newY + y, newZ + z)
				
				print(zeta)
				
				if r > 2 then break end
				
				iter += 1; if iter == maxIter then 
					table.insert(mandelbuld, Vector3.new(x * 10, y * 10, z * 10))
					break 
				end
			end
			
			--createPart(x, y, z)
			--wait(.1)
			--print(`{x} {y} {z}`)
		end
	end
end

for i, v in mandelbuld do
	createPart(v)
end
