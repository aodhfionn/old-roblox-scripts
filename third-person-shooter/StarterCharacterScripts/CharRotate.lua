local Cam = workspace.CurrentCamera
local Player = game.Players.LocalPlayer
local HRP = Player.Character:WaitForChild("HumanoidRootPart")
local Hum = Player.Character:FindFirstChild("Humanoid")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

local Waist = Player.Character:FindFirstChild("Waist", true)
local Neck = Player.Character:FindFirstChild("Neck",true)
local waistOffset = Waist.C0.Y
local neckOffset = Neck.C0.Y

local rotate = true
local aim = false
local db = false

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.Parent = RS
bodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
bodyGyro.D = 100

RS.RemoteEvents.ChangeCam.OnClientEvent:Connect(function(mode)
	if mode == "Default" then
		rotate = false
	elseif mode == "Lock" then
		rotate = true
	end
end)

RS.RemoteEvents.Zoom.OnClientEvent:Connect(function(dir)
	if dir == "In" then
		aim = true
		bodyGyro.D = 1
	else
		aim	= false
		bodyGyro.D = 100
	end
end)

game:GetService("PhysicsService"):SetPartCollisionGroup(Player.Character.UpperTorso,"Player")
Hum.AutoRotate = true

-- Rotate



local Info = TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)

game:GetService("RunService").RenderStepped:Connect(function()
	if rotate then
		Hum.AutoRotate = false
		bodyGyro.Parent = HRP
		if not db then
			db = true
			
			--
			
			wait(.15)
		end
		
		bodyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + Vector3.new(Cam.CFrame.LookVector.X,0,Cam.CFrame.LookVector.Z))
	else
		db = false
		Hum.AutoRotate = true
		bodyGyro.Parent = workspace
	end
end)

-- Up & Down

local Info2 = TweenInfo.new(.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)

while wait(.05) do
	if rotate then
		local camDir = HRP.CFrame:ToObjectSpace(Cam.CFrame).LookVector
		
		if Waist and Neck then
			
			local P1 = {C0 = CFrame.new(0,waistOffset,0) * CFrame.Angles(math.asin(camDir.Y),0,0)}
			local P2 = {C0 = CFrame.new(0,neckOffset,0) * CFrame.Angles(math.asin(camDir.Y)/2,0,0)}
			
			local T1 = TS:Create(Waist,Info2,P1)
			local T2 = TS:Create(Neck,Info2,P2)
			
			T1:Play()
			T2:Play()
		end
	else
		
		local P1 = {
			C0 = CFrame.new(0,waistOffset,0)
		}

		local P2 = {
			C0 = CFrame.new(0,neckOffset,0)
		}

		local T1 = TS:Create(Waist,Info2,P1)
		local T2 = TS:Create(Neck,Info2,P2)

		T1:Play()
		T2:Play()
		
		db = false
	end
end

