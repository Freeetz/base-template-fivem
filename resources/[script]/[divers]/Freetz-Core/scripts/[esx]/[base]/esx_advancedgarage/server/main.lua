TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.execute('UPDATE owned_vehicles SET state = true WHERE state = false', {}, function(rowsChanged)
		if rowsChanged > 0 then
			--print(('esx_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
		end
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOwnedProperties', function(source, cb)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = ESX.GetIdentifierFromId(source)
	}, function(data)
		for k, v in pairs(data) do
			table.insert(properties, v.name)
		end

		cb(properties)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'aircraft'
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, {vehicle = vehicle, state = v.state, plate = v.plate})
		end

		cb(ownedAircrafts)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOwnedBoats', function(source, cb)
	local ownedBoats = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'boat'
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, {vehicle = vehicle, state = v.state, plate = v.plate})
		end

		cb(ownedBoats)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'car'
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, state = v.state, plate = v.plate})
		end

		cb(ownedCars)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:storeVehicle', function(source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match('^%s*(.-)%s*$')
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)

			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner'] = ESX.GetIdentifierFromId(source),
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function(rowsChanged)
					if rowsChanged == 0 then
						--print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(ESX.GetIdentifierFromId(source)))
					end

					cb(true)
				end)
			else
				--print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(ESX.GetIdentifierFromId(source)))
				DropPlayer(source, _U('custom_kick'))
				cb(false)
			end
		else
			--print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(ESX.GetIdentifierFromId(source)))
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND state = @state', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'aircraft',
		['@state'] = false
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, vehicle)
		end

		cb(ownedAircrafts)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedBoats', function(source, cb)
	local ownedBoats = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND state = @state', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'boat',
		['@state'] = false
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, vehicle)
		end

		cb(ownedBoats)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND state = @state', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'car',
		['@state'] = false
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, vehicle)
		end

		cb(ownedCars)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAircrafts', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('cash').money >= ConfigAdvancedGarage.AircraftPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyBoats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('cash').money >= ConfigAdvancedGarage.BoatPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyCars', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('cash').money >= ConfigAdvancedGarage.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_advancedgarage:payAircraft')
AddEventHandler('esx_advancedgarage:payAircraft', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('cash', ConfigAdvancedGarage.AircraftPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. ConfigAdvancedGarage.AircraftPoundPrice)
end)

RegisterServerEvent('esx_advancedgarage:payBoat')
AddEventHandler('esx_advancedgarage:payBoat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('cash', ConfigAdvancedGarage.BoatPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. ConfigAdvancedGarage.BoatPoundPrice)
end)

RegisterServerEvent('esx_advancedgarage:payCar')
AddEventHandler('esx_advancedgarage:payCar', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('cash', ConfigAdvancedGarage.CarPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. ConfigAdvancedGarage.CarPoundPrice)
end)

RegisterServerEvent('esx_advancedgarage:payhealth')
AddEventHandler('esx_advancedgarage:payhealth', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('cash', price)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. price)
end)

RegisterServerEvent('esx_advancedgarage:setVehicleState')
AddEventHandler('esx_advancedgarage:setVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET state = @state WHERE plate = @plate', {
		['@state'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			--print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)