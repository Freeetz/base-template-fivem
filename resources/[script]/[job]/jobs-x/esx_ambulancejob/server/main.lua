TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.job.name ~= 'ambulance' then
		TriggerEvent('BanSql:ICheatServer', _source)
		return
	end
	local sourcePed = GetPlayerPed(_source)
	local targetPed = GetPlayerPed(target)

	if #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) < 3.0 and GetEntityHealth(targetPed) <= 0.0 then
		xPlayer.addAccountMoney('cash', ConfigAmbulance.ReviveReward)
		TriggerClientEvent('esx_ambulancejob:revive', target)
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	TriggerClientEvent('esx_ambulancejob:heal', target, type)
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

-- ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
--	local xPlayer = ESX.GetPlayerFromId(source)
--	local playerLoadout = {}
--
--	if ConfigAmbulance.RemoveWeaponsAfterRPDeath then
--		for i = 1, #xPlayer.loadout, 1 do
--			if ConfigAmbulance.VIPWeapons[xPlayer.loadout[i].name] == nil then
--				xPlayer.removeWeapon(xPlayer.loadout[i].name)
--			else
--				table.insert(playerLoadout, xPlayer.loadout[i])
--
--				Citizen.CreateThread(function()
--					Citizen.Wait(5000)
--
--					for i = 1, #playerLoadout, 1 do
--						if playerLoadout[i].label then
--							xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
--						end
--					end
--				end)
--			end
--		end
--	else
--		for i = 1, #xPlayer.loadout, 1 do
--			table.insert(playerLoadout, xPlayer.loadout[i])
--		end
--
--		Citizen.CreateThread(function()
--			Citizen.Wait(5000)
--
--			for i = 1, #playerLoadout, 1 do
--				if playerLoadout[i].label ~= nil then
--					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
--				end
--			end
--		end)
--	end
--
--	cb()
-- end)

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(item).count
	cb(count)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and (item == 'medikit' or item == 'bandage') then
		xPlayer.removeInventoryItem(item, 1)
		TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('used_%s'):format(item))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemAvailable = false

	for i = 1, #ConfigAmbulance.RestockItems, 1 do
		if ConfigAmbulance.RestockItems[i].value == itemName then
			itemAvailable = true
		end
	end

	if itemAvailable and xPlayer.job.name == 'ambulance' then
		if xPlayer.canCarryItem(itemName, 1) then
			xPlayer.addInventoryItem(itemName, 1)
		else
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('max_item'))
		end
	end
end)

ESX.AddGroupCommand('reviveall', 'admin', function(source, args, user)
	TriggerClientEvent('esx_ambulancejob:revive', -1)
end, {help = _U('revive_help')})

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('medikit', 1)

	TriggerClientEvent('esx_ambulancejob:heal', xPlayer.source, 'big')
	TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('used_medikit'))
end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandage', 1)

	TriggerClientEvent('esx_ambulancejob:heal', xPlayer.source, 'small')
	TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('used_bandage'))
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET isDead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@isDead'] = isDead
	})
end)

RegisterServerEvent('AnnonceOuvertEMS')
AddEventHandler('AnnonceOuvertEMS', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'E.M.S', '~b~Annonce E.M.S', 'Nous sommes actuellement ~g~Disponible~s~ !', 'CHAR_ORTEGA', 8)
    end
end)

RegisterServerEvent('AnnonceFermerEMS')
AddEventHandler('AnnonceFermerEMS', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'E.M.S', '~b~Annonce E.M.S', 'Nous sommes actuellement ~r~Indisponible~s~!', 'CHAR_ORTEGA', 8)
    end
end)

RegisterServerEvent('AnnonceRecrutementEMS')
AddEventHandler('AnnonceRecrutementEMS', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'E.M.S', '~b~Annonce E.M.S', 'Les recrutements ~b~E.M.S~s~ sont actuellement ~g~Ouver~s~! Rejoignez-nous vite ~r~devant l\'hopital~s~ !', 'CHAR_ORTEGA', 8)
    end
end)

ESX.AddGroupCommand('revive', ConfigAmbulance.GradeForRevive, function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]))
		end
	else
		TriggerClientEvent('esx_ambulancejob:revive', source)
	end
end, {help = _U('revive_help'), params = { {name = 'id'} }})

RegisterServerEvent('freetz:remove:item')
AddEventHandler('freetz:remove:item', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local resultat = math.random(1, 10)

	if resultat == 5 or resultat == 6 or resultat == 7 then
		for i = 1, #xPlayer.loadout, 1 do 
			if ConfigAmbulance.VIPWeapons[xPlayer.loadout[i].name] == nil then
				xPlayer.removeWeapon(xPlayer.loadout[i].name)
			end
		end
	end
end)

local onedeleted = false

AddEventHandler('playerDropped', function(reason)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerLoadout = {}

	if reason == 'Exiting' or reaseon == 'Disconnected.' then

		TriggerClientEvent('esx_ambulancejob:requestDeath', xPlayer)
		
		MySQL.Async.fetchScalar('SELECT isDead FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(isDead)
			if isDead == 1 then
				onedeleted = false
				MySQL.Async.execute('INSERT INTO jail (identifier, time, raison, staffname) VALUES (@identifier, @time, @raison, @staffname)', {
					['@identifier'] = xPlayer.identifier,
					['@time'] = '45',
					["@raison"] = 'Déconnexion dans le coma..',
					["@staffname"] = 'Sanction Automatique'
				}, function()
				end)

				MySQL.Async.execute('UPDATE users SET isDead = @isDead WHERE identifier = @identifier', {
					['@identifier'] = xPlayer.identifier,
					['@isDead'] = 0
				})

				for i = 1, #xPlayer.loadout, 1 do
					if ConfigAmbulance.VIPWeapons[xPlayer.loadout[i].name] == nil then
						xPlayer.removeWeapon(xPlayer.loadout[i].name)
					end
				end
			end
		end)
	end
end)