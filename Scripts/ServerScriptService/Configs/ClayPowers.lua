-- services

local tweenService = game:GetService('TweenService')
local debris = game:GetService('Debris')

-- functions

function radioactiveClay(clay: Part)
	local radioactiveSphere = script.radioactiveSphere:Clone()
	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 10, true)
	local goal = {Size = radioactiveSphere.Size * 10 ^ 2}
	local lifeTime = 10
	
	radioactiveSphere.Parent = clay
	radioactiveSphere.CFrame = clay.CFrame
	
	if clay.Transparency <= 0 then
		debris:AddItem(clay, lifeTime)
		debris:AddItem(radioactiveSphere, lifeTime)
		coroutine.wrap(function()
			local tween = tweenService:Create(radioactiveSphere, tweenInfo, goal)
			tween:Play()
			while not tween.Completed and wait(.5) do
				for i, v in workspace:GetPartsInPart(radioactiveSphere) do
					if v:IsA('Part') and not (v == clay) then
						v.Color = clay.Color
						v.Anchored = false
						debris:AddItem(v, lifeTime)
						v.Touched:Connect(function(hit: Part)
							local hum = v.Parent:FindFirstChildOfClass('Humanoid')
							if hum then hum.Health -= 1 end
						end)
					end
				end
			end		
		end)()
	end
end

--[[

	телепорт клей после активации будет испускать сферу, которая зафиксирует первый попвшийся телепорт рядом и к нему привяжется, как колапс
	фотона
	
	переделать клеи в класс, с методами setup и activate

]]