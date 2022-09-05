local currentspeed = 0

game:GetService("ReplicatedStorage").RemoteEvents.GetPlayerSpeed.OnServerInvoke = function()
	return currentspeed
end

script.Parent.Humanoid.Running:Connect(function(speed)
	currentspeed = speed
end)

