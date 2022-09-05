local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PickupGui = RS.PickupGui
local Plr = Players.LocalPlayer
local Char = Plr.Character

local closest,gui

local function Toggle(t)
	if gui then
		gui:Destroy()
		gui = nil
	end
	
	if t == true then
		gui = PickupGui:Clone()
		gui.Parent = closest:FindFirstChildWhichIsA("BoolValue")
		gui.Enabled = true
	end
end

while wait(.05) do
	local max = 10
	local newClosest
	
	for i,tool in pairs(workspace.DroppedTools:GetChildren()) do
		if (tool.Position - Char.HumanoidRootPart.Position).magnitude <= max then
			max = (tool.Position - Char.HumanoidRootPart.Position).magnitude
			newClosest = tool
		end
	end
	
	closest = newClosest
	
	if closest then
		Toggle(true)
	else
		Toggle(false)
	end
end

