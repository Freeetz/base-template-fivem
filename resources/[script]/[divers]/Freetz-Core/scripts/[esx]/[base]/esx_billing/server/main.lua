TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(target, sharedAccountName, label, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(target)
	amount = ESX.Math.Round(amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
		if amount < 0 then
			print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
		elseif account == nil then
			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target'] = xPlayer.identifier,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('esx:showAdvancedNotification', target, 'Banquier', 'Réception d\'une facture', 'Vous avez ~r~reçu~s~ une facture', 'BILLING')
					TriggerClientEvent('esx_billing:newBill', target)
					
				end)
			end
		else
			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target'] = sharedAccountName,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('esx:showAdvancedNotification', target, 'Banquier', 'Réception d\'une facture', 'Vous avez ~r~reçu~s~ une facture', 'BILLING')
					TriggerClientEvent('esx_billing:newBill', target)
					
				end)
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				identifier = result[i].identifier,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				identifier = result[i].identifier,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)
		local sender = result[1].sender
		local targetType = result[1].target_type
		local target = result[1].target
		local amount = result[1].amount
		local xTarget = ESX.GetPlayerFromIdentifier(sender)

		if targetType == 'player' then
			if xTarget ~= nil then
				if xPlayer.getAccount('bank').money >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank', amount)
						TriggerClientEvent('esx:showNotification', source, 'Vous avez ~g~payé~s~ une facture de ~g~'..ESX.Math.GroupDigits(amount)..'$~s~')
						if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~g~recu~s~ un paiement de ~g~'..ESX.Math.GroupDigits(amount)..'~s~$ !') end
						
						cb()
					end)
				else
					TriggerClientEvent('esx:showNotification', source, '~r~Vous n\'avez pas assez d\'argent pour payer cette facture !')
					if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, 'L\'individu n\'as pas assez d\'argent pour payer cette facture !') end
					cb()
				end
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Le joueur n\'est pas connecté !')
				cb()
			end
		else
			TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
				if xPlayer.getAccount('bank').money >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)
						TriggerClientEvent('esx:showNotification', source, 'Vous avez ~g~payé~s~ une facture de ~g~'..ESX.Math.GroupDigits(amount)..'$~s~')
						if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez ~g~recu~s~ un paiement de ~g~'..ESX.Math.GroupDigits(amount)..'~s~$ !') end
						
						cb()
					end)
				else
					TriggerClientEvent('esx:showNotification', source, '~r~Vous n\'avez pas assez d\'argent pour payer cette facture !')
					if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, 'L\'individu n\'as pas assez d\'argent pour payer cette facture !') end
					cb()
				end
			end)
		end
	end)
end)


-----------------------------------------------> Freetz Commu - esx_billing (modification) <-----------------------------------------------


ESX.RegisterServerCallback('Freetz:FactureListe', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
			})
		end

		cb(bills)
	end)
end)

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

RegisterServerEvent('Freetz:Whype')
AddEventHandler('Freetz:Whype', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then 
		-- logs discord
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

		if discord == nil or discord == '' then 
			Logs(3141376, "**Cette personne a été whype parce que elle avait trop de facture ! Voici ces informations : \n\nNom :** "..NamePlayer.."\n**Discord :** ``Inconnu``\n**License :** "..xPlayer.identifier, "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
		else
			Logs(3141376, "**Cette personne a été whype parce que elle avait trop de facture ! Voici ces informations : \n\nNom :** "..NamePlayer.."\n**Discord :** <@".. discord .. ">\n**License :** "..xPlayer.identifier, "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
		end

		-- Whype et déconnection
		MySQL.Async.execute("DELETE FROM billing WHERE identifier = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		MySQL.Sync.execute("DELETE FROM users WHERE identifier = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)
		
		MySQL.Sync.execute("DELETE FROM playerstattoos WHERE identifier = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE owner = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		MySQL.Sync.execute("DELETE FROM addon_inventory_items WHERE owner = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		MySQL.Sync.execute("DELETE FROM addon_account_data WHERE owner = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		MySQL.Sync.execute("DELETE FROM property_created WHERE owner = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE owner = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		MySQL.Sync.execute("DELETE FROM datastore_data WHERE owner = @identifier", {
			["@identifier"] = xPlayer.identifier
		}, function()
		end)

		DropPlayer(xPlayer.source, "Kick automatiquement du serveur.\n\n Raison de la déconnexion : Vous avez été automatiquement whype puisque vous possédiez trop de factures impayées !")
	end
end)