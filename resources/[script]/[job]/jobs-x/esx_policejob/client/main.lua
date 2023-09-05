local PlayerData = {}

local HasAlreadyEnteredMarker = false

local LastStation = nil
local LastPart = nil
local LastPartNum = nil
local LastEntity = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local IsHandcuffed = false

local playerInService = false
local hasAlreadyJoined = false

local isDead = false
local CurrentTask = {}

local DragStatus = {}
DragStatus.isDragged = false
DragStatus.dragger = tonumber(draggerId)

shieldActive = false
shieldEntity = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

rxList = {
	serviceTenue = 1,
	giletCadet = 1,
	giletPBL = 1,
}

local menu_police_garage = RageUI.CreateMenu("Police", "Garage :")
local menu_g = false 
menu_police_garage.Closed = function()
	menu_g = false 
end
menu_police_garage:SetTotalItemsPerPage(13)

function OpenGarageLSPD()
	if menu_g then 
		menu_g = false 
		RageUI.Visible(menu_police_garage, false)
        return
	else
		menu_g = true 
        RageUI.Visible(menu_police_garage, true)

		Citizen.CreateThread(function()
            while menu_g do 
				Citizen.Wait(1)

				RageUI.IsVisible(menu_police_garage, function()
					RageUI.Separator("↓ ~r~Garage~s~ ↓")

					RageUI.Button('Dodge', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'police3'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)
							end
						end
                    }) 

					RageUI.Button('Moto', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'policeb'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)
							end
						end
                    }) 

					RageUI.Button('Buffalo', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'police2'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    }) 


					RageUI.Button('Véhicule à Haute Vitesse', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'polgs350'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    }) 

					RageUI.Button('V.I.R', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'ghispo2'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    })
					
					RageUI.Button('GTX L.S.P.D', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'poldom'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    })

					RageUI.Button('Porsche L.S.P.D', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'apolicec6'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    })

					RageUI.Button('Gauntlet L.S.P.D', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'nkgauntlet4'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    })

					RageUI.Separator("↓ ~b~Blindé~s~ ↓")

					RageUI.Button('R.I.O.T', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'riot'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    })

					RageUI.Button('Camion Blindé', nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
							local car = 'policet'

							local vehicles = GetClosestVehicle(vector3(483.2976, -1020.4835, 27.9024), 3.0, 0, 71)

							if not DoesEntityExist(vehicles) then
								ESX.Game.SpawnVehicle(car, vector3(483.2976, -1020.4835, 27.9024), 270.2068, function(vehicle)
									local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
									SetVehicleNumberPlateText(vehicle, newPlate)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								end)

							end
						end
                    }) 


				end)

			end
		end)
	end
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0.0)
end

function setUniformPolice(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if ConfigPolice.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigPolice.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if ConfigPolice.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigPolice.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end



local cooldownv = false
local vestPolice_menu = false
local menu_vestPolice = RageUI.CreateMenu("Police", "Vestiaire :")
menu_vestPolice.Closed = function()
    vestPolice_menu = false
end
menu_vestPolice:SetTotalItemsPerPage(11)

function OpenCloakroomMenuPolice()
    if vestPolice_menu then 
        vestPolice_menu = false 
        RageUI.Visible(menu_vestPolice, false)
        return
    else
        vestPolice_menu = true 
        RageUI.Visible(menu_vestPolice, true)

        Citizen.CreateThread(function()
            while vestPolice_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(menu_vestPolice, function()

					
					RageUI.Separator("~g~↓↓~s~  Tenue de service  ~g~↓↓~s~")

					RageUI.Button('Prendre votre tenue', nil, {RightLabel = "~g~5'000~s~$"}, not cooldownv, {
                        onSelected = function()
							cooldownv = true
							TriggerServerEvent('freetz:give:tenue:lspd', PlayerData.job.grade_name)

							Citizen.SetTimeout(360000, function() cooldownv = false end)
                        end
                    }) 

					RageUI.Separator("~g~↓↓~s~  Intervention & Autres  ~g~↓↓~s~")

					RageUI.Button('Tenue Anti-émeute', nil, {RightLabel = "~g~10'000~s~$"}, true, {
                        onSelected = function()
							TriggerServerEvent('freetz:give:tenue:lspd', 'emeute')
                        end
                    }) 

					RageUI.Button('Tenue du S.W.A.T', nil, {RightLabel = "~g~10'000~s~$"}, true, {
                        onSelected = function()
							TriggerServerEvent('freetz:give:tenue:lspd', 'swat')
                        end
                    }) 

					RageUI.Button('Tenue de Cérémonie', nil, {RightLabel = "~g~10'000~s~$"}, true, {
                        onSelected = function()
							TriggerServerEvent('freetz:give:tenue:lspd', 'ceremonie')
                        end
                    }) 

					RageUI.Separator("~g~↓↓~s~  Gilet  ~g~↓↓~s~")

					RageUI.List("Gilet cadet", {"Equiper", "Enlever"}, rxList.giletCadet, nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, {
						onListChange = function(Index)
							rxList.giletCadet = Index
						end, 

						onSelected = function(Index)
							if Index == 1 then 
								setUniformPolice('gilet_wear', PlayerPedId())
							elseif Index == 2 then
								cleanPlayer(PlayerPedId())
								setUniformPolice('gilet_wear1', PlayerPedId())
							end
						end
					})

					RageUI.List("Gilet pare-balle", {"Equiper", "Enlever"}, rxList.giletPBL, nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, {
						onListChange = function(Index)
							rxList.giletPBL = Index
						end, 

						onSelected = function(Index)
							if Index == 1 then 
								setUniformPolice("bullet_wear", PlayerPedId())
							elseif Index == 2 then
								cleanPlayer(PlayerPedId())
								setUniformPolice("bullet_wear1", PlayerPedId())
							end
						end
					})
				end)
            end
        end)
    end
end


local coffreObjet, coffreArmes = {}, {}

local armPolice_menu = false
local menu_armPolice = RageUI.CreateMenu("Police", "Coffre :")
local buy_menu_armPolice = RageUI.CreateSubMenu(menu_armPolice, "Police", "Coffre :")
local recupArme_menu_armPolice = RageUI.CreateSubMenu(menu_armPolice, "Police", "Coffre :")
local depArme_menu_armPolice = RageUI.CreateSubMenu(menu_armPolice, "Police", "Coffre :")
local recupObjet_menu_armPolice = RageUI.CreateSubMenu(menu_armPolice, "Police", "Coffre :")
local depObjet_menu_armPolice = RageUI.CreateSubMenu(menu_armPolice, "Police", "Coffre :")
menu_armPolice.CloarmPolice_menused = function()
    armPolice_menu = false
end

function OpenArmoryMenu(station)
    if armPolice_menu then 
        armPolice_menu = false 
        RageUI.Visible(menu_armPolice, false)
        return
    else
        armPolice_menu = true 
        RageUI.Visible(menu_armPolice, true)

        Citizen.CreateThread(function()
            while armPolice_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(menu_armPolice, function()

					RageUI.Separator("~g~↓↓~s~  Armurerie  ~g~↓↓~s~")

					RageUI.Button('Acheter une arme', nil, {RightLabel = "→→→"}, true, {
                    }, buy_menu_armPolice) 
					

					RageUI.Button('Déposer une arme', nil, {RightLabel = "→→→"}, true, {
                    }, depArme_menu_armPolice) 

					if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'intendent' then
						RageUI.Button('Retirer une arme', nil, {RightLabel = "→→→"}, true, {
							onSelected = function()
								
							end
						}, recupArme_menu_armPolice) 
					else
						RageUI.Button('Retirer une arme', nil, {RightLabel = "→→→"}, false, {
						}, recupArme_menu_armPolice) 
					end


					RageUI.Separator("~g~↓↓~s~  Coffre  ~g~↓↓~s~")

					RageUI.Button('Déposer un objet', nil, {RightLabel = "→→→"}, true, {
                    }, depObjet_menu_armPolice) 

					if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'intendent' then
						RageUI.Button('Prendre un objet', nil, {RightLabel = "→→→"}, true, {
							onSelected = function()
								
							end
						}, recupObjet_menu_armPolice) 
					else
						RageUI.Button('Prendre un objet', nil, {RightLabel = "→→→"}, false, {
						}, recupObjet_menu_armPolice) 
					end
					
				end)

				RageUI.IsVisible(buy_menu_armPolice, function()
			
					RageUI.Separator("~g~↓↓~s~  Armurerie  ~g~↓↓~s~")

					RageUI.Button("Rendre son équipement", "Si vous stoppez votre service sans rendre vos armes, vous risqué de vous faire wype.", {RightLabel = "~b~→→→~s~"}, true, {
						onSelected = function()
							TriggerServerEvent('freetz:remove:weapon:lspd')
						end
					})

					RageUI.Button("Prendre son équipement", "Prennez votre équipement uniquement si vous prennez votre service !", {RightLabel = "~b~→→→~s~"}, true, {
						onSelected = function()
							TriggerServerEvent('freetz:give:weapon:lspd', PlayerData.job.grade_name)
						end
					})

					RageUI.Line()

				end)

				RageUI.IsVisible(depArme_menu_armPolice, function()
					
				end)

				RageUI.IsVisible(recupArme_menu_armPolice, function()
					
				end)

				
				RageUI.IsVisible(depObjet_menu_armPolice, function()
					
				end)

				RageUI.IsVisible(recupObjet_menu_armPolice, function()

				end)
            end
        end)
    end
end


-- function OpenArmoryMenu(station)
-- 	local elements = {
-- 		{label = _U('buy_weapons'), value = 'buy_weapons'},
-- 		{label = _U('recup_police_items'), value = 'buy_items'},
-- 		{label = _U('get_weapon'), value = 'get_weapon'},
-- 		{label = _U('put_weapon'), value = 'put_weapon'},
-- 		{label = _U('remove_object'), value = 'get_stock'},
-- 		{label = _U('deposit_object'), value = 'put_stock'}
-- 	}

-- 	ESX.UI.Menu.CloseAll()

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
-- 		title = _U('armory'),
-- 		elements = elements
-- 	}, function(data, menu)
-- 		if data.current.value == 'buy_weapons' then
-- 			OpenBuyWeaponsMenu(station)
-- 		end

-- 		if data.current.value == 'buy_items' then
-- 			--TriggerServerEvent('Freetz:AchatMenotte')
-- 		end

-- 		if data.current.value == 'get_weapon' then
-- 			if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'intendent' then
-- 				OpenGetWeaponMenu()
-- 			else
-- 				ESX.ShowNotification("~r~Vous devez être le Commandant ou Capitaine, afin d\'avoir accès à ceci !")
-- 			end
-- 		end

-- 		if data.current.value == 'put_weapon' then
-- 			OpenPutWeaponMenu()
-- 		end

-- 		if data.current.value == 'get_stock' then
-- 			OpenGetStocksMenu()
-- 		end

-- 		if data.current.value == 'put_stock' then
-- 			OpenPutStocksMenu()
-- 		end
-- 	end, function(data, menu)
-- 		CurrentAction = 'menu_armory'
-- 		CurrentActionMsg = _U('open_armory')
-- 		CurrentActionData = {station = station}
-- 	end)
-- end

function OpenVehicleSpawnerMenuPolice(station, partNum)
	local vehicles = ConfigPolice.PoliceStations[station].Vehicles
	ESX.UI.Menu.CloseAll()

	if ConfigPolice.EnableSocietyOwnedVehicles then
		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)
			for i = 1, #garageVehicles, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model), rightlabel = {'[' .. garageVehicles[i].plate .. ']'}, value = garageVehicles[i]})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
				title = _U('cacao'),
				elements = elements
			}, function(data, menu)
				menu.close()

				ESX.Game.SpawnVehicle(data.current.value.model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, data.current.value)
				end)

				TriggerServerEvent('esx_society:removeVehicleFromGarage', 'police', data.current.value)
			end, function(data, menu)
				CurrentAction = 'menu_vehicle_spawner'
				CurrentActionMsg = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}
			end)
		end, 'police')
	else
		local elements = {}
		local authorizedVehicles = ConfigPolice.AuthorizedVehicles[PlayerData.job.grade_name]

		for i = 1, #authorizedVehicles, 1 do
			table.insert(elements, {label = authorizedVehicles[i].label, model = authorizedVehicles[i].model})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			title = _U('cacao'),
			elements = elements
		}, function(data, menu)
			menu.close()

			local model = data.current.model
			local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint, 3.0, 0, 71)

			if not DoesEntityExist(vehicle) then
				local playerPed = PlayerPedId()

				if ConfigPolice.MaxInService == -1 then
					ESX.Game.SpawnVehicle(model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
						local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
						SetVehicleNumberPlateText(vehicle, newPlate)
						TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
						--TriggerServerEvent('esx_vehiclelock:registerkey', newPlate, 'no')
						--SetVehicleMaxMods(vehicle)
					end)
				else
					ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
						if isInService then
							ESX.Game.SpawnVehicle(model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
								local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
								SetVehicleNumberPlateText(vehicle, newPlate)
								TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
								--SetVehicleMaxMods(vehicle)
							end)
						else
							ESX.ShowNotification(_U('service_not'))
						end
					end, 'police')
				end
			else
				ESX.ShowNotification(_U('vehicle_out'))
			end
		end, function(data, menu)
			CurrentAction = 'menu_vehicle_spawner'
			CurrentActionMsg = _U('vehicle_spawner')
			CurrentActionData = {station = station, partNum = partNum}
		end)
	end
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title = _U('fine'),
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'), value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'), value = 3}
		}
	}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
		local elements = {}

		for i = 1, #fines, 1 do
			table.insert(elements, {
				label = fines[i].label,
				rightlabel = {'$' .. fines[i].amount},
				value = fines[i].id,
				amount = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title = _U('fine'),
			elements = elements
		}, function(data, menu)
			menu.close()

			if ConfigPolice.EnablePlayerManagement then
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', data.current.fineLabel), data.current.amount)
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
		end)
	end, category)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = _U('search_database_title')
	}, function(data, menu)
		if (data.value == nil) or (string.len(data.value) ~= 8) then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)

			menu.close()
		end
	end, function(data, menu)
	end)
end

function ShowPlayerLicense(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i = 1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end

		local targetName = (data.firstname or 'Inconnu') .. ' ' .. (data.lastname or 'Inconnu')

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title = _U('license_revoke'),
			elements = elements
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
		end)
	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i = 1, #bills, 1 do
			table.insert(elements, {label = bills[i].label, rightlabel = {'$' .. bills[i].amount}, value = bills[i].id})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title = _U('unpaid_bills'),
			elements = elements
		}, function(data, menu)
		end, function(data, menu)
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title = _U('vehicle_info'),
			elements = elements
		}, nil, function(data, menu)
		end)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i = 1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {label = ESX.GetWeaponLabel(weapons[i].name), rightlabel = {'[' .. weapons[i].count .. ']'}, value = weapons[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title = _U('get_weapon_menu'),
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i = 1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title = _U('put_weapon_menu'),
		elements = elements
    }, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	PlayerData = ESX.GetPlayerData()

	for k, v in ipairs(ConfigPolice.AuthorizedWeapons[PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i = 1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = component.label
						rightlabel = {_U('armory_owned')}
					else
						if v.components[i] > 0 then
							label = component.label
							rightlabel = {_U('armory_item', ESX.Math.GroupDigits(v.components[i]))}
						else
							label = component.label
							rightlabel = {_U('armory_free')}
						end
					end

					table.insert(components, {
						label = label,
						rightlabel = rightlabel,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = weapon.label
			rightlabel = {'>'}
		elseif hasWeapon and not v.components then
			label = weapon.label
			rightlabel = {_U('armory_owned')}
		else
			if v.price > 0 then
				label = weapon.label
				rightlabel = {_U('armory_item', ESX.Math.GroupDigits(v.price))}
			else
				label = weapon.label
				rightlabel = {_U('armory_free')}
			end
		end

		table.insert(elements, {
			label = label,
			rightlabel = rightlabel,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title = _U('armory_weapontitle'),
		elements = elements
	}, function(data, menu)
		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end
	end, function(data, menu)
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title = _U('armory_componenttitle'),
		elements = components
	}, function(data, menu)
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)
		local elements = {}

		for i = 1, #items, 1 do
			table.insert(elements, {label = items[i].label, rightlabel = {'(' .. items[i].count .. ')'}, value = items[i].name})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = _U('police_stock'),
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_policejob:getStockItem', data.current.value, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
		local elements = {}

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label, rightlabel = {'(' .. item.count .. ')'}, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = _U('inventory'),
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_policejob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name = _U('phone_police'),
		number = 'police',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'police' and PlayerData.job.name == dispatchNumber then
		if ConfigPolice.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
  if part == 'Cloakroom' then
    CurrentAction = 'menu_cloakroom'
    CurrentActionMsg = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction = 'menu_armory'
    CurrentActionMsg = _U('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
    CurrentAction = 'menu_vehicle_spawner'
    CurrentActionMsg = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'HelicopterSpawner' then
    local helicopters = ConfigPolice.PoliceStations[station].Helicopters

    if not IsAnyVehicleNearPoint(vector3(-327.2168, -1072.7723, 43.7215), 3.0) then
      ESX.Game.SpawnVehicle('polmav', vector3(-327.2168, -1072.7723, 42.7214), helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
      end)
    end
  end

  if part == 'VehicleDeleter' then
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed, false)

    if IsPedInAnyVehicle(playerPed,  false) then
      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction = 'delete_vehicle'
        CurrentActionMsg = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end
    end
  end

  if part == 'BossActions' then
    CurrentAction = 'menu_boss_actions'
    CurrentActionMsg = _U('open_bossmenu')
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction = 'remove_entity'
		CurrentActionMsg = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == `p_ld_stinger_s` then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)

		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i = 0, 7, 1 do
				SetVehicleTyreBurst(vehicle,  i,  true,  1000)
			end
		end
	end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(draggerId)
	DragStatus.isDragged = not DragStatus.isDragged
	DragStatus.dragger = tonumber(draggerId)

	if not DragStatus.isDragged then
		DetachEntity(PlayerPedId(), true, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()

		if DragStatus.isDragged then
			local target = GetPlayerFromServerId(DragStatus.dragger)

			if target ~= PlayerId() and target > 0 then
				local targetPed = GetPlayerPed(target)

				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(plyPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.isDragged = false
					DetachEntity(plyPed, true, false)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	local plyPed = PlayerPedId()
	local coords = GetEntityCoords(plyPed, false)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i = maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				DragStatus.isDragged = false
				DetachEntity(plyPed, true, false)
				TaskWarpPedIntoVehicle(plyPed, vehicle, freeSeat)
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	local plyPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(plyPed) then
		return
	end

	DragStatus.isDragged = false
	DetachEntity(plyPed, true, false)
	local vehicle = GetVehiclePedIsIn(plyPed, false)
	TaskLeaveVehicle(plyPed, vehicle, 16)
end)

Citizen.CreateThread(function() 
	local blip4 = AddBlipForCoord(431.8424, -981.6880, 30.7107)
		SetBlipSprite  (blip4, 60)
		SetBlipDisplay (blip4, 4)
		SetBlipScale   (blip4, 0.8)
		SetBlipColour  (blip4, 4)
		SetBlipAsShortRange(blip4, true) 
		SetBlipCategory(blip, 99)

		BeginTextCommandSetBlipName('STRING') 
		AddTextComponentSubstringPlayerName("L.S.P.D")
		EndTextCommandSetBlipName(blip4) 
  end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed, false)

			for k, v in pairs(ConfigPolice.PoliceStations) do
				for i = 1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true) < ConfigPolice.DrawDistance then
						DrawMarker(ConfigPolice.MarkerType, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigPolice.MarkerSize, ConfigPolice.MarkerColor.r, ConfigPolice.MarkerColor.g, ConfigPolice.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i = 1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i], true) < ConfigPolice.DrawDistance then
						DrawMarker(ConfigPolice.MarkerType, v.Armories[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigPolice.MarkerSize, ConfigPolice.MarkerColor.r, ConfigPolice.MarkerColor.g, ConfigPolice.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i = 1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner, true) < ConfigPolice.DrawDistance then
						DrawMarker(ConfigPolice.MarkerType, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigPolice.MarkerSize, ConfigPolice.MarkerColor.r, ConfigPolice.MarkerColor.g, ConfigPolice.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i = 1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i], true) < ConfigPolice.DrawDistance then
						DrawMarker(ConfigPolice.MarkerType, v.VehicleDeleters[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigPolice.MarkerSize, ConfigPolice.MarkerColor.r, ConfigPolice.MarkerColor.g, ConfigPolice.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				if ConfigPolice.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then
					for i = 1, #v.BossActions, 1 do
						if GetDistanceBetweenCoords(coords, v.BossActions[i], true) < ConfigPolice.DrawDistance then
							DrawMarker(ConfigPolice.MarkerType, v.BossActions[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigPolice.MarkerSize, ConfigPolice.MarkerColor.r, ConfigPolice.MarkerColor.g, ConfigPolice.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local coords = GetEntityCoords(PlayerPedId(), false)
			local isInMarker = false
			local currentStation = nil
			local currentPart = nil
			local currentPartNum = nil

			for k, v in pairs(ConfigPolice.PoliceStations) do
				for i = 1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true) < ConfigPolice.MarkerSize.x then
						isInMarker = true
						currentStation = k
						currentPart = 'Cloakroom'
						currentPartNum = i
					end
				end

				for i = 1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i], true) < ConfigPolice.MarkerSize.x then
						isInMarker = true
						currentStation = k
						currentPart = 'Armory'
						currentPartNum = i
					end
				end

				for i = 1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner, true) < ConfigPolice.MarkerSize.x then
						isInMarker = true
						currentStation = k
						currentPart = 'VehicleSpawner'
						currentPartNum = i
					end

					if GetDistanceBetweenCoords(coords, v.Vehicles[i].SpawnPoint, true) < ConfigPolice.MarkerSize.x then
						isInMarker = true
						currentStation = k
						currentPart = 'VehicleSpawnPoint'
						currentPartNum = i
					end
				end

				for i = 1, #v.Helicopters, 1 do
					if GetDistanceBetweenCoords(coords, v.Helicopters[i].Spawner, true) < 15 then
						isInMarker = true
						currentStation = k
						currentPart = 'HelicopterSpawner'
						currentPartNum = i
					end

					if GetDistanceBetweenCoords(coords, v.Helicopters[i].SpawnPoint, true) < ConfigPolice.MarkerSize.x then
						isInMarker = true
						currentStation = k
						currentPart = 'HelicopterSpawnPoint'
						currentPartNum = i
					end
				end

				for i = 1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i], true) < ConfigPolice.MarkerSize.x then
						isInMarker = true
						currentStation = k
						currentPart = 'VehicleDeleter'
						currentPartNum = i
					end
				end

				if ConfigPolice.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then
					for i = 1, #v.BossActions, 1 do
						if GetDistanceBetweenCoords(coords, v.BossActions[i], true) < ConfigPolice.MarkerSize.x then
							isInMarker = true
							currentStation = k
							currentPart = 'BossActions'
							currentPartNum = i
						end
					end
				end
			end

			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
					TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation = currentStation
				LastPart = currentPart
				LastPartNum = currentPartNum

				TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
		end
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		`prop_roadcone02a`,
		`prop_barrier_work05`,
		`p_ld_stinger_s`,
		`prop_boxpile_07d`,
		`hei_prop_cash_crate_half_full`
	}

	while true do
		local Sleep = 1000

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)
		local closestDistance = -1
		local closestEntity = nil

		for i = 1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, trackedEntities[i], false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object, false)
				local distance = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				Sleep = 500
				TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
		Wait(Sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentSubstringPlayerName(CurrentActionMsg)
			EndTextCommandDisplayHelp(0, 0, 1, -1)

			if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenuPolice()
				elseif CurrentAction == 'menu_armory' then
					if ConfigPolice.MaxInService == -1 then
						OpenArmoryMenu(CurrentActionData.station)
					elseif playerInService then
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OpenGarageLSPD()
				elseif CurrentAction == 'delete_vehicle' then
					if ConfigPolice.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)
					end
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
						CurrentAction = 'menu_boss_actions'
						CurrentActionMsg = _U('open_bossmenu')
						CurrentActionData = {}
					end, {wash = false})
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end	
				CurrentAction = nil
			end
		end

		if (IsControlJustReleased(0, 167) or IsDisabledControlJustReleased(0, 167)) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			if ConfigPolice.MaxInService == -1 then
				WarMenu.OpenMenu('policemenu')
			elseif playerInService then
				WarMenu.OpenMenu('policemenu')
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 38) and CurrentTask.Busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(CurrentTask.Task)
			ClearPedTasks(PlayerPedId())

			CurrentTask.Busy = false
		end
	end
end)

AddEventHandler('playerSpawned', function()
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end

	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'police')

		if ConfigPolice.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'police')
		end
	end
end)

-- Armurerie
Citizen.CreateThread(function()
	local hash = GetHashKey("s_m_y_cop_01")
	
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(20)
	end

	ped = CreatePed("PED_TYPE_CIVFEMALE", "s_m_y_cop_01", 441.0357, -978.7866, 29.6896, 181.6562, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)
end)

function ImpoundVehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
	CurrentTask.Busy = false
end