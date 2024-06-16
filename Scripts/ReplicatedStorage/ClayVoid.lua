local ReplicatedStorage = game:GetService('ReplicatedStorage')
local CollectionService = game:GetService('CollectionService')

local ClayWork = require(ReplicatedStorage.ClayWork)

-- propertiesList is a table within cframe, parent, size

local ClayVoid = {}

ClayVoid.__index = ClayVoid

function ClayVoid.New(propertiesList: table, nameOfClay)
	local self = setmetatable({}, ClayVoid)
	local clayProp = ClayWork.GetClayProperties(nameOfClay)
	self.color = clayProp['color']
	
	self.CFrame = propertiesList['CFrame']
	self.size = propertiesList['Size']
	self.parent = propertiesList['Parent']
	
	return self:CreateClay()
end

function ClayVoid:CreateClay()
	local clay = Instance.new('Part', self.parent)
	clay.Transparency = .5
	clay.Anchored = true
	clay.CanCollide = false
	clay.Color = self.color
	clay.CFrame = self.CFrame
	clay.Size = self.size
	
	CollectionService:AddTag(clay, 'clayVoid')
	
	return clay
end

return ClayVoid
