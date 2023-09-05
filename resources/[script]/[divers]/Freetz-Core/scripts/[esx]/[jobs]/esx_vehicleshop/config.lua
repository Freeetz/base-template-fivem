ConfigConCess = {}
ConfigConCess.Locale = 'fr'

ConfigConCess.DrawDistance = 25.0
ConfigConCess.MarkerColor = {r = 120, g = 120, b = 240}

ConfigConCess.EnablePlayerManagement = true
ConfigConCess.EnableOwnedVehicles = true
ConfigConCess.EnableSocietyOwnedVehicles = false

ConfigConCess.ResellPercentage = 0
ConfigConCess.LicenseEnable = false

ConfigConCess.PlateLetters = 4
ConfigConCess.PlateNumbers = 4
ConfigConCess.PlateUseSpace = false

ConfigConCess.Society = {
	carshop = {label = 'Concessionnaire Voitures', type = 'car'},
	planeshop = {label = 'Concessionnaire Avions', type = 'aircraft'},
	boatshop = {label = 'Concessionnaire Bateaux', type = 'boat'}
}

ConfigConCess.Blips = {
	carshop = {
		Pos = vector3(-37.7346, -1107.5588, 26.4365),
		Sprite = 326,
		Name = 'Concessionnaire Voitures'
	},
	planeshop = {
		Pos = vector3(-941.273, -2954.613, 12.895),
		Sprite = 326,
		Name = 'Concessionnaire Avions'
	},
	boatshop = {
		Pos = vector3(-816.2860, -1345.4148, 5.1504),
		Sprite = 326,
		Name = 'Concessionnaire Bateaux'
	}
}

ConfigConCess.Zones = {
	carshop = {
		ShopEntering = { -- C FAIT
			Pos = vector3(-2211.8452, -391.1855, 12.3859),
			Size = vector3(1.5, 1.5, 1.0),
			Type = 1
		},
		ShopInside = { --  C FAIT
			Pos = vector3(-2214.4897, -393.9353, 22.1212),
			Size = vector3(1.5, 1.5, 1.0),
			Heading = 356.2888,
			Type = -1
		},
		ShopOutside = { -- C FAIT
			Pos = vector3(-2234.0364, -379.8403, 13.4128),
			Size = vector3(1.5, 1.5, 1.0),
			Heading = 48.6466,
			Type = -1
		},
		BossActions = { -- C FAIT
			Pos = vector3(-2228.8442, -399.9283, 16.4683),
			Size = vector3(1.5, 1.5, 1.0),
			Type = -1
		},
		GiveBackVehicle = { --  C FAIT
			Pos = vector3(-888.91, -2040.85, 8.3),
			Size = vector3(3.0, 3.0, 1.0),
			Type = (ConfigConCess.EnablePlayerManagement and 1 or -1)
		},
		ResellVehicle = {
			Pos = vector3(-948.4, -2044.23, 8.54), -- -44.630, -1080.738, 25.483
			Size = vector3(3.0, 3.0, 1.0),
			Type = 1,
			bossOnly = true
		}
	},
	planeshop = {
		ShopEntering = {
			Pos = vector3(-941.273, -2954.613, 12.895),
			Size = vector3(1.5, 1.5, 1.0),
			Type = 1
		},
		ShopInside = {
			Pos = vector3(-960.377, -2986.138, 12.895),
			Size = vector3(1.5, 1.5, 1.0),
			Heading = -20.0,
			Type = -1
		},
		ShopOutside = {
			Pos = vector3(-985.222, -3014.081, 12.895),
			Size = vector3(1.5, 1.5, 1.0),
			Heading = 330.0,
			Type = -1
		},
		BossActions = {
			Pos = vector3(-941.433, -2954.402, 18.795),
			Size = vector3(1.5, 1.5, 1.0),
			Type = -1
		},
		GiveBackVehicle = {
			Pos = vector3(-971.208, -2951.747, 12.895),
			Size = vector3(3.0, 3.0, 1.0),
			Type = (ConfigConCess.EnablePlayerManagement and 1 or -1)
		},
		ResellVehicle = {
			Pos = vector3(-960.300, -3027.518, -120.895), -- -960.300, -3027.518, 12.895
			Size = vector3(3.0, 3.0, 1.0),
			Type = 1,
			bossOnly = true
		}
	},
	boatshop = {
		ShopEntering = {
			Pos = vector3(-805.7613, -1368.5695, 4.1783),
			Size = vector3(1.5, 1.5, 1.0),
			Type = 1
		},
		ShopInside = {
			Pos = vector3(-855.7906, -1372.5966, 12.8188),
			Size = vector3(1.5, 1.5, 1.0),
			Heading = 180.0,
			Type = -1
		},
		ShopOutside = {
			Pos = vector3(-855.7906, -1372.5966, 12.81880),
			Size = vector3(1.5, 1.5, 1.0),
			Heading = 180.0,
			Type = -1
		},
		BossActions = {
			Pos = vector3(-787.7404, -1350.5447, 4.1783),
			Size = vector3(1.5, 1.5, 1.0),
			Type = -1
		},
		GiveBackVehicle = {
			Pos = vector3(-843.8259, -1361.1572, -0.4755),
			Size = vector3(3.0, 3.0, 1.0),
			Type = (ConfigConCess.EnablePlayerManagement and 1 or -1)
		},
		ResellVehicle = {
			Pos = vector3(579.013, -3142.490, -100.250), -- 579.013, -3142.490, 0.250
			Size = vector3(3.0, 3.0, 1.0),
			Type = 1,
			bossOnly = true
		}
	}
}