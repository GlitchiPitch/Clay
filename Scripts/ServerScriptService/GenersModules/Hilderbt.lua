local order = 1
local n = math.pow(2, order)
local total = n ^ n

local width = 10
local counter = 0

local path = {} :: {Vector3}
local f = Instance.new('Folder', workspace)

function binaryToString(bin: {}) : string
	local result = ''
	for i = 1, #bin do
		result = result .. tostring(bin[i])
	end
	return result
end

function part(i: number)
	local p = script.Part:Clone()
	p.Parent = f
	p.Position = path[i]
	p.SurfaceGui.TextLabel.Text = i
end

function hilbert(i)
	
	local points = {
		[0] = Vector3.new(0, 0, 0),
		[1] = Vector3.new(0, 0, 1),
		[2] = Vector3.new(1, 0, 1),
		[3] = Vector3.new(1, 0, 0),
	}
	
	local index = i % 3
	local v = points[index];

	for j = 2, order - 1 do
		
	end

	--for (let j = 1; j < order; j++) {
	--	i = i >>> 2;
	--	index = i & 3;
	--	let len = pow(2, j);
	--	if (index == 0) {
	--		let temp = v.x;
	--		v.x = v.y;
	--		v.y = temp;
	--		} else if (index == 1) {
	--	v.y += len;
	--	} else if (index == 2) {
	--	v.x += len;
	--	v.y += len;
	--	} else if (index == 3) {
	--	let temp = len - 1 - v.x;
	--	v.x = len - 1 - v.y;
	--	v.y = temp;
	--	v.x += len;
	--	}
	--	}
	--	return v;
end

function setup()
	for i = 0, total - 1 do
		
		path[i] = hilbert(i)
		local len = .5 * width / n
		path[i] *= len
	end
end

function draw()
	for i = 1, #path do
		part(i)
	end
end

setup()

draw()

for i = 0, 9 do
	print(i % 3)
end