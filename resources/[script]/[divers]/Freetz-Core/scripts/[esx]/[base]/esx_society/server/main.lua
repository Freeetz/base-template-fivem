local Jobs = {}
local RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(result)
		for i = 1, #result, 1 do
			Jobs[result[i].name] = result[i]
			Jobs[result[i].name].grades = {}
		end
	
		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(result2)
			for i = 1, #result2, 1 do
				Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
			end
		end)
	end)
end)

function GetSociety(name)
	for i = 1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

function isPlayerBoss(xPlayerJob, jobName)
	if (jobName == xPlayerJob.name or jobName == 'unemployed' or jobName == 'unemployed2') and xPlayerJob.grade_name == 'boss' then
		return true
	else
		return false
	end
end

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name = name,
		label = label,
		account = account,
		datastore = datastore,
		inventory = inventory,
		data = data,
	}

	for i = 1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))

	if not isPlayerBoss(xPlayer.job, societyName) and not isPlayerBoss(xPlayer.job2, societyName) then
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount and amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addAccountMoney('cash', amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous avez retiré '.. ESX.Math.GroupDigits(amount))
			sendToDiscord('Freetz CommuRP - LOGS', '[ENTREPRISES] ' ..xPlayer.getName().. ' Vient de prendre de l\'argent dans une entreprise | Nom de l\'entreprise : ' ..society.name.. ' | Somme : ' ..amount.. '', 3145658)
			TriggerEvent("esx:withdrawsocietymoney", xPlayer.name, amount, society.name)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Montant invalide !')
		end
	end)
end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))

	if not isPlayerBoss(xPlayer.job, societyName) and not isPlayerBoss(xPlayer.job2, societyName) then
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and xPlayer.getAccount('cash').money >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeAccountMoney('cash', amount)
			account.addMoney(amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous avez déposé '.. ESX.Math.GroupDigits(amount))
			TriggerEvent("esx:depositsocietymoney", xPlayer.name, amount, society.name)
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Montant invalide !')
	end
end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local _source = source
	if _source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(_source)

		if (xPlayer.job.name ~= societyName) and (xPlayer.job2.name ~= societyName) then
			print(('esx_society: %s attempted to put vehicle!'):format(xPlayer.identifier))
			return
		end
	end

	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local _source = source
	if _source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(_source)

		if (xPlayer.job.name ~= societyName) and (xPlayer.job2.name ~= societyName) then
			print(('esx_society: %s attempted to remove vehicle!'):format(xPlayer.identifier))
			return
		end
	end

	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i = 1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	if source == 0 then
		local society = GetSociety(societyName)

		if society then
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				cb(account.money)
			end)
		else
			cb(0)
		end
	else
		local xPlayer = ESX.GetPlayerFromId(source)

		if (xPlayer.job.name == societyName) or (xPlayer.job2.name == societyName) then
			local society = GetSociety(societyName)

			if society then
				TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
					cb(account.money)
				end)
			else
				cb(0)
			end
		else
			print(('esx_society: %s attempted to get society money!'):format(xPlayer.identifier))
			cb(0)
		end
	end
end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, societyName)
	if source == 0 then
		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = societyName
		}, function(results)
			local employees = {}

			for i = 1, #results, 1 do
				table.insert(employees, {
					name = (results[i].firstname or 'Inconnu') .. ' ' .. (results[i].lastname or 'Inconnu'),
					identifier = results[i].identifier,
					job = {
						name = results[i].job,
						label = Jobs[results[i].job].label,
						grade = results[i].job_grade,
						grade_name = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
						grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		local xPlayer = ESX.GetPlayerFromId(source)

		if (xPlayer.job.name == societyName) or (xPlayer.job2.name == societyName) then
			MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
				['@job'] = societyName
			}, function(results)
				local employees = {}

				for i = 1, #results, 1 do
					table.insert(employees, {
						name = (results[i].firstname or 'Inconnu') .. ' ' .. (results[i].lastname or 'Inconnu'),
						identifier = results[i].identifier,
						job = {
							name = results[i].job,
							label = Jobs[results[i].job].label,
							grade = results[i].job_grade,
							grade_name = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
							grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
						}
					})
				end

				cb(employees)
			end)
		else
			print(('esx_society: %s attempted to get employees!'):format(xPlayer.identifier))
			cb({})
		end
	end
end)

ESX.RegisterServerCallback('esx_society:getEmployees2', function(source, cb, societyName)
	if source == 0 then
		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job2, job2_grade FROM users WHERE job2 = @job2 ORDER BY job2_grade DESC', {
			['@job2'] = societyName
		}, function(results)
			local employees = {}

			for i = 1, #results, 1 do
				table.insert(employees, {
					name = (results[i].firstname or 'Inconnu') .. ' ' .. (results[i].lastname or 'Inconnu'),
					identifier = results[i].identifier,
					job2 = {
						name = results[i].job2,
						label = Jobs[results[i].job2].label,
						grade = results[i].job2_grade,
						grade_name = Jobs[results[i].job2].grades[tostring(results[i].job2_grade)].name,
						grade_label = Jobs[results[i].job2].grades[tostring(results[i].job2_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		local xPlayer = ESX.GetPlayerFromId(source)

		if (xPlayer.job.name == societyName) or (xPlayer.job2.name == societyName) then
			MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job2, job2_grade FROM users WHERE job2 = @job2 ORDER BY job2_grade DESC', {
				['@job2'] = societyName
			}, function(results)
				local employees = {}

				for i = 1, #results, 1 do
					table.insert(employees, {
						name = (results[i].firstname or 'Inconnu') .. ' ' .. (results[i].lastname or 'Inconnu'),
						identifier = results[i].identifier,
						job2 = {
							name = results[i].job2,
							label = Jobs[results[i].job2].label,
							grade = results[i].job2_grade,
							grade_name = Jobs[results[i].job2].grades[tostring(results[i].job2_grade)].name,
							grade_label = Jobs[results[i].job2].grades[tostring(results[i].job2_grade)].label
						}
					})
				end

				cb(employees)
			end)
		else
			print(('esx_society: %s attempted to get employees2!'):format(xPlayer.identifier))
			cb({})
		end
	end
end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	local job = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k, v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades
	cb(job)
end)

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = isPlayerBoss(xPlayer.job, job)

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez été recruté dans la société ~b~'.. job)
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez été promu')
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez été viré !')
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job'] = job,
				['@job_grade'] = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setJob2', function(source, cb, identifier, job2, grade2, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = isPlayerBoss(xPlayer.job2, job2)

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob2(job2, grade2)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez été recruté dans le groupe illégaux ~r~'.. job2)
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez été promu')
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez été viré !')
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job2 = @job2, job2_grade = @job2_grade WHERE identifier = @identifier', {
				['@job2'] = job2,
				['@job2_grade'] = grade2,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob2'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = isPlayerBoss(xPlayer.job, job)

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary'] = salary,
				['@job_name'] = job,
				['@grade'] = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i = 1, #xPlayers, 1 do
					local result, thePlayer = xpcall(ESX.GetPlayerFromId, function(err)
						print("ERROR:", err)
					end, xPlayers[i])

					if thePlayer ~= nil and thePlayer.job.name == job and thePlayer.job.grade == grade then
						thePlayer.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(xPlayer.identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players = {}

	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer then
			table.insert(players, {
				source = xPlayer.source,
				identifier = xPlayer.identifier,
				name = xPlayer.name,
				job = xPlayer.job,
				job2 = xPlayer.job2
			})
		end
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(ESX.GetPlayerFromId(source).job, job))
end)

ESX.RegisterServerCallback('esx_society:isBoss2', function(source, cb, job2)
	cb(isPlayerBoss(ESX.GetPlayerFromId(source).job2, job2))
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