ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[ ESX.RegisterServerCallback('euk-carlock:requestPlayerCars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end) ]]

ESX.RegisterServerCallback('euk-carlock:requestPlayerCars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not (plate) then 
		return 
	end

	MySQL.Async.fetchAll(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate', 
		{
			['@plate'] = plate
		},
	function(result)
		if #result >= 1 then 
			if result[1].owner == xPlayer.identifier then
				cb(true)
			end
		else
			cb(false)
		end
	end)
end)


--[[ RegisterServerEvent('freetz:GiveCleTempo')
AddEventHandler('freetz:GiveCleTempo', function(plate, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehicleData = {}

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, state, carseller) VALUES (@owner, @plate, @vehicle, @type, @state, @carseller)', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate,
		['@vehicle'] = json.encode(vehicleData),
		['@type'] = 'car',
		['@state'] = 1,
		['@carseller'] = 0,
	}, function()
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Freetz Commu", '~b~Clés', 'Vous avez reçu un double de clé ', 'CHAR_CARLIFORNIA', 7)
	end)
end) ]]