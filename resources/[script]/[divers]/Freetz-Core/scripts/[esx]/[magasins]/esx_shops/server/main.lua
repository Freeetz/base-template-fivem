TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ShopItems = {}

RegisterServerEvent('freetz:achat:Pain')
AddEventHandler('freetz:achat:Pain', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 8
	local item = 'bread'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Pain~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Burger')
AddEventHandler('freetz:achat:Burger', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 25
	local item = 'burger'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Burger~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Eau')
AddEventHandler('freetz:achat:Eau', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 9
	local item = 'water'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Bouteille D\'eau~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Coca')
AddEventHandler('freetz:achat:Coca', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 30
	local item = 'cola'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Canette de Coca Cola~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Canne')
AddEventHandler('freetz:achat:Canne', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 500
	local item = 'canneapeche'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Canne à pêche~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Radio')
AddEventHandler('freetz:achat:Radio', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 150
	local item = 'radio'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Canne à pêche~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Repa')
AddEventHandler('freetz:achat:Repa', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 8000
	local item = 'fixkit'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Kit de Réparation~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Caro')
AddEventHandler('freetz:achat:Caro', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 150
	local item = 'carokit'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Kit de carosserie~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Spray')
AddEventHandler('freetz:achat:Spray', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 500
	local item = 'spray'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Kit de carosserie~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Eponge')
AddEventHandler('freetz:achat:Eponge', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 500
	local item = 'spray_remover'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Éponge~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Capote')
AddEventHandler('freetz:achat:Capote', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 50
	local item = 'capote8'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Pack de 8 Capotes~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Menotte')
AddEventHandler('freetz:achat:Menotte', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 500
	local item = 'basic_cuff'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Menotte Basique~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Cle')
AddEventHandler('freetz:achat:Cle', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 600
	local item = 'basic_key'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Clé de Menotte Basique~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Bmx')
AddEventHandler('freetz:achat:Bmx', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 850
	local item = 'bmx'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 BMX~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:Cigarette')
AddEventHandler('freetz:achat:Cigarette', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 20
	local item = 'cigarette'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Cigarette~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:gant')
AddEventHandler('freetz:achat:gant', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 250
	local item = 'gants'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Gants de Boxe~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:feu')
AddEventHandler('freetz:achat:feu', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 200
	local item = 'firework'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Feu d\'artifice~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:coyote')
AddEventHandler('freetz:achat:coyote', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 5000
	local item = 'coyote'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 Coyote~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('freetz:achat:gps')
AddEventHandler('freetz:achat:gps', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 5000
	local item = 'gps'

	TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous avez achetez ~r~x1 GPS~s~ pour ~g~".. price .."$ !", 'CHAR_SUPERETTE', 9, 18)
	xPlayer.removeAccountMoney('cash', price)
	xPlayer.addInventoryItem(item, 1)
end)