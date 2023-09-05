TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('freetz:achat:ammu')
AddEventHandler('freetz:achat:ammu', function(weapon, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local arme = weapon 
	local prix = price 

	if xPlayer.getAccount('cash').money >= prix then
		if xPlayer.getWeapon(arme) then 
			xPlayer.showNotification("~r~Vous possèdez déjà cette arme !")
		else
			xPlayer.showNotification("~g~Vous avez effectué votre achat !")
			xPlayer.removeAccountMoney('cash', prix)
			xPlayer.addWeapon(arme, 250)
		end
	else
		xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
	end
end)

RegisterServerEvent('freetz:chargeur')
AddEventHandler('freetz:chargeur', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('cash').money >= 200 then
		xPlayer.addInventoryItem('clip', 1)
		xPlayer.showNotification('~g~Vous avez effectué votre achat !')
	else
		xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
	end
end)

RegisterServerEvent('freetz:removeClip')
AddEventHandler('freetz:removeClip', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('clip', 1)
    ESX.SavePlayer(xPlayer, function() end)
end)

--[[ ESX.RegisterUsableItem('clip', function(source)
    TriggerClientEvent('freetz:useClip', source)
end) ]]