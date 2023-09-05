TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	--if xPlayer.job.name == 'police' then
		local xPlayerTarget = ESX.GetPlayerFromId(target)

		if xPlayerTarget.get('cuffState').isCuffed then
			TriggerClientEvent('esx_policejob:drag', target, xPlayer.source)
		end
	--else
	--	print(('esx_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	--end
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	--if xPlayer.job.name == 'police' then
		local xPlayerTarget = ESX.GetPlayerFromId(target)

		if xPlayerTarget.get('cuffState').isCuffed then
			TriggerClientEvent('esx_policejob:putInVehicle', target)
		end
	--else
	--	print(('esx_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	--end
end)

RegisterServerEvent('renfort')
AddEventHandler('renfort', function(coords, raison)
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' or thePlayer.job.name == 'fbi' or thePlayer.job.name == 'vinewood' then
			TriggerClientEvent('renfort:setBlip', xPlayers[i], coords, _raison)
		end
	end
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	--if xPlayer.job.name == 'police' then
		local xPlayerTarget = ESX.GetPlayerFromId(target)

		if xPlayerTarget.get('cuffState').isCuffed then
			TriggerClientEvent('esx_policejob:OutVehicle', target)
		end
	--else
	--	print(('esx_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	--end
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('have_withdrawn', count, inventoryItem.label))
				sendToDiscord('Freetz CommuRP - LOGS', '[L.S.P.D] ' ..xPlayer.getName().. ' Vient de prendre | NOM : ' ..itemName.. ' NOMBRE : ' ..count.. '', 3145658)
			else
				TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('quantity_invalid'))
			end
		else
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

--[[
RegisterServerEvent('Freetz:AchatMenotte')
AddEventHandler('Freetz:AchatMenotter', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("iNotificationV3:showNotification", source, "Je cherche les menottes là..")

	if xPlayer.canCarryItem('police_cuff', 2) then 
		xPlayer.addInventoryItem('police_cuff', 1)
		xPlayer.addInventoryItem('police_key', 1)
		TriggerClientEvent("iNotificationV3:showNotification", source, "~g~Vous avez récupérer vos menottes & vos clés")
	else
		TriggerClientEvent("iNotificationV3:showNotification", source, "~r~Vous n\'avez pas assez de place sur vous !")
	end
end) --]]

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('have_deposited', count, ESX.GetItem(itemName).label))
			sendToDiscord('Freetz CommuRP - LOGS', '[L.S.P.D] ' ..xPlayer.getName().. ' Vient de déposer | NOM : ' ..itemName.. ' NOMBRE : ' ..count.. '', 3145658)
		else
			TriggerClientEvent('iNotificationV3:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback("Freetz:GetInventoryPlayer", function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(data)
		local data = {
			identifier = data[1].identifier,
			liquide = xPlayer.getAccount('cash').money,
			argent_sale = xPlayer.getAccount('dirtycash').money,
			inventory = xPlayer.getInventory(),
			weapons = xPlayer.getLoadout()
		}
		cb(data)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb({items = xPlayer.inventory})
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(target),
			job = xPlayer.job,
			job2 = xPlayer.job2,
			inventory = xPlayer.inventory,
			accounts = xPlayer.accounts,
			weapons = xPlayer.loadout,
			firstname = result[1]['firstname'],
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			dob = result[1]['dateofbirth'],
			height = result[1]['height']
		}
	
		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			if licenses ~= nil then
				data.licenses = licenses
			end
		end)
	
		cb(data)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)
				if ConfigPolice.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
				['@identifier'] = result[1].owner
			}, function(result2)
				if ConfigPolice.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end
			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		sendToDiscord('Freetz CommuRP - LOGS', '[L.S.P.D] ' ..xPlayer.getName().. ' Vient de déposer une arme | NOM : ' ..weaponName.. '', 3145658)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i = 1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)
	sendToDiscord('Freetz CommuRP - LOGS', '[L.S.P.D] ' ..xPlayer.getName().. ' Vient de déposer une arme | NOM : ' ..weaponName.. '', 3145658)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i = 1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_policejob:buyWeapon', function(source, cb, weaponName, type, componentNum)
	local xPlayer = ESX.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon = ConfigPolice.AuthorizedWeapons[xPlayer.job.grade_name]

	for i = 1, #authorizedWeapons, 1 do
		if authorizedWeapons[i].weapon == weaponName then
			selectedWeapon = authorizedWeapons[i]
			break
		end
	end

	if not selectedWeapon then
		print(('esx_policejob: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	else
		if type == 1 then
			if xPlayer.getAccount('cash').money >= selectedWeapon.price then
				xPlayer.removeAccountMoney('cash', selectedWeapon.price)
				sendToDiscord('Freetz CommuRP - LOGS', '[L.S.P.D] ' ..xPlayer.getName().. ' vien d`\'achetez une arme | NOM : ' ..weaponName.. '', 3145658)
				xPlayer.addWeapon(weaponName, 100)

				cb(true)
			else
				cb(false)
			end
		elseif type == 2 then
			local price = selectedWeapon.components[componentNum]
			local weaponNum, weapon = ESX.GetWeapon(weaponName)
			local component = weapon.components[componentNum]

			if component then
				if xPlayer.getAccount('cash').money >= price then
					xPlayer.removeAccountMoney('cash', price)
					sendToDiscord('Freetz CommuRP - LOGS', '[L.S.P.D] ' ..xPlayer.getName().. ' Vient de custom sur l\'arme | NOM : ' ..weaponName.. ' et à pris l\'objet ' ..component.name.. '', 3145658)
					xPlayer.addWeaponComponent(weaponName, component.name)

					cb(true)
				else
					cb(false)
				end
			else
				print(('esx_policejob: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
				cb(false)
			end
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('iNotificationV3:showNotification', target, msg)
	end
end)

RegisterServerEvent('AnnonceOuvertLSPD')
AddEventHandler('AnnonceOuvertLSPD', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', 'Nous sommes actuellement ~g~Disponible~s~ !', 'CHAR_LSPD', 8)
    end
end)

RegisterServerEvent('AnnonceFermerLSPD')
AddEventHandler('AnnonceFermerLSPD', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', 'Nous sommes actuellement ~r~Indisponible~s~ !', 'CHAR_LSPD', 8)
    end
end)

RegisterServerEvent('AnnonceRecrutementLSPD')
AddEventHandler('AnnonceRecrutementLSPD', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', 'Les sessions de ~y~Recrutements~s~, sont actuellement ~g~Ouvert~s~ ! Afin d\'y participez rendez vous au ~b~Poste-De-Police~s~ !', 'CHAR_LSPD', 8)
    end
end)

RegisterServerEvent('AnnonceJuanParker')
AddEventHandler('AnnonceJuanParker', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', 'Fin de l\'alerte à la ~r~Bombe~s~ ! Les élèves sont hors de dangers, ~b~1 agent~s~ est à terre.', 'CHAR_LSPD', 8)
    end
end)

RegisterServerEvent('AnnonceCode1')
AddEventHandler('AnnonceCode1', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', 'Déploiement du ~b~Code 1~s~ en ville ! Tout revien à la normal.', 'CHAR_LSPD', 8)
    end
end)

RegisterServerEvent('AnnonceCode2')
AddEventHandler('AnnonceCode2', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', 'Déploiement du ~g~Code 2~s~ en ville ! ~r~Sécurité renforcée~s~ en ville !', 'CHAR_LSPD', 8)
    end
end)

RegisterServerEvent('AnnonceCode3')
AddEventHandler('AnnonceCode3', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('iNotificationV3:showAdvancedNotification', xPlayers[i], ''.. name ..'', '~b~Annonce LSPD', 'Déploiement du ~r~Code 3~s~ en ville ! ~r~Sécurité maximale~s~ en ville !', 'CHAR_LSPD', 8)
    end
end)
--
local messages = {
    "Vous souhaitez améliorer votre ~r~expérience~s~ en jeux ? Utilisez ~b~la boutique~s~ en appuyant directement sur ~g~F1~s~.",
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        for i = 1, #messages do
            TriggerClientEvent('iNotificationV3:showAdvancedNotification', -1, 'Boutique', '~o~Informations :', messages[i], 'CHAR_CALIFORNIA', 15)
            Citizen.Wait(300000)
        end


    end
end)

function sendToDiscord (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF"

local embeds = {
	{
		["title"]=message,
		["type"]="rich",
		["color"] =color,
		["footer"]=  {
			["text"]= "Par Freetz | Pour Freetz Commu - Heure: " ..date_local.. "",
		},
	}
}

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 






--------------------- ↓ FONCTION DIVERS ↓ ----------------------- 

RegisterServerEvent('freetz:annonce:service')
AddEventHandler('freetz:annonce:service', function(matricule, etat)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	if etat == 'prise' then -- SI PRISE DE SERVICE
		for i = 1, #xPlayers, 1 do 
			local autreJoueurs = ESX.GetPlayerFromId(xPlayers[i])
			if autreJoueurs.job.name == 'police' then 
				TriggerClientEvent('freetz:info:service', xPlayers[i], 'prise', matricule)
			end
		end
	elseif etat == 'fin' then -- SI FIN DE SERVICE
		for i = 1, #xPlayers, 1 do 
			local autreJoueurs = ESX.GetPlayerFromId(xPlayers[i])
			if autreJoueurs.job.name == 'police' then 
				TriggerClientEvent('freetz:info:service', xPlayers[i], 'fin', matricule)
			end
		end
	end
end)

RegisterServerEvent('freetz:msg:hg')
AddEventHandler('freetz:msg:hg', function(matricule, msg)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do 
		local autreJoueurs = ESX.GetPlayerFromId(xPlayers[i])
		if autreJoueurs.job.name == 'police' then 
			TriggerClientEvent('freetz:msg:hg', xPlayers[i], matricule, msg)
		end
	end

end)


RegisterServerEvent('freetz:remove:weapon:lspd')
AddEventHandler('freetz:remove:weapon:lspd', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeWeapon('WEAPON_COMBATPISTOL')
	xPlayer.removeWeapon('WEAPON_STUNGUN')
	xPlayer.removeWeapon('WEAPON_NIGHTSTICK')
	xPlayer.removeWeapon('WEAPON_FLASHLIGHT')
	xPlayer.removeWeapon('WEAPON_TACTICALRIFLE')
	xPlayer.removeWeapon('WEAPON_PUMPSHOTGUN')
	xPlayer.removeWeapon('WEAPON_ADVANCEDRIFLE')
	xPlayer.removeWeapon('WEAPON_CARBINERIFLE')
	xPlayer.removeWeapon('WEAPON_CARBINERIFLE')
end)

RegisterServerEvent('freetz:give:weapon:lspd')
AddEventHandler('freetz:give:weapon:lspd', function(grade)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		if grade == 'recruit' then
			xPlayer.addWeapon('WEAPON_NIGHTSTICK', 250)
			xPlayer.addWeapon('WEAPON_FLASHLIGHT', 250)
			xPlayer.addWeapon('WEAPON_STUNGUN', 250)
			xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)
		elseif grade == 'officer' then
			xPlayer.addWeapon('WEAPON_NIGHTSTICK', 250)
			xPlayer.addWeapon('WEAPON_FLASHLIGHT', 250)
			xPlayer.addWeapon('WEAPON_STUNGUN', 250)
			xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)
		elseif grade == 'sergeant' then
			xPlayer.addWeapon('WEAPON_NIGHTSTICK', 250)
			xPlayer.addWeapon('WEAPON_FLASHLIGHT', 250)
			xPlayer.addWeapon('WEAPON_STUNGUN', 250)
			xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)
			xPlayer.addWeapon('WEAPON_ADVANCEDRIFLE', 250)
		elseif grade == 'intendent' then
			xPlayer.addWeapon('WEAPON_NIGHTSTICK', 250)
			xPlayer.addWeapon('WEAPON_FLASHLIGHT', 250)
			xPlayer.addWeapon('WEAPON_STUNGUN', 250)
			xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)
			xPlayer.addWeapon('WEAPON_ADVANCEDRIFLE', 250)
			xPlayer.addWeapon('WEAPON_PUMPSHOTGUN', 250)
		elseif grade == 'lieutenant' then
			xPlayer.addWeapon('WEAPON_NIGHTSTICK', 250)
			xPlayer.addWeapon('WEAPON_FLASHLIGHT', 250)
			xPlayer.addWeapon('WEAPON_STUNGUN', 250)
			xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)
			xPlayer.addWeapon('WEAPON_ADVANCEDRIFLE', 250)
			xPlayer.addWeapon('WEAPON_PUMPSHOTGUN', 250)
			xPlayer.addWeapon('WEAPON_CARBINERIFLE', 250)
		elseif grade == 'chef' then
			xPlayer.addWeapon('WEAPON_NIGHTSTICK', 250)
			xPlayer.addWeapon('WEAPON_FLASHLIGHT', 250)
			xPlayer.addWeapon('WEAPON_STUNGUN', 250)
			xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)
			xPlayer.addWeapon('WEAPON_ADVANCEDRIFLE', 250)
			xPlayer.addWeapon('WEAPON_PUMPSHOTGUN', 250)
			xPlayer.addWeapon('WEAPON_CARBINERIFLE', 250)
		elseif grade == 'boss' then
			xPlayer.addWeapon('WEAPON_NIGHTSTICK', 250)
			xPlayer.addWeapon('WEAPON_FLASHLIGHT', 250)
			xPlayer.addWeapon('WEAPON_STUNGUN', 250)
			xPlayer.addWeapon('WEAPON_COMBATPISTOL', 250)
			xPlayer.addWeapon('WEAPON_ADVANCEDRIFLE', 250)
			xPlayer.addWeapon('WEAPON_PUMPSHOTGUN', 250)
			xPlayer.addWeapon('WEAPON_CARBINERIFLE', 250)
			xPlayer.addWeapon('WEAPON_TACTICALRIFLE', 250)
		end
	else
		DropPlayer(source, "Utilisation de trigger ! (Kick automatique : discord.gg/freetz en cas de problème !)")
	end
end)

RegisterServerEvent('freetz:give:tenue:lspd')
AddEventHandler('freetz:give:tenue:lspd', function(grade)
	local xPlayer = ESX.GetPlayerFromId(source)
	print('freetz:give:tenue:lspd used with sucess !')

	if xPlayer.job.name == 'police' then
		if xPlayer.getAccount('cash').money >= 5000 then
			xPlayer.removeAccountMoney('cash', 5000)
			if grade == 'recruit' then
				xPlayer.addInventoryItem('tenue-cadet', 1)
			elseif grade == 'officer' then
				xPlayer.addInventoryItem('tenue-officier', 1)
			elseif grade == 'sergeant' then
				xPlayer.addInventoryItem('tenue-caporal', 1)
			elseif grade == 'intendent' then
				xPlayer.addInventoryItem('tenue-sergent', 1)
			elseif grade == 'lieutenant' then
				xPlayer.addInventoryItem('tenue-lieutnant', 1)
			elseif grade == 'chef' then
				xPlayer.addInventoryItem('tenue-capitaine', 1)
			elseif grade == 'boss' then
				xPlayer.addInventoryItem('tenue-commandant', 1)
			elseif grade == 'emeute' then 
				xPlayer.removeAccountMoney('cash', 5000)
				xPlayer.addInventoryItem('tenue-emeute', 1)
			elseif grade == 'swat' then 
				xPlayer.removeAccountMoney('cash', 5000)
				xPlayer.addInventoryItem('tenue-swat', 1)
			elseif grade == 'ceremonie' then 
				xPlayer.addInventoryItem('tenue-ceremonie', 1)
			end
		else
			xPlayer.showNotification("~r~Vous n'avez pas assez d'argent !!")
		end
	else
		DropPlayer(source, "Utilisation de trigger ! (Kick automatique : discord.gg/freetz en cas de problème !)")
	end
end)

local function sendToDiscordWithSpecialURL(Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	            ["text"] = "Freetz Commu - R.D.V Police",
	            ["icon_url"] = 'https://cdn.discordapp.com/attachments/1100796934161191043/1106196308764672060/Freetz Commu.png',
	            },
	        }
	    }
	PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('Freetz:Rdv:Police')
AddEventHandler('Freetz:Rdv:Police', function(nomprenom, numero, heurerdv, rdvmotif)
	local xPlayer = ESX.GetPlayerFromId(source)
	local date = os.date('*t')

	if date.day < 10 then date.day = '' .. tostring(date.day) end
	if date.month < 10 then date.month = '' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
	if date.min < 10 then date.min = '' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '' .. tostring(date.sec) end


	sendToDiscordWithSpecialURL(2067276, "__Nouveau Rendez-Vous__\n\n```Nom :``` "..nomprenom.."\n\n```Numéro de Téléphone :``` "..numero.."\n\n```Heure du Rendez Vous :``` " ..heurerdv.."\n\n```Motif du Rendez-vous :``` " ..rdvmotif.. "```\n\nDate :``` " .. date.day .. "." .. date.month .. "." .. date.year .. " | " .. date.hour .. " h " .. date.min .. " min " .. date.sec)
end)