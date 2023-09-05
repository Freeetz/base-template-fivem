ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getMaximumGrade(jobname)
    local queryDone, queryResult = false, nil

    MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
        ['@jobname'] = jobname
    }, function(result)
        queryDone, queryResult = true, result
    end)

    while not queryDone do
        Wait(10)
    end

    if queryResult[1] then
        return queryResult[1].grade
    end

    return nil
end

function isEmployed(jobName)
    return (jobName ~= "unemployed" and jobName ~= "unemployed2")
end


ESX.RegisterServerCallback('FreetZ-PersonalMenu:Admin_getUsergroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyGroup = xPlayer.getGroup()

    if plyGroup ~= nil then
        cb(plyGroup)
    else
        cb('user')
    end
end)

ESX.RegisterServerCallback('freetz:getcash', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getAccount('cash').money

    cb(money)
end)

ESX.RegisterServerCallback('ewen:getFactures', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_promouvoirplayer', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_promouvoirplayer sur " .. target)

    if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~s~.')
    else
        if source ~= target and sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~b~promu ' .. targetXPlayer.name .. '~s~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~b~promu par ' .. sourceXPlayer.name .. '~s~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~s~.')
        end
    end
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_destituerplayer', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_destituerplayer sur " .. target)

    if (targetXPlayer.job.grade == 0) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~s~ davantage.')
    else
        if source ~= target and sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~s~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~s~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~s~.')
        end
    end
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_recruterplayer', function(target, job)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_recruterplayer sur " .. target)

    if source ~= target and sourceXPlayer.job.grade_name == 'boss' then
        if not isEmployed(targetXPlayer.job.name) then
            targetXPlayer.setJob(job, 0)
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~b~recruté ' .. targetXPlayer.name .. '~s~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~b~embauché par ' .. sourceXPlayer.name .. '~s~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas recruter quelqu\'un déjà embauché.')
        end
    end
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_virerplayer', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_virerplayer sur " .. target)

    if source ~= target and sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
        targetXPlayer.setJob('unemployed', 0)
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~s~.')
        TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~b~viré par ' .. sourceXPlayer.name .. '~s~.')
    else
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~s~.')
    end
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_promouvoirplayer2', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_promouvoirplayer2 sur " .. target)

    if (targetXPlayer.job2.grade == tonumber(getMaximumGrade(sourceXPlayer.job2.name)) - 1) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~s~.')
    else
        if source ~= target and sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
            targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) + 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~b~promu ' .. targetXPlayer.name .. '~s~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~b~promu par ' .. sourceXPlayer.name .. '~s~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~s~.')
        end
    end
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_destituerplayer2', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_destituerplayer2 sur " .. target)

    if (targetXPlayer.job2.grade == 0) then
        TriggerClientEvent('esx:showNotification', _source, 'Vous ne pouvez pas ~r~rétrograder~s~ davantage.')
    else
        if ssource ~= target and sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
            targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) - 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~s~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~s~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~s~.')
        end
    end
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_recruterplayer2', function(target, job2)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_recruterplayer2 sur " .. target)

    if source ~= target and sourceXPlayer.job2.grade_name == 'boss' then
        if not isEmployed(targetXPlayer.job2.name) then
            targetXPlayer.setJob2(job2, 0)
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~b~recruté ' .. targetXPlayer.name .. '~s~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~b~embauché par ' .. sourceXPlayer.name .. '~s~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas recruter quelqu\'un déjà embauché.')
        end
    end
end)

RegisterNetEvent('FreetZ-PersonalMenu:Boss_virerplayer2', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	--print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_virerplayer2 sur " .. target)

    if source ~= target and sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
        targetXPlayer.setJob2('unemployed2', 0)
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~s~.')
        TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~b~viré par ' .. sourceXPlayer.name .. '~s~.')
    else
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~s~.')
    end
end)

RegisterNetEvent('Admin:ActionTeleport', function(action, id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getGroup() ~= "user" then 
        if action == "teleportto" then 
            local ped = GetPlayerPed(id)
            local coord = GetEntityCoords(ped)
            TriggerClientEvent("Admin:ActionTeleport", _source, "teleportto", coord)
        elseif action == "teleportme" then 
            local ped = GetPlayerPed(_source)
            local coord = GetEntityCoords(ped)
            TriggerClientEvent("Admin:ActionTeleport", id, "teleportme", coord)
        elseif action == "teleportpc" then
            local coord = vector3(215.76, -810.12, 30.73)
            TriggerClientEvent("Admin:ActionTeleport", id, "teleportpc", coord)
        end
    else
        TriggerEvent("BanSql:ICheatServer", source, "Le Cheat n'est pas autorisé sur notre serveur [téléportation]")
    end
end)

ESX.RegisterServerCallback("ronflex:getradio", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem("radio").count >= 1 then 
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('ewen:ChangeWeightInventory',function(NewMaxWeight)
    local SECURITY = NewMaxWeight == 40 and true or NewMaxWeight == 128 and true or NewMaxWeight == 200 and true or false

    if SECURITY then
		local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        if xPlayer then
            xPlayer.setMaxWeight(NewMaxWeight)
        end
        --xPlayer.showNotification('~n~Le poids de votre inventaire a été changé à ~b~'..NewMaxWeight..'~s~kg.')
    else
        DropPlayer(source, 'Désynchronisation avec le serveur ou Detection de Cheat')
    end
end)

local isHandsup = {}
RegisterNetEvent('ewen:handsup', function(value)
    if not isHandsup[source] then 
        isHandsup[source] = value
    else 
        isHandsup[source] = value
    end
end)

ESX.RegisterServerCallback('FreetZ-PersonalMenu:getHandsUp', function(source, cb, target)
    if isHandsup[target] then 
        cb(isHandsup[target])
    else
        isHandsup[target] = false
        cb(isHandsup[target])
    end
    --print(isHandsup[target])
end)

RegisterServerEvent('Entreprise')
AddEventHandler('Entreprise', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.grade_name == "boss" then

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', '')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', '')
	end
end)

RegisterServerEvent('Police')
AddEventHandler('Police', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "police" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			--print("hood")
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_LSPD')
			--print("goo2")
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_LSPD')
	end
end)
RegisterServerEvent('Sheriff')
AddEventHandler('Sheriff', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "vinewood" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'RECOLTEOR')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'RECOLTEOR')
	end
end)

RegisterServerEvent('ConcessV')
AddEventHandler('ConcessV', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "carshop" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_CONCESS')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_CONCESS')
	end
end)

RegisterServerEvent('Ambulance')
AddEventHandler('Ambulance', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "ambulance" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_EMS')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_EMS')
	end
end)

RegisterServerEvent('Bennys')
AddEventHandler('Bennys', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "mecano" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_CARSITE3')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_CARSITE3')
	end
end)

RegisterServerEvent('AutoTuners')
AddEventHandler('AutoTuners', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "autotuners" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_GSMECHANIC')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_GSMECHANIC')
	end
end)

RegisterServerEvent('LSCustom')
AddEventHandler('LSCustom', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "lscustom" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_LS_CUSTOMS')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_LS_CUSTOMS')
	end
end)

RegisterServerEvent('AutoMotors')
AddEventHandler('AutoMotors', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "automotors" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_GSMECHANIC')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_GSMECHANIC')
	end
end)

RegisterServerEvent('Unicorn')
AddEventHandler('Unicorn', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "unicorn" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_UNICORN')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_UNICORN')
	end
end)

RegisterServerEvent('Vigneron')
AddEventHandler('Vigneron', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "vigne" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_VIGNERONS')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_VIGNERONS')
	end
end)

RegisterServerEvent('Gouvernement')
AddEventHandler('Gouvernement', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "gouvernement" then

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_GOUV')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_GOUV')
	end
end)

RegisterServerEvent('Burgershot')
AddEventHandler('Burgershot', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "burgershot" then

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_BURGERSHOT')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_BURGERSHOT')
	end
end)

RegisterServerEvent('Agence')
AddEventHandler('Agence', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "realestateagent" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_IMMO')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''.._raison..'', ''..name..'',  ''..message..'', 'CHAR_IMMO')
	end
end)

-------------------------- FUNCTION POUR LE DUREX -------------------------------------

ESX.RegisterUsableItem('dildo', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('dildo', 1)

	TriggerClientEvent('scully:org', source)
end)

ESX.RegisterUsableItem('dildo2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('dildo2', 1)

	TriggerClientEvent('scully:org2', source)
end)


------------- ↓ STATUS ENTREPRISES ↓ ---------------- 

ESX.RegisterServerCallback('freetz:status:taxi', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'taxi' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:vigneron', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'vigne' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:police', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:tabac', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'tabac' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:bcso', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'bcso' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:sheriff', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'vinewood' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:unicorn', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'unicorn' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:WeazelNews', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'journaliste' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:Bahamas', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'bahamas' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:ConcessVoiture', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'carshop' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:ConcessBateau', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'boatshop' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:ConcessAvion', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'planeshop' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:Bennys', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'mecano' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:LsCustom', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'lscustom' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:AutoTuners', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'autotuners' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:EMS', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:BurgerShot', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'burgershot' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:status:AgenceImmo', function(source, cb)
    local travailleur = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'realestateagent' then
            travailleur = travailleur + 1
        end
    end
    if travailleur >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:cartei', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem('idcard').count

    if quantity >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:permic', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem('permis').count

    if quantity >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('freetz:permia', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem('ppa').count

    if quantity >= 1 then
        cb(true)
    else
        cb(false)
    end
end)
