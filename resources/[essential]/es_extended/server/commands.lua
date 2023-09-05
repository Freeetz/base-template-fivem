-- COMMAND HANDLER --

FREETZ = {}

FREETZ.VIPWeapons = {
	['WEAPON_APPISTOL'] = true,
	['WEAPON_SPECIALCARBINE'] = true,
	['WEAPON_COMBATPDW'] = true,
	['WEAPON_ASSAULTRIFLE'] = true,
	['WEAPON_HEAVYSHOTGUN'] = true,
	['WEAPON_HEAVYSNIPER'] = true,
	['WEAPON_SAWNOFFSHOTGUN'] = true,
	['WEAPON_MILITARYRIFLE'] = true,
	['WEAPON_COMBATPISTOL'] = true,
	['WEAPON_STUNGUN'] = true,
	['WEAPON_ADVANCEDRIFLE'] = true,
	['WEAPON_PUMPSHOTGUN'] = true,
	['WEAPON_NIGHTSTICK'] = true,
	['WEAPON_CARBINERIFLE'] = true,
	['WEAPON_TACTICALRIFLE'] = true,
	['WEAPON_NAVYREVOLVER'] = true,
	['WEAPON_GUSENBERG'] = true,
	['WEAPON_PRECISIONRIFLE'] = true,
	['WEAPON_DOUBLEACTION'] = true,
	['WEAPON_MAZE'] = true,
	['WEAPON_SCAR17'] = true,
	['WEAPON_MILITARM4'] = true,
	['WEAPON_KINETIC'] = true,
	['WEAPON_BLACKSNIPER'] = true,
	['WEAPON_SHOTGUNK'] = true,
	['WEAPON_HELLSNIPER'] = true,
	['WEAPON_HELL'] = true,
	['WEAPON_SPECIALHAMMER'] = true,
	['WEAPON_HELLDOUBLEACTION'] = true,

-- ↓ ARMEMENTS TYPE TROLL SOUS BLACKLIST ↓ --

	['WEAPON_RPG'] = true,
	['WEAPON_STICKYBOMB'] = true,
	['WEAPON_FIREWORK'] = true,
	['WEAPON_RPG'] = true,
	['WEAPON_PROXMINE'] = true,
	['WEAPON_PIPEBOMB'] = true,
	['WEAPON_MOLOTOV'] = true,
	['WEAPON_SMOKEGRENADE'] = true,
	['WEAPON_GRENADELAUNCHER'] = true,
	['WEAPON_MINIGUN'] = true,
	['WEAPON_COMPACTLAUNCHER'] = true,
	['WEAPON_RAILGUN'] = true,
	['WEAPON_COMBATMG_MK2'] = true,
	['WEAPON_COMBATMG'] = true,
	['WEAPON_MG'] = true
	-- ENLEVER LA VIRGUE AU DERNIER
}

local function GetTime()
	local date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

	local date = "Freetz Commu  •  " .. date.day .. "/" .. date.month .. "/" .. date.year .. " à " .. date.hour+2 .. ":" .. date.min .. ":" .. date.sec .. ""
	return date
end


local function Logs(Color, Description, Webhook)
	local Content = {
	        {
	            ["color"] = Color,
				["author"] = {
					["name"] = "Freetz Commu",
					["icon_url"] = "https://cdn.discordapp.com/attachments/959155479718793226/1130462002792386670/lettrev2.png",
				},
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = GetTime(),
	                ["icon_url"] = "https://cdn.discordapp.com/attachments/959155479718793226/1130462002792386670/lettrev2.png",
	            },
	        }
	    }
	PerformHttpRequest(Webhook, function() end, 'POST', json.encode({username = nil, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('chatMessage', function(source, author, message)
	if (message):find(Config.CommandPrefix) ~= 1 then
		return
	end

	local commandArgs = ESX.StringSplit(((message):sub((Config.CommandPrefix):len() + 1)), ' ')
	local commandName = (table.remove(commandArgs, 1)):lower()
	local command = ESX.Commands[commandName]

	if command then
		CancelEvent()
		local xPlayer = ESX.GetPlayerFromId(source)

		if command.group ~= nil then
			if ESX.Groups[xPlayer.getGroup()]:canTarget(ESX.Groups[command.group]) then
				if (command.arguments > -1) and (command.arguments ~= #commandArgs) then
					TriggerEvent("esx:incorrectAmountOfArguments", source, command.arguments, #commandArgs)
				else
					command.callback(source, commandArgs, xPlayer)
				end
			else
				ESX.ChatMessage(source, 'Permissions Insuffisantes !')
			end
		else
			if (command.arguments > -1) and (command.arguments ~= #commandArgs) then
				TriggerEvent("esx:incorrectAmountOfArguments", source, command.arguments, #commandArgs)
			else
				command.callback(source, commandArgs, xPlayer)
			end
		end
	end
end)

function ESX.AddCommand(command, callback, suggestion, arguments)
	ESX.Commands[command] = {}
	ESX.Commands[command].group = nil
	ESX.Commands[command].callback = callback
	ESX.Commands[command].arguments = arguments or -1

	if type(suggestion) == 'table' then
		if type(suggestion.params) ~= 'table' then
			suggestion.params = {}
		end

		if type(suggestion.help) ~= 'string' then
			suggestion.help = ''
		end

		table.insert(ESX.CommandsSuggestions, {name = ('%s%s'):format(Config.CommandPrefix, command), help = suggestion.help, params = suggestion.params})
	end
end

function ESX.AddGroupCommand(command, group, callback, suggestion, arguments)
	ESX.Commands[command] = {}
	ESX.Commands[command].group = group
	ESX.Commands[command].callback = callback
	ESX.Commands[command].arguments = arguments or -1

	if type(suggestion) == 'table' then
		if type(suggestion.params) ~= 'table' then
			suggestion.params = {}
		end

		if type(suggestion.help) ~= 'string' then
			suggestion.help = ''
		end

		table.insert(ESX.CommandsSuggestions, {name = ('%s%s'):format(Config.CommandPrefix, command), help = suggestion.help, params = suggestion.params})
	end
end

-- SCRIPT --
ESX.AddGroupCommand('devinfo', '_dev', function(source, args, user)
	ESX.ChatMessage(source, "^2[^3Freetz Commu^2]^0 Groupes de modération : ^2 " .. (ESX.Table.SizeOf(ESX.Groups) - 1))
	ESX.ChatMessage(source, "^2[^3Freetz Commu^2]^0 Commandes chargé : ^2 " .. (ESX.Table.SizeOf(ESX.Commands) - 1))
end)

ESX.AddGroupCommand('pos', 'superadmin', function(source, args, user)
	local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
	
	if x and y and z then
		TriggerClientEvent('esx:teleport', source, vector3(x, y, z))
	else
		ESX.ChatMessage(source, "Invalid coordinates!")
	end
end, {help = "Teleport to coordinates", params = {
	{name = "x", help = "X coords"},
	{name = "y", help = "Y coords"},
	{name = "z", help = "Z coords"}
}})

ESX.AddGroupCommand('setjob', 'gerantl', function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if ESX.DoesJobExist(args[2], args[3]) then
				xPlayer.setJob(args[2], args[3])

				local NamePlayer = GetPlayerName(source)
				local IpJoueur = GetPlayerEndpoint(source)
				local steamhex = GetPlayerIdentifier(source)
		
				discord = {}
				for i = 0, GetNumPlayerIdentifiers(source) - 1 do
					local id = GetPlayerIdentifier(source, i)
		
					if string.find(id, "discord") then
						discord = id
						discord = string.sub(discord, 9)
					else
						discord = nil
					end
				end
				
				for k,v in ipairs(GetPlayerIdentifiers(source)) do
					if string.match(v, 'license:') then
						identifier = string.sub(v, 9)
						break
					end
				end
		
				if discord == nil then 
					Logs(3141376, "**Un staff vien de faire un setjob ! Voici ces informations : \n\nJob : **".. args[2] .."**\nGrade : **".. args[3] .."**\nNom :** "..NamePlayer.."\n**Discord :** ``Inconnu``\n**License :** "..xPlayer.identifier, "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
				else
					Logs(3141376, "**Un staff vien de faire un setjob ! Voici ces informations : \n\nJob : **".. args[2] .."**\nGrade : **".. args[3] .."**\nNom :** "..NamePlayer.."\n**Discord :** <@".. discord .. ">\n**License :** "..xPlayer.identifier, "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
				end
			else
				ESX.ChatMessage(source, 'Ce job n\'existe pas.')
			end
		else
			ESX.ChatMessage(source, 'Ce joueur est hors ligne.')
		end
	else
		ESX.ChatMessage(source, 'Utilisation invalide.')
	end
end, {help = _U('setjob'), params = {
	{name = "playerId", help = _U('id_param')},
	{name = "job", help = _U('setjob_param2')},
	{name = "grade_id", help = _U('setjob_param3')}
}})

ESX.AddGroupCommand('setjob2', 'gerantl', function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if ESX.DoesJobExist(args[2], args[3]) then
				xPlayer.setJob2(args[2], args[3])
			else
				ESX.ChatMessage(source, 'Ce job n\'existe pas.')
			end
		else
			ESX.ChatMessage(source, 'Joueur hors ligne.')
		end
	else
		ESX.ChatMessage(source, 'Utilisation invalide.')
	end
end, {help = _U('setjob'), params = {
	{name = "playerId", help = _U('id_param')},
	{name = "job2", help = _U('setjob_param2')},
	{name = "grade_id", help = _U('setjob_param3')}
}})

ESX.AddGroupCommand('car', 'gerantl', function(source, args, user)
	TriggerClientEvent('esx:spawnVehicle', source, args[1])
end, {help = _U('spawn_car'), params = {
	{name = "car", help = _U('spawn_car_param')}
}})

ESX.AddGroupCommand('dv', 'support', function(source, args, user)
	TriggerClientEvent('esx:deleteVehicle', source, args[1])
end, {help = _U('delete_vehicle'), params = {
	{name = 'radius', help = 'Option, supprimer les véhicules dans un radius'}
}})

ESX.AddGroupCommand('giveitem', 'admin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local item = args[2]
		local count = tonumber(args[3])

		if count then
			if ESX.Items[item] then
				xPlayer.addInventoryItem(item, count)
				xPlayer.showNotification('Un staff vous as give ~r~'..item..'~s~ en ~g~'..count..'~s~ exemplaires !')
			else
				xPlayer.showNotification(_U('invalid_item'))
			end
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		ESX.ChatMessage(source, 'Joueur hors-ligne.')
	end
end, {help = _U('giveitem'), params = {
	{name = "playerId", help = _U('id_param')},
	{name = "item", help = _U('item')},
	{name = "amount", help = _U('amount')}
}})

ESX.AddGroupCommand('giveweapon', 'gerantl', function(source, args, user) -- TODO : LOGS
	local cmdBoug = ESX.GetPlayerFromId(source)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local weaponName = args[2] or 'unknown'

		if ESX.GetWeapon(weaponName) then
			if xPlayer.hasWeapon(weaponName) then
				ESX.ChatMessage(source, 'Le joueur à déjà cette arme.')
			else
				if FREETZ.VIPWeapons[weaponName] == nil then
					xPlayer.addWeapon(weaponName, tonumber(args[3]))
					ESX.SavePlayer(xPlayer, function(cb) end)

					local NamePlayer = GetPlayerName(source)
					local IpJoueur = GetPlayerEndpoint(source)
					local steamhex = GetPlayerIdentifier(source)
				
					discord = {}
					for i = 0, GetNumPlayerIdentifiers(source) - 1 do
						local id = GetPlayerIdentifier(source, i)
					
						if string.find(id, "discord") then
							discord = id
							discord = string.sub(discord, 9)
						else
							discord = nil
						end
					end

					for k,v in ipairs(GetPlayerIdentifiers(source)) do
						if string.match(v, 'license:') then
							identifier = string.sub(v, 9)
							break
						end
					end
				
					if discord == nil then 
						Logs(3141376, "**Un staff c\'est/à give une arme ! Voici ces informations : \n\nArme : **".. weaponName .."**\nNom :** "..NamePlayer.."\n**Discord :** ``Inconnu``\n**License :** "..xPlayer.identifier, "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
					else
						Logs(3141376, "**Un staff c\'est/à give une arme ! Voici ces informations : \n\nArme : **".. weaponName .."**\nNom :** "..NamePlayer.."\n**Discord :** <@".. discord .. ">\n**License :** "..xPlayer.identifier, "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
					end
				else
					cmdBoug.showNotification("~r~Vous ne pouvez pas give d\'arme permanente !!")
				end
			end
		else
			ESX.ChatMessage(source, 'Arme invalide.')
		end
	else
		ESX.ChatMessage(source, 'Joueur hors ligne.')
	end
end, {help = _U('giveweapon'), params = {
	{name = "playerId", help = _U('id_param')},
	{name = "weaponName", help = _U('weapon')},
	{name = "ammo", help = _U('amountammo')}
}})

ESX.AddGroupCommand('giveweaponcomponent', 'cofonda', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local weaponName = args[2] or 'unknown'

		if ESX.GetWeapon(weaponName) then
			if xPlayer.hasWeapon(weaponName) then
				local component = ESX.GetWeaponComponent(weaponName, args[3] or 'unknown')

				if component then
					if xPlayer.hasWeaponComponent(weaponName, args[3]) then
						ESX.ChatMessage(source, 'Player already has that weapon component.')
					else
						xPlayer.addWeaponComponent(weaponName, args[3])
					end
				else
					ESX.ChatMessage(source, 'Invalid weapon component.')
				end
			else
				ESX.ChatMessage(source, 'Player does not have that weapon.')
			end
		else
			ESX.ChatMessage(source, 'Invalid weapon.')
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = 'Give weapon component', params = {
	{name = 'playerId', help = _U('id_param')},
	{name = 'weaponName', help = _U('weapon')},
	{name = 'componentName', help = 'weapon component'}
}})

ESX.AddGroupCommand('chatclear', 'help', function(source, args, user)
	TriggerEvent("ratelimit", source, "chatclear")
	TriggerClientEvent('chat:clear', -1)
end, {help = _U('chat_clear_all')})

ESX.AddGroupCommand('clearinventory', 'superadmin', function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if xPlayer then
		for i = 1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = _U('command_clearinventory'), params = {
	{name = "playerId", help = _U('command_playerid_param')}
}})

ESX.AddGroupCommand('clearloadout', 'superadmin', function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if xPlayer then
		for i = #xPlayer.loadout, 1, -1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = _U('command_clearloadout'), params = {
	{name = "playerId", help = _U('command_playerid_param')}
}})

ESX.AddGroupCommand('kill', 'owner', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local target = ESX.GetPlayerFromId(args[1])

	if tostring(args[1]) then
		TriggerClientEvent('freetz:kill:user', target, xPlayer.getName())
	else
		xPlayer.showNotification("~r~ID Invalide")
	end
end)

ESX.AddGroupCommand('giveaccountmoney', 'cofonda', function(source, args)
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(args[1])
	local account = args[2]
	local amount  = tonumber(args[3])

	if amount  ~= nil then
		if xPlayer.getAccount(account) ~= nil then
			xPlayer.addAccountMoney(account, amount)
		else
			print("Compte invalide")
		end
	else
		print("Montant invalide")
	end
end)

RegisterCommand('giveaccountmoney2', function(source, args)
	if source == 0 then
		local source = source 
		local xPlayer = ESX.GetPlayerFromId(args[1])
		local account = args[2]
		local amount  = tonumber(args[3])
	
		if amount  ~= nil then
			if xPlayer.getAccount(account) ~= nil then
				xPlayer.addAccountMoney(account, amount)
			else
				print("Compte invalide")
			end
		else
			print("Montant invalide")
		end
	end
end, true)