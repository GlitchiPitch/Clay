local dim = 16

local f = Instance.new('Folder', workspace)
local mandelbulb = {}

function part(v)
	local p = script.Part:Clone()
	p.Parent = f
	p.Position = v.pos
	p.BrickColor = v.color
end

function SphericalZ(x, y, z)
	local r = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
	local theta = math.atan2(math.sqrt(x ^ 2 + y ^ 2), z)
	local phi = math.atan2(y, x)
	return Vector3.new(r, theta, phi) 
end 

function map(value, inMin, inMax, outMin, outMax)
	return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

for i = 0, dim - 1 do
	for j = 0, dim - 1 do
		
		local edge = false
		
		for k = 0, dim - 1 do
			
			local x = map(i, 0, dim, -1, 1)
			local y = map(j, 0, dim, -1, 1)
			local z = map(k, 0, dim, -1, 1)
			
			local n = 8
			local iter = 0
			local maxIter = 10
			local zeta = Vector3.new(0, 0, 0)
			
			while true do
				c = SphericalZ(zeta.X, zeta.Y, zeta.Z)
				
				local newX = math.pow(c.X, n) * math.sin(c.Y * n) * math.cos(c.Z * n)
				local newY = math.pow(c.X, n) * math.sin(c.Y * n) * math.sin(c.Z * n)
				local newZ = math.pow(c.X, n) * math.cos(c.Y * n)
				
				zeta = Vector3.new(newX + x, newY + y, newZ + z)
				
				iter += 1
				
				if c.X > 16 then
					if edge then
						edge = false
					end
					break
				end
				
				if iter > maxIter then
					
					
					local color
					
					
					--if (i * j * k) % 2 == 1 then -- +
						
					--	if math.cos(i + k + j) < 0 then -- and math.sin(i + k + j) < 0
					--		color = BrickColor.new('Gold')
					--	else
					--		color = BrickColor.new('White')
					--	end
						
					--else
					--	color = BrickColor.new('Black')
					--end
					
					color = BrickColor.new('Gold')
					
					table.insert(mandelbulb, {pos = Vector3.new(x*300, y*300, z*300), color = color})
					if not edge then
						edge = true
					end
					break
				end
			end
		end
	end
end


for i, v in mandelbulb do
	part(v)
end

--for i, v: Part in f:GetChildren() do
--	if v.BrickColor == BrickColor.new('Black') then
--		v.Transparency = 1
--	end
--end