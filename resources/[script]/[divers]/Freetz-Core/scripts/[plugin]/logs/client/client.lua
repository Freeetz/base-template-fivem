ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

--Aim Logs
Citizen.CreateThread(function()
    local lastPedAimed
    while true do
        Citizen.Wait(1000)
        local letSleep = true
        local playerPed = PlayerPedId()
		local exist, weapon = GetCurrentPedWeapon(PlayerPedId()) 

        if DoesEntityExist(playerPed) then
            if IsPedArmed(playerPed, 4) then
                letSleep = false

                local isAiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
                if isAiming and targetPed ~= lastPedAimed then
                    lastPedAimed = targetPed

                    if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
                        if IsPedAPlayer(targetPed) then
                            local targetId = NetworkGetPlayerIndexFromPed(targetPed)

                            if targetId then
                                local pedId = GetPlayerServerId(targetId)
                                
                                if pedId and (pedId > 0) then
                                    TriggerServerEvent('freetz:aimlogs', pedId)
                                end
                            end
                        end
                    end
                end
            end
        end

        if letSleep then
            Wait(1000)
        end
    end 
end)

local playerArmor = 0

Citizen.CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon

	while true do
        local sleep = true
		Citizen.Wait(1000)
		
		if IsEntityDead(PlayerPedId()) then
            sleep = false
			Citizen.Wait(500)
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
			Weapon = WeaponNames[tostring(DeathCauseHash)]

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end
			
			if (Killer == PlayerId()) then
				DeathReason = 'committed suicide'
			elseif (Killer == nil) then
				DeathReason = 'died'
			else
				if IsMelee(DeathCauseHash) then
					DeathReason = 'Assassiné'
				elseif IsTorch(DeathCauseHash) then
					DeathReason = 'Incendié'
				elseif IsKnife(DeathCauseHash) then
					DeathReason = 'Poignardé'
				elseif IsPistol(DeathCauseHash) then
					DeathReason = 'Tué au pistolet'
				elseif IsSub(DeathCauseHash) then
					DeathReason = 'criblé'
				elseif IsRifle(DeathCauseHash) then
					DeathReason = 'Mitraillé'
				elseif IsLight(DeathCauseHash) then
					DeathReason = 'Mitraillé'
				elseif IsShotgun(DeathCauseHash) then
					DeathReason = 'Pulvériser'
				elseif IsSniper(DeathCauseHash) then
					DeathReason = 'Snipé'
				elseif IsHeavy(DeathCauseHash) then
					DeathReason = 'Effacé'
				elseif IsMinigun(DeathCauseHash) then
					DeathReason = 'Déchiqueté'
				elseif IsBomb(DeathCauseHash) then
					DeathReason = 'Bombardé'
				elseif IsVeh(DeathCauseHash) then
					DeathReason = 'Fauché'
				elseif IsVK(DeathCauseHash) then
					DeathReason = 'aplati'
				else
					DeathReason = 'Tué (Raison Inconnu)'
				end
			end
			
			if DeathReason == 'committed suicide' or DeathReason == 'died' then
				TriggerServerEvent('freetz:killlogs', '``'.. GetPlayerName(PlayerId()) .. '`` ' .. DeathReason .. '.', Weapon)
			else
				if Weapon == nil then
					TriggerServerEvent('freetz:killlogs', '\n**Tueur** : ``'.. GetPlayerName(Killer) .. '`` - ID : ``'..GetPlayerServerId(Killer).. '`` \n**Raison** : ' .. DeathReason .. '\n **Joueur tué** : ``' .. GetPlayerName(PlayerId()) .. '`` - ID : ``'..GetPlayerServerId(PlayerId())..'``', "Arme Inconnu")
				else
					TriggerServerEvent('freetz:killlogs', '\n**Tueur** : ``'.. GetPlayerName(Killer) .. '`` - ID : ``'..GetPlayerServerId(Killer).. '`` \n**Raison** : ' .. DeathReason .. '\n **Joueur tué** : ``' .. GetPlayerName(PlayerId()) .. '`` - ID : ``'..GetPlayerServerId(PlayerId())..'``', Weapon)
				end
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		else
			playerArmor = GetPedArmour(PlayerPedId())
		end
		
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(0)
		end

        if sleep then Wait(500) end
	end
end)

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Poing',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Couteau',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Matraque',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Batte',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Club de Golf',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Pied De Biche',
	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistolet',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Pistolet de Combat (L.S.P.D)',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'Pistolet Perforant',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol Cal.50',
	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Uzi',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'P-90',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'AK-47',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carabine (L.S.P.D)',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Fusil Avancé (L.S.P.D)',
	[tostring(GetHashKey('WEAPON_TACTICALRIFLE'))] = 'Fusil Tactique (L.S.P.D)',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Tazer (L.S.P.D)',
	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Sniper',
	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Percuté en voiture',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Pistolet Lourd',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'G-36',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Mousquet',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'ADP De Combat',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'AK-47 Compact',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Revolver Lourd',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Feu',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Fusil Bull Pup',
	[tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
    [tostring(GetHashKey('WEAPON_AKG'))] = 'AKG',
    [tostring(GetHashKey('WEAPON_FOOL'))] = 'FOOL',
    [tostring(GetHashKey('WEAPON_T9ACC'))] = 'T9ACC',
    [tostring(GetHashKey('WEAPON_STG'))] = 'STG',
    [tostring(GetHashKey('WEAPON_MDR'))] = 'MDR',
    [tostring(GetHashKey('WEAPON_FNFAL'))] = 'FNFAL',
    [tostring(GetHashKey('WEAPON_M4A4'))] = 'M4A4',
    [tostring(GetHashKey('WEAPON_BEOWULF'))] = 'BEOWUFL',
    [tostring(GetHashKey('WEAPON_ACR'))] = 'ACR',
    [tostring(GetHashKey('WEAPON_HK516'))] = 'HK516',
    [tostring(GetHashKey('WEAPON_MPX'))] = 'MPX',
    [tostring(GetHashKey('WEAPON_FAMAS'))] = 'FAMAS',
    [tostring(GetHashKey('WEAPON_CBQ'))] = 'CBQ',
    [tostring(GetHashKey('WEAPON_BIZON'))] = 'BIZON',
    [tostring(GetHashKey('WEAPON_BARSKA'))] = 'BARSKA',
    [tostring(GetHashKey('WEAPON_AUG'))] = 'AUG',
    [tostring(GetHashKey('WEAPON_AK102'))] = 'AK-102',
    [tostring(GetHashKey('WEAPON_AK12'))] = 'AK-12',
    [tostring(GetHashKey('WEAPON_AUGA'))] = 'AUGA',
    [tostring(GetHashKey('WEAPON_M16A1'))] = 'M16A1',
    [tostring(GetHashKey('WEAPON_SCARMK17'))] = 'SCARMK-17',
    [tostring(GetHashKey('WEAPON_M203'))] = 'M203',
    [tostring(GetHashKey('WEAPON_ISY'))] = 'ISY',
    [tostring(GetHashKey('WEAPON_REDISY'))] = 'FIRED ISY',
    [tostring(GetHashKey('WEAPON_MARINE'))] = 'MARINE',
    [tostring(GetHashKey('WEAPON_L119A2'))] = 'L119A2',
    [tostring(GetHashKey('WEAPON_AK117'))] = 'AK-117',
    [tostring(GetHashKey('WEAPON_MINIAK'))] = 'MINIAK',
    [tostring(GetHashKey('WEAPON_G36K'))] = 'G36K',
    [tostring(GetHashKey('WEAPON_MILITERYSMG'))] = 'Military SMG',
    [tostring(GetHashKey('WEAPON_M13'))] = 'M133',
    [tostring(GetHashKey('WEAPON_AKM'))] = 'AKM',
    [tostring(GetHashKey('WEAPON_G36C'))] = 'G36C',
    [tostring(GetHashKey('WEAPON_RPK'))] = 'RPK',
    [tostring(GetHashKey('WEAPON_SUNDA2'))] = 'SUNDA2',
    [tostring(GetHashKey('WEAPON_SUNDA'))] = 'SUNDA',
    [tostring(GetHashKey('WEAPON_SAKURA'))] = 'SAKURA',
    [tostring(GetHashKey('WEAPON_GRAU'))] = 'GRAU',
    [tostring(GetHashKey('WEAPON_M4A5'))] = 'M4A5',
    [tostring(GetHashKey('WEAPON_HK43'))] = 'HK43',
    [tostring(GetHashKey('WEAPON_HK416'))] = 'HK416',
    [tostring(GetHashKey('WEAPON_SIG516'))] = 'SIG516',
    [tostring(GetHashKey('WEAPON_DRAGON'))] = 'DRAGON',
    [tostring(GetHashKey('WEAPON_CZ75'))] = 'CZ75',
    [tostring(GetHashKey('WEAPON_FENNEC'))] = 'FENNEC',
    [tostring(GetHashKey('WEAPON_MAC10'))] = 'MAC10',
    [tostring(GetHashKey('WEAPON_PHANTOM'))] = 'PHANTOM',
    [tostring(GetHashKey('WEAPON_MP40'))] = 'MP40',
    [tostring(GetHashKey('WEAPON_BTR'))] = 'BTR',
    [tostring(GetHashKey('WEAPON_IA2'))] = 'IA2',
    [tostring(GetHashKey('WEAPON_M4A8'))] = 'M4A8',
    [tostring(GetHashKey('WEAPON_SCAR'))] = 'SCAR',
    [tostring(GetHashKey('WEAPON_VECTOR45'))] = 'VECTOR45',
    [tostring(GetHashKey('WEAPON_P90'))] = 'P90',
    [tostring(GetHashKey('WEAPON_TAR'))] = 'TAR',
	[tostring(GetHashKey('WEAPON_KTR'))] = 'KTR',
    [tostring(GetHashKey('WEAPON_M4'))] = 'M4',
    [tostring(GetHashKey('WEAPON_RTD'))] = 'RTD',
    [tostring(GetHashKey('WEAPON_AR15'))] = 'AR15',

	[tostring(GetHashKey('WEAPON_CASH'))] = 'Argent',
	[tostring(GetHashKey('WEAPON_SHOES'))] = 'Chaussures',
	[tostring(GetHashKey('WEAPON_BOOK'))] = 'Livres',
	[tostring(GetHashKey('WEAPON_THROWABLEBOTTLES'))] = 'Bouteille Jetable',
	[tostring(GetHashKey('WEAPON_BRICK'))] = 'Brique',
}