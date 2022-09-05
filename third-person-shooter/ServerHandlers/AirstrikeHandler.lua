game.ReplicatedStorage.RemoteEvents.AirstrikeCam.OnServerEvent:Connect(function(plr, mode)
	game.ReplicatedStorage.RemoteEvents.AirstrikeCam:FireClient(plr, mode)
end)
