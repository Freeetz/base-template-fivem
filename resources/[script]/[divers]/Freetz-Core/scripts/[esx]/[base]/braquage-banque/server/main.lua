local rob = false
local havetowait = false
local robbers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('esx_holdupbank:toofar')
AddEventHandler('esx_holdupbank:toofar', function(robb)
	local source = source
	TriggerEvent("ratelimit", source, "esx_holdupbank:toofar")

	local xPlayers = ESX.GetPlayers()
	rob = false

	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

 		if xPlayer and xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'vinewood' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], "~r~ Braquage de banque, annulé à: ~b~" .. Banks[robb].nameofbank)
			TriggerClientEvent('esx_holdupbank:killblip', xPlayers[i])
		end
	end

	if (robbers[source]) then
		TriggerClientEvent('esx_holdupbank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, "~r~ le braquage à été annulé: ~b~" .. Banks[robb].nameofbank)
	end
end)

RegisterServerEvent('esx_holdupbank:rob')
AddEventHandler('esx_holdupbank:rob', function(robb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	
	if Banks[robb] then
		if (os.time() - Banks[robb].lastrobbed) < 600 and Banks[robb].lastrobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, "cette banque a déjà été braqué. Veuillez attendre: " .. (1800 - (os.time() - Banks[robb].lastrobbed)) .. "secondes.")
			return
		end

		local cops = 0

		for i = 1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer and xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'vinewood' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= ConfigBanque.NumberOfCopsRequired then
				rob = true

				for i = 1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer and xPlayer.job.name == 'police' or xPlayer.job.name == 'vinewood' or xPlayer.job.name == 'fbi' then
						TriggerClientEvent('esx:showNotification', xPlayers[i], "~r~ braquage en cours à: ~b~" .. Banks[robb].nameofbank)
						TriggerClientEvent('esx_holdupbank:setblip', xPlayers[i], Banks[robb].position)
					end
				end

				TriggerClientEvent('esx:showNotification', _source, "vous avez commencé à braquer" .. Banks[robb].nameofbank .. ", ne vous éloignez pas!")
				TriggerClientEvent('esx:showNotification', _source, "l\'alarme à été déclenché")
				TriggerClientEvent('esx:showNotification', _source, "Tenez la position pendant 5min et l\'argent est à vous!")
				TriggerClientEvent('esx_holdupbank:currentlyrobbing', _source, robb)
				Banks[robb].lastrobbed = os.time()
				robbers[_source] = robb

				SetTimeout(300000, function()
					if robbers[_source] then
						rob = false
						TriggerClientEvent('esx_holdupbank:robberycomplete', _source, job)

						if xPlayer then
							--xPlayer.addAccountMoney('dirtycash', Banks[robb].reward)
							xPlayer.addInventoryItem('or', math.random(40, 100))
							havetowait = true
							local xPlayers = ESX.GetPlayers()

							for i = 1, #xPlayers, 1 do
								local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

								if xPlayer and xPlayer.job.name == 'police' or xPlayer.job.name == 'vinewood' or xPlayer.job.name == 'fbi' then
									TriggerClientEvent('esx:showNotification', xPlayers[i], "~r~ Braquage terminé.~s~ ~h~ Fuie!" .. Banks[robb].nameofbank)
									TriggerClientEvent('esx_holdupbank:killblip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, "Pour braquer il faut minimum autant de policiers : " .. ConfigBanque.NumberOfCopsRequired)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Un braquage est déjà en cours.")
		end
	end
end)

ESX.RegisterServerCallback('freetz:getPoliceBraquo', function(source, cb)    
    if not havetowait then
        cb(true)
    else
        cb(false)
    end
end)

CreateThread(function()
	while havetowait do 
		Wait(7200000)

		havetowait = false
	end
end)