TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if ConfigUnicorn.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'unicorn', ConfigUnicorn.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'unicorn', 'Unicorn', 'society_unicorn', 'society_unicorn', 'society_unicorn', {type = 'private'})

RegisterServerEvent('esx_unicornjob:getStockItem')
AddEventHandler('esx_unicornjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retiré " .. count .. ' ' .. inventoryItem.label)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Quantité invalide")
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('esx_unicornjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_unicornjob:putStockItems')
AddEventHandler('esx_unicornjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer" .. count .. ' ' .. ESX.GetItem(itemName).label)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source,"Quantité invalide")
		end
	end)
end)

RegisterServerEvent('esx_unicornjob:getFridgeStockItem')
AddEventHandler('esx_unicornjob:getFridgeStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn_fridge', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retiré : " .. count .. ' ' .. ESX.GetItem(itemName).label)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Quantité invalide")
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('esx_unicornjob:getFridgeStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn_fridge', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_unicornjob:putFridgeStockItems')
AddEventHandler('esx_unicornjob:putFridgeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn_fridge', function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposez : " .. count .. ' ' .. ESX.GetItem(itemName).label)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('esx_unicornjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb({items = xPlayer.inventory})
end)

RegisterServerEvent('esx_unicornjob:buyItem')
AddEventHandler('esx_unicornjob:buyItem', function(itemName, price, itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local societyAccount = nil

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_unicorn', function(account)
		societyAccount = account
	end)
	
	if societyAccount ~= nil and societyAccount.money >= price then
		if xPlayer.canCarryItem(itemName, 1) then
			societyAccount.removeMoney(price)
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('esx:showNotification', _source, "Vous avez acheté : " .. itemLabel)
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n\'avez pas assez d\'espace sur vous !")
		end
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n\'en possédez pas assez.")
	end
end)

--[[ RegisterServerEvent('esx_unicornjob:craftingCoktails')
AddEventHandler('esx_unicornjob:craftingCoktails', function(itemValue)
	local _source = source
	TriggerClientEvent('esx:showNotification', _source, "Préparation en cours..")

	if itemValue == 'jagerbomb' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('energy').count
			local bethQuantity = xPlayer.getInventoryItem('jager').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('energy') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jager') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('energy', 2)
					xPlayer.removeInventoryItem('jager', 2)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('jagerbomb') .. ' ~s~!')
					xPlayer.removeInventoryItem('energy', 2)
					xPlayer.removeInventoryItem('jager', 2)
					xPlayer.addInventoryItem('jagerbomb', 1)
				end
			end
		end)
	end

	if itemValue == 'golem' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('limonade').count
			local bethQuantity = xPlayer.getInventoryItem('vodka').count
			local gimelQuantity = xPlayer.getInventoryItem('ice').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~s~')
			elseif gimelQuantity < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('ice', 1)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('golem') .. ' ~s~!')
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('ice', 1)
					xPlayer.addInventoryItem('golem', 1)
				end
			end
		end)
	end
	
	if itemValue == 'whiskycoca' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('limonade').count
			local bethQuantity = xPlayer.getInventoryItem('whisky').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('whisky', 2)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('whiskycoca') .. ' ~s~!')
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('whisky', 2)
					xPlayer.addInventoryItem('whiskycoca', 1)
				end
			end
		end)
	end

	if itemValue == 'rhumcoca' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('limonade').count
			local bethQuantity = xPlayer.getInventoryItem('rhum').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('rhum', 2)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('rhumcoca') .. ' ~s~!')
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('rhum', 2)
					xPlayer.addInventoryItem('rhumcoca', 1)
				end
			end
		end)
	end

	if itemValue == 'vodkaenergy' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('energy').count
			local bethQuantity = xPlayer.getInventoryItem('vodka').count
			local gimelQuantity = xPlayer.getInventoryItem('ice').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('energy') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~s~')
			elseif gimelQuantity < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('energy', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('ice', 1)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('vodkaenergy') .. ' ~s~!')
					xPlayer.removeInventoryItem('energy', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('ice', 1)
					xPlayer.addInventoryItem('vodkaenergy', 1)
				end
			end
		end)
	end

	if itemValue == 'vodkafruit' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('jusfruit').count
			local bethQuantity = xPlayer.getInventoryItem('vodka').count
			local gimelQuantity = xPlayer.getInventoryItem('ice').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~s~')
			elseif gimelQuantity < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('jusfruit', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('ice', 1)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('vodkafruit') .. ' ~s~!')
					xPlayer.removeInventoryItem('jusfruit', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('ice', 1)
					xPlayer.addInventoryItem('vodkafruit', 1) 
				end
			end
		end)
	end

	if itemValue == 'rhumfruit' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('jusfruit').count
			local bethQuantity = xPlayer.getInventoryItem('rhum').count
			local gimelQuantity = xPlayer.getInventoryItem('ice').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~s~')
			elseif gimelQuantity < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('jusfruit', 2)
					xPlayer.removeInventoryItem('rhum', 2)
					xPlayer.removeInventoryItem('ice', 1)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('rhumfruit') .. ' ~s~!')
					xPlayer.removeInventoryItem('jusfruit', 2)
					xPlayer.removeInventoryItem('rhum', 2)
					xPlayer.removeInventoryItem('ice', 1)
					xPlayer.addInventoryItem('rhumfruit', 1)
				end
			end
		end)
	end

	if itemValue == 'teqpaf' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('limonade').count
			local bethQuantity = xPlayer.getInventoryItem('tequila').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('tequila', 2)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('teqpaf') .. ' ~s~!')
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('tequila', 2)
					xPlayer.addInventoryItem('teqpaf', 1)
				end
			end
		end)
	end

	if itemValue == 'mojito' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('rhum').count
			local bethQuantity = xPlayer.getInventoryItem('limonade').count
			local gimelQuantity = xPlayer.getInventoryItem('menthe').count
			local daletQuantity = xPlayer.getInventoryItem('ice').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~s~')
			elseif gimelQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('menthe') .. '~s~')
			elseif daletQuantity < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('rhum', 2)
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('menthe', 2)
					xPlayer.removeInventoryItem('ice', 1)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('mojito') .. ' ~s~!')
					xPlayer.removeInventoryItem('rhum', 2)
					xPlayer.removeInventoryItem('limonade', 2)
					xPlayer.removeInventoryItem('menthe', 2)
					xPlayer.removeInventoryItem('ice', 1)
					xPlayer.addInventoryItem('mojito', 1)
				end
			end
		end)
	end

	if itemValue == 'mixapero' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('bolcacahuetes').count
			local bethQuantity = xPlayer.getInventoryItem('bolnoixcajou').count
			local gimelQuantity = xPlayer.getInventoryItem('bolpistache').count
			local daletQuantity = xPlayer.getInventoryItem('bolchips').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolcacahuetes') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolnoixcajou') .. '~s~')
			elseif gimelQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolpistache') .. '~s~')
			elseif daletQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolchips') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('bolcacahuetes', 2)
					xPlayer.removeInventoryItem('bolnoixcajou', 2)
					xPlayer.removeInventoryItem('bolpistache', 2)
					xPlayer.removeInventoryItem('bolchips', 1)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('mixapero') .. ' ~s~!')
					xPlayer.removeInventoryItem('bolcacahuetes', 2)
					xPlayer.removeInventoryItem('bolnoixcajou', 2)
					xPlayer.removeInventoryItem('bolpistache', 2)
					xPlayer.removeInventoryItem('bolchips', 2)
					xPlayer.addInventoryItem('mixapero', 1)
				end
			end
		end)
	end

	if itemValue == 'metreshooter' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('jager').count
			local bethQuantity = xPlayer.getInventoryItem('vodka').count
			local gimelQuantity = xPlayer.getInventoryItem('whisky').count
			local daletQuantity = xPlayer.getInventoryItem('tequila').count

			if alephQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jager') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~s~')
			elseif gimelQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~s~')
			elseif daletQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('jager', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('whisky', 2)
					xPlayer.removeInventoryItem('tequila', 2)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('metreshooter') .. ' ~s~!')
					xPlayer.removeInventoryItem('jager', 2)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('whisky', 2)
					xPlayer.removeInventoryItem('tequila', 2)
					xPlayer.addInventoryItem('metreshooter', 1)
				end
			end
		end)
	end

	if itemValue == 'jagercerbere' then
		SetTimeout(10000, function()
			local xPlayer = ESX.GetPlayerFromId(_source)

			local alephQuantity = xPlayer.getInventoryItem('jagerbomb').count
			local bethQuantity = xPlayer.getInventoryItem('vodka').count
			local gimelQuantity = xPlayer.getInventoryItem('tequila').count

			if alephQuantity < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jagerbomb') .. '~s~')
			elseif bethQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~s~')
			elseif gimelQuantity < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~s~')
			else
				local chanceToMiss = math.random(100)
				if chanceToMiss <= ConfigUnicorn.MissCraft then
					TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
					xPlayer.removeInventoryItem('jagerbomb', 1)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('tequila', 2)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('jagercerbere') .. ' ~s~!')
					xPlayer.removeInventoryItem('jagerbomb', 1)
					xPlayer.removeInventoryItem('vodka', 2)
					xPlayer.removeInventoryItem('tequila', 2)
					xPlayer.addInventoryItem('jagercerbere', 1)
				end
			end
		end)
	end
end) ]]

ESX.RegisterServerCallback('esx_unicornjob:getVaultWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_unicorn', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_unicornjob:addVaultWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeWeapon(weaponName)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_unicorn', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_unicornjob:removeVaultWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 1000)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_unicorn', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i = 1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

RegisterServerEvent('freetz:unicorn:ouverture')
AddEventHandler('freetz:unicorn:ouverture', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'UNICORN', '~b~Annonce UNICORN', 'L\'unicorn est actuellement ~g~Ouvert~s~ !', 'CHAR_UNICORN', 8)
    end
end)

RegisterServerEvent('freetz:unicorn:fermeture')
AddEventHandler('freetz:unicorn:fermeture', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'UNICORN', '~b~Annonce UNICORN', 'L\'unicorn est actuellement ~r~Fermé~s~ !', 'CHAR_UNICORN', 8)
    end
end)

RegisterServerEvent('freetz:unicorn:recrutement')
AddEventHandler('freetz:unicorn:recrutement', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'UNICORN', '~b~Annonce UNICORN', 'L\'unicorn est à la recherche de nouveaux ~g~employé(e)s~s~ ! Nous vous attendons nombreux devant ~p~l\'Unicorn~s~ !', 'CHAR_UNICORN', 8)
    end
end)

RegisterServerEvent('freetz:leaveunicorn')
AddEventHandler('freetz:leaveunicorn', function(source)
	DropPlayer(source, "Vous ne pouvez pas sortir du unicorn en ped !")
end)