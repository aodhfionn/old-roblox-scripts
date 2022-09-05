local RS = game:GetService("ReplicatedStorage")
local Gun = script.Parent
local Settings = require(Gun:WaitForChild("Settings")).Settings

local Zoom = RS.RemoteEvents.Zoom
local Shoot = RS.RemoteEvents.PistolShoot

local Equipped = false

local newTool = Gun:Clone()
newTool.Parent = game.ReplicatedStorage.ToolStorage

script.Parent.Equipped:Connect(function()
	if not Equipped then
		Equipped = true
	end
	script.Parent.Unequipped:Connect(function()
		if Equipped then
			Equipped = false
		end
	end)
end)

Shoot.OnServerEvent:Connect(function(plr,gun,raystart,rayend,dmg,range,firerate)
	if gun.Name == "Deagle" and Equipped and script.Parent.Parent.Name == plr.Name then
		local speed = math.random(13,16)
		
		gun.Handle.ShootSound.PlaybackSpeed = speed/10 --decimals dont work with math.random??
		RS.RemoteEvents.GunSound:FireAllClients(Gun.Parent, Gun, Gun.Handle.ShootSound) -- make this play on the players client, but then fireallclients OTHER than the player so that there is no latency on the players end but the sound also plays for others..
		
		local Bullet = Ray.new(raystart,(rayend-raystart).unit*range)
		local Hit, Pos, Norm = workspace:FindPartOnRay(Bullet,plr.Character,false,true)
		
		if Hit then
			
			if Settings.doExplosion then
				RS.RemoteEvents.Explode:FireClient(plr, rayend, Gun)
			end
			
			local h = Hit.Parent:FindFirstChild("Humanoid")
			if h then
				h:TakeDamage(dmg)
			end
		end
		
		-- effects
		
		if Settings.doBulletHole and Hit then
			local h = Hit.Parent:FindFirstChild("Humanoid")
			local Hole = RS:FindFirstChild("BulletHole"):Clone()
			if not h then
				Hole.Parent = workspace.BulletHoles
				Hole.Position = rayend
				Hole.CFrame = CFrame.new(Hole.Position,Hole.Position+Norm) * CFrame.Angles(0,0,math.rad(math.random(1,360))) -- random bullethole rotation 
			end
		end
		
		
		if Settings.doBulletFX then
			local Effect = RS:FindFirstChild("HitParticle"):Clone()
			Effect.Parent = workspace
			Effect.Position = rayend
			Effect.CFrame = CFrame.new(Effect.Position,Effect.Position+Norm)
		end
	end
end)
