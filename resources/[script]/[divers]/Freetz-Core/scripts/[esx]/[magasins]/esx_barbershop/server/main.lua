TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_barbershop:pay')
AddEventHandler('esx_barbershop:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeAccountMoney('cash', ConfigBarber.Price)
	TriggerClientEvent('esx:showNotification', _source,"Vous avez payé : ~g~" .. '$' .. ConfigBarber.Price)
end)

ESX.RegisterServerCallback('esx_barbershop:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('cash').money >= ConfigBarber.Price then
		cb(true)
	else
		cb(false)
	end
end)