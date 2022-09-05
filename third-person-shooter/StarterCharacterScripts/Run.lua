
-- FIX THIS CODE IT WORKS BUT IS BAD

local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local Player = game.Players.LocalPlayer
local Char = Player.Character
local Humanoid = Char:FindFirstChild("Humanoid")

local RunAnim = Instance.new("Animation")
RunAnim.AnimationId = 'rbxassetid://5551535463'
local LoadAnim = Humanoid:LoadAnimation(RunAnim)

local currentspeed = 0
local isRunning = false

local walkS = 14
local runS = 20

Humanoid.Running:Connect(function(speed)
	--[[if isRunning then
		if speed > 0 then
		LoadAnim:Play()
		else
			LoadAnim:Stop()
		end
	end]]
	currentspeed = speed
end)

local function checkfortool()
	local tool = Char:FindFirstChildWhichIsA("Tool")
	if tool then
		return true
	else
		return false
	end
end

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		if not isRunning --[[and currentspeed > 0]] then
			isRunning = true
			RS.RemoteEvents.ChangeCam:FireServer("Default")
			Humanoid.WalkSpeed = runS
			--LoadAnim:Play()
		end
	end
	UIS.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			if isRunning then
				local findtool = checkfortool()
				--if findtool == true then
					RS.RemoteEvents.ChangeCam:FireServer("Lock")
				--end
				Humanoid.WalkSpeed = walkS
				--LoadAnim:Stop()
				isRunning = false
			end
		end
	end)
end)
