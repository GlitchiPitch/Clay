--[[
	а что если не говорить игроку о способностях глин, а сделать так чтобы 
	игрок сам должен догадываться например сначала глина не работает, а потом
	какая-то глина например сразу даст бафф, и потом игроки будут искать способы
	активировать другие глины, а что если сделать как пятый элемент

]]

function onPlayerAdded(player: Player)
	script.Cash:Clone().Parent = player
end

game.Players.PlayerAdded:Connect(onPlayerAdded)