TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local spawnCoords = vector3(-1275.6431, 313.1318, 65.511)

function getIdentity(source, cb)
    local identifier = ESX.GetPlayerFromId(source).identifier

    MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        local data = {}

        data.identifier = identifier

        if result[1] then
            data.firstname = result[1].firstname
            data.lastname = result[1].lastname
            data.dateofbirth = result[1].dateofbirth
            data.sex = result[1].sex
            data.height = result[1].height
        end

        cb(data)
    end)
end

function setIdentity(identifier, data, cb)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@firstname'] = data.firstname,
		['@lastname'] = data.lastname,
		['@dateofbirth'] = data.dateofbirth,
		['@sex'] = data.sex,
		['@height'] = data.height
	}, function(rowsChanged)
		if cb then
			cb(true)
		end
	end)
end

RegisterServerEvent('esx_identity:setIdentity')
AddEventHandler('esx_identity:setIdentity', function(data)
	local _source = source

	setIdentity(ESX.GetIdentifierFromId(_source), data, function(success)
		if success then
			TriggerClientEvent('esx_identity:identityCheck', _source, true)
		else
			TriggerClientEvent('esx:showNotification', _source, '~r~Action Impossible~s~ : Il y a eu un bug dans la matrice contactez un membre du staff !')
		end
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    getIdentity(source, function(data)
        if data.firstname == nil or data.firstname == '' then
			TriggerClientEvent('esx_identity:identityCheck', source, false)
			TriggerClientEvent('esx_identity:showRegisterIdentity', source)
        else 
			TriggerClientEvent('esx_identity:identityCheck', source, true)
        end
    end)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		while not ESX do
			Wait(10)
		end

		local xPlayers = ESX.GetPlayers()

		for i = 1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer then
				getIdentity(xPlayer.source, function(data)
					if data.firstname == nil or data.firstname == '' then
						TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, false)
						TriggerClientEvent('esx_identity:showRegisterIdentity', xPlayer.source)
					else
						TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, true)
					end
				end)
			end
		end
	end
end)

ESX.AddCommand('register', function(source, args, user)
	local plyPed = GetPlayerPed(source)
	local plyCoords = GetEntityCoords(plyPed, false)
	local dist = #(plyCoords - spawnCoords)

	if dist <= 50.0 then
		TriggerClientEvent('esx_identity:showRegisterIdentity', source)
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Action Impossible~s~ : Vous devez être au spawn !')
	end
end, {help = "Enregistrer un nouveau personnage"})

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'setgroup' then
		if (tonumber(args[1]) ~= nil and tonumber(args[1]) >= 0) and (tostring(args[2]) ~= nil) then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

			if xPlayer == nil then
				RconPrint("Ce joueur n\'est pas connecté !\n")
				CancelEvent()
				return
			end

			xPlayer.setGroup(tostring(args[2]))

			RconPrint(tostring('Le jouer avec l\'ID ('..args[1]).. ') à était setgroup avec succès !')
		else
			RconPrint("Utilisation : setgroup [ID] [GROUPE]\n")
			CancelEvent()
			return
		end

		CancelEvent()
	end
end)