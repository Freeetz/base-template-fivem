-------- [Base Template] dev par Freetz -------

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end
end)

local HasAlreadyEnteredMarker = false
local CurrentAction, CurrentActionMsg, CurrentZone = nil, '', nil

local shopBlips = {}
local shopItems = {}
local objects = {}

local robbing = false

local ShopMenu = {
	ItemIndex = 1
}

CreateThread(function()
	for i = 1, #ConfigSuperette.Zones, 1 do
		local hash = GetHashKey(ConfigSuperette.Zones[i].ped.model)
    	while not HasModelLoaded(hash) do
        	RequestModel(hash)
        	Wait(20)
    	end
    	ped = CreatePed("PED_TYPE_CIVMALE", ConfigSuperette.Zones[i].ped.model, ConfigSuperette.Zones[i].ped.coords, ConfigSuperette.Zones[i].ped.heading, false, true)
		ConfigSuperette.Zones[i].ped.handle = ped
		SetPedHearingRange(ped, 0.0)
		SetPedSeeingRange(ped, 0.0)
		SetPedAlertness(ped, 0.0)
		SetPedFleeAttributes(ped, 0, false)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCombatAttributes(ped, 46, true)
		SetEntityInvincible(ped, true)
	end
end)

AddEventHandler('esx_shops:hasEnteredMarker', function()
	CurrentAction = 'shop_menu'
	CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin."
end)

AddEventHandler('esx_shops:hasExitedMarker', function()
	CurrentAction = nil
end)

RegisterNetEvent('esx_shops:removePickup')
AddEventHandler('esx_shops:removePickup', function(bank)
	for i = 1, #objects do
		if objects[i].bank == bank and DoesEntityExist(objects[i].handle) then
			DeleteObject(objects[i].handle)
		end
	end
end)

RegisterNetEvent('esx_shops:robberyOver')
AddEventHandler('esx_shops:robberyOver', function()
	Citizen.Wait(10000)
	robbing = false
end)

RegisterNetEvent('esx_shops:talk')
AddEventHandler('esx_shops:talk', function(store, text, time)
	robbing = false
	local endTime = GetGameTimer() + 1000 * time

	while endTime >= GetGameTimer() do
		local pedCoords = GetEntityCoords(ConfigSuperette.Zones[store].ped.handle)
		ESX.Game.Utils.DrawText3D(vector3(pedCoords.x, pedCoords.y, pedCoords.z + 1.0), text, 0.5)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_shops:resetStore')
AddEventHandler('esx_shops:resetStore', function(store)
	local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(ped), 5.0, `prop_till_01_dam`)

	if DoesEntityExist(brokenCashRegister) then
		CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, `prop_till_01_dam`, `prop_till_01`, false)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #ConfigSuperette.Zones, 1 do
		local blipsuperette = AddBlipForCoord(ConfigSuperette.Zones[i].coords)
		shopBlips[i] = blipsuperette

		SetBlipSprite  (blipsuperette, 52)
		SetBlipDisplay (blipsuperette, 4)
		SetBlipScale   (blipsuperette, 0.8)
		SetBlipColour  (blipsuperette, 2)
		SetBlipAsShortRange(blipsuperette, true) 
		
		BeginTextCommandSetBlipName('STRING') 
		AddTextComponentSubstringPlayerName("Supérette")
		EndTextCommandSetBlipName(blipsuperette) 
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local plyCoords = GetEntityCoords(PlayerPedId(), false)

		for i = 1, #ConfigSuperette.Zones, 1 do
			if ConfigSuperette.MarkerType ~= -1 and #(plyCoords - ConfigSuperette.Zones[i].coords) < 50 then 
				interval = 0
				if ConfigSuperette.MarkerType ~= -1 and #(plyCoords - ConfigSuperette.Zones[i].coords) < ConfigSuperette.DrawDistance then 
					DrawMarker(ConfigSuperette.MarkerType, ConfigSuperette.Zones[i].coords, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.5, 0.5, 0.5), ConfigSuperette.MarkerColor.r, ConfigSuperette.MarkerColor.g, ConfigSuperette.MarkerColor.b, ConfigSuperette.MarkerColor.a, false, false, 2, true, nil, nil, false)
				end
			end

			if ConfigSuperette.Zones[i].ped.handle and #(plyCoords - ConfigSuperette.Zones[i].ped.coords) < ConfigSuperette.DrawTextDistance and not IsPedDeadOrDying(ConfigSuperette.Zones[i].ped.handle) then
				ESX.Game.Utils.DrawText3D(GetPedBoneCoords(ConfigSuperette.Zones[i].ped.handle, 31086, vector3(0.3, 0.0, 0.0)), ConfigSuperette.Zones[i].ped.name, 0.70)
			end
		end

		Wait(interval)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false

		for i = 1, #ConfigSuperette.Zones, 1 do
			if #(plyCoords - ConfigSuperette.Zones[i].coords) < 20 then
				interval = 0
				if #(plyCoords - ConfigSuperette.Zones[i].coords) < ConfigSuperette.MarkerSize.x then
					isInMarker = true
					CurrentZone = i
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_shops:hasEnteredMarker')
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shops:hasExitedMarker')
		end

		Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if CurrentAction ~= nil then
			interval = 0
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					openSuperette()
				end

				CurrentAction = nil
			end
		end

		Wait(interval)
	end
end)

openSuperette = function()
	main = RageUI.CreateMenu('Supérette', 'Voici les catégories disponibles :')

	main.Closed = function()
		TriggerEvent('esx_shops:hasEnteredMarker')
	end

	RageUI.Visible(main, not RageUI.Visible(main))

	while main do
		Wait(0)
        RageUI.IsVisible(main, function()

			RageUI.Button("> Nos Produits", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					openSuperette2()
				end
			}, main)

			if exports['Freetz-Core']:GetVIP() then
				RageUI.Button("> Nos Produits - ~y~V.I.P~s~", nil, {RightLabel = "→→→"}, true, {
					onSelected = function()
						openSuperette3()
					end 
				}, main)
			else
				RageUI.Button("> Nos Produits - ~y~V.I.P~s~", nil, {RightLabel = "→→→"}, false, {
					onSelected = function()
						ESX.ShowNotification("~r~Vous n\'avez pas accès à ceci !")
					end 
				}, main)
			end

			RageUI.Separator("___________")

			RageUI.Button("~r~Fermer le menu", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					RageUI.CloseAll()
				end
			}, main)

		end, function()
		end)

		if not RageUI.Visible(main) then
            main = RMenu:DeleteType("main", true)
		end
	end
end

openSuperette2 = function()
	main2 = RageUI.CreateMenu('Nos Produits', 'Voici nos produits :')

	main2.Closed = function()
		TriggerEvent('esx_shops:hasEnteredMarker')
	end

	RageUI.Visible(main2, not RageUI.Visible(main2))

	while main2 do 
		Wait(0)
		RageUI.IsVisible(main2, function()

			RageUI.Separator("↓ ~p~Commestibles~s~ ↓")

			RageUI.Button("> Pain", nil, {RightLabel = "~g~8$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Pain')
				end
			}, main2)

			RageUI.Button("> Burger", nil, {RightLabel = "~g~25$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Burger')
				end
			}, main2)

			RageUI.Button("> Bouteille d\'eau", nil, {RightLabel = "~g~9$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Eau')
				end
			}, main2)

			RageUI.Button("> Canette de Coca Cola", nil, {RightLabel = "~g~30$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Coca')
				end
			}, main2)

			RageUI.Separator("↓ ~y~Divers~s~ ↓")

			RageUI.Button("> Canne à pêche", nil, {RightLabel = "~g~500$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Canne')
				end
			}, main2)

			RageUI.Button("> Radio", nil, {RightLabel = "~g~150$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Radio')
				end
			}, main2)

			--RageUI.Button("> Kit de réparation", nil, {RightLabel = "~g~8000$~s~"}, true, {
			--	onSelected = function()
			--		TriggerServerEvent('freetz:achat:Repa')
			--	end
			--}, main2)

			--RageUI.Button("> Kit de carosserie", nil, {RightLabel = "~g~4000$~s~"}, true, {
			--	onSelected = function()
			--		TriggerServerEvent('freetz:achat:Caro')
			--	end
			--}, main2)

			RageUI.Button("> Bombe à Spray", nil, {RightLabel = "~g~500$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Spray')
				end
			}, main2)

			RageUI.Button("> Éponge", nil, {RightLabel = "~g~500$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Eponge')
				end
			}, main2)

			RageUI.Button("> Coyote", nil, {RightLabel = "~g~5'000$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:coyote')
				end
			}, main2)

			RageUI.Button("> GPS", nil, {RightLabel = "~g~5'000$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:gps')
				end
			}, main2)

			RageUI.Separator("___________")

			RageUI.Button("~r~Fermer le menu", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					RageUI.CloseAll()
				end
			}, main2)
		
	end, function()
	end, 1)

	if not RageUI.Visible(main2) then 
		main2 = RMenu:DeleteType("main2", true)
	end
end
end

openSuperette3 = function()
	main3 = RageUI.CreateMenu('Nos Produits', 'Voici nos produits V.I.P :')

	main3.Closed = function()
		TriggerEvent('esx_shops:hasEnteredMarker')
	end

	RageUI.Visible(main3, not RageUI.Visible(main3))

	while main3 do 
		Wait(0)
		RageUI.IsVisible(main3, function()

			RageUI.Separator("↓ ~s~Produits ~y~V.I.P~s~ ↓")

			RageUI.Button("> Pack de 8 capotes", nil, {RightLabel = "~g~50$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Capote')
				end
			}, main3)

			RageUI.Button("> Menotte Basique", nil, {RightLabel = "~g~800$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Menotte')
				end
			}, main3)

			RageUI.Button("> Clé de Menotte Basique", nil, {RightLabel = "~g~600$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Cle')
				end
			}, main3)

			RageUI.Button("> BMX", nil, {RightLabel = "~g~850$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Bmx')
				end
			}, main3)

			RageUI.Button("> Cigarette", nil, {RightLabel = "~g~20$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Cigarette')
				end
			}, main3)

			RageUI.Button("> Kit de réparation", nil, {RightLabel = "~g~8000$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Repa')
				end
			}, main3)

			RageUI.Button("> Kit de carosserie", nil, {RightLabel = "~g~4000$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:Caro')
				end
			}, main3)

			RageUI.Button("> Gants De Boxe", nil, {RightLabel = "~g~250$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:gant')
				end
			}, main3)

			RageUI.Button("> Feu d\'artifice", nil, {RightLabel = "~g~200$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:feu')
				end
			}, main3)

			RageUI.Button("> Masque de plongée", nil, {RightLabel = "~g~250$~s~"}, true, {
				onSelected = function()
					ESX.ShowNotification("~r~Action impossible pour le moment !")
				end
			}, main3)

			RageUI.Separator("___________")

			RageUI.Button("~r~Fermer le menu", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					RageUI.CloseAll()
				end
			}, main3)
		
	end, function()
	end, 1)

	if not RageUI.Visible(main3) then 
		main3 = RMenu:DeleteType("main3", true)
	end
end
end