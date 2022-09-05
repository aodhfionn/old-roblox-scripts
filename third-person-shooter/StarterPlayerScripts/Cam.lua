local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local TS = game:GetService("TweenService")
local Replicated = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = Player:GetMouse()
local xAngle = 0
local yAngle = 0
local cameraPos = Vector3.new(2.5,0,5)
local FOV = 65
local doCam = true

local spring = require(Replicated.spring)

wait(2)
Camera.CameraType = Enum.CameraType.Scriptable
Camera.FieldOfView = FOV

CAS:BindAction("CameraMovement", function(_,_,input)
	xAngle = xAngle - input.Delta.x/3
	yAngle = math.clamp(yAngle - input.Delta.y/3,-60,60)
end, false, Enum.UserInputType.MouseMovement)

local mouseBehaviour = Enum.MouseBehavior.LockCenter

--

Replicated.RemoteEvents.BuildCam.OnClientEvent:Connect(function(mode)
	Camera.CameraType = Enum.CameraType[mode]
end)

Replicated.RemoteEvents.AirstrikeCam.OnClientEvent:Connect(function(bool)
	doCam = bool
end)

-- this is for testing purpouses because roblox studio is dumb and wont let me open the menu in play mode

local freemouse = false

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.BackSlash then
		if freemouse then
			freemouse = false
			mouseBehaviour = Enum.MouseBehavior.LockCenter
		else
			freemouse = true
			mouseBehaviour = Enum.MouseBehavior.Default
		end
	end
end)

-- Shoulder Cam

local recoilVal = 0
local newspring = spring.create()

RS.RenderStepped:Connect(function(deltaTime)
	local char = Player.Character or Player.CharacterAdded:Wait()
	local rootPart = char:FindFirstChild("HumanoidRootPart")

	if char and rootPart and Camera.CameraType == Enum.CameraType.Scriptable and doCam then
		local startCFrame = CFrame.new((rootPart.CFrame.p + Vector3.new(0,2,0)))*CFrame.Angles(0, math.rad(xAngle), 0)*CFrame.Angles(math.rad(yAngle), 0, 0)

		local cameraCFrame = startCFrame + startCFrame:VectorToWorldSpace(Vector3.new(cameraPos.X,cameraPos.Y,cameraPos.Z))
		local cameraFocus = startCFrame + startCFrame:VectorToWorldSpace(Vector3.new(cameraPos.X,cameraPos.Y,-50000))
		
		local recoil = newspring:update(deltaTime)

		Camera.CFrame = CFrame.new(cameraCFrame.p,cameraFocus.p)
		UIS.MouseBehavior = mouseBehaviour
	end
end)
