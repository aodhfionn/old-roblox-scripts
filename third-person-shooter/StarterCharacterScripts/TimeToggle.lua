local UIS = game:GetService("UserInputService")
local toggle = false
local l = game.Lighting

UIS.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.RightBracket then
		if toggle then
			toggle = false
			l.ClockTime = 12
			if not l.NVEffect.Enabled then
				l.NightEffect.Enabled = false
				l.Ambient = Color3.new(0.392157, 0.392157, 0.392157)
				l.Brightness = 2.5
				l.OutdoorAmbient = Color3.new(0.392157, 0.392157, 0.392157)
				l.FogEnd = 9999
			end
		else
			toggle = true
			l.ClockTime = 0
			if not l.NVEffect.Enabled then
				l.NightEffect.Enabled = true
				l.Ambient = Color3.new(0,0,0)
				l.Brightness = 2
				l.OutdoorAmbient = Color3.new(0.392157, 0.392157, 0.392157)
				l.FogEnd = 200
			end
		end
	end
end)


