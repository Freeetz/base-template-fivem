AddTextEntry('BLIP_PROPCAT', '~b~Entreprises~s~ ')
local PlayerData = {}
local GUI = {}
GUI.Time = 0

local HasAlreadyEnteredMarker = false
local LastZone = nil

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

	PlayerData = ESX.GetPlayerData()
end)

function SetVehicleMaxMods(vehicle)
	local props = {
		color1 = 142,
		color2 = 111,
		modEngine = 3,
		modBrakes = 3,
		modTransmission = 3,
		modSuspension = 3,
		modTurbo = true
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0.0)
end

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title = _U('cloakroom'),
		elements = {
			{label = _U('vine_clothes_civil'), value = 'citizen_wear'},
			{label = _U('vine_clothes_vine'), value = 'avocat_wear'}
		}
	}, function(data, menu)
		cleanPlayer(PlayerPedId())

		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		if data.current.value == 'avocat_wear' then
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

function OpenAvocatActionsMenu()
	local elements = {
		{label = _U('cloakroom'), value = 'cloakroom'},
		{label = _U('deposit_stock'), value = 'put_stock'}
	}

	if ConfigAvocat.EnablePlayerManagement and PlayerData.job ~= nil and (PlayerData.job.grade_name ~= 'recrue' and PlayerData.job.grade_name ~= 'novice') then -- ConfigAvocat.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss'
		table.insert(elements, {label = _U('take_stock'), value = 'get_stock'})
	end
	
	if ConfigAvocat.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then -- ConfigAvocat.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss'
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'avocat_actions', {
		title = 'Avocat',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		end

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		end

		if data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'avocat', function(data, menu) end)
		end
	end, function(data, menu)
		CurrentAction = 'avocat_actions_menu'
		CurrentActionMsg = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()

	if ConfigAvocat.EnableSocietyOwnedVehicles then
		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
			for i = 1, #vehicles, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model), rightlabel = {'[' .. vehicles[i].plate .. ']'}, value = vehicles[i]})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
				title = _U('veh_menu'),
				elements = elements,
			}, function(data, menu)
				menu.close()

				local vehicleProps = data.current.value

				ESX.Game.SpawnVehicle(vehicleProps.model, ConfigAvocat.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
				end)

				TriggerServerEvent('esx_society:removeVehicleFromGarage', 'avocat', vehicleProps)
			end, function(data, menu)
				CurrentAction = 'vehicle_spawner_menu'
				CurrentActionMsg = _U('spawn_veh')
				CurrentActionData = {}
			end)
		end, 'avocat')
	else
		local elements = {
			{label = 'Véhicule de Travail',  value = 'schafter2'},
		}
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			title = _U('veh_menu'),
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.Game.SpawnVehicle(data.current.value, ConfigAvocat.Zones.VehicleSpawnPoint.Pos, 56.326, function(vehicle)
				local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('AVOC')
				SetVehicleNumberPlateText(vehicle, newPlate)
				TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
				SetVehicleMaxMods(vehicle)
			end)
		end, function(data, menu)
			CurrentAction = 'vehicle_spawner_menu'
			CurrentActionMsg = _U('spawn_veh')
			CurrentActionData = {}
		end)
	end
end

function OpenMobileAvocatActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_avocat_actions', {
		title = 'avocat',
		elements = {
			{label = _U('billing'), value = 'billing'}
		}
	}, function(data, menu)
		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data2, menu2)
				local amount = tonumber(data2.value)

				if amount == nil or amount <= 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu2.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_near'))
					else
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_avocat', 'Avocat', amount)
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_avocatjob:getStockItems', function(items)
		local elements = {}

		for i = 1, #items, 1 do
			if (items[i].count ~= 0) then
				table.insert(elements, {label = items[i].label, rightlabel = {'(' .. items[i].count .. ')'}, value = items[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Avocat Stock',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil or count <= 0 then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					OpenGetStocksMenu()
					TriggerServerEvent('esx_avocatjob:getStockItem', data.current.value, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_avocatjob:getPlayerInventory', function(inventory)
		local elements = {}

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label, rightlabel = {'(' .. item.count .. ')'}, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = _U('inventory'),
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil or count <= 0 then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					OpenPutStocksMenu()
					TriggerServerEvent('esx_avocatjob:putStockItems', data.current.value, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler('esx_avocatjob:hasEnteredMarker', function(zone)
	if zone == 'AvocatActions' and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then
		CurrentAction = 'avocat_actions_menu'
		CurrentActionMsg = _U('press_to_open')
		CurrentActionData = {}
	end
	
	if zone == 'VehicleSpawner' and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then
		CurrentAction = 'vehicle_spawner_menu'
		CurrentActionMsg = _U('spawn_veh')
		CurrentActionData = {}
	end
		
	if zone == 'VehicleDeleter' and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)
		
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

			if distance ~= -1 and distance <= 1.0 then
				CurrentAction = 'delete_vehicle'
				CurrentActionMsg = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end
end)

AddEventHandler('esx_avocatjob:hasExitedMarker', function(zone)
	CurrentAction = nil
	CurrentActionMsg = nil
	CurrentActionData = {}
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		local Sleep = 1000
		local coords = GetEntityCoords(PlayerPedId(), false)

		for k, v in pairs(ConfigAvocat.Zones) do
			if PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then
				if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos, true) < ConfigAvocat.DrawDistance) then
					Sleep = 0
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		Wait(Sleep)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		local Interval = 2500

		if PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then
			local coords = GetEntityCoords(PlayerPedId(), false)
			local isInMarker = false
			local currentZone = nil

			for k, v in pairs(ConfigAvocat.Zones) do
				if (GetDistanceBetweenCoords(coords, v.Pos, true) < 50) then
					Interval = 0
					if (GetDistanceBetweenCoords(coords, v.Pos, true) < v.Size.x) then
						isInMarker = true
						currentZone = k
					end
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				Interval = 0
				HasAlreadyEnteredMarker = true
				LastZone = currentZone
				TriggerEvent('esx_avocatjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				Interval = 0
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_avocatjob:hasExitedMarker', LastZone)
			end
		end

		Wait(Interval)
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	blips()

	while true do
		local Interval = 2500

		if CurrentAction ~= nil then
			Interval = 0
			SetTextComponentFormat('STRING')
			AddTextComponentSubstringPlayerName(CurrentActionMsg)
			EndTextCommandDisplayHelp(0, 0, 1, -1)

			if IsControlPressed(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'avocat_actions_menu' then
					OpenAvocatActionsMenu()
				end

				if CurrentAction == 'vehicle_spawner_menu' then
					OpenVehicleSpawnerMenu()
				end

				if CurrentAction == 'delete_vehicle' then
					if ConfigAvocat.EnableSocietyOwnedVehicles then
						local vehicle   = GetVehiclePedIsIn(playerPed,  false)
						local plate = GetVehicleNumberPlateText(vehicle)
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'avocat', vehicleProps)
						TriggerServerEvent('esx_vehiclelock:deletekeyjobs', 'no', plate) --vehicle lock
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
					TriggerServerEvent('esx_vehiclelock:deletekeyjobs', 'no', plate) --vehicle lock
				end

				CurrentAction = nil
				GUI.Time = GetGameTimer()
			end
		end

		Wait(Interval)
	end
end)

--RegisterCommand("f6avocat", function(source)
--	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'avocat' and not isDead then
--		OpenMobileAvocatActionsMenu()
--	end
--end)

--RegisterKeyMapping("f6avocat", "Menu Intéraction - Avocat", "keyboard", "F6")