function getBlaster(player: Player)
	local character = player.Character
	if character then
		local blaster = character:FindFirstChild('Blaster')
		if blaster then
			local trunk = blaster:FindFirstChild('Trunk')
			local clayPlace = blaster:FindFirstChild('ClayPlace')
			local trunk = trunk:FindFirstChild('Attachment')
			return {
				trunk = trunk, 
				clayPlace = clayPlace,
			}
		end
	end
end

function getShop(player: Player)
	local main = player.PlayerGui:FindFirstChild('Main')
	return main.Shop
end

function getTools(player: Player)
	local tools = {}
	local backpack = player.Backpack
	local character = player.Character
	for i, v in backpack:GetChildren() do tools[v.Name] = v end
	for i, v in character:GetChildren() do if v:IsA('Tool') then tools[v.Name] = v end end
	
	return tools
end

return {
	getBlaster = getBlaster,
	getShop = getShop,
	getTools = getTools,
}