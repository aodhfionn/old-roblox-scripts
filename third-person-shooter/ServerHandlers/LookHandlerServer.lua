local RS = game:GetService("ReplicatedStorage")
local dist = 128

RS.RemoteEvents.Look.OnServerEvent:Connect(function(plr,waist,neck)
	for i,v in pairs(game.Players:GetChildren()) do
		if v.Name ~= plr.Name and (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude <= dist then
			RS.RemoteEvents.Look:FireClient(v,plr,waist,neck)
		end
	end
end)
