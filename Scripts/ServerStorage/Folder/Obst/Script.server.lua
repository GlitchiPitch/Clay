local maze = script.Parent

local plates = maze.Folder

function createClay(plate)
	local a = Instance.new('Part', plate.Parent)
	a.CFrame = plate.CFrame * CFrame.new(0,20,0)
	a.Color = Color3.new(1, 0, 1)
	a.Name = 'clay'
	a.Anchored = true
	
	return a
end

function createClayVoidModel(plate)
	local a = Instance.new('Model', maze)
	plate.Parent = a
	
	return a
end

function createDebris(clayVoidModel)
	local a = Instance.new('Part', clayVoidModel)
	a.Color = Color3.new(0.666667, 0.333333, 0)
	a.Anchored = false
	a.CFrame = clayVoidModel.clay.CFrame
end

for _, o in pairs(plates:GetChildren()) do
	createDebris(createClayVoidModel(createClay(o)))
end