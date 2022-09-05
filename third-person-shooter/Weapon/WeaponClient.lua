-- variables 1

local Gun = script.Parent
local Settings = require(Gun:WaitForChild("Settings")).Settings
local spring = require(game.ReplicatedStorage.spring)
local newspring = spring.create()
local Cam = workspace.CurrentCamera
local FOV = Cam.FieldOfView
local cameraPos = Vector3.new(2.5,0,5)
local TS = game:GetService("TweenService")
local Replicated = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local ammoAmt = Settings.currentAmmo

-- zoom function for ads

local function Zoom(dir)
	local P = {}

	if dir == "In" then
		P = {FieldOfView = FOV/2;}

		cameraPos = Vector3.new(cameraPos.X,cameraPos.Y,3.5)
	else
		P = {FieldOfView = FOV;}

		cameraPos = Vector3.new(cameraPos.X,cameraPos.Y,5)
	end

	TS:Create(Cam,TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),P):Play()
end

-- recoil

game:GetService("RunService").RenderStepped:Connect(function(dt)
	local recoil = newspring:update(dt)
	
	Cam.CFrame = Cam.CFrame * CFrame.Angles(recoil.x,recoil.y,recoil.z)
end)

-- explosion client handler

Replicated.RemoteEvents.Explode.OnClientEvent:Connect(function(pos, gun)
	Replicated.RemoteEvents.Explode:FireServer(pos, gun)
end)


Gun.Equipped:Connect(function()
	
	-- variables 2
	
	local Player = game.Players.LocalPlayer
	local Char = Player.Character
	local Humanoid = Char:WaitForChild("Humanoid")
	local Mouse = Player:GetMouse()
	
	local recoilAmp = math.random(3,4)
	
	local IdleUpAnim = Humanoid:LoadAnimation(Gun:WaitForChild("idleup"))
	local IdleDownAnim = Humanoid:LoadAnimation(Gun:WaitForChild("idledown"))
	local ShootAnim = Humanoid:LoadAnimation(Gun:WaitForChild("shoot"))
	local ReloadAnim = Humanoid:LoadAnimation(Gun:WaitForChild("reload"))
	
	local Equipped = false
	local ShootDB = false
	local statecooldown = -1
	local mouseDown = false
	
	local currentSpeed = 0
	
	local canReload = true
	local reloading = false
	
	-- state controller
	
	local function changeState(state)
		if state == "Up" and Equipped then
			IdleDownAnim:Stop()
			IdleUpAnim:Play()
		elseif state == "Down" and Equipped then
			IdleUpAnim:Stop()
			IdleDownAnim:Play()
		end
	end
	
	-- starting stuff
	
	Equipped = true
	Player.PlayerGui.GunStat.Enabled = true
	
	--Replicated.RemoteEvents.ChangeCam:FireServer("Lock")
	
	IdleDownAnim:Play()
	
	-- ammo gui

	local function updateGui()
		Player.PlayerGui.GunStat.BG.GunName.Text = Gun.Name..":"
		Player.PlayerGui.GunStat.BG.Ammo.Text = ammoAmt.." / "..Settings.maxAmmo
	end
	
	updateGui()
	
	-- shoot
	
	local function Shoot()
		if Equipped and not ShootDB and not reloading then
			if ammoAmt > 0 then
				ShootDB = true
				Replicated.RemoteEvents.PistolShoot:FireServer(Gun,Gun.MuzzleFlash.Position,Mouse.Hit.Position,Settings.Damage,Settings.Range,Settings.fireRate)
				ammoAmt = ammoAmt - 1
				updateGui()
				canReload = true

				Gun.Handle.ShootSound:Play()

				newspring:shove(Vector3.new(recoilAmp*.1,0,0))

				ShootAnim:Play()
				changeState("Up")
				statecooldown = 9

				Gun.MuzzleFlash.MuzzleEffect.Enabled = true
				delay(.025, function()
					Gun.MuzzleFlash.MuzzleEffect.Enabled = false	--might have to change this, bad code?
				end)
 
				wait(Settings.fireRate)

				ShootDB = false
			end
		else return end
	end
	
	Mouse.Button1Down:Connect(function()
		mouseDown = true
		if Settings.isAuto then
			while mouseDown do
				if not ShootDB and ammoAmt > 0 and not reloading then
					Shoot()
				else break end
			end
		else
			Shoot()
		end
	end)
	
	Mouse.Button1Up:Connect(function()
		mouseDown = false
	end)
	
	-- reload
	
	UIS.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.R and ammoAmt < 8 and canReload and not reloading and Equipped then -- clean this up
			reloading = true
			canReload = false
			ReloadAnim:Play()
			Gun.Handle.ReloadSound:Play()
			wait(2.5)
			ammoAmt = Settings.maxAmmo
			updateGui()
			reloading = false
		end
	end)
	
	-- aiming
	
	Mouse.Button2Down:Connect(function()
		if Equipped then
		
			--Replicated.RemoteEvents.Zoom:FireServer("In")
			Zoom("In")
			
			if statecooldown <= 0 then
				changeState("Up")
			end
			
			Mouse.Button2Up:Connect(function()
				
				--Replicated.RemoteEvents.Zoom:FireServer("Out")
				Zoom("Out")
				
				if statecooldown <= 0 then
					changeState("Down")
				end
			end)
		end
	end)
	
	-- drop
	
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.G and Equipped and not reloading and not ShootDB then
			Equipped = false

			IdleUpAnim:Stop()
			IdleDownAnim:Stop()
			Gun.Handle.UnequipSound:Play()
			Gun.Handle.EquipSound:Stop()
			Player.PlayerGui.GunStat.Enabled = false
			
			game:GetService("ReplicatedStorage").RemoteEvents.DropTool:FireServer(Gun)
		end
	end)
	
	-- unequip
	
	Gun.Unequipped:Connect(function()
		Equipped = false
		
		--Replicated.RemoteEvents.ChangeCam:FireServer("Default")
		
		IdleUpAnim:Stop()
		IdleDownAnim:Stop()
		Player.PlayerGui.GunStat.Enabled = false
	end)
	
	-- state timer
	
	while wait(1) and Equipped do -- optimize this good for nothing piece of garbage excuse for code
		if statecooldown > 0 then
			statecooldown = statecooldown - 1
		elseif statecooldown == 0 then
			changeState("Down")
			statecooldown = -1
		end
	end
end)
