local Replicated = game:GetService("ReplicatedStorage")

Replicated.RemoteEvents.PlaceBuild.OnServerEvent:Connect(function(plr,name,cf)
	local build = Replicated.BuildTemplates:FindFirstChild(name)
	if build then
		local newbuild = build:Clone()
		newbuild.Parent = workspace.Structures
		newbuild.CFrame = cf
	end
end)
