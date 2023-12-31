TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("tattoos:GetPlayerTattoos_s")
AddEventHandler("tattoos:GetPlayerTattoos_s", function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM playerstattoos WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
		if (result[1] ~= nil) then
			local tattoosList = json.decode(result[1].tattoos)
			TriggerClientEvent("tattoos:getPlayerTattoos", xPlayer.source, tattoosList)
		else
			local tattooValue = json.encode({})
			MySQL.Async.execute("INSERT INTO playerstattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['@identifier'] = xPlayer.identifier, ['@tattoo'] = tattooValue})
			TriggerClientEvent("tattoos:getPlayerTattoos", xPlayer.source, {})
		end
	end)
end)

RegisterServerEvent("tattoos:save")
AddEventHandler("tattoos:save", function(tattoosList, price, value)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)

		table.insert(tattoosList, value)

		MySQL.Async.execute("UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['@tattoos'] = json.encode(tattoosList), ['@identifier'] = xPlayer.identifier})
		
		TriggerClientEvent("tattoo:buySuccess", xPlayer.source, value)
		TriggerClientEvent("esx:showNotification", xPlayer.source, "~g~Vous venez d\'achetez ce tatouage.")
	else
		TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Vous n\'avez pas assez d\'argent !")
	end
end)