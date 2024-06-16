local blue = script.Parent.Blue
local gray = script.Parent.Gray

function creteDetectHitBox(part)
	local detectPart = Instance.new('Part', part)
	detectPart.Size = Vector3.new(part.Size.X / 2, 1, part.Size.Z / 2)
	detectPart.Anchored = true
	detectPart.CanCollide = false
	detectPart.Transparency = .5
	detectPart.Color = Color3.new(1,0,0)
	detectPart.CFrame = part.CFrame * CFrame.new(0,1,0)
	return detectPart
end

function touched(part, destroy)
	part.Touched:Connect(function(hit)
		if not hit.Parent:FindFirstChild('Humanoid') then return end
		if destroy then 
			-- anim destroy
			part.Parent:Destroy() 
		else
			part.Parent.Color = Color3.new(0.3, 1, 0.4)
			part:Destroy()
		end
	end)
	
end

function finishPartWork(part)
	part.Touched:Connect(function(hit)
		local humanoidRootPart = hit.Parent:FindFirstChild('HumanoidRootPart')
		if not humanoidRootPart then return end
		part.Parent.Color = Color3.new(0.3, 1, 0.4)
		part:Destroy()
		humanoidRootPart.CFrame = CFrame.new(0,300,0)
	end)
	
end

function start()
	local mainColor = Color3.new(1, 0.6, 0)
	local function a(folder, destroy: bool)
		for i, o in pairs(folder:GetChildren()) do
			o.Color = mainColor
			local detectPart = creteDetectHitBox(o)
			if o.Name == 'finishPart' then 
				finishPartWork(detectPart, destroy)
			else
				touched(detectPart, destroy)
			end
		end
	end
	a(blue, false)
	a(gray, true)
	
	--for i, o in pairs(blue:GetChildren()) do
	--	o.Color = mainColor
	--	touched(o, false)
	--end
	--for i, o in pairs(gray:GetChildren()) do
	--	o.Color = mainColor
	--	touched(o, true)
	--end
end

start()