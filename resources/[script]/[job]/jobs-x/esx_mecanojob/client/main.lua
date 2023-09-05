local PlayerData = {}

local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local CurrentlyTowedVehicle = nil

local Blips = {}
local JobBlips = {}

local NPCOnJob = false
local NPCTargetTowable = nil
local NPCTargetTowableZone = nil
local NPCHasSpawnedTowable = false
local NPCLastCancel = GetGameTimer() - 5 * 60000
local NPCHasBeenNextToTowable = false
local NPCTargetDeleterZone = false

local IsDead = false
local IsBusy = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	deleteBlips()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	deleteBlips()
	refreshBlips()
end)

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #ConfigMecano.Towables)

	for k,v in pairs(ConfigMecano.Zones) do
		if v.Pos.x == ConfigMecano.Towables[index].x and v.Pos.y == ConfigMecano.Towables[index].y and v.Pos.z == ConfigMecano.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone = ConfigMecano.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] ~= nil then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] ~= nil then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	ConfigMecano.Zones.VehicleDelivery.Type = -1

	NPCOnJob = false
	NPCTargetTowable = nil
	NPCTargetTowableZone = nil
	NPCHasSpawnedTowable = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	end
end

function OpenMecanoActionsMenu()
	local elements = {
		{label = _U('vehicle_list'), value = 'vehicle_list'},
		{label = _U('work_wear'), value = 'cloakroom'},
		{label = _U('civ_wear'), value = 'cloakroom2'},
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'}
	}

	if ConfigMecano.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_actions', {
		title = _U('mechanic'),
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vehicle_list' then
			if ConfigMecano.EnableSocietyOwnedVehicles then
				local elements = {}

				ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
					for i = 1, #vehicles, 1 do
						table.insert(elements, {
							label = GetDisplayNameFromVehicleModel(vehicles[i].model),
							rightlabel = {'[' .. vehicles[i].plate .. ']'},
							value = vehicles[i]
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
						title = _U('service_vehicle'),
						elements = elements
					}, function(data, menu)
						menu.close()
						local vehicleProps = data.current.value

						ESX.Game.SpawnVehicle(vehicleProps.model, ConfigMecano.Zones.VehicleSpawnPoint.Pos, ConfigMecano.Zones.VehicleSpawnPoint.Heading, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
						end)

						TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mecano', vehicleProps)
					end, function(data, menu)
					end)
				end, 'mecano')
			else
				local elements = {
					{label = _U('flat_bed'), value = 'flatbed'},
					{label = _U('tow_truck'), value = 'towtruck2'}
				}

				if ConfigMecano.EnablePlayerManagement and PlayerData.job ~= nil and (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'chef' or PlayerData.job.grade_name == 'experimente') then
					table.insert(elements, {label = 'SlamVan', value = 'slamvan3'})
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
					title = _U('service_vehicle'),
					elements = elements
				}, function(data, menu)
					if ConfigMecano.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data.current.value, ConfigMecano.Zones.VehicleSpawnPoint.Pos, ConfigMecano.Zones.VehicleSpawnPoint.Heading, function(vehicle)
							local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('MECA')
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
							SetVehicleNumberPlateText(vehicle, newPlate)
							TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
						end)
					else
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if canTakeService then
								ESX.Game.SpawnVehicle(data.current.value, ConfigMecano.Zones.VehicleSpawnPoint.Pos, ConfigMecano.Zones.VehicleSpawnPoint.Heading, function(vehicle)
									local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('MECA')
									local playerPed = PlayerPedId()
									TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
									SetVehicleNumberPlateText(vehicle, newPlate)
									TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
								end)
							else
								ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
							end
						end, 'mecano')
					end

					menu.close()
				end, function(data, menu)
				end)
			end
		elseif data.current.value == 'cloakroom' then
			menu.close()
			setUniform("mecano_wear", playerPed)
		elseif data.current.value == 'cloakroom2' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mecano', function(data, menu) end)
		end
	end, function(data, menu)
		CurrentAction = 'mecano_actions_menu'
		CurrentActionMsg = _U('open_actions')
		CurrentActionData = {}
	end)
end

function OpenMecanoHarvestMenu()
	if ConfigMecano.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('gas_can'), value = 'gaz_bottle'},
			{label = _U('repair_tools'), value = 'fix_tool'},
			{label = _U('body_work_tools'), value = 'caro_tool'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_harvest', {
			title = _U('harvest'),
			elements = elements
		}, function(data, menu)
			if data.current.value == 'gaz_bottle' then
				menu.close()
				TriggerServerEvent('esx_mecanojob:startHarvest')
			elseif data.current.value == 'fix_tool' then
				menu.close()
				TriggerServerEvent('esx_mecanojob:startHarvest2')
			elseif data.current.value == 'caro_tool' then
				menu.close()
				TriggerServerEvent('esx_mecanojob:startHarvest3')
			end
		end, function(data, menu)
			CurrentAction = 'mecano_harvest_menu'
			CurrentActionMsg = _U('harvest_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMecanoCraftMenu()
	if ConfigMecano.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then

		local elements = {
			{label = _U('blowtorch'),  value = 'blow_pipe'},
			{label = _U('repair_kit'), value = 'fix_kit'},
			{label = _U('body_kit'),   value = 'caro_kit'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecano_craft', {
			title = _U('craft'),
			elements = elements
		}, function(data, menu)
			if data.current.value == 'blow_pipe' then
				menu.close()
				TriggerServerEvent('esx_mecanojob:startCraft')
			elseif data.current.value == 'fix_kit' then
				menu.close()
				TriggerServerEvent('esx_mecanojob:startCraft2')
			elseif data.current.value == 'caro_kit' then
				menu.close()
				TriggerServerEvent('esx_mecanojob:startCraft3')
			end
		end, function(data, menu)
			CurrentAction = 'mecano_craft_menu'
			CurrentActionMsg = _U('craft_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_mecanojob:getStockItems', function(items)
		local elements = {}

		for i = 1, #items, 1 do
			table.insert(elements, {
				label = items[i].label,
				rightlabel = {'(' .. items[i].count .. ')'},
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = _U('mechanic_stock'),
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mecanojob:getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_mecanojob:getPlayerInventory', function(inventory)
		local elements = {}

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label,
					rightlabel = {'(' .. item.count .. ')'},
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = _U('inventory'),
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mecanojob:putStockItems', itemName, count)

					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

RegisterNetEvent('esx_mecanojob:onHijack')
AddEventHandler('esx_mecanojob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_mecanojob:onCarokit')
AddEventHandler('esx_mecanojob:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_mecanojob:onFixkit')
AddEventHandler('esx_mecanojob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			ExecuteCommand("répare le véhicule")
			exports['progressBars']:startUI(40000, "Vous réparez le véhicule..")
			Citizen.CreateThread(function()
				Citizen.Wait(40000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	refreshBlips()
end)

AddEventHandler('esx_mecanojob:hasEnteredMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'MecanoActions' then
		CurrentAction = 'mecano_actions_menu'
		CurrentActionMsg = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction = 'mecano_harvest_menu'
		CurrentActionMsg = _U('harvest_menu')
		CurrentActionData = {}
	elseif zone == 'Craft' then
		CurrentAction = 'mecano_craft_menu'
		CurrentActionMsg = _U('craft_menu')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			CurrentAction = 'delete_vehicle'
			CurrentActionMsg = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_mecanojob:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	elseif zone == 'Craft' then
		TriggerServerEvent('esx_mecanojob:stopCraft')
		TriggerServerEvent('esx_mecanojob:stopCraft2')
		TriggerServerEvent('esx_mecanojob:stopCraft3')
	elseif zone == 'Garage' then
		TriggerServerEvent('esx_mecanojob:stopHarvest')
		TriggerServerEvent('esx_mecanojob:stopHarvest2')
		TriggerServerEvent('esx_mecanojob:stopHarvest3')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mecanojob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction = 'remove_entity'
		CurrentActionMsg = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end
end)

AddEventHandler('esx_mecanojob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

-- Create Blips
function deleteBlips()
	if JobBlips[1] ~= nil then
		for i = 1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	if PlayerData.job ~= nil then
		for k, v in pairs(ConfigMecano.Blips) do
			if v.isMecanoOnly then
				if PlayerData.job.name == 'mecano' then
					local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

					SetBlipSprite(blip, v.Sprite)
					SetBlipDisplay(blip, 4)
					SetBlipScale(blip, v.Scale)
					SetBlipColour(blip, 5)
					SetBlipAsShortRange(blip, true)

					
					AddTextComponentSubstringPlayerName(v.Name)
					EndTextCommandSetBlipName(blip)

					table.insert(JobBlips, blip)
				end
			else
					local blip3 = AddBlipForCoord(-238.2166, -1327.5105, 31.2965)
						SetBlipSprite  (blip3, 446)
						SetBlipDisplay (blip3, 4)
						SetBlipScale   (blip3, 0.8)
						SetBlipColour  (blip3, 5)
						SetBlipAsShortRange(blip3, true) 
						BeginTextCommandSetBlipName('STRING') 
						AddTextComponentSubstringPlayerName("Benny's")
						EndTextCommandSetBlipName(blip3) 
						SetBlipCategory(blip3, 10)
						--SetBlipCategory(blip3, 2)
			end
		end
	end
end

-- Display markers
Citizen.CreateThread(function()
	while true do
		local Interval= 2500
		if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			local coords = GetEntityCoords(PlayerPedId(), false)

			for k, v in pairs(ConfigMecano.Zones) do
				if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 30) then
					Interval = 0
					if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < ConfigMecano.DrawDistance) then
						DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					end
				end
			end
		end

		Wait(Interval)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		local Interval = 2500

		if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			local coords = GetEntityCoords(PlayerPedId(), false)
			local isInMarker = false
			local currentZone = nil

			for k, v in pairs(ConfigMecano.Zones) do
				if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 30) then
					Interval = 0
					if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
						isInMarker = true
						currentZone = k
					end
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				Interval = 0
				HasAlreadyEnteredMarker = true
				LastZone = currentZone
				TriggerEvent('esx_mecanojob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				Interval = 0
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mecanojob:hasExitedMarker', LastZone)
			end
		end

		Wait(Interval)
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		local Interval = 2000

		if CurrentAction ~= nil then
			Interval = 0
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
				if CurrentAction == 'mecano_actions_menu' then
					OpenMecanoActionsMenu()
				elseif CurrentAction == 'mecano_harvest_menu' then
					OpenMecanoHarvestMenu()
				elseif CurrentAction == 'mecano_craft_menu' then
					OpenMecanoCraftMenu()
				elseif CurrentAction == 'delete_vehicle' then
					if ConfigMecano.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'mecano', vehicleProps)
					else
						if
							GetEntityModel(vehicle) == `flatbed` or
							GetEntityModel(vehicle) == `towtruck2` or
							GetEntityModel(vehicle) == `slamvan3`
						then
							TriggerServerEvent('esx_service:disableService', 'mecano')
						end
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end

		Wait(Interval)
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function()
	IsDead = false
end)

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if ConfigMecano.Uniforms[job].male then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigMecano.Uniforms[job].male)
				ESX.ShowAdvancedNotification("Mécano", "~h~Prise de service~s~", "Vous avez ~r~pris~s~ votre service", "CHAR_MECHANIC", 1)
			else
				ESX.ShowAdvancedNotification("Mécano", "Tenue de travail", "~r~Aucun uniforme~s~ à votre taille", "CHAR_MECHANIC", 1)
			end
		else
			if ConfigMecano.Uniforms[job].female then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigMecano.Uniforms[job].female)
				ESX.ShowAdvancedNotification("Mécano", "~h~Prise de service~s~", "Vous avez ~r~pris~s~ votre service", "CHAR_MECHANIC", 1)
			else
				ESX.ShowAdvancedNotification("Mécano", "Tenue de travail", "~r~Aucun uniforme~s~ à votre taille", "CHAR_MECHANIC", 1)
			end
		end
	end)
end