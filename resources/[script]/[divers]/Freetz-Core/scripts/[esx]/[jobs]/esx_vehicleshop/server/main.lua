local Categories = {}
local Vehicles = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k, v in pairs(ConfigConCess.Society) do
	TriggerEvent('esx_society:registerSociety', k, v.label, 'society_' .. k, 'society_' .. k, 'society_' .. k, {type = 'private'})
end

Citizen.CreateThread(function()
	local char = ConfigConCess.PlateLetters
	char = char + ConfigConCess.PlateNumbers

	if ConfigConCess.PlateUseSpace then
		char = char + 1
	end

	if char > 8 then
		--print(('esx_vehicleshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, function(result)
		Categories = result

		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result2)
			local vehicles = result2

			for i = 1, #vehicles, 1 do
				for j = 1, #Categories, 1 do
					if Categories[j].name == vehicles[i].category then
						vehicles[i].categoryLabel = Categories[j].label
						break
					end
				end

				table.insert(Vehicles, vehicles[i])
			end

			TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Categories)
			TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles)
		end)
	end)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwned')
AddEventHandler('esx_vehicleshop:setVehicleOwned', function(vehicleProps, vehicleType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	--print(xPlayer.identifier)
	--print(vehicleProps.plate)
	--print(json.encode(vehicleProps))
	--print(vehicleType)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type'] = vehicleType
	}, function(rowsChanged)
	end)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(playerId, vehicleProps, vehicleType)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type'] = vehicleType
	}, function(rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, "Le véhicule avec la plaque ~y~".. vehicleProps.plate .."~s~ est désormais à ~b~vous~s~", "Informations")
	end)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedSociety')
AddEventHandler('esx_vehicleshop:setVehicleOwnedSociety', function(society, vehicleProps, vehicleType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
		['@owner'] = 'society:' .. society,
		['@plate'] = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type'] = vehicleType
	})
end)

RegisterServerEvent('esx_vehicleshop:sellVehicle')
AddEventHandler('esx_vehicleshop:sellVehicle', function(vehicle)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function(result)
		if result[1] ~= nil then
			local id = result[1].id

			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
				['@id'] = id
			})
		end
	end)
end)

RegisterServerEvent('esx_vehicleshop:addToList')
AddEventHandler('esx_vehicleshop:addToList', function(target, model, plate, society)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
	local dateNow = os.date('%Y-%m-%d %H:%M')

	MySQL.Async.execute('INSERT INTO vehicle_sold (client, model, plate, soldby, date, society) VALUES (@client, @model, @plate, @soldby, @date, @society)', {
		['@client'] = xTarget.getName(),
		['@model'] = model,
		['@plate'] = plate,
		['@soldby'] = xPlayer.getName(),
		['@date'] = dateNow,
		['@society'] = society
	})
end)

ESX.RegisterServerCallback('esx_vehicleshop:getSoldVehicles', function(source, cb, society)
	MySQL.Async.fetchAll('SELECT * FROM vehicle_sold WHERE society = @society ORDER BY vehicle_sold.date DESC', {
		['@society'] = society
	}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_vehicleshop:rentVehicle')
AddEventHandler('esx_vehicleshop:rentVehicle', function(vehicle, plate, playerName, basePrice, rentPrice, target, society)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function (result)
		local id = result[1].id
		local price = result[1].price
		local owner = xPlayer.identifier

		MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
			['@id'] = id
		})

		MySQL.Async.execute('INSERT INTO rented_vehicles (vehicle, plate, player_name, base_price, rent_price, owner, society) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner, @society)', {
			['@vehicle'] = vehicle,
			['@plate'] = plate,
			['@player_name'] = playerName,
			['@base_price'] = basePrice,
			['@rent_price'] = rentPrice,
			['@owner'] = owner,
			['@society'] = society
		})
	end)
end)

RegisterServerEvent('esx_vehicleshop:getStockItem')
AddEventHandler('esx_vehicleshop:getStockItem', function(job, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retiré ~y~".. count .."~s~ ~b~".. inventoryItem.label .." !")
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n\'avez ~r~pas~s~ assez ~y~d\'espace~s~ dans votre inventaire!")
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Il n\'y à plus assez ~r~de cet objet~s~ dans la societé!")
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getStockItems', function(source, cb, job)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_vehicleshop:putStockItems')
AddEventHandler('esx_vehicleshop:putStockItems', function(job, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer ~y~".. count .."~s~ ~b~".. ESX.GetItem(itemName).label .." !")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Le montant est invalide")
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb({items = xPlayer.inventory})
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function(source, cb, vehicleModel)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehicleData = nil

	for i = 1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if xPlayer.getAccount('cash').money >= vehicleData.price then
		xPlayer.removeAccountMoney('cash', vehicleData.price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicleSociety', function(source, cb, society, vehicleModel)
	local vehicleData = nil

	for i = 1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
		if account.money >= vehicleData.price then
			account.removeMoney(vehicleData.price)

			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price, society) VALUES (@vehicle, @price, @society)', {
				['@vehicle'] = vehicleData.model,
				['@price'] = vehicleData.price,
				['@society'] = society
			}, function(rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function(source, cb, society)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE society = @society ORDER BY vehicle ASC', {
		['@society'] = society
	}, function(result)
		local vehicles = {}

		for i = 1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				price = result[i].price
			})
		end

		cb(vehicles)
	end)
end)

RegisterServerEvent('esx_vehicleshop:returnProvider')
AddEventHandler('esx_vehicleshop:returnProvider', function(vehicleModel)
	local _source = source

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function(result)
		if result[1] then
			local id = result[1].id
			local price = ESX.Math.Round(result[1].price * 0.75)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(price)
			end)

			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
				['@id'] = id
			})

			TriggerClientEvent('esx:showNotification', _source, "Le ~r~".. vehicleModel .."~s~ a été vendu pour ~g~".. ESX.Math.GroupDigits(price).."~s~ !")
		else
			--print(('esx_vehicleshop: %s attempted selling an invalid vehicle!'):format(ESX.GetIdentifierFromId(_source)))
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getRentedVehicles', function(source, cb, society)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE society = @society ORDER BY player_name ASC', {
		['@society'] = society
	}, function(result)
		local vehicles = {}

		for i = 1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				plate = result[i].plate,
				playerName = result[i].player_name
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:giveBackVehicle', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then
			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price, society) VALUES (@vehicle, @price, @society)', {
				['@vehicle'] = result[1].vehicle,
				['@price'] = result[1].basePrice,
				['@society'] = result[1].society
			})

			MySQL.Async.execute('DELETE FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			})

			RemoveOwnedVehicle(plate)
			cb(true)
		else
			cb(false)
		end
	end)
end)

--[[
ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function(source, cb, plate, model)
	local resellPrice = 0

	for i = 1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * ConfigConCess.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		print(('esx_vehicleshop: %s attempted to sell an unknown vehicle!'):format(ESX.GetIdentifierFromId(source)))
		cb(false)
	end

	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(false)
		else
			local xPlayer = ESX.GetPlayerFromId(source)

			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
				['@owner'] = xPlayer.identifier,
				['@plate'] = plate
			}, function(result)
				if result[1] then
					local vehicle = json.decode(result[1].vehicle)

					if vehicle.model == model then
						if vehicle.plate == plate then
							xPlayer.addAccountMoney('cash', resellPrice)
							RemoveOwnedVehicle(plate)
							cb(true)
						else
							print(('esx_vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
							cb(false)
						end
					else
						print(('esx_vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
						cb(false)
					end
				else
					if xPlayer.job.grade_name == 'boss' then
						MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
							['@owner'] = 'society:' .. xPlayer.job.name,
							['@plate'] = plate
						}, function(result)
							if result[1] then
								local vehicle = json.decode(result[1].vehicle)

								if vehicle.model == model then
									if vehicle.plate == plate then
										xPlayer.addAccountMoney('cash', resellPrice)
										RemoveOwnedVehicle(plate)
										cb(true)
									else
										print(('esx_vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
										cb(false)
									end
								else
									print(('esx_vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
									cb(false)
								end
							else
								cb(false)
							end
						end)
					else
						cb(false)
					end
				end
			end)
		end
	end)
end)
]]

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET state = @state WHERE plate = @plate AND job = @job', {
		['@state'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			--print(('esx_vehicleshop: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles', {}, function(result)
		for i = 1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)

			if xPlayer then
				xPlayer.removeAccountMoney('bank', result[i].rent_price)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez ~g~payé~s~ votre location de véhicule : ~g~".. ESX.Math.GroupDigits(result[i].rent_price) .."$ ~s~! ")
			else
				MySQL.Async.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', {
					['@bank'] = result[i].rent_price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. result[i].society, function(account)
				account.addMoney(result[i].rent_price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 00, PayRent)

RegisterServerEvent('Freetz:OuvertureConcess')
AddEventHandler('Freetz:OuvertureConcess', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'CONCESSIONAIRE VOITURE', '~b~Annonce CONCESSIONAIRE', 'Nous sommes actuellement ~g~ouvert~s~ !', 'CHAR_ABIGAIL', 8)
    end
end)

RegisterServerEvent('Freetz:FermetureConcess')
AddEventHandler('Freetz:FermetureConcess', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'CONCESSIONAIRE VOITURE', '~b~Annonce CONCESSIONAIRE', 'Nous sommes actuellement ~r~fermé~s~ !', 'CHAR_ABIGAIL', 8)
    end
end)

RegisterServerEvent('Freetz:RecrutementConcess')
AddEventHandler('Freetz:RecrutementConcess', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'CONCESSIONAIRE VOITURE', '~b~Annonce CONCESSIONAIRE', 'Nous sommes actuellement à la recherche de nouveaux employés, vous etes intéressez par ce poste ? Venez vite au concessionaire!', 'CHAR_ABIGAIL', 8)
    end
end)

function sendWebhook(message,color,url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"]=message,
            ["type"]="rich",
            --["color"] =red,
            ["footer"]=  {
                ["text"]= "For Freetz Commu RolePlay - 2023/2024",
            },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "Logs Concess Facture - Freetz Commu",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('freetz:logs:concess:facture')
AddEventHandler('freetz:logs:concess:facture', function(prix)
	sendWebhook(("L'utilisateur %s vient de facturer ".. prix .."$ à un joueur !"):format(GetPlayerName(source)), "red", "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
end)