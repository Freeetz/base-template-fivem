local PlayersHarvesting, PlayersHarvesting2, PlayersHarvesting3 = {}, {}, {}
local PlayersCrafting, PlayersCrafting2, PlayersCrafting3 = {}, {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if ConfigMecano.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'mecano', ConfigMecano.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mecano', _U('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'mecano', 'mecano', 'society_mecano', 'society_mecano', 'society_mecano', {type = 'private'})

local function Harvest(source)
	SetTimeout(4000, function()
		if PlayersHarvesting[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

			if GazBottleQuantity >= 5 then
				TriggerClientEvent('iNotificationV3:showNotification', source, _U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('gazbottle', 1)
				Harvest(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mecanojob:startHarvest')
AddEventHandler('esx_mecanojob:startHarvest', function()
	local _source = source
	PlayersHarvesting[_source] = true
	TriggerClientEvent('iNotificationV3:showNotification', _source, _U('recovery_gas_can'))
	Harvest(_source)
end)

RegisterServerEvent('esx_mecanojob:stopHarvest')
AddEventHandler('esx_mecanojob:stopHarvest', function()
	local _source = source
	PlayersHarvesting[_source] = false
end)

local function Harvest2(source)
	SetTimeout(4000, function()
		if PlayersHarvesting2[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count

			if FixToolQuantity >= 5 then
				TriggerClientEvent('iNotificationV3:showNotification', source, _U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('fixtool', 1)
				Harvest2(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mecanojob:startHarvest2')
AddEventHandler('esx_mecanojob:startHarvest2', function()
	local _source = source
	PlayersHarvesting2[_source] = true
	TriggerClientEvent('iNotificationV3:showNotification', _source, _U('recovery_repair_tools'))
	Harvest2(_source)
end)

RegisterServerEvent('esx_mecanojob:stopHarvest2')
AddEventHandler('esx_mecanojob:stopHarvest2', function()
	local _source = source
	PlayersHarvesting2[_source] = false
end)

local function Harvest3(source)
	SetTimeout(4000, function()
		if PlayersHarvesting3[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count

			if CaroToolQuantity >= 5 then
				TriggerClientEvent('iNotificationV3:showNotification', source, _U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('carotool', 1)
				Harvest3(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mecanojob:startHarvest3')
AddEventHandler('esx_mecanojob:startHarvest3', function()
	local _source = source
	PlayersHarvesting3[_source] = true
	TriggerClientEvent('iNotificationV3:showNotification', _source, _U('recovery_body_tools'))
	Harvest3(_source)
end)

RegisterServerEvent('esx_mecanojob:stopHarvest3')
AddEventHandler('esx_mecanojob:stopHarvest3', function()
	local _source = source
	PlayersHarvesting3[_source] = false
end)

local function Craft(source)
	SetTimeout(4000, function()
		if PlayersCrafting[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

			if GazBottleQuantity <= 0 then
				TriggerClientEvent('iNotificationV3:showNotification', source, _U('not_enough_gas_can'))
			else
				xPlayer.removeInventoryItem('gazbottle', 1)
				xPlayer.addInventoryItem('blowpipe', 1)
				Craft(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mecanojob:startCraft')
AddEventHandler('esx_mecanojob:startCraft', function()
	local _source = source
	PlayersCrafting[_source] = true
	TriggerClientEvent('iNotificationV3:showNotification', _source, _U('assembling_blowtorch'))
	Craft(_source)
end)

RegisterServerEvent('esx_mecanojob:stopCraft')
AddEventHandler('esx_mecanojob:stopCraft', function()
	local _source = source
	PlayersCrafting[_source] = false
end)

local function Craft2(source)
	SetTimeout(4000, function()
		if PlayersCrafting2[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count

			if FixToolQuantity <= 0 then
				TriggerClientEvent('iNotificationV3:showNotification', source, _U('not_enough_repair_tools'))
			else
				xPlayer.removeInventoryItem('fixtool', 1)
				xPlayer.addInventoryItem('fixkit', 1)
				Craft2(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mecanojob:startCraft2')
AddEventHandler('esx_mecanojob:startCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = true
	TriggerClientEvent('iNotificationV3:showNotification', _source, _U('assembling_repair_kit'))
	Craft2(_source)
end)

RegisterServerEvent('esx_mecanojob:stopCraft2')
AddEventHandler('esx_mecanojob:stopCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = false
end)

local function Craft3(source)
	SetTimeout(4000, function()
		if PlayersCrafting3[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count

			if CaroToolQuantity <= 0 then
				TriggerClientEvent('iNotificationV3:showNotification', source, _U('not_enough_body_tools'))
			else
				xPlayer.removeInventoryItem('carotool', 1)
				xPlayer.addInventoryItem('carokit', 1)
				Craft3(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mecanojob:startCraft3')
AddEventHandler('esx_mecanojob:startCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = true
	TriggerClientEvent('iNotificationV3:showNotification', _source, _U('assembling_body_kit'))
	Craft3(_source)
end)

RegisterServerEvent('esx_mecanojob:stopCraft3')
AddEventHandler('esx_mecanojob:stopCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = false
end)

RegisterServerEvent('esx_mecanojob:onNPCJobMissionCompleted')
AddEventHandler('esx_mecanojob:onNPCJobMissionCompleted', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = math.random(ConfigMecano.NPCJobEarnings.min, ConfigMecano.NPCJobEarnings.max)

	if xPlayer.job.grade_name == 'boss' then
		total = total * 2
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		account.addMoney(total)
	end)

	TriggerClientEvent("iNotificationV3:showNotification", _source, _U('your_comp_earned') .. total)
end)

ESX.RegisterUsableItem('blowpipe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('blowpipe', 1)
	TriggerClientEvent('esx_mecanojob:onHijack', source)
	TriggerClientEvent('iNotificationV3:showNotification', source, _U('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)
	TriggerClientEvent('esx_mecanojob:onFixkit', source)
	TriggerClientEvent('iNotificationV3:showNotification', source, _U('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('carokit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('carokit', 1)
	TriggerClientEvent('esx_mecanojob:onCarokit', source)
	TriggerClientEvent('iNotificationV3:showNotification', source, _U('you_used_body_kit'))
end)

RegisterServerEvent('esx_mecanojob:getStockItem')
AddEventHandler('esx_mecanojob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('have_withdrawn', count, inventoryItem.label))
			else
				TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('player_cannot_hold'))
			end
		else
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mecanojob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_mecanojob:putStockItems')
AddEventHandler('esx_mecanojob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('have_deposited', count, ESX.GetItem(itemName).label))
		else
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mecanojob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb({items = xPlayer.inventory})
end)

RegisterServerEvent('AnnonceOuvertMECANO')
AddEventHandler('AnnonceOuvertMECANO', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'Mécano', '~b~Annonce Mécano', 'Le Benny\'s est actuellement ~g~Ouvert~s~ !', 'CHAR_ORTEGA', 8)
    end
end)

RegisterServerEvent('AnnonceRecrutementMECANO')
AddEventHandler('AnnonceRecrutementMECANO', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'Mécano', '~b~Annonce Mécano', 'Le ~b~Benny\'s~s~ est actuellement à la recherche de nouveaux employés ! En conséquence, les ~y~Recrutements~s~ sont actuellement ouvert ! ~r~Rendez-vous~s~ devant le Mécano !', 'CHAR_ORTEGA', 8)
    end
end)

RegisterServerEvent('AnnonceFermerMECANO')
AddEventHandler('AnnonceFermerMECANO', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'Mécano', '~b~Annonce Mécano', 'Le Benny\'s est actuellement ~r~Fermer~s~ !', 'CHAR_ORTEGA', 8)
    end
end)