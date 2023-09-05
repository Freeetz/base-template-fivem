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
	for i = 1, #ConfigIkea.Zones, 1 do
		local hash = GetHashKey(ConfigIkea.Zones[i].ped.model)
    	while not HasModelLoaded(hash) do
        	RequestModel(hash)
        	Wait(20)
    	end
    	ped = CreatePed("PED_TYPE_CIVMALE", ConfigIkea.Zones[i].ped.model, ConfigIkea.Zones[i].ped.coords, ConfigIkea.Zones[i].ped.heading, false, true)
		ConfigIkea.Zones[i].ped.handle = ped
		SetPedHearingRange(ped, 0.0)
		SetPedSeeingRange(ped, 0.0)
		SetPedAlertness(ped, 0.0)
		SetPedFleeAttributes(ped, 0, false)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCombatAttributes(ped, 46, true)
		SetEntityInvincible(ped, true)
	end
end)

AddEventHandler('esx_ikea:hasEnteredMarker', function()
	CurrentAction = 'shop_menu'
	CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au IKÉA.'
end)

AddEventHandler('esx_ikea:hasExitedMarker', function()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	for i = 1, #ConfigIkea.Zones, 1 do
		local blip = AddBlipForCoord(ConfigIkea.Zones[i].coords)
		shopBlips[i] = blip

		SetBlipSprite  (blip, 605)
		SetBlipDisplay (blip, 4)
		SetBlipScale   (blip, 0.8)
		SetBlipColour  (blip, 2)
		SetBlipAsShortRange(blip, true) 
		
		BeginTextCommandSetBlipName('STRING') 
		AddTextComponentSubstringPlayerName("Ikéa")
		EndTextCommandSetBlipName(blip) 
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local interval = 2500

		for i = 1, #ConfigIkea.Zones, 1 do
			if ConfigIkea.MarkerType ~= -1 and #(plyCoords - ConfigIkea.Zones[i].coords) < 50 then 
				interval = 0
				if ConfigIkea.MarkerType ~= -1 and #(plyCoords - ConfigIkea.Zones[i].coords) < ConfigIkea.DrawDistance then 
					DrawMarker(ConfigIkea.MarkerType, ConfigIkea.Zones[i].coords, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.5, 0.5, 0.5), ConfigIkea.MarkerColor.r, ConfigIkea.MarkerColor.g, ConfigIkea.MarkerColor.b, ConfigIkea.MarkerColor.a, false, false, 2, true, nil, nil, false)
				end
			end
		end

		Wait(interval)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local interval = 2500

		for i = 1, #ConfigIkea.Zones, 1 do
			if #(plyCoords - ConfigIkea.Zones[i].coords) < 20 then
				interval = 0
				if #(plyCoords - ConfigIkea.Zones[i].coords) < ConfigIkea.MarkerSize.x then
					isInMarker = true
					CurrentZone = i
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_ikea:hasEnteredMarker')
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ikea:hasExitedMarker')
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
					OpenIkea()
				end

				CurrentAction = nil
			end
		end

		Wait(interval)
	end
end)

OpenIkea = function()
	main = RageUI.CreateMenu('', 'Voici nos articles :')

	main.Closed = function()
		TriggerEvent('esx_ikea:hasEnteredMarker')
	end

	RageUI.Visible(main, not RageUI.Visible(main))

	while main do
		Wait(0)
        RageUI.IsVisible(main, function()

			RageUI.Button("~b~→~s~ Radio", nil, {RightLabel = "~g~1'500~s~$"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ikea', 'boombox')
				end 
			})

			RageUI.Button("~b~→~s~ Canapé", nil, {RightLabel = "~g~850~s~$"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ikea', 'canape')
				end 
			})

			RageUI.Button("~b~→~s~ Chaise", nil, {RightLabel = "~g~800~s~$"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ikea', 'chaise')
				end 
			})

			RageUI.Button("~b~→~s~ Grillage", nil, {RightLabel = "~g~8'000~s~$"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ikea', 'grillage')
				end 
			})

			RageUI.Button("~b~→~s~ Table", nil, {RightLabel = "~g~500~s~$"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ikea', 'table')
				end 
			})

			RageUI.Button("~b~→~s~ Télévision", nil, {RightLabel = "~g~5'000~s~$"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ikea', 'television')
				end 
			})

			RageUI.Button("~b~→~s~ Tente", nil, {RightLabel = "~g~7'000~s~$"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ikea', 'tente')
				end 
			})



			RageUI.Separator("___________")

			RageUI.Button("			~r~Fermer le menu", nil, {RightLabel = "→→→"}, true, {
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