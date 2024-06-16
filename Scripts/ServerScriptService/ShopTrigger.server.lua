-- items

local remotes = game.ReplicatedStorage.Remotes

local trigger = script.Parent
local clayTemplate = trigger.ClayTemplate

-- events

local event = remotes.ShopEvent

function onTriggered(player: Player)
	trigger.Enabled = false
	event:FireClient(player, 'openShop', trigger)
end

trigger.Triggered:Connect(onTriggered)