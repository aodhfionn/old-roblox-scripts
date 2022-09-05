local Player = game.Players.LocalPlayer
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local Waist = Player.Character.UpperTorso.Waist
local Neck = Player.Character.Head.Neck

local delay = .25

RS.RemoteEvents.Look.OnClientEvent:Connect(function(plr,waistC0,neckC0)
	local waist = plr.Character:FindFirstChild("Waist",true)
	local neck = plr.Character:FindFirstChild("Neck",true )
	
	if waist and neck then
		neck.C0 = neckC0
		
		TS:Create(waist,TweenInfo.new(delay,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0),{C0 = waistC0}):Play()
		TS:Create(neck,TweenInfo.new(delay,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0),{C0 = neckC0}):Play()
	end
end)

while wait(delay) do
	RS.RemoteEvents.Look:FireServer(Waist.C0,Neck.C0)
end
