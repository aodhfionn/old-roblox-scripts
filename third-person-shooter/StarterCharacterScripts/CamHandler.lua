game:GetService("ReplicatedStorage").RemoteEvents.BuildCam.OnServerEvent:Connect(function(plr,mode)
	game.ReplicatedStorage.RemoteEvents.BuildCam:FireClient(plr,mode)
end)
