
-- services 

local serverScriptService = game.ServerScriptService

-- items

local configs = serverScriptService.Configs
local toolTemp = script.Tool

-- moudules

local utils = require(serverScriptService.Utils)
local clays = require(configs.Clays)

-- events

local event = game.ReplicatedStorage.Remotes.BlasterEvent

-- functions

function bullet(color)
	local clay = script.Clay:Clone()
	clay.Parent = workspace
	clay.Color = Color3.fromHex(color)
	
	--clay.Touched:Connect(function(hit: BasePart) 
	--	if hit.BrickColor == clay.BrickColor then
	--		hit.Transparency -= .1
	--		clay:Destroy()
	--	end
	--end)
	
	return clay
end

function shoot(player: Player, target: Part, tool: Tool)
	
	local color = tool:GetAttribute('ClayColor')
	local charge = tool:GetAttribute('Charge')
	local rightColor = true --target and target.BrickColor == color
	local targetAttachment = target:FindFirstChildOfClass('Attachment')
	if rightColor and targetAttachment and charge > 0 then
		local trunkPos: Attachment = utils.getBlaster(player).trunk
		local clay = bullet(color)
		clay.CFrame = trunkPos.WorldCFrame
		clay.AlignPosition.Attachment1 = targetAttachment
		tool:SetAttribute('Charge', charge - 1)
	end
end

-- activations

for clayName, clayProp in clays do
	local tool = toolTemp:Clone()
	tool.Name = clayName
	tool.ToolTip = clayProp.description 
	tool:SetAttribute('ClayColor', clayProp.color)
	tool.Parent = game.StarterPack
end

event.OnServerEvent:Connect(shoot)