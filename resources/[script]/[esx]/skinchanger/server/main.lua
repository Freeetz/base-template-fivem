TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

ESX.AddGroupCommand('skin', 'help', function(source, args, user)
	local target = tonumber(args[1])
	local target2 = ESX.GetPlayerFromId(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if args[1] == nil then 
		TriggerClientEvent('esx_skin:openSaveableMenu', source)
	else
		TriggerClientEvent('esx_skin:openSaveableMenu', target2)
	end
end, {help = _U('skin')})