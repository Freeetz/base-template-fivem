TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

SetMapName('Los Santos')
SetGameType('Freetz RP')

sqlReady = false

MySQL.ready(function()
	sqlReady = true
end)

AddEventHandler('playerConnecting', function()
	local _source = source
	local license, steam, xbl, discord, live, fivem = '', '', '', '', '', ''
	local name, ip, guid = GetPlayerName(_source), GetPlayerEP(_source), GetPlayerGuid(_source)

	while not sqlReady do
		Citizen.Wait(100)
	end

	for k, v in pairs(GetPlayerIdentifiers(_source)) do
		if string.sub(v, 1, string.len('license:')) == 'license:' then
			license = v
		elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
			steam = v
		elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
			xbl = v
		elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
			discord = v
		elseif string.sub(v, 1, string.len('live:')) == 'live:' then
			live = v
		elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
			fivem = v
		end
	end

	if license ~= nil then
		MySQL.Async.fetchAll('SELECT * FROM account_info WHERE license = @license', {
			['@license'] = license
		}, function(result)
			if result[1] ~= nil then
				MySQL.Async.execute('UPDATE account_info SET steam = @steam, xbl = @xbl, discord = @discord, live = @live, fivem = @fivem, `name` = @name, ip = @ip, guid = @guid WHERE license = @license', {
					['@license'] = license,
					['@steam'] = steam,
					['@xbl'] = xbl,
					['@discord'] = discord,
					['@live'] = live,
					['@fivem'] = fivem,
					['@name'] = name,
					['@ip'] = ip,
					['@guid'] = guid
				})
			else
				MySQL.Async.execute('INSERT INTO account_info (license, steam, xbl, discord, live, fivem, `name`, ip, guid) VALUES (@license, @steam, @xbl, @discord, @live, @fivem, @name, @ip, @guid)', {
					['@license'] = license,
					['@steam'] = steam,
					['@xbl'] = xbl,
					['@discord'] = discord,
					['@live'] = live,
					['@fivem'] = fivem,
					['@name'] = name,
					['@ip'] = ip,
					['@guid'] = guid
				})
			end
		end)
	end
end)

RegisterCommand('setMap', function(source, args, rawCommand)
	if source == 0 then
		if #args == 1 then
			SetMapName(args[1])
			print(('Carte : %s'):format(args[1]))
		else
			print("utilisation : map [nom]")
		end
	end
end)

RegisterCommand('setGametype', function(source, args, rawCommand)
	if source == 0 then
		if #args == 1 then
			SetGameType(args[1])
			print(('Gametype : %s'):format(args[1]))
		else
			print("utilisation: gametype [nom]")
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		TriggerClientEvent('freetz:updatePlayerCount', -1, GetNumPlayerIndices())
		Citizen.Wait(2500)
	end
end)