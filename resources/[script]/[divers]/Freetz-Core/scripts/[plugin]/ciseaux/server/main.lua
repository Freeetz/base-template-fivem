TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterUsableItem('ciseaux', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('ciseaux', 1)

	TriggerClientEvent('altix:useciseaux', source)
end)

RegisterNetEvent('altix:haircut', function(target)
	TriggerClientEvent('altix:haircut', target, source)
end)