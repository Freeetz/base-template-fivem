TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local status = false

if ConfigTaxi.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', ConfigTaxi.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'taxi' then
		math.randomseed(GetGameTimer())
		local total = math.random(ConfigTaxi.NPCJobEarnings.min, ConfigTaxi.NPCJobEarnings.max);
		local societyAccount = nil

		if xPlayer.job.grade >= 3 then
			total = total * 2
		end

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
			societyAccount = account
		end)

		if societyAccount ~= nil then
			local playerMoney = math.floor(total / 100 * 750)
			local societyMoney = math.floor(total / 100 * 1500)

			xPlayer.addAccountMoney('cash', playerMoney)
			societyAccount.addMoney(societyMoney)

			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('have_earned') .. playerMoney)
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('comp_earned') .. societyMoney)
		else
			xPlayer.addAccountMoney('cash', total)
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('have_earned') .. total)
		end
	end
end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. inventoryItem.label)
			else
				TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('player_cannot_hold'))
			end
		else
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. ESX.GetItem(itemName).label)
		else
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb({items = xPlayer.inventory})
end)

function GetStatusTaxi()
	return status 
end

RegisterServerEvent('AnnonceOuvertTAXI')
AddEventHandler('AnnonceOuvertTAXI', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'Taxi', '~b~Annonce Taxi', 'Nos chauffeurs sont actuellement ~g~Disponible~s~ !', 'CHAR_TAXI', 8)
    end
end)

RegisterServerEvent('AnnonceRecrutementTAXI')
AddEventHandler('AnnonceRecrutementTAXI', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'Taxi', '~b~Annonce Taxi', 'Nos chauffeurs sont actuellement ~r~Indisponible~s~ !', 'CHAR_TAXI', 8)
    end
end)

RegisterServerEvent('AnnonceFermerTAXI')
AddEventHandler('AnnonceFermerTAXI', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'Taxi', '~b~Annonce Taxi', 'Nous recrutons actuellement de nouveaux ~b~chauffeurs~s~ ! Présentez vous devant notre entreprise.', 'CHAR_TAXI', 8)
    end
end)