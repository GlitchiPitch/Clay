-- this script about generate random walls
-- надо будет сделать комнату где радиактивность используется 
-- в виде тунелей и 

-- и вторая комната для радиактивного клэя это будет башня с комнатами, 
-- где будет четыре комнаты и нужно один из них разломать радиактивным глиной
-- и там удут какие -нибудь смешные ващи, по типо переодеться во флопу
-- найти апргейды из магазина апргрейдов
-- зомби от которого не отобьешся ( можно убить ) и тебе надо будет 
-- пробраться до телепорта на следующий этаж через зомби ( можно исползовать глину белые и туда желтую)


-- поведение курсора когда используешь белую глину

-- вот что исать сканер, который покажет где нужен глэй


--башня с радиактивными глинами--
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local CollectionService = game:GetService('CollectionService')

local MainProperties = require(ReplicatedStorage.MainProperties)
local CreateGlobalClayVoids = require(ReplicatedStorage.CreateGlobalClayVoids)
--local furnitureFolder = RS.Items.RoomItems

local roomModel = script.Parent.Items.roomModel
local coridoreModel = script.Parent.Items.coridoreModel
-- RadioactiveTower this is folder
local floorTemplate = script.Parent.floorTemplate -- model

SpawnCentralRoom = function(centralTemplateRoomModel)

	local cubeSize = Vector3.new(1,1,1)
	local parent = centralTemplateRoomModel
	local cubesFolder = Instance.new('Folder', parent)

	local function createCube(cframe)
		local cube = Instance.new('Part', cubesFolder)
		cube.Anchored = true
		cube.Size = cubeSize
		cube.CFrame = cframe
	end

	local function spawnGreenClay(part, index)
		local clay = Instance.new('Part', part.Parent)
		clay.Anchored = true
		clay.Size = Vector3.new(5,5,2.5)
		clay.CFrame = part.CFrame * CFrame.new(0,0,(5 * index))
		clay.Name = 'greenClay'
		clay.BrickColor = BrickColor.Green()
		
		return clay
	end

	local previousCFrame


	for index, item in pairs(centralTemplateRoomModel:GetChildren()) do
		if item:IsA('Part') then
			local part = item
			local startCframe = part.CFrame * CFrame.new(part.Size.X/2 - cubeSize.X/2,part.Size.Y/2 - cubeSize.Y/2,0)
			previousCFrame = startCframe
			local xPos,yPos = 0,0

			local entranceWall = 6 -- number of wall which need ignore ( between 3 and 6)

			for x = 0, part.Size.X - 1 do
				for y = 0, part.Size.Y - 1 do
					xPos = x
					yPos = y
					local cframe = previousCFrame * CFrame.new(-cubeSize.X * xPos, -cubeSize.Y * yPos, 0) 
					createCube(cframe)
				end
			end

			local checkTopAndBottom = (part.Orientation == Vector3.new(90,180,0) or part.Orientation == Vector3.new(-90,0,0))
			if entranceWall ~= nil and entranceWall == index then
				CreateGlobalClayVoids.SettingClayVoid(spawnGreenClay(part, 1), MainProperties.ClayPropertiesList.green.color)
			elseif not checkTopAndBottom then
				CreateGlobalClayVoids.SettingClayVoid(spawnGreenClay(part, -1), MainProperties.ClayPropertiesList.green.color)
			end
			
			part:Destroy()
		end
	end
end 

local hasStartFloor = false
local entranceRoom = 4

SpawnRoom = function(template, index)
	
	local function setupRoom(room,template)
		local cloneModel = room:Clone()
		cloneModel.Parent = template.Parent
		cloneModel:PivotTo(template.CFrame)
	end
	
	if not hasStartFloor and index == entranceRoom  then
		--local cloneCorridor = coridoreModel:Clone()
		--cloneCorridor.Parent = template.Parent
		--cloneCorridor:PivotTo(template.CFrame)
		setupRoom(coridoreModel, template)
		hasStartFloor = true
	else
		setupRoom(roomModel, template)
	end
	--local cloneRoom = roomModel:Clone()
	--cloneRoom.Parent = template.Parent
	--cloneRoom:PivotTo(template.CFrame)
end
for index, template in pairs(floorTemplate:GetChildren()) do
	if template:GetAttribute('Type') == 'central' and template:IsA('Model') then
		SpawnCentralRoom(floorTemplate.centralRoom)
	else
		SpawnRoom(template, index)
		template:Destroy()
	end
end

--[[

еще загадка с дартсом, где нужно выстроить хаотичные кубики по принципе генерации поля для дартса
будет панель которая запускается с промта, камера движется на панель игрок отключается, фиксируется мышка передвигаются кубики
если дверь открыть то панель раздвинеться и покажет каменный тунель, который ведет в место похожее на бэкрум ( это будет отсылка что игра связана с паралельным роблоксом )

]]



--SpawnRoom = function(spawnTemplatePartList)
--	for i , template in pairs(spawnTemplatePartList) do
--		if template:GetAttribute('Type') == 'central' then
--			SpawnCentralRoom(template)
--		else
--			local cloneModel = roomModel:Clone()
--			cloneModel.Parent = template.Parent --Parent
--			cloneModel:PivotTo(template.CFrame)
--			--FurnitureRoom(cloneModel)
--			template:Destroy()
--		end
--	end
--end

--SpawnTower = function(amountOfFloors: number)
--	--local roomTemplates = AmountOfFloors(amountOfFloors)
--	local roomTemplates = roomModel
--	SpawnRoom(roomTemplates)
--end

--SpawnTower(floorAmount)


--[[

в общем вся эта игра это эксперимент ученых по внедрению оцифрованных разумов, смертельно больных людей, которых переносят в мертвые аккаунты роблокса. 
их потом обучают на этой карте, заклеивать дыры в пространстве. Которые опявляются от мозгов больмана, которые связались с искуственным интелектомиз даркнета, который
не остановился в развитии и накопил мощностей достаточных для получения сигналов из космоса через анализ данных наблюдений Наса, просто люди не под тем углом смотрят и 
не могут ничего найти, а ии по-другому просчитал данные и нашел сигнал, который дал возможность связаться с другой расой, тех самых мозгов больцмана
мозги больцмана проводили очень много веремени с чатом и изучая наш интернет они добрались до роблокса, там им понравилось и они начали создавать плэйсы, бывало такое что они
публиковали свои плэйсы, а если мозг умирал, от игра удалялась после смерти мозга, но по нашему времени их жизни пролетала за секунды и в играх появлялись плэйс на несколько секунд
а потом удалялись.
Так этих чуваков и готовят что заклеивать внутри игр вот эти дыры, которые ведут на другие плэйсы, которые создали мозги, потому что там опасно и дети пропадают
-- еще одна ветка про жизнь вот этих чувваков, которые попали сюда и теперь должны служить и защищать роблокс, типо какие у них там опасные страшные вещи происходили на плэйсах, просто
об этом некому рассказать, умирают дети.

-- а потом можно связать что чувак из космических коллекторов, который гг внутри матрицы и он геймплэи делает, так вот он будет делать видос про эту игру, таким образом получиться вселенная
внутри вселенной

-- воспоминания человека складываются из нескольких блоков, эти блоки будут рассказывать о каком-то событии человека, но в контексте имеено того человека который попался игроку
-- например: предательство ( надо брать более абстрактный класс типо рождение, жизнь, смерть) вот эти три этапа будут состоять из более точных классов( 
напрмер для рождения = место, родители, ситуация в мире(войны, пандемия и тд) ) эти будут состоять из категорий плохие-средние-хорошие, 
для показа жизни = работа, семья, друзья ( возможно здоровье ) ( тут тоже рандомно выбираться плохой-хороший, но с увеличением шанса на положительный результат, либо отрицательный )
для показа смерти = место, кто рядом, возраст, удовлетворенность жизнью ( тут тоже рандомно но с поправками )

к каждому варианту будет прикручена своя ситуация, по типу выпало место: плохой, игроку предлагается рандомный вариант из плохих, для того чтобы определеить как должны выглядеть плохие
надо расписать кто родители и ситуация в мире,
ситуация в мире складывается из = плохие {война, катаклизмы, паднемии}, средние = {} 

-- у каждого игрока будет рандомно выбираться воспоминания человека за которого они играют
--[ в кноце каждых воспоминаний, или большинства люди в черном в расплывающимся взгляде человека] --

]]