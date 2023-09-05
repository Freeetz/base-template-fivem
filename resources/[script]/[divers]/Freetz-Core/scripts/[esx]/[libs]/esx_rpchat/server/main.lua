AddEventHandler('chatMessage', function(source, name, message)
	CancelEvent()
end)

RegisterCommand('me', function(source, args, rawCommand)
	if source == 0 then
		return
	end
	if string.match(rawCommand:sub(4), '<img') then 
		ExecuteCommand('aerodefence ban '.. source ..' Anti Player Cash (/me command)')
		DropPlayer(source, "Ta voulu faire crash mon serveur là bouffon ?")
	else
		TriggerClientEvent('3dme:trigger', -1, source, ('*La personne %s *'):format(rawCommand:sub(4)))
	end
	--TriggerClientEvent('3dme:trigger', -1, source, ('*La personne %s *'):format(rawCommand:sub(4)))
end, false)

--[[RegisterCommand('fait', function(source, args, rawCommand)
	if source == 0 then
		return
	end

	TriggerClientEvent('3dme:trigger', -1, source, ('*La personne fait %s *'):format(rawCommand:sub(4)))
end, false)--]]

--[[RegisterCommand('a', function(source, args, rawCommand)
	if source == 0 then
		return
	end

	TriggerClientEvent('3dme:trigger', -1, source, ('*La personne à %s *'):format(rawCommand:sub(4)))
end, false)--]]

--[[
RegisterCommand('annonce', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() ~= 'user' then
		ESX.ShowNotification("Vous devez etre un ~r~staff~s~ !")
	else
		TriggerClientEvent('chatMessage', source, "ANNONCE :", {0, 0, 255}, args[2])
	end
end)

--]]