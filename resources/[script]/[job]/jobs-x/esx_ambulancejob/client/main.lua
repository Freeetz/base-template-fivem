ESX = nil

local FirstSpawn, PlayerLoaded = true, false
local isDead, IsBusy = false, false

local cooldown = false
local cooldown2 = false
local HasAlreadyEnteredMarker = false
local LastZone = nil

local Ragdolle = false
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	PlayerLoaded = true
end)

-------------------- MENU --------------------------
local coma_menu_ems = false
local coma_menu = RageUI.CreateMenu("Coma", "Intéractions disponible :")
coma_menu.Closable = false
coma_menu.Closed = function()
    coma_menu_ems = false
	Ragdolle = false
	SetEntityInvincible(PlayerPedId(), false)
	SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function RespawnPedAmbulance(ped, spawn)
	SetEntityCoordsNoOffset(ped, spawn.coords, false, false, false, true)
	NetworkResurrectLocalPlayer(spawn.coords, spawn.heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', spawn)
	ClearPedBloodDamage(ped)
	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(_type)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if _type == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth , math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif _type == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	ESX.ShowNotification(_U('healed'))
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = ConfigAmbulance.RespawnDelay
		local timer2 = ConfigAmbulance.RespawnDelayVIP

		if exports['Freetz-Core']:GetVIP() then
			Citizen.Wait(0)
			timer2 = timer2 - 30
		else
			Citizen.Wait(0)
			timer = timer - 30
		end
	end)
end

function SendDistressSignal()
	-------------- ↓ LB Phone ↓ --------------

	local message = "Individu mort, sur la position GPS"
	local xPlayer = PlayerPedId()
	local coords = GetEntityCoords(xPlayer)

	exports["lb-phone"]:SendCompanyMessage('ambulance', message)
	exports["lb-phone"]:SendCompanyCoords('ambulance', coords)

	------------------------------------------
end

function RemoveItemsAfterRPDeath(respawnPed)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			ESX.SetPlayerData('', {})
			TriggerEvent('esx_status:resetStatus')

			if respawnPed then
				RespawnPedAmbulance(PlayerPedId(), {coords = ConfigAmbulance.Zones.HospitalInteriorInside1.Pos, heading = 0.0})
				AnimpostfxStop('DeathFailOut')
				DoScreenFadeIn(800)
			else
				ESX.Game.Teleport(PlayerPedId(), ConfigAmbulance.Zones.HospitalInteriorOutside1.Pos, function()
					DoScreenFadeIn(800)
				end)
			end
		end)
	end)
end

function TeleportFadeEffect(entity, coords)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)
	end)
end

function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped, false)
	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

	if distance ~= -1 and distance <= 5.0 then
		local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
		local freeSeat = nil

		for i = maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat ~= nil then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

function OpenAmbulanceActionsMenu()
	local elements = {
		{label = _U('cloakroom'), value = 'cloakroom'}
	}

	if ConfigAmbulance.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title = _U('ambulance'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenuAmbulance()
		end

		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu) end, {wash = false})
		end
	end, function(data, menu)
		CurrentAction = 'ambulance_actions_menu'
		CurrentActionMsg = _U('open_bossmenu')
		CurrentActionData = {}
	end)
end

function OpenCloakroomMenuAmbulance()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'}
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		if data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end
	end, function(data, menu)
	end)
end

function OpenVehicleSpawnerMenuAmbulance()
	ESX.UI.Menu.CloseAll()

	if ConfigAmbulance.EnableSocietyOwnedVehicles then
		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
			for i = 1, #vehicles, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model), rightlabel = {'[' .. vehicles[i].plate .. ']'}, value = vehicles[i]})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
				title = _U('veh_menu'),
				elements = elements
			}, function(data, menu)
				menu.close()

				local vehicleProps = data.current.value

				ESX.Game.SpawnVehicle(vehicleProps.model, ConfigAmbulance.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
				end)

				TriggerServerEvent('esx_society:removeVehicleFromGarage', 'ambulance', vehicleProps)
			end, function(data, menu)
				CurrentAction = 'vehicle_spawner_menu'
				CurrentActionMsg = _U('veh_spawn')
				CurrentActionData = {}
			end)
		end, 'ambulance')
	else
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			title = _U('veh_menu'),
			elements = ConfigAmbulance.AuthorizedVehicles
		}, function(data, menu)
			--menu.close()

			ESX.Game.SpawnVehicle(data.current.model, ConfigAmbulance.Zones.VehicleSpawnPoint.Pos, 230.0, function(vehicle)
				local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSMC')
				SetVehicleNumberPlateText(vehicle, newPlate)
				TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
			end)
		end, function(data, menu)
			CurrentAction = 'vehicle_spawner_menu'
			CurrentActionMsg = _U('veh_spawn')
			CurrentActionData = {}
		end)
	end
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title = _U('pharmacy_menu_title'),
		elements = ConfigAmbulance.RestockItems
	}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)
	end, function(data, menu)
		CurrentAction = 'pharmacy'
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	end)
end

AddEventHandler('playerSpawned', function()
	isDead = false

	if FirstSpawn then
		TriggerServerEvent('esx_ambulancejob:firstSpawn')
		FirstSpawn = false
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

--RegisterNetEvent('esx_phone:loaded')
--AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
--	local specialContact = {
--		name = 'Ambulance',
--		number = 'ambulance',
--		base64Icon = 'data:image/png;base64,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'
--	}
--
--	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
--end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 1)

	ShowDeathTimer()
	StartDistressSignal()

	if IsPedSittingInAnyVehicle(PlayerPedId()) then 
		ClearPedTasks(PlayerPedId())
	else
		ClearPedTasksImmediately(PlayerPedId())
	end
	--AnimpostfxPlay('DeathFailOut', 0, false)
	PlaySoundFrontend(-1, "Bed", "WastedSounds", true)
	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
	--SetEntityHealth(PlayerPedId(), 200)
	SetEntityInvincible(PlayerPedId(), true)
	Ragdolle = true
	Wait(500)
	OpenComaMenu()
end)

RegisterNetEvent('esx_ambulancejob:revive2')
AddEventHandler('esx_ambulancejob:revive2', function()

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
	TriggerEvent('esx_status:resetStatus')

	exports['pma-voice']:resetProximityCheck()
	TriggerEvent("esx_basicneeds:healPlayer")
	SetEntityInvincible(PlayerPedId(), false)
	SetEntityHealth(PlayerPedId(), 200)


	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	RespawnPedAmbulance(PlayerPedId(), {coords = coords, heading = 0.0})
	AnimpostfxStop('DeathFailOut')
	DoScreenFadeIn(800)


	--isDead = false
	Ragdolle = false
	coma_menu_ems = false
	RageUI.CloseAll()
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
	TriggerEvent('esx_status:resetStatus')

	exports['pma-voice']:resetProximityCheck()
	TriggerEvent("esx_basicneeds:healPlayer")
	SetEntityInvincible(PlayerPedId(), false)
	SetEntityHealth(PlayerPedId(), 200)


	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	RespawnPedAmbulance(PlayerPedId(), {coords = coords, heading = 0.0})
	AnimpostfxStop('DeathFailOut')
	DoScreenFadeIn(800)


	--isDead = false
	Ragdolle = false
	coma_menu_ems = false
	RageUI.CloseAll()

	-- ↓ ANIMATION DE REVIVE ↓ --

--[[ 	Wait(1000)
	local dict = "anim@scripted@heist@ig25_beach@male@"
  	RequestAnimDict(dict)
	repeat Wait(0) until HasAnimDictLoaded(dict)


  	local playerPed = PlayerPedId()
  	local playerPos = GetEntityCoords(PlayerPedId())
  	local playerHead = GetEntityHeading(PlayerPedId())
	
  	local scene = NetworkCreateSynchronisedScene(playerPos.x, playerPos.y, playerPos.z - 1, 0.0, 0.0, playerHead, 2, false, false, 8.0, 1000.0, 1.0)
  	NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, dict, "action", 1000.0, 8.0, 0, 0, 1000.0, 8192)
  	NetworkAddSynchronisedSceneCamera(scene, dict, "action_camera")
	
  	NetworkStartSynchronisedScene(scene)

	exports['pma-voice']:resetProximityCheck() ]]
end)

RegisterNetEvent('esx:reviveradius')
AddEventHandler('esx:reviveradius', function(radius)
	local playerPed = PlayerPedId()
	local xPlayers = ESX.GetPlayers()
	local coords = GetEntityCoords(xPlayers, false)

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local people = ESX.GetPlayers(GetEntityCoords(playerPed, false), radius)

		for i = 1, #people, 1 do
			local attempt = 0

			--while not attempt < 100 do
				--Citizen.Wait(100)
				--NetworkRequestControlOfEntity(vehicles[i])
				--attempt = attempt + 1
			--end

			--if DoesEntityExist(people[i]) then
			TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
			TriggerEvent('esx_status:resetStatus')
			
			Citizen.CreateThread(function()
				DoScreenFadeOut(800)
			
				while not IsScreenFadedOut() do
					Citizen.Wait(0)
				end
			
				RespawnPedAmbulance(xPlayers, {coords = coords, heading = 0.0})
				AnimpostfxStop('DeathFailOut')
				DoScreenFadeIn(800)
			end)
		end
		--end
	--[[else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.Game.DeleteVehicle(vehicle)
		end]]
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(zone)
	if zone == 'HospitalInteriorEntering1' then
		--TeleportFadeEffect(PlayerPedId(), ConfigAmbulance.Zones.HospitalInteriorInside1.Pos)
	end

	if zone == 'HospitalInteriorExit1' then
		--TeleportFadeEffect(PlayerPedId(), ConfigAmbulance.Zones.HospitalInteriorOutside1.Pos)
	end

	if zone == 'HospitalInteriorEntering2' then
		local heli = ConfigAmbulance.HelicopterSpawner

		if not IsAnyVehicleNearPoint(heli.SpawnPoint, 6.0) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
			ESX.Game.SpawnVehicle('polmav', {
				x = -646.5390,
				y = 319.3656,
				z = 141.9593
			}, 186.4418, function(vehicle)
				SetVehicleModKit(vehicle, 0)
				SetVehicleLivery(vehicle, 1)
			end)
		end

		--TeleportFadeEffect(PlayerPedId(), ConfigAmbulance.Zones.HospitalInteriorInside2.Pos)
	end

	if zone == 'HospitalInteriorExit2' then
		--TeleportFadeEffect(PlayerPedId(), ConfigAmbulance.Zones.HospitalInteriorOutside2.Pos)
	end

	if zone == 'AmbulanceActions' then
		CurrentAction = 'ambulance_actions_menu'
		CurrentActionMsg = _U('open_bossmenu')
		CurrentActionData = {}
	end

	if zone == 'VehicleSpawner' then
		CurrentAction = 'vehicle_spawner_menu'
		CurrentActionMsg = _U('veh_spawn')
		CurrentActionData = {}
	end

	if zone == 'Pharmacy' then
		CurrentAction = 'pharmacy'
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	end

	if zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

			if distance ~= -1 and distance <= 10.0 then
				CurrentAction = 'delete_vehicle'
				CurrentActionMsg = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end

	if zone == 'VehicleDeleter2' then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

			if distance ~= -1 and distance <= 10.0 then
				CurrentAction = 'delete_vehicle'
				CurrentActionMsg = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end
end)

function FastTravel(pos)
	TeleportFadeEffect(PlayerPedId(), pos)
end

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create blips
--Citizen.CreateThread(function()
--	local blip = AddBlipForCoord(ConfigAmbulance.Blip.Pos)

--	SetBlipSprite(blip, ConfigAmbulance.Blip.Sprite)
--	SetBlipDisplay(blip, ConfigAmbulance.Blip.Display)
--	SetBlipScale(blip, 0.8)
--	SetBlipColour(blip, 4)
--	SetBlipAsShortRange(blip, true)

--	--BeginTextCommandSetBlipName("STRING")
--	AddTextComponentSubstringPlayerName(_U('hospital'))
--	EndTextCommandSetBlipName(blip)
--end)

Citizen.CreateThread(function() 
	local blip = AddBlipForCoord(-678.74, 298.42, 82.17)
		SetBlipSprite  (blip, 61)
		SetBlipDisplay (blip, 4)
		SetBlipScale   (blip, 0.8)
		SetBlipColour  (blip, 2)
		SetBlipAsShortRange(blip, true) 
		BeginTextCommandSetBlipName('STRING') 
		AddTextComponentSubstringPlayerName("E.M.S")
		EndTextCommandSetBlipName(blip)
		SetBlipCategory(blip, 99)
		SetBlipCategory(blip, 10)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local coords = GetEntityCoords(PlayerPedId(), false)

		for k, v in pairs(ConfigAmbulance.Zones) do
			if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos, true) < ConfigAmbulance.DrawDistance) then
				interval = 0
				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, vector3(5.0, 5.0, 1.0), ConfigAmbulance.MarkerColor.r, ConfigAmbulance.MarkerColor.g, ConfigAmbulance.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				elseif k ~= 'AmbulanceActions' and k ~= 'VehicleSpawner' and k ~= 'VehicleDeleter' and k ~= 'Pharmacy' then
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, vector3(5.0, 5.0, 1.0), ConfigAmbulance.MarkerColor.r, ConfigAmbulance.MarkerColor.g, ConfigAmbulance.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end

		Wait(interval)
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local coords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local currentZone = nil

		for k, v in pairs(ConfigAmbulance.Zones) do
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
				if #(coords - v.Pos) < ConfigAmbulance.MarkerSize.x then
					isInMarker = true
					currentZone = k
				end
			elseif k ~= 'AmbulanceActions' and k ~= 'VehicleSpawner' and k ~= 'VehicleDeleter' and k ~= 'Pharmacy' then
				if #(coords - v.Pos) < ConfigAmbulance.MarkerSize.x then
					isInMarker = true
					currentZone = k
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone = currentZone
			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_ambulancejob:hasExitedMarker', lastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentSubstringPlayerName(CurrentActionMsg)
			EndTextCommandDisplayHelp(0, 0, 1, -1)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
				if CurrentAction == 'ambulance_actions_menu' then
					OpenAmbulanceActionsMenu()
				end

				if CurrentAction == 'vehicle_spawner_menu' then
					OpenVehicleSpawnerMenuAmbulance()
				end

				if CurrentAction == 'pharmacy' then
					OpenPharmacyMenu()
				end

				if CurrentAction == 'fast_travel_goto_top' or CurrentAction == 'fast_travel_goto_bottom' then
					FastTravel(CurrentActionData.pos)
				end

				if CurrentAction == 'delete_vehicle' then
					if ConfigAmbulance.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'ambulance', vehicleProps)
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				CurrentAction = nil
			end
		end

		--if (IsControlJustReleased(0, 167) or IsDisabledControlJustReleased(0, 167)) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not isDead then
		--	WarMenu.OpenMenu('ambulancemenu')
		--end
	end
end)

RegisterNetEvent('esx_ambulancejob:requestDeath')
AddEventHandler('esx_ambulancejob:requestDeath', function()
	--if ConfigAmbulance.AntiCombatLog then
	while not PlayerLoaded and FirstSpawn do
		Citizen.Wait(1000)
	end
--
--		
--		ESX.ShowNotification(_U('combatlog_message'))
--		TriggerEvent("ws_deathtimeout:died")
--		RemoveItemsAfterRPDeath(false)
	--else
		--local playerPed = PlayerPedId()
		--SetEntityHealth(playerPed, 0)
		--isDead = true 
		--ShowDeathTimer()
		--StartDistressSignal()
	
		--ClearPedTasksImmediately(PlayerPedId())
		--AnimpostfxPlay('DeathFailOut', 0, false)
		--PlaySoundFrontend(-1, "Bed", "WastedSounds", true)
		--ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
		--TriggerServerEvent('freetz:AltF4')
	--end
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t, i = {}, 1

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

RegisterCommand("revive2", function(source, args)
	--local xPlayer = ESX.GetPlayerFromId(source)
	--if xPlayer.getGroup() ~= 'user' then
		if args[1] == nil then 
			return 
		end
		if exports.AdminMenu:GetStaffMode() then
			local player = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), tonumber(args[1]))
			for i = 1, #player do
	  			ExecuteCommand("revive " ..GetPlayerServerId(player[i]))
			end
		else
			ESX.ShowNotification("~r~Vous devez avoir votre mode staff d\'activer pour faire ceci !")
		end
	--else
	--	TriggerClientEvent('iNotificationV3:showNotification', source, "Vous devez faire parti de l\'équipe de modération afin d\'utilisez cette commande !")
	--end
end)

RegisterCommand("f6ambulance", function(source)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not isDead then
		WarMenu.OpenMenu('ambulancemenu')
	end
end)

RegisterKeyMapping("f6ambulance", "Menu Intéraction - E.M.S", "keyboard", "F6")

local respawnTimer = nil 
local respawnTimer2 = nil 
local allowRespawn = nil 
local allowRespawn2 = nil

function ShowDeathTimer()
	respawnTimer = ConfigAmbulance.RespawnDelay / 1000
	respawnTimer2 = ConfigAmbulance.RespawnDelayVIP / 1000
	allowRespawn = respawnTimer / 2
	allowRespawn2 = respawnTimer2 / 2

	--scaleform = ESX.Scaleform.Utils.RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

	--piggyBackInProgress = true
	--BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	--BeginTextCommandScaleformString("STRING")
	--AddTextComponentSubstringPlayerName("~r~Vous êtes dans le coma")
	--EndTextCommandScaleformString()
	--EndScaleformMovieMethod()

	--PlaySoundFrontend(-1, "TextHit", "WastedSounds", true)

	Citizen.CreateThread(function()
		while respawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if exports['Freetz-Core']:GetVIP() then
				if respawnTimer2 > 0 then
					respawnTimer2 = respawnTimer2 - 1
				end
			else
				if respawnTimer > 0 then
					respawnTimer = respawnTimer - 1
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		while isDead do 
			DisableControlAction(0, 311, true) -- K
			DisableControlAction(0, 246, true) -- Y
			DisableControlAction(0, 289, true) -- F2
			DisableControlAction(0, 57, true) -- F10
			DisableControlAction(0, 74, true) -- H
			Wait(1)
		end
	end)
end

---------------------------------------------------------------------

function OpenComaMenu()
    if coma_menu_ems then 
        coma_menu_ems = false 
        RageUI.Visible(coma_menu, false)
        return
    else
        coma_menu_ems = true
        RageUI.Visible(coma_menu, true)
        Citizen.CreateThread(function()
            while coma_menu_ems do 

				if Ragdolle then
					SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
					SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
					exports['pma-voice']:overrideProximityCheck(function(player)
						return false
					end)
				end

				Citizen.Wait(1)

                RageUI.IsVisible(coma_menu, function()

					RageUI.Line()

					RageUI.Button('Envoyer un message aux E.M.S', nil, {RightLabel = "→→→"}, not cooldown, {
                        onSelected = function()
                            cooldown = true
							ESX.ShowNotification("~r~Message envoyé au E.M.S disponible !")
							SendDistressSignal()
                            Citizen.SetTimeout(720000, function() cooldown = false end)
                        end
                    })

					if exports['Freetz-Core']:GetVIP() then
						if respawnTimer2 <= allowRespawn2 then
							RageUI.Button('Réapparaitre à l\'hopital', "~g~1 Chance sur 10~s~ de perdre vos armes & objets illégaux.", {RightLabel = "→→→"}, allowRespawn2, {
                    		    onSelected = function()
									TriggerEvent('esx_ambulancejob:revive2')
									Ragdolle = false 
									SetEntityInvincible(PlayerPedId(), false)
									ESX.ShowNotification("Vous venez d\'etre réanimer de ~r~force~s~ par les interne !")
									Citizen.Wait(1000)
									SetEntityCoords(PlayerPedId(), -671.4615, 326.8440, 83.0832)
									exports['pma-voice']:resetProximityCheck()
									TriggerServerEvent('freetz:remove:item', source)
									isDead = false
									RespawnPedAmbulance(PlayerPedId(), {coords = ConfigAmbulance.Zones.HospitalInteriorInside1.Pos, heading = 0.0})
									RageUI.CloseAll()
                    		    end
                    		})
						else
							RageUI.Button('Réapparaitre à l\'hopital', "~g~1 Chance sur 10~s~ de perdre vos armes & objets illégaux.", {RightLabel = "→→→"}, false, {
                    		    onSelected = function()
                    		    end
                    		})
					    end
					else
						if respawnTimer <= allowRespawn then
							RageUI.Button('Réapparaitre à l\'hopital', "~g~1 Chance sur 10~s~ de perdre vos armes & objets illégaux.", {RightLabel = "→→→"}, allowRespawn, {
                    		    onSelected = function()
									TriggerEvent('esx_ambulancejob:revive2')
									Ragdolle = false 
									SetEntityInvincible(PlayerPedId(), false)
									ESX.ShowNotification("Vous venez d\'etre réanimer de ~r~force~s~ par les interne !")
									Citizen.Wait(1000)
									SetEntityCoords(PlayerPedId(), -671.4615, 326.8440, 83.0832)
									exports['pma-voice']:resetProximityCheck()
									isDead = false
									RespawnPedAmbulance(PlayerPedId(), {coords = ConfigAmbulance.Zones.HospitalInteriorInside1.Pos, heading = 0.0})
									RageUI.CloseAll()
                    		    end
                    		})
						else
							RageUI.Button('Réapparaitre à l\'hopital', "~g~1 Chance sur 10~s~ de perdre vos armes & objets illégaux.", {RightLabel = "→→→"}, false, {
								onSelected = function()
								end
							})
						end
					end

					if exports['Freetz-Core']:GetVIP() then
						RageUI.Separator("~r~".. secondsToClock(respawnTimer2).."~s~ minutes avant réanimation" )
					else
						RageUI.Separator("~r~".. secondsToClock(respawnTimer).."~s~ minutes avant réanimation" )
					end

					RageUI.Line()

				end)
			end
		end)
	end
end

-------------------------------------------------------------- 