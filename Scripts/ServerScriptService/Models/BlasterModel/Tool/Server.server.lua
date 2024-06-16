local utils = require(game.ServerScriptService.Utils)

local tool = script.Parent

function getClayPlace()
	local player = tool:FindFirstAncestorOfClass('Player') or game.Players:GetPlayerFromCharacter(tool.Parent)
	local clayPlace = utils.getBlaster(player).clayPlace
	return clayPlace
end

function onAttributeChanged(attribute: string) 
	if attribute == 'Charge' then
		--tool.ToolTip = tostring(tool:GetAttribute('Charge'))		
		getClayPlace().Count.TextLabel.Text = tool:GetAttribute('Charge')
	end
end

function changeClayPlace(color)
	local clayPlace = getClayPlace()
	clayPlace.Transparency = color and 0 or 1
	clayPlace.Count.Enabled = color and true or false
	clayPlace.Color = color or Color3.new(0,0,0)
	clayPlace.Count.TextLabel.Text = tool:GetAttribute('Charge')
end

function toolEquipped()	changeClayPlace(Color3.fromHex(tool:GetAttribute('ClayColor'))) end
function toolUnequipped() changeClayPlace() end

tool.Equipped:Connect(toolEquipped)
tool.Unequipped:Connect(toolUnequipped)
tool.AttributeChanged:Connect(onAttributeChanged)