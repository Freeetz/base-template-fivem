local Players = {
	Farm = {},
	Process = {},
	Sell = {}
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function Farm(source, zone, type)
	SetTimeout(ConfigFarming.FarmTime, function()
		if Players.Farm[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local info = ConfigFarming.Zones[zone][type].ActionInfo
			math.randomseed(GetGameTimer())
			local rngCount = math.random(info.Min, info.Max)

			if xPlayer.canCarryItem(info.Item, rngCount) then
				xPlayer.addInventoryItem(info.Item, rngCount)
				xPlayer.triggerEvent('farming:changeMarker', zone, type)
			else
				xPlayer.showNotification('Vous n\'avez pas assez de place')
			end
		end
	end)
end

function Process(source, zone, type)
	SetTimeout(ConfigFarming.ProcessTime, function()
		if Players.Process[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local info = ConfigFarming.Zones[zone][type].ActionInfo
			local sourceItem = xPlayer.getInventoryItem(info.Item)

			if sourceItem.count < info.Slice and sourceItem.count < 1 then
				--xPlayer.showNotification(('Vous n\'avez pas assez d\'%s'):format(ESX.GetItem(info.Item).label))
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "Vous devez avoir aux moins 20 de cette item pour le traiter !", 'RECOLTEOR', 9, 18)
			else
				local slicedCount = math.floor(sourceItem.count / info.Slice)
				local loseNumber = info.Slice * slicedCount
				local winNumber = info.EarnCount * slicedCount

				if xPlayer.canSwapItem(info.Item, loseNumber, info.ItemTarget, winNumber) then
					xPlayer.removeInventoryItem(info.Item, loseNumber)
					xPlayer.addInventoryItem(info.ItemTarget, winNumber)
				else
					--xPlayer.showNotification('Vous n\'avez pas assez de place')
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "SUPERETTE", "Paiement Effectué", "~r~Vous n\'avez pas assez de place sur vous !", 'RECOLTEOR', 9, 18)
				end
			end
		end
	end)
end

function Sell(source, zone, type)
	SetTimeout(ConfigFarming.SellTime, function()
		if Players.Sell[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local info = ConfigFarming.Zones[zone][type].ActionInfo
			local sourceItem = xPlayer.getInventoryItem(info.Item)

			if sourceItem.count < info.Slice and sourceItem.count < 1 then
				xPlayer.showNotification("Il vous faut au moins ~y~" .. info.Slice .. "~s~ ~b~" .. ESX.GetItem(info.Item).label .. "~s~ pour vendre.")
			else
				local slicedCount = math.floor(sourceItem.count / info.Slice)
				local loseNumber = info.Slice * slicedCount
				local winNumber = info.EarnCount * slicedCount

				xPlayer.removeInventoryItem(info.Item, loseNumber)
				xPlayer.addAccountMoney('cash', winNumber)
				xPlayer.showNotification("Vous avez vendu ~y~x" .. loseNumber .. "~s~ ~b~" .. ESX.GetItem(info.Item).label .. "~s~ pour ~g~" .. winNumber .. "~s~$.")
			end
		end
	end)
end

RegisterServerEvent('farming:startAction')
AddEventHandler('farming:startAction', function(zone, type)
	local _source = source

	if Players[type][_source] == nil then
		Players[type][_source] = true

		if type == 'Farm' then
			Farm(_source, zone, type)
		elseif type == 'Process' then
			Process(_source, zone, type)
		elseif type == 'Sell' then
			Sell(_source, zone, type)
		end
	else
		print(('farming: %s attempted to exploit the %s marker of %s !'):format(ESX.GetIdentifierFromId(_source), type, zone))
	end
end)

RegisterServerEvent('farming:stopAction')
AddEventHandler('farming:stopAction', function(zone, type)
	local _source = source
	Players[type][_source] = nil
end)