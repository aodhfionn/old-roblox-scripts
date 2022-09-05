game.ReplicatedStorage.RemoteEvents.Explode.OnServerEvent:Connect(function(plr,pos,gun)
	local boom = Instance.new("Explosion")
	boom.BlastRadius = 6
	boom.BlastPressure = 250000
	boom.Parent = workspace
	boom.Position = pos
	local sound = game.ReplicatedStorage.ExplodeSound:Clone()
	sound.Parent = workspace
	sound.Position = pos
	sound.Explosion:Play()
	wait(3)
	sound:Destroy()
end)
