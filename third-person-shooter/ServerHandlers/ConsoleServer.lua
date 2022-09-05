game.ReplicatedStorage.RemoteEvents.ConsoleOpened.OnServerEvent:Connect(function(p,b)
	game.ReplicatedStorage.RemoteEvents.ConsoleOpened:FireClient(p,b)
end)
