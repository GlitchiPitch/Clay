function onPlayerAdded(player: Player)
	script.Cash:Clone().Parent = player
end

game.Players.PlayerAdded:Connect(onPlayerAdded)