game.ReplicatedStorage.RemoteEvents.RPGShoot.OnClientEvent:Connect(function(plr,hit,gun)
	local new = game.ReplicatedStorage.Missile:Clone()
	new.Parent = workspace
	new.CFrame = CFrame.new(gun.Handle.Missile.Position,hit)
	
	local vel = Instance.new("BodyVelocity",new)
	vel.Velocity = CFrame.new(new.Position,hit).LookVector * 125
	gun.Handle.Missile.Transparency = 1
	
	new.Touched:Connect(function(h)
		if h:IsA("BasePart") and h ~= gun.Handle and h ~= gun.Handle.Missile then
			game.ReplicatedStorage.RemoteEvents.Explode:FireServer(new.Position,gun)
			--h.Anchored = false
			new:Destroy()
		end
	end)
	
	wait(10)
	if new then
		new:Destroy()
	end
end)

game.ReplicatedStorage.RemoteEvents.RPGReload.OnClientEvent:Connect(function(plr,gun)
	gun.Handle.Missile.Transparency = 0
end)

