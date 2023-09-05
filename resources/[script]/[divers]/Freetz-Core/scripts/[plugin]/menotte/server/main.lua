TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	xPlayer.set('cuffState', {isCuffed = false, cuffMethod = nil})
end)

RegisterServerEvent('freetz:menotte:handcuff')
AddEventHandler('freetz:menotte:handcuff', function(target, wannacuff, method)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)
	local targetCuff = xPlayerTarget.get('cuffState')

	if wannacuff then
		if not targetCuff.isCuffed then
			if method == 'policecuff' then
				TriggerClientEvent('freetz:menotte:arresting', xPlayer.source)
				TriggerClientEvent('freetz:menotte:thecuff', target, true, xPlayer.source)
				xPlayerTarget.set('cuffState', {isCuffed = true, cuffMethod = method})
			elseif method == 'basiccuff' then
				TriggerClientEvent('freetz:menotte:arresting', xPlayer.source)
				TriggerClientEvent('freetz:menotte:thecuff', target, true, xPlayer.source)
				xPlayerTarget.set('cuffState', {isCuffed = true, cuffMethod = method})
			end
		end
	elseif not wannacuff then
		if targetCuff.isCuffed then
			if (method == targetCuff.cuffMethod) or (method == 'all') then
				TriggerClientEvent('freetz:menotte:unarresting', xPlayer.source)
				TriggerClientEvent('freetz:menotte:thecuff', target, false)
				xPlayerTarget.set('cuffState', {isCuffed = false, cuffMethod = nil})
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous ne pouvez démenottez cette personne')
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous ne pouvez démenottez cette personne')
		end
	end
end)

ESX.RegisterUsableItem('basic_cuff', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	--xPlayer.removeInventoryItem('basic_cuff', 1)

	TriggerClientEvent('freetz:menotte:cbClosestPlayerID', source, true, 'basiccuff')
end)

ESX.RegisterUsableItem('basic_key', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	--xPlayer.addInventoryItem('basic_cuff', 1)

	TriggerClientEvent('freetz:menotte:cbClosestPlayerID', source, false, 'basiccuff')
end)

ESX.RegisterUsableItem('police_cuff', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	--xPlayer.removeInventoryItem('basic_cuff', 1)

	TriggerClientEvent('freetz:menotte:cbClosestPlayerID', source, true, 'policecuff')
end)

ESX.RegisterUsableItem('police_key', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	--xPlayer.addInventoryItem('police_cuff', 1)

	TriggerClientEvent('freetz:menotte:cbClosestPlayerID', source, false, 'policecuff')
end)

ESX.RegisterUsableItem('lockpick', function(source)
	TriggerClientEvent('freetz:menotte:cbClosestPlayerID', source, false, 'all')
end)

-- Unhandcuff
ESX.AddGroupCommand('demenotter', "support", function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if xPlayer then
		xPlayer.triggerEvent('freetz:menotte:thecuff', false)
		xPlayer.set('cuffState', {isCuffed = false, cuffMethod = nil})
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = "Se démenotter en urgence", params = { {name = "userid", help = "ID Du joueur à déménotter"}, {name = "reason", help = "Raison (Laissez vide)"} }})