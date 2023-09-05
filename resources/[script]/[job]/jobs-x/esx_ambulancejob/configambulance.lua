ConfigAmbulance = {}
ConfigAmbulance.Locale = 'fr'

ConfigAmbulance.DrawDistance = 25.0
ConfigAmbulance.MarkerColor = { r = 15, g = 160, b = 7 }
ConfigAmbulance.MarkerSize = vector3(1.5, 1.5, 1.0)

ConfigAmbulance.ReviveReward = 8000
ConfigAmbulance.AntiCombatLog = true

ConfigAmbulance.RespawnDelay = 12 * 60000
ConfigAmbulance.RespawnDelayVIP = 6 * 60000

ConfigAmbulance.EnablePlayerManagement = true
ConfigAmbulance.EnableSocietyOwnedVehicles = false

ConfigAmbulance.RemoveWeaponsAfterRPDeath = false
ConfigAmbulance.RemoveCashAfterRPDeath = false
ConfigAmbulance.RemoveItemsAfterRPDeath = false

ConfigAmbulance.GradeForRevive = 'support'

ConfigAmbulance.ShowDeathTimer = true

ConfigAmbulance.Blip = {
	Pos = vector3(-678.74, 298.42, 82.17),
	Sprite = 61,
	Display = 4,
	Scale = 1.2,
	Colour = 2
}

ConfigAmbulance.HelicopterSpawner = {
	SpawnPoint = vector3(-687.2, 321.49, 140.15),
	Heading = 338.14
}
--
ConfigAmbulance.AuthorizedVehicles = {
	{
		model = 'dodgeems',
		label = 'Dodge Ambulance'
	},
	{
		model = 'ems',
		label = 'Voiture E.M.S'
	},
	{
		model = 'lsambulance',
		label = 'Ambulance'
	},
	{
		model = 'ambulance22',
		label = 'Camion E.M.S'
	}
}

ConfigAmbulance.Zones = {
	HospitalInteriorEntering2 = {
		Pos = vector3(-664.5696, 320.6164, 140.1487), -- spawn helico
		Type = 1
	},
	AmbulanceActions = {
		Pos = vector3(-673.3946, 353.0100, 82.0836),
		Type = 1
	},
	VehicleSpawner = {
		Pos = vector3(-660.2372, 353.7002, 76.7684),
		Type = 1
	},
	VehicleSpawnPoint = {
		Pos = vector3(-668.3569, 346.4816, 77.7072),
		Type = -1
	},
	VehicleDeleter = {
		Pos = vector3(-686.2642, 347.0845, 76.7072),
		Type = 1
	},
	VehicleDeleter2 = {
		Pos = vector3(-646.5342, 319.4692, 141.9593),
		Type = 1
	},
	Pharmacy = {
		Pos = vector3(-663.3329, 319.9117, 82.0835),
		Type = 1
	}
}

ConfigAmbulance.RestockItems = {
	{label = _U('pharmacy_take'), rightlabel = {_('medikit')}, value = 'medikit'},
	{label = _U('pharmacy_take'), rightlabel = {_('bandage')}, value = 'bandage'},
	{label = _U('pharmacy_take'), rightlabel = {'GHB'}, value = 'piluleoubli'}
}

ConfigAmbulance.VIPWeapons = {
	['WEAPON_APPISTOL'] = true,
	['WEAPON_SPECIALCARBINE'] = true,
	['WEAPON_COMBATPDW'] = true,
	['WEAPON_ASSAULTRIFLE'] = true,
	['WEAPON_HEAVYSHOTGUN'] = true,
	['WEAPON_HEAVYSNIPER'] = true,
	['WEAPON_SAWNOFFSHOTGUN'] = true,
	['WEAPON_MILITARYRIFLE'] = true,
	['WEAPON_COMBATPISTOL'] = true,
	['WEAPON_STUNGUN'] = true,
	['WEAPON_ADVANCEDRIFLE'] = true,
	['WEAPON_PUMPSHOTGUN'] = true,
	['WEAPON_NIGHTSTICK'] = true,
	['WEAPON_CARBINERIFLE'] = true,
	['WEAPON_TACTICALRIFLE'] = true,
	['WEAPON_NAVYREVOLVER'] = true,
	['WEAPON_GUSENBERG'] = true,
	['WEAPON_PRECISIONRIFLE'] = true,
	['WEAPON_DOUBLEACTION'] = true,
	['WEAPON_MAZE'] = true,
	['WEAPON_SCAR17'] = true,
	['WEAPON_MILITARM4'] = true,
	['WEAPON_KINETIC'] = true,
	['WEAPON_BLACKSNIPER'] = true,
	['WEAPON_SHOTGUNK'] = true,
	['WEAPON_HELLSNIPER'] = true,
	['WEAPON_HELL'] = true,
	['WEAPON_SPECIALHAMMER'] = true,
	['WEAPON_HELLDOUBLEACTION'] = true
}