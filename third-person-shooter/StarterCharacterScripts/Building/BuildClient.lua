-- servisesz

local UIS = game:GetService("UserInputService")
local Replicated = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")

-- objectz

local Event = Replicated.RemoteEvents.PlaceBuild
local Player = game.Players.LocalPlayer
local Char = Player.Character
local HRP = Char.HumanoidRootPart
local Buildings = Replicated.BuildTemplates

-- other stuff

local Mouse = Player:GetMouse()
local poopoo = false

-- setting

local yOffset = 0
local yOrientation = 0
local maxDist = 50
local canPlace = false
local rotating = false
local rotspeed = 2
local building = false
local increment = 11.25

-- special variables

local valy = Instance.new("NumberValue")
local valx = Instance.new("NumberValue")
local tag = Instance.new("StringValue")
local cf = CFrame.new()
local closestStruct
local closestAtt

-- ok

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.B then
		if not building then
			building = true
			
			game.StarterGui:SetCoreGuiEnabled("Backpack",false)
			Replicated.RemoteEvents.BuildCam:FireServer("Custom")
			
			-- making the ghost part look like a cool forcefield thingy
			
			local ghost = Buildings:FindFirstChild("WoodFloor"):Clone()
			tag.Value = ghost.Name
			ghost.CanCollide = false
			ghost.Material = "ForceField"
			ghost.Name = "ghost"
			local ff = Buildings.ff:Clone()
			ff.Parent = ghost
			ff.Scale = ghost.Size
			ghost.Parent = workspace
			
			yOffset = ghost.Size.Y / 2 -- bugged, everytime build mode is re-entered it gets higher
			
			-- determine position, if can place, other stuff (using rays so we can use an ignore list)
			
			RunService.RenderStepped:Connect(function()
				if building then
					local ray = Mouse.UnitRay
					local cast = Ray.new(ray.Origin,ray.Direction * 1000)
					local ignore = {ghost, Char}
					local hit, pos = workspace:FindPartOnRayWithIgnoreList(cast,ignore)
					
					if hit and (HRP.Position - ghost.Position).magnitude <= maxDist then
						canPlace = true
						ff.VertexColor = Vector3.new(0,255,0) -- green = yes
					else
						canPlace = false
						ff.VertexColor = Vector3.new(255,0,0) -- red = no
					end
					
					local newCFrame
					local targ = Mouse.Target
					local newClosestStruct
					
					Mouse.TargetFilter = ghost
					
					-- finds closest attatch point, if the mouse target is a structure
					
					if targ and targ.Name == "WoodFloor" then
						for _, floor in pairs (targ:GetChildren()) do
							if (floor.Parent.Position + floor.Position - pos).magnitude <= 12 then
								newClosestStruct = Vector3.new(floor.Parent.Position.X + floor.Position.X,floor.Parent.Position.Y + floor.Position.Y,floor.Parent.Position.Z + floor.Position.Z) -- MEGA CODE
							end
						end
						closestStruct = newClosestStruct
					elseif not targ or targ.Name ~= "WoodFloor" then
						closestStruct = nil
					end
					
					if closestStruct then
						newCFrame = CFrame.new(closestStruct.X,closestStruct.Y,closestStruct.Z)
					else
						newCFrame = CFrame.new(pos.x, pos.y + yOffset, pos.z)
					end
					
					local newAngles = CFrame.Angles(math.rad(valx.Value),math.rad(valy.Value),0)
					ghost.CFrame = newCFrame * newAngles
					cf = ghost.CFrame
				else
					ghost:Destroy()
				end
			end)
		else
			building = false
			game.StarterGui:SetCoreGuiEnabled("Backpack",true)
			Replicated.RemoteEvents.BuildCam:FireServer("Scriptable")
		end
	end
end)

-- increments

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Z then
		if increment < 90 then
			if increment ~= 11.25 then
				increment = increment + 22.5
			else
				increment = 22.5
			end
		else
			increment = 11.25
		end
		print(increment)
	end
end)

-- placement

UIS.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if building and canPlace then
			Replicated.RemoteEvents.PlaceBuild:FireServer(tag.Value,cf)
			script.Parent.click:Play()
		end
	end
end)

-- rotation stuff

local p = {}
local canrot = true

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.R then
		if canrot then
			canrot = false
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
				p = {Value = valy.Value - increment}
			else
				p = {Value = valy.Value + increment}
			end
			local tee = TS:Create(valy,TweenInfo.new(.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),p):Play()
			wait(.15)
			canrot = true
		end
	elseif input.KeyCode == Enum.KeyCode.E then
		if canrot then
			canrot = false
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
				p = {Value = valx.Value - increment}
			else
				p = {Value = valx.Value + increment}
			end
			local tee = TS:Create(valx,TweenInfo.new(.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),p):Play()
			wait(.15)
			canrot = true
		end
	end
end)
