
-- services

local tweenService = game:GetService('TweenService')

-- items

local remotes = game.ReplicatedStorage.Remotes
local configs = game.ServerScriptService.Configs

-- modules 

local utils = require(game.ServerScriptService.Utils)
local clays = require(configs.Clays)

-- events

local invoke = remotes.ShopInvoke
local event = remotes.ShopEvent

---- config

function getTweenInfo(clayTemplate: Part)
	local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Sine)
	local goal = {
		Position = clayTemplate.Position + Vector3.new(0, clayTemplate.Size.X / 2, 0),
		Size = Vector3.new(10, 10, 10),
	}
	
	return tweenInfo, goal
end

function getClays() return clays end

function clayPartTouched(trigger, clay: Part, hit, color, clayAmount)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player then
		
		local tools = utils.getTools(player)		
		for i, v in tools do 
			if v:GetAttribute('ClayColor') == color then
				v:SetAttribute('Charge', v:GetAttribute('Charge') + clayAmount)
				break
			end
		end
		
		clay:Destroy()
		trigger.Enabled = true
	end
end

function createClay(trigger, color, clayAmount)
	
	local clayPart = trigger.ClayTemplate:Clone()
	local tweenInfo, goal = getTweenInfo(trigger.ClayTemplate)
	
	clayPart.Parent = trigger
	clayPart.Color = Color3.fromHex(color)
	clayPart.Transparency = 0
	

	tweenService:Create(clayPart, tweenInfo, goal):Play()
	
	clayPart.Touched:Connect(function(hit: Part) clayPartTouched(trigger, clayPart, hit, color, clayAmount) end)
end

function buy(player, color: string, clayAmount: number, trigger: ProximityPrompt)

	for i, clay in clays do
		if clay.color == color then
			if player.Cash.Value >= clay.cost then
				player.Cash.Value -= clay.cost
				createClay(trigger, color, clayAmount)
				return true, `create {color}`
			else
				return false, 'You have no money'
			end		
		end
	end

	return false, 'color was not found'

end

local actions = {
	getClays = getClays,
	buy = buy,
}

function server(player, action, ...)
	if actions[action] then
		return actions[action](player, ...)
	else
		return `unknown command {action}`
	end
end

invoke.OnServerInvoke = server