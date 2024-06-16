local ReplicatedStorage = game:GetService('ReplicatedStorage')
local remotes = ReplicatedStorage.Remotes
local remoteFunctions = ReplicatedStorage.RemoteFunctions

local clayPower = {}

clayPower.StartPower = function(clay)
	CheckPower(clay)
end

GreenPower = function(clay)

	local radiationField = clay:Clone()
	radiationField.Parent = clay
	radiationField.Transparency = .5
	radiationField.CanCollide = false


	local cubesFolder = clay.Parent:FindFirstChild('Debris')
	local folderOfNearParts = cubesFolder

	local info = TweenInfo.new(2,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local target = {Size = clay.Size + clay.Size/2}
	game:GetService('TweenService'):Create(radiationField, info, target):Play()

	local function getNearestParts(folderOfNearParts)

		local nearPartsList = folderOfNearParts:GetChildren()
		local lengthOfList = {}

		for i = 1, #nearPartsList do
			table.insert(lengthOfList, i)
		end

		for i = 1, #lengthOfList do

			local randomNumber = lengthOfList[math.random(#lengthOfList)]
			table.remove(lengthOfList, (table.find(lengthOfList, randomNumber, 1)))

			local part = nearPartsList[randomNumber]
			if part and (clay.Position - part.Position).Magnitude < 200 then

				part.Color = clay.Color
				part.Anchored = false
				game:GetService('Debris'):AddItem(part, 2)
				part.Touched:Connect(function(otherPart)
					if otherPart.Parent:FindFirstChild('Humanoid') then
						-- проверка костюма от радиации
						otherPart.Parent:FindFirstChild('Humanoid').Health -= 5
					end
				end)
			end
			task.wait(math.random(.1,.5))

		end
	end

	getNearestParts(folderOfNearParts)

	radiationField.Touched:Connect(function(touchedPart)
		if touchedPart.Parent:FindFirstChild('Humanoid') then
			-- проверка костюма от радиации
			touchedPart.Parent:FindFirstChild('Humanoid').Health -= 5
		end
	end)

	task.wait(5,10)
	clay:Destroy()
end

BlackPower = function(clay)

	local hp = Instance.new('IntValue')
	hp.Parent = clay

	local highestVector = (math.max(table.unpack({clay.Size.X, clay.Size.Y, clay.Size.Z})))
	local volume = ((highestVector * 2) + highestVector)
	local maxHp = volume
	local damage = 1
	local shangeSizeValue = Vector3.new(clay.Size.X / volume * .2, clay.Size.Y / volume * .2, clay.Size.Z / volume * .2) 

	hp.Value = volume -- volume of clay
	hp.Name = 'hp'

	local db = false

	clay.Touched:Connect(function(otherPart)
		if not otherPart.Parent:FindFirstChild('Humanoid') then return end
		clay.CanTouch = false
		hp.Value -= damage
		local tween = game:GetService('TweenService'):Create(clay, TweenInfo.new(.1,Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 5, true), {Size = clay.Size - Vector3.new(.2,.2,.2)})
		tween:Play()
		tween.Completed:Wait()
		task.wait(1)
		clay.CanTouch = true
	end)

	hp.Changed:Connect(function(value)
		clay.Size -= shangeSizeValue
		if value <= 10 then
			clay:Destroy()
		end
	end)
end

LightBluePower = function(clay)
	-- уменьшает гравитацию на некоторое время
	local charge = 5
	clay.Material = Enum.Material.Neon

	clay.Touched:Connect(function(otherPart)
		local humanoid = otherPart.Parent:FindFirstChild('Humanoid')
		if not humanoid then return end
		clay.CanTouch = false
		charge -= 1
		humanoid.JumpPower = 150 -- привязать увеличение прыжка к размерам блока
		-- добавить партиклс на ноги чтобы показать усиление прыжка
		if charge <= 0 then
			clay.Material = Enum.Material.Plastic
			task.wait(5)
			clay:Destroy()
		end
		task.wait(5)
		clay.CanTouch = true
	end)

end

RedPower = function(clay)
	print('Red power')
	
	local function gravity(item)
		
		local AlignPosition = Instance.new('AlignPosition')
		local passiveAttachment = Instance.new('Attachment')
		local activeAttachment = Instance.new('Attachment')

		AlignPosition.Parent = clay
		passiveAttachment.Parent = item
		activeAttachment.Parent = clay

		AlignPosition.Attachment0 = passiveAttachment
		AlignPosition.Attachment1 = activeAttachment

		AlignPosition.MaxForce = 100000000
		return AlignPosition
	end

	local nearList = {}

	local function nearest()
		local debris = clay.Parent:FindFirstChild('Debris')
		--print(debris)
		for _, v in pairs(debris:GetDescendants()) do
			--print(v)
			if v:IsA('Part') or v:IsA('MeshPart') or v:IsA('UnionOperation') then
				if v.Anchored then v.Anchored = false end
				gravity(v)
				--table.insert(nearList, v)
			end
		end
		wait(5)
		for _, item in pairs(clay:GetChildren()) do
			if item:IsA('AlignPosition') or item:IsA('Attachment') then item:Destroy() end
		end
		clay.Anchored = false
	end
	nearest()
	wait(5)
	clay:Destroy()

	-- красная глина будет магнитить к себе ближайшие детали с атрибутов type = part и через определенное время удаляется, испыскает луч в ближайшие объекты
end

PinkPower = function(clay)

	-- розовая глина показывает скрытые объекты на карте, будь то вещи, пустоты и скрытые ходы удаляется после использвоания 
end

WhitePower = function(clay)
	-- можно ставить где угодно и заполнять любым цветом
end

YellowPower = function(clay)
	-- teleport on one way
	-- make particles for activeted clay

	local nearestYellowClay = Instance.new('ObjectValue')
	nearestYellowClay.Parent = clay
	nearestYellowClay.Name = 'nearestYellowClay'

	local function getNearPart()

		local connectedPart = clay.Parent:FindFirstChild(tostring(tonumber(clay.Name) + 1))
		print(connectedPart)

		if connectedPart:FindFirstChild('nearestYellowClay') then
			print('find near')
			clay.nearestYellowClay.Value = connectedPart
			return true
		elseif not connectedPart then
			print('near not exist')
			return true
		end

		return false

	end

	local childAddedSignal

	if not getNearPart() then
		print('childDetected')
		childAddedSignal = clay.Parent.ChildAdded:Connect(function()
			print('wait')
			task.wait(3)
			print(clay.Name .. ' ' .. 'Changed')


			if getNearPart() then print('disconnect') childAddedSignal:Disconnect() end

			--for i,o in pairs(clay.Parent:GetChildren()) do
			--	if tonumber(o.Name) == tonumber(clay.Name) + 1 and o:FindFirstChild('nearestYellowClay') then
			--		clay.nearestYellowClay.Value = o  
			--	end
			--end
		end)
	end


	clay.Touched:Connect(function(otherPart)
		print('TOUCHED' .. clay.Name)
		local humanoidRootPart = otherPart.Parent:FindFirstChild('HumanoidRootPart')
		if humanoidRootPart then
			local nearPart = clay.nearestYellowClay
			print(nearPart.Value)
			if nearPart.Value ~= nil then
				remotes.ClayPowerRemotes.yellowClayPower:FireServer(humanoidRootPart, nearPart.Value.CFrame)
			end

			--clay.CanTouch, nearestYellowClay.Value.CanTouch = false, false
			----charge -= 1
			--task.wait(2)
			--clay.CanTouch, nearestYellowClay.Value.CanTouch = true, true
			--if charge <= 0 then clay:Destroy() end --nearestYellowClay.Value:Destroy()
		end
	end)

	clay.CanCollide = false
	clay.Transparency = .8

	--local clayFolder = clay:FindFirstAncestorOfClass('Folder')
	----print(clayFolder)

	--local function findNearestYellowClay() -- perhaps i need to remake this function like in b ricey's video about coroutine
	--	print('clay number' .. clay.Name)
	--	local childAdded = clayFolder.ChildAdded:Connect(function()
	--		print('changed' .. '' .. clay.Name)
	--		findNearestYellowClay()
	--	end)

	--	for _, item in pairs(clayFolder:GetChildren()) do -- пробежка по тэгу

	--		if tonumber(item.Name) == tonumber(clay.Name) + 1  then
	--			print(item)
	--			print(item:IsA('Part'))
	--			--print(tonumber(clay.Name) + 1)
	--			print(tonumber(item.Name) == tonumber(clay.Name) + 1)
	--			print(item ~= clay)
	--			print(item.Color == clay.Color)
	--			print(item:GetChildren())
	--			print(item:FindFirstChild('nearestYellowClay'))
	--		end



	--		if item:IsA('Part') and tonumber(item.Name) == tonumber(clay.Name) + 1 and item.Color == clay.Color and item ~= clay and item:FindFirstChild('nearestYellowClay') then
	--			nearestYellowClay.Value = item
	--			print('find')
	--			childAdded:Disconnect()
	--			break
	--		end
	--	end


	--	if nearestYellowClay.Value ~= nil then
	--		nearestYellowClay.Value.Touched:Connect(function(otherPart)
	--			local humanoidRootPart = otherPart.Parent:FindFirstChild('HumanoidRootPart')
	--			if humanoidRootPart and nearestYellowClay.Value ~= nil then
	--				remotes.yellowClayPower:FireServer(humanoidRootPart, clay.CFrame)
	--				clay.CanTouch, nearestYellowClay.Value.CanTouch = false, false
	--				--charge -= 1
	--				task.wait(2)
	--				clay.CanTouch, nearestYellowClay.Value.CanTouch = true, true
	--				--if charge <= 0 then clay:Destroy() end --  nearestYellowClay:Destroy() 
	--			end		
	--		end)
	--	end
	--end

	--findNearestYellowClay()

end




BluePower = function(clay)
	local nearest = clay.Parent:FindFirstChild('Debris')
	local function createGui(target)
		local faces = Enum.NormalId:GetEnumItems()
		for i = 1,6 do
			local gui = Instance.new('SurfaceGui', target)
			game:GetService('Debris'):AddItem(gui, 60)
			gui.Face = faces[i]
			local label = Instance.new('ImageLabel', gui)
			label.Size = UDim2.fromScale(1,1)
			label.BackgroundTransparency = 1
			gui.AlwaysOnTop = true
			label.Image = 'rbxassetid://12754479702'
		end
	end

	if nearest then
		for i, v in pairs(nearest:GetChildren()) do
			createGui(v)
			--v.Transparency = .5
			task.wait(.2)
		end
	end

	--синяя глина при активации испускается сигнал и работает как рентген ( попробовать через селетион бокс или сурфэцс гуи + адвэйс он топ ) работает долго 
end

CheckPower = function(clay)
	if clay.Color == MainProperties.ClayPropertiesList.green.color then
		GreenPower(clay) 
	elseif clay.Color == MainProperties.ClayPropertiesList.black.color then
		BlackPower(clay)
	elseif clay.Color == MainProperties.ClayPropertiesList.lightBlue.color then
	elseif clay.Color == MainProperties.ClayPropertiesList.red.color then
		RedPower(clay)
	elseif clay.Color == MainProperties.ClayPropertiesList.pink.color then
	elseif clay.Color == MainProperties.ClayPropertiesList.white.color then
	elseif clay.Color == MainProperties.ClayPropertiesList.yellow.color then
		YellowPower(clay)
	elseif clay.Color == MainProperties.ClayPropertiesList.blue.color then
		BluePower(clay)
	end
end

return clayPower
