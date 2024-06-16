local ReplicatedStorage	= game:GetService('ReplicatedStorage')
local MainProperties = require(ReplicatedStorage.MainProperties)

local commonFunctions = {}

commonFunctions.ShowHowMuchGetCash = function(parent, cost)
	local billboardGui = Instance.new('BillboardGui', parent)
	billboardGui.AlwaysOnTop = true
	billboardGui.MaxDistance = 150
	billboardGui.Size = UDim2.new(4,0,2,0)

	local label = Instance.new('TextLabel', billboardGui)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextStrokeTransparency = 0
	label.Font = MainProperties.FontProperties.font
	label.TextScaled = true
	label.TextColor3 = MainProperties.FontProperties.textColor
	label.Text = cost .. '$'

	local timer = 1
	local tween = game:GetService('TweenService'):Create(billboardGui, TweenInfo.new(1, Enum.EasingStyle.Sine), {StudsOffsetWorldSpace = Vector3.new(0,5,0)})
	tween:Play()
	--tween.Completed:Wait()
	task.wait(timer)
	billboardGui:Destroy()
end

commonFunctions.createWarningGui = function(plrGui, text: string)
	local textLabel = Instance.new('TextLabel', plrGui)
	textLabel.Size = UDim2.new(.3,0,.15,0)
	textLabel.BackgroundTransparency = 1
	textLabel.AnchorPoint = Vector2.new(.5,0)
	textLabel.TextScaled = true
	textLabel.Position = UDim2.new(.5,0,.2,0)
	textLabel.TextColor3 = MainProperties.FontProperties.textColor
	textLabel.Font = MainProperties.FontProperties.font
	textLabel.TextStrokeTransparency = 0
	textLabel.Text = text
	task.wait(2)
	textLabel:Destroy()
end

return commonFunctions
