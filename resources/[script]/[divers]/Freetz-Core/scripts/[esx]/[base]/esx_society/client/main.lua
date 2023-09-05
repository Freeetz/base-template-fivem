-------- [Base Template] dev par Freetz -------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenBossMenu(society, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}

	ESX.TriggerServerCallback('esx_society:isBoss', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		withdraw = true,
		deposit = true,
		wash = true,
		employees = true,
		grades = true
	}

	for k, v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.withdraw then
		table.insert(elements, {label = 'Retirer argent société', value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = 'Déposer argent société', value = 'deposit_money'})
	end

	if options.employees then
		table.insert(elements, {label = 'Gestion employés', value = 'manage_employees'})
	end

	if options.grades then
		table.insert(elements, {label = 'Gestion des salaires', value = 'manage_grades'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title = 'Menu Patron',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw_society_money' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = 'montant du retrait'
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification('~r~Montant invalide')
				else
					menu.close()
					TriggerServerEvent('esx_society:withdrawMoney', society, amount)
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'deposit_money' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = 'montant du dépôt'
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification('~r~Montant invalide')
				else
					menu.close()
					TriggerServerEvent('esx_society:depositMoney', society, amount)
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(society)
		elseif data.current.value == 'manage_grades' then
			OpenManageGradesMenu(society)
		end
	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)
end

function OpenBossMenu2(society, close, options)
	local isBoss = nil
	local options = options or {}
	local elements = {}

	ESX.TriggerServerCallback('esx_society:isBoss2', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		withdraw = true,
		deposit = true,
		--wash = true,
		employees = true
	}

	for k, v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.withdraw then
		table.insert(elements, {label = 'Retirer argent société', value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = 'Déposer argent société', value = 'deposit_money'})
	end

	if options.employees then
		table.insert(elements, {label = 'Gestion employés', value = 'manage_employees'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title = 'Menu Patron',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw_society_money' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = 'montant du retrait'
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification('~r~Montant invalide')
				else
					menu.close()
					TriggerServerEvent('esx_society:withdrawMoney', society, amount)
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'deposit_money' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = 'montant du dépôt'
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification('~r~Montant invalide')
				else
					menu.close()
					TriggerServerEvent('esx_society:depositMoney', society, amount)
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu2(society)
		end
	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)
end

function OpenManageEmployeesMenu(society)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title = 'gestion employés',
		elements = {
			{label = 'liste des employés', value = 'employee_list'},
			{label = 'recruter', value = 'recruit'}
		}
	}, function(data, menu)
		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenu(society)
		end
	end, function(data, menu)
	end)
end

function OpenManageEmployeesMenu2(society)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title = 'gestion employés',
		elements = {
			{label = 'liste des employés', value = 'employee_list'},
			{label = 'recruter', value = 'recruit'}
		}
	}, function(data, menu)
		if data.current.value == 'employee_list' then
			OpenEmployeeList2(society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenu2(society)
		end
	end, function(data, menu)
	end)
end

function OpenEmployeeList(society)
	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
		local elements = {
			head = {'employé', 'grade', 'actions'},
			rows = {}
		}

		for i = 1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{promouvoir|promote}} {{licencier|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification('Vous avez viré'..employee.name)
				ESX.TriggerServerCallback('esx_society:setJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenEmployeeList2(society)
	ESX.TriggerServerCallback('esx_society:getEmployees2', function(employees)
		local elements = {
			head = {'employé', 'grade', 'actions'},
			rows = {}
		}

		for i = 1, #employees, 1 do
			local gradeLabel = (employees[i].job2.grade_label == '' and employees[i].job2.label or employees[i].job2.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{promouvoir|promote}} {{licencier|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu2(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification('Vous avez viré'..employee.name)
				ESX.TriggerServerCallback('esx_society:setJob2', function()
					OpenEmployeeList2(society)
				end, employee.identifier, 'unemployed2', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenRecruitMenu(society)
	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
		local elements = {}

		for i = 1, #players, 1 do
			if players[i].job.name ~= society then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
			title = 'Recrutement',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				title = 'Voulez-vous recruter '..data.current.name,
				elements = {
					{label = '~r~non',  value = 'no'},
					{label = '~g~oui', value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification('Vous avez recruté '..data.current.name)
					ESX.TriggerServerCallback('esx_society:setJob', function()
						OpenRecruitMenu(society)
					end, data.current.identifier, society, 0, 'hire')
				end
			end, function(data2, menu2)
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenRecruitMenu2(society)
	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
		local elements = {}

		for i = 1, #players, 1 do
			if players[i].job2.name ~= society then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
			title = 'Recrutement',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				title = 'Voulez-vous recruter '..data.current.name,
				elements = {
					{label = 'non',  value = 'no'},
					{label = 'oui', value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification('Vous avez recruté '..data.current.name)
					ESX.TriggerServerCallback('esx_society:setJob2', function()
						OpenRecruitMenu2(society)
					end, data.current.identifier, society, 0, 'hire')
				end
			end, function(data2, menu2)
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenPromoteMenu(society, employee)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}

		for i = 1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.job.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title = 'promouvoir '..employee.name,
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.ShowNotification('Vous avez promu '..employee.name..' en tant que '..data.current.label)
			ESX.TriggerServerCallback('esx_society:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			OpenEmployeeList(society)
		end)
	end, society)
end

function OpenPromoteMenu2(society, employee)
	ESX.TriggerServerCallback('esx_society:getJob', function(job2)
		local elements = {}

		for i = 1, #job2.grades, 1 do
			local gradeLabel = (job2.grades[i].label == '' and job2.label or job2.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job2.grades[i].grade,
				selected = (employee.job2.grade == job2.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title = 'promouvoir '..employee.name,
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.ShowNotification('Vous avez promu '..employee.name..' en tant que '..data.current.label)
			ESX.TriggerServerCallback('esx_society:setJob2', function()
				OpenEmployeeList2(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			OpenEmployeeList2(society)
		end)
	end, society)
end

function OpenManageGradesMenu(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}

		for i = 1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				rightlabel = {'$' .. ESX.Math.GroupDigits(job.grades[i].salary)},
				value = job.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title = 'gestion salaires',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = 'Montant du salaire ?'
			}, function(data2, menu2)
				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification('~r~Montant invalide')
				elseif amount > 50000 then
					ESX.ShowNotification('~r~Montant trop élevé !')
				else
					menu2.close()
					ESX.TriggerServerCallback('esx_society:setJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end, society)
end

AddEventHandler('esx_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

AddEventHandler('esx_society:OpenEmployeeList2', function(society)
    OpenEmployeeList2(society)
end)

AddEventHandler('esx_society:openBossMenu2', function(society, close, options)
	OpenBossMenu2(society, close, options)
end)