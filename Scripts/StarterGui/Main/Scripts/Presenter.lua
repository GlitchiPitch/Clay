local View
local Invoke
local Event

local currentTrigger
local buttonTemplate = script.Template

function buy(color: string)
	local success, msg = Invoke:InvokeServer('buy', color, 1, currentTrigger)
	
	if not (success == nil) then
		if success then
			View.shop.Visible = false
			View.showNotification(msg)
		else
			View.showNotification(msg)
		end
	end
end

function openShop(trigger: ProximityPrompt)
	currentTrigger = trigger
	View.shop.Visible = true
end

function createShop(scroll: ScrollingFrame)
	
	local clays = Invoke:InvokeServer('getClays')
	
	for clayName, clayProp in clays do
		local button = buttonTemplate:Clone()
		button.Parent = scroll
		button.Name = clayName
		button.ClayName.Text = clayProp.color
		button.Cost.Text = clayProp.cost
		button.BackgroundColor3 = Color3.fromHex(clayProp.color)
		
		button.Activated:Connect(function() buy(clayProp.color) end)
	end
	
end

function onEvent(action, ...)
	local actions = {
		openShop = openShop,
	}
	
	if actions[action] then actions[action](...) end
end

function constructor(view: {})
	View = view
	Invoke = game.ReplicatedStorage.Remotes.ShopInvoke
	Event = game.ReplicatedStorage.Remotes.ShopEvent
	
	Event.OnClientEvent:Connect(onEvent)
end

return {
	constructor = constructor,
	createShop = createShop,
}