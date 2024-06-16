local CollectionService = game:GetService('CollectionService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ClayPower = require(ReplicatedStorage.ClayPower)
local MainProperties = require(ReplicatedStorage.MainProperties)

local createGlobalClayVoids = {}

createGlobalClayVoids.SettingClayVoid = function(clay, color)
	clay.Transparency = .5
	CollectionService:AddTag(clay, 'clayVoid')
	clay.Color = color
	clay.CanCollide = false
	--ClayPower.StartPower(clay)
end

createGlobalClayVoids.createRedClayField = function(holeTemplate)
	local itemsForCreateRedClay = game.ReplicatedStorage.Items.ForRedClay
	local redClayModel = itemsForCreateRedClay.redClayModel:Clone()
	redClayModel.Parent= holeTemplate.Parent
	redClayModel:PivotTo(holeTemplate.CFrame)
	holeTemplate:Destroy()
	
end
createGlobalClayVoids.CreateGreenClayHole = function(holeTemplate, value, destroyTemplate: bool)
	-- надо сделать чтобы здесь высчитывался размер кубов для темплэйта, чтоб можно было выбрать 3 варианта маленький средний большой и по формуле вычситывался выбранны вариант
	local ROWS = holeTemplate.Size.X / value
	local COLS = holeTemplate.Size.Y / value
	
	local greenHoleModel = Instance.new('Model')
	greenHoleModel.Parent = holeTemplate.Parent
	greenHoleModel.Name = 'greenHole'
	
	local greenHoleFolder = Instance.new('Folder')
	greenHoleFolder.Parent = greenHoleModel
	greenHoleFolder.Name = 'GreenHole'

	local debrisFolder = Instance.new('Folder')
	debrisFolder.Parent = greenHoleFolder
	debrisFolder.Name = 'Debris'

	local checkX, checkY = math.round(ROWS/2), math.round(COLS/2)

	local cubeSize = Vector3.new(value,value,holeTemplate.Size.Z)
	local startPoint = holeTemplate.CFrame * CFrame.new(-(holeTemplate.Size.X / 2 - cubeSize.X / 2), -(holeTemplate.Size.Y / 2 - cubeSize.Y / 2), 0)

	local function createPart(x, y)
		local part = Instance.new('Part')
		--part.Parent = workspace
		part.Size = cubeSize
		part.Anchored = true
		part.CFrame = startPoint * CFrame.new(part.Size.X * x, part.Size.Y * y, 0)
		part.Name = x .. y
		part.BrickColor = BrickColor.Red()
		return part
	end

	for y = 0, math.floor(COLS) - 1 do
		for x = 0, math.floor(ROWS) - 1 do
			if y == checkY and x == checkX then
				local greenClay = createPart(x ,y)
				greenClay.Size += Vector3.new(0,0,2)
				greenClay.Parent = greenHoleFolder
				createGlobalClayVoids.SettingClayVoid(greenClay, MainProperties.ClayPropertiesList.green.color)
			else
				local part = createPart(x,y)
				part.Parent = debrisFolder
			end
			--task.wait()
		end
	end
	if destroyTemplate then
		holeTemplate:Destroy()
	else
		holeTemplate.Transparency = 1
		holeTemplate.CanCollide = false
	end
end

return createGlobalClayVoids
