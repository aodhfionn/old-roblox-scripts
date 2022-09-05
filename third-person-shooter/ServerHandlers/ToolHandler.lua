local RS = game:GetService("ReplicatedStorage")

RS.RemoteEvents.DropTool.OnServerEvent:Connect(function(plr,tool)
	local newTool = Instance.new("Model")
	newTool.PrimaryPart = tool:WaitForChild("Handle")
	newTool.Parent = RS
	newTool.Name = tool.Name
	
	tool:WaitForChild("Mesh").CanCollide = true
	tool:WaitForChild("Handle").CanCollide = true
	tool.ProximityPrompt.Enabled = true
	
	wait()
	
	for i,v in pairs(tool:GetChildren()) do
		v.Parent = newTool
		if v.ClassName == "Script" and v.Parent ~= tool.ProximityPrompt then
			v:Destroy()
		elseif v.ClassName == "LocalScript" then
			v:Destroy()
		end
	end
	
	tool:Destroy()
	newTool.Parent = workspace.DroppedTools
	newTool.PrimaryPart.CFrame = plr.Character:FindFirstChild("RightHand").CFrame
end)
