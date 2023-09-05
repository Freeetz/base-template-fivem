ConfigPolice = {}
ConfigPolice.Locale = 'fr'

ConfigPolice.DrawDistance = 25.0
ConfigPolice.MarkerType = 1
ConfigPolice.MarkerColor = { r = 14, g = 138, b = 0 }
ConfigPolice.MarkerSize = vector3(1.5, 1.5, 1.0)

ConfigPolice.EnablePlayerManagement = true
ConfigPolice.EnableArmoryManagement = true
ConfigPolice.EnableESXIdentity = true -- enable if you're using esx_identity
ConfigPolice.EnableNonFreemodePeds = true -- turn this on if you want custom peds
ConfigPolice.EnableSocietyOwnedVehicles = false
ConfigPolice.EnableLicenses = true -- enable if you're using esx_license

ConfigPolice.EnableHandcuffTimer = true -- enable handcuff timer? will unrestrain player after the time ends
ConfigPolice.HandcuffTimer = 10 * 60000 -- 10 mins

ConfigPolice.EnableJobBlip = true -- enable blips for colleagues, requires esx_society

ConfigPolice.MaxInService = -1
ConfigPolice.PoliceStations = {
	LSPD = {
		Blip = {
			Pos = vector3(431.8424, -981.6880, 30.7107),
			Sprite = 60,
			Display = 4,
			Scale = 0.8,
			Colour = 4
		},
		Cloakrooms = {
			vector3(450.8365, -992.5054, 29.6896)
		},
		Armories = {
			vector3(452.1006, -980.2886, 29.6896)
		},
		Vehicles = {
			{
				Spawner = vector3(473.1105, -1018.0317, 28.0885), 
				SpawnPoint = vector3(477.4363, -1021.3508, 28.0287),
				Heading = 270.2363
			}
		},
		Helicopters = { -- FAIT
			{
				Spawner = vector3(462.8514, -984.0670, 43.6919), 
				SpawnPoint = vector3(449.1586, -981.3587, 43.6917),
				Heading = 344.8360
			}
		},
		VehicleDeleters = {
			vector3(485.1886, -1020.7260, 26.8749),
			vector3(448.9539, -981.2246, 42.6916) -- FAIT
		},
		BossActions = {
			vector3(448.2367, -973.2461, 30.6896) -- FAIT
		}
	}
}

ConfigPolice.Menu = {
	armurerieItems = {
		{Name = "Carabine d'assault", value = "", price = ""}
	}
}

ConfigPolice.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, nil }, price = 10000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 1500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 80 }
	},
	officer = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, nil }, price = 10000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	sergeant = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, nil }, price = 10000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	intendent = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	lieutenant = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	chef = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	boss = {
		{ weapon = 'WEAPON_CARBINERIFLE', components = { 0, 6000, 1000, 4000, nil }, price = 120000 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	}
}

ConfigPolice.AuthorizedVehicles = {
	recruit = {
		{ model = 'scorcher', label = 'Vélo'},
		{ model = 'police3', label = 'Dodge'},
		{ model = 'policeb', label = 'Moto'},
		{ model = 'police2', label = 'Buffalo'}
	},
	officer = {
		{ model = 'scorcher', label = 'Vélo'},
		{ model = 'police3', label = 'Dodge'},
		{ model = 'policeb', label = 'Moto'},
		{ model = 'police2', label = 'Buffalo'},
		{ model = 'policet', label = 'Camion Blindé'}
	},
	sergeant = {
		{ model = 'scorcher', label = 'Vélo'},
		{ model = 'polgs350', label = 'Véhicule à Haute Vitesse'},
		{ model = 'police3', label = 'Dodge'},
		{ model = 'policeb', label = 'Moto'},
		{ model = 'police2', label = 'Buffalo'},
		{ model = 'policet', label = 'Camion Blindé'}
	},
	chef = {
		{ model = 'scorcher', label = 'Vélo'},
		{ model = 'polgs350', label = 'Véhicule à Haute Vitesse'},
		{ model = 'poldom', label = 'GTX L.S.P.D'},
		{ model = 'police3', label = 'Dodge'},
		{ model = 'policeb', label = 'Moto'},
		{ model = 'police2', label = 'Buffalo'},
		{ model = 'policet', label = 'Camion Blindé'}
	},
	lieutenant = {
		{ model = 'scorcher', label = 'Vélo'},
		{ model = 'polgs350', label = 'Véhicule à Haute Vitesse'},
		{ model = 'apolicec6', label = 'Porsche L.S.P.D'},
		{ model = 'poldom', label = 'GTX L.S.P.D'},
		{ model = 'ghispo2', label = 'V.I.R'},
		{ model = 'police3', label = 'Dodge'},
		{ model = 'policeb', label = 'Moto'},
		{ model = 'police2', label = 'Buffalo'},
		{ model = 'policet', label = 'Camion Blindé'}
	},
	intendent = {
		{ model = 'scorcher', label = 'Vélo'},
		{ model = 'polgs350', label = 'Véhicule à Haute Vitesse'},
		{ model = 'apolicec6', label = 'Porsche L.S.P.D'},
		{ model = 'poldom', label = 'GTX L.S.P.D'},
		{ model = 'nkgauntlet4', label = 'Gauntlet L.S.P.D'},
		{ model = 'riot', label = 'R.I.O.T'},
		{ model = 'ghispo2', label = 'V.I.R'},
		{ model = 'police3', label = 'Dodge'},
		{ model = 'policeb', label = 'Moto'},
		{ model = 'police2', label = 'Buffalo'},
		{ model = 'policet', label = 'Camion Blindé'}
	},
	boss = {
		{ model = 'scorcher', label = 'Vélo'},
		{ model = 'riot', label = 'R.I.O.T'},
		{ model = 'polgs350', label = 'Véhicule à Haute Vitesse'},
		{ model = 'apolicec6', label = 'Porsche L.S.P.D'},
		{ model = 'poldom', label = 'GTX L.S.P.D'},
		{ model = 'nkgauntlet4', label = 'Gauntlet L.S.P.D'},
		{ model = 'ghispo2', label = 'V.I.R'},
		{ model = 'police3', label = 'Dodge'},
		{ model = 'policeb', label = 'Moto'},
		{ model = 'police2', label = 'Buffalo'},
		{ model = 'policet', label = 'Camion Blindé'}
	}
}

ConfigPolice.Uniforms = {
	recruit_wear = {
		male = {
            ['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 303,   ['torso_2'] = 25,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 145,
            ['pants_1'] = 105,   ['pants_2'] = 2,
            ['shoes_1'] = 116,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 29,  ['bproof_2'] = 0,
            ['bag_1'] = 30,  ['bag_2'] = 0 
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	officer_wear = {
		male = {
            ['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 303,   ['torso_2'] = 25,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 145,
            ['pants_1'] = 105,   ['pants_2'] = 2,
            ['shoes_1'] = 116,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bag_1'] = 30,  ['bag_2'] = 0 
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	sergeant_wear = {
		male = {
            ['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 303,   ['torso_2'] = 25,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 145,
            ['pants_1'] = 105,   ['pants_2'] = 2,
            ['shoes_1'] = 116,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bag_1'] = 30,  ['bag_2'] = 0 
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	intendent_wear = {
		male = {
            ['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 303,   ['torso_2'] = 25,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 145,
            ['pants_1'] = 105,   ['pants_2'] = 2,
            ['shoes_1'] = 116,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bag_1'] = 30,  ['bag_2'] = 0 
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	lieutenant_wear = {
		male = {
            ['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 303,   ['torso_2'] = 25,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 145,
            ['pants_1'] = 105,   ['pants_2'] = 2,
            ['shoes_1'] = 116,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bag_1'] = 30,  ['bag_2'] = 0 
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	chef_wear = {
		male = {
            ['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 303,   ['torso_2'] = 25,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 145,
            ['pants_1'] = 105,   ['pants_2'] = 2,
            ['shoes_1'] = 116,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bag_1'] = 30,  ['bag_2'] = 0 
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	boss_wear = {
		male = {
			['tshirt_1'] = 82,  ['tshirt_2'] = 0,
			['torso_1'] = 206,   ['torso_2'] = 0,
			['decals_1'] = 73,   ['decals_2'] = 0,
			['arms'] = 145,
			['pants_1'] = 133,   ['pants_2'] = 1,
			['shoes_1'] = 90,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 45,  ['bproof_2'] = 0,
			['bag_1'] = 0,  ['bag_2'] = 0
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 49,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 113,  ['helmet_2'] = 7,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	emeute_wear = {
		male = {
			['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 263,   ['torso_2'] = 7,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 143,
            ['pants_1'] = 133,   ['pants_2'] = 2,
            ['shoes_1'] = 90,   ['shoes_2'] = 0,
            ['helmet_1'] = 152,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 5,  ['bproof_2'] = 2,
            ['bag_1'] = 30,  ['bag_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	inter_wear = {
		male = {
			['tshirt_1'] = 82,  ['tshirt_2'] = 0,
			['torso_1'] = 333,   ['torso_2'] = 0,
			['decals_1'] = 73,   ['decals_2'] = 0,
			['arms'] = 143,
			['pants_1'] = 112,   ['pants_2'] = 2,
			['shoes_1'] = 90,   ['shoes_2'] = 0,
			['helmet_1'] = 210,  ['helmet_2'] = 0,
			['chain_1'] = 238,    ['chain_2'] = 2,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 29,     ['mask_2'] = 1,
			['bproof_1'] = 33,  ['bproof_2'] = 0,
			['bag_1'] = 30,  ['bag_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 42,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 122,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 56,     ['mask_2'] = 1,
			['bproof_1'] = 18,  ['bproof_2'] = 2
		}
	},
 	ceremonie_wear = {
		male = {
			['tshirt_1'] = 82,  ['tshirt_2'] = 0,
            ['torso_1'] = 313,   ['torso_2'] = 25,
            ['decals_1'] = 73,   ['decals_2'] = 0,
            ['arms'] = 141,
            ['pants_1'] = 105,   ['pants_2'] = 2,
            ['shoes_1'] = 116,   ['shoes_2'] = 0,
            ['helmet_1'] = 106,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['mask_1'] = 0,     ['mask_2'] = 0,
            ['bproof_1'] = 45,  ['bproof_2'] = 0,
            ['bag_1'] = 0,  ['bag_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 12,  ['bproof_2'] = 1
		}
	},
	bullet_wear1 = {
		male = {
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 29,  ['tshirt_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 0
		}
	},
	gilet_wear1 = {
		male = {
			['tshirt_1'] = 0,  ['tshirt_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0
		}
	}
}