TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('freetz:PayeLoca:Panto')
AddEventHandler('freetz:PayeLoca:Panto', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeAccountMoney('cash', 2500)
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez payez ~g~2\'500$~s~ pour ~b~x1 Panto~s~, ~r~Bonne route & Bienvenue~s~ !')
end)

RegisterServerEvent('freetz:PayeLoca:Sultan')
AddEventHandler('freetz:PayeLoca:Sultan', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeAccountMoney('cash', 7500)
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez payez ~g~7\'500$~s~ pour ~b~x1 Sultan~s~, ~r~Bonne route & Bienvenue~s~ !')
end)

RegisterServerEvent('freetz:PayeLoca:Buffalo')
AddEventHandler('freetz:PayeLoca:Buffalo', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeAccountMoney('cash', 5000)
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez payez ~g~5\'000$~s~ pour ~b~x1 Buffalo~s~, ~r~Bonne route & Bienvenue~s~ !')
end)

RegisterServerEvent('freetz:PayeLoca:Faggio')
AddEventHandler('freetz:PayeLoca:Faggio', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeAccountMoney('cash', 800)
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez payez ~g~800$~s~ pour ~b~x1 Faggio~s~, ~r~Bonne route & Bienvenue~s~ !')
end)

RegisterServerEvent('freetz:PayeLoca:Sanchez')
AddEventHandler('freetz:PayeLoca:Sanchez', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeAccountMoney('cash', 2000)
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez payez ~g~2\'000$~s~ pour ~b~x1 Buffalo~s~, ~r~Bonne route & Bienvenue~s~ !')
end)