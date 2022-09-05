local RS = game:GetService("ReplicatedStorage")

RS.RemoteEvents.ChangeCam.OnServerEvent:Connect(function(plr,mode)
	RS.RemoteEvents.ChangeCam:FireClient(plr,mode)
end)
