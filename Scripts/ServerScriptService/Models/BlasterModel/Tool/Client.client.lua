local mouse = game.Players.LocalPlayer:GetMouse()
local tool = script.Parent
local event = game.ReplicatedStorage.Remotes.BlasterEvent

function toolActivated() event:FireServer(mouse.Target, tool) end

tool.Activated:Connect(toolActivated)