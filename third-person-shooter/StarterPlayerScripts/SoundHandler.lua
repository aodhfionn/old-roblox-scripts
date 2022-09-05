local Replicated = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

Replicated.RemoteEvents.GunSound.OnClientEvent:Connect(function(plr,tool,sound)
	if game.Players:GetPlayerFromCharacter(plr) ~= Player then
		sound:Play()
	end
end)
