local module = {}

module.Settings = 
	{
		-- How much damage each bullet does
		Damage = 20,
		
		-- How long it takes for the shoot cooldown to end
		fireRate = .15,
		
		-- Max ammo in a mag
		maxAmmo = 8,
		
		-- How much ammo in a clip by default
		currentAmmo = 0,
		
		-- How far the gun can shoot
		Range = 128,
		
		-- Recoil amount
		recoilAmp = math.random(2,3),
		
		-- Whether or not the gun is fully automatic
		isAuto = true,
		
		-- Bullets make a hole on impact
		doBulletHole = true,
		
		-- Bullet effects like smoke
		doBulletFX = false,
		
		-- Make blood when a bullet hits a player
		doBlood = true,
		
		-- Explosive bullets
		doExplosion = false
	}

return module
