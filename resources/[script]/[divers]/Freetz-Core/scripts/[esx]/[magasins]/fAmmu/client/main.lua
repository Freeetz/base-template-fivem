-------- [Base Template] dev par Freetz -------

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(2000)
	end
end)

local cooldown = false
local HasAlreadyEnteredMarker = false
local CurrentAction, CurrentActionMsg, CurrentZone = nil, '', nil

AddEventHandler('fAmmunation:hasEnteredMarker', function()
	CurrentAction = 'ammu_menu'
	CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin.'
end)

AddEventHandler('fAmmunation:hasExitedMarker', function()
	CurrentAction = nil
end)

RegisterNetEvent('fAmmunation:talk')
AddEventHandler('fAmmunation:talk', function(store, text, time)
	robbing = false
	local endTime = GetGameTimer() + 1000 * time

	while endTime >= GetGameTimer() do
		local pedCoords = GetEntityCoords(ConfigAmmu.Zones[store].ped.handle)
		ESX.Game.Utils.DrawText3D(vector3(pedCoords.x, pedCoords.y, pedCoords.z + 1.0), text, 0.5)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #ConfigAmmu.Coords, 1 do
		local blipammu = AddBlipForCoord(ConfigAmmu.Coords[i])
		--shopBlips[i] = blip

		SetBlipSprite  (blipammu, 110)
		SetBlipDisplay (blipammu, 4)
		SetBlipScale   (blipammu, 0.8)
		--SetBlipColour  (blip, 2)
		SetBlipAsShortRange(blipammu, true) 
		
		BeginTextCommandSetBlipName('STRING') 
		AddTextComponentSubstringPlayerName("Ammunation")
		EndTextCommandSetBlipName(blipammu) 
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local plyCoords = GetEntityCoords(PlayerPedId(), false)

		for i = 1, #ConfigAmmu.Coords, 1 do
			if ConfigAmmu.MarkerType ~= -1 and #(plyCoords - ConfigAmmu.Coords[i]) < 50 then 
				interval = 0
				if ConfigAmmu.MarkerType ~= -1 and #(plyCoords - ConfigAmmu.Coords[i]) < ConfigAmmu.DrawDistance then 
					DrawMarker(ConfigAmmu.MarkerType, ConfigAmmu.Coords[i], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.5, 0.5, 0.5), ConfigAmmu.MarkerColor.r, ConfigAmmu.MarkerColor.g, ConfigAmmu.MarkerColor.b, ConfigAmmu.MarkerColor.a, false, false, 2, true, nil, nil, false)
				end
			end
		end

		Wait(interval)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		local interval = 1500
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false

		for i = 1, #ConfigAmmu.Coords, 1 do
			if #(plyCoords - ConfigAmmu.Coords[i]) < ConfigAmmu.MarkerSize.x then
				interval = 0
				isInMarker = true
				CurrentZone = i
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = true
			TriggerEvent('fAmmunation:hasEnteredMarker')
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = false
			TriggerEvent('fAmmunation:hasExitedMarker')
		end

		Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 1500

		if CurrentAction ~= nil then
			interval = 0
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'ammu_menu' then
					openAmmunation()
				end

				CurrentAction = nil
			end
		end

		Wait(interval)
	end
end)

openAmmunation = function()
	ammuMenu = RageUI.CreateMenu('Ammunations', 'Voici les articles disponibles :')

	ammuMenu.Closed = function()
		TriggerEvent('fAmmunation:hasEnteredMarker')
	end

	RageUI.Visible(ammuMenu, not RageUI.Visible(ammuMenu))

	while ammuMenu do
		Wait(0)
        RageUI.IsVisible(ammuMenu, function()

			RageUI.Button("> Armes blanches", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					openArmeBlanche()
				end
			}, ammuMenu)

			RageUI.Button("> Armes à feux", nil, {RightLabel = "→→→"}, false, {
				onSelected = function()
					ESX.ShowNotification("~r~Vous n\'avez pas votre PPA afin d\'accéder à ceci !")
				end 
			}, ammuMenu)

--[[ 			RageUI.Separator("↓~b~ Divers ~s~↓") -- Chargeurs

			RageUI.Button("> Chargeurs", nil, {RightLabel = "~g~200$~s~"}, not cooldown, {
				onSelected = function()
					cooldown = true
					TriggerServerEvent('freetz:chargeur')
					print('trigger "freetz:chargeur" effectué !')

					Citizen.SetTimeout(500, function() cooldown = false end)
				end 
			}, ammuMenu) ]]

			RageUI.Separator("___________")

			RageUI.Button("~r~Fermer le menu", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					RageUI.CloseAll()
				end
			}, ammuMenu)

		end, function()
		end)

		if not RageUI.Visible(ammuMenu) then
            ammuMenu = RMenu:DeleteType("ammuMenu", true)
		end
	end
end

openArmeBlanche = function()
	AmmuMenu2 = RageUI.CreateMenu('Nos Armes Blanches', 'Voici nos armes blanches :')

	AmmuMenu2.Closed = function()
		TriggerEvent('fAmmunation:hasEnteredMarker')
	end

	RageUI.Visible(AmmuMenu2, not RageUI.Visible(AmmuMenu2))

	while AmmuMenu2 do 
		Wait(0)
		RageUI.IsVisible(AmmuMenu2, function()

			RageUI.Separator("↓ ~p~Armes Blanches~s~ ↓")

			RageUI.Button("> Couteau", nil, {RightLabel = "~g~5'000$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ammu', 'WEAPON_KNIFE', 5000)
				end
			}, AmmuMenu2)

			RageUI.Button("> Batte de baseball", nil, {RightLabel = "~g~7'000$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ammu', 'WEAPON_BAT', 7000)
				end
			}, AmmuMenu2)

			RageUI.Button("> Poing Américain", nil, {RightLabel = "~g~4'500$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ammu', 'WEAPON_KNUCKLE', 4500)
				end
			}, AmmuMenu2)

			RageUI.Button("> Couteau à cran d\'arrêt", nil, {RightLabel = "~g~7'000$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ammu', 'WEAPON_SWITCHBLADE', 7000)
				end
			}, AmmuMenu2)

			RageUI.Button("> Machette", nil, {RightLabel = "~g~3'500$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ammu', 'WEAPON_MACHETE', 7000)
				end
			}, AmmuMenu2)

			RageUI.Button("> Poignard", nil, {RightLabel = "~g~1'500$~s~"}, true, {
				onSelected = function()
					TriggerServerEvent('freetz:achat:ammu', 'WEAPON_DAGGER', 1500)
				end
			}, AmmuMenu2)

			RageUI.Separator("___________")

			RageUI.Button("~r~Fermer le menu", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					RageUI.CloseAll()
				end
			}, AmmuMenu2)
		
	end, function()
	end, 1)

	if not RageUI.Visible(AmmuMenu2) then 
		AmmuMenu2 = RMenu:DeleteType("AmmuMenu2", true)
	end
end
end

RegisterNetEvent('freetz:useClip')
AddEventHandler('freetz:useClip', function()
    local playerPed = PlayerPedId()

    if IsPedArmed(playerPed, 4) then
        local hash = GetSelectedPedWeapon(playerPed)

        if hash then
            TriggerServerEvent('freetz:removeClip')
            AddAmmoToPed(playerPed, hash, 25)
            ESX.ShowNotification("Vous avez ~g~utilisé~s~ 1x chargeur ! (+ 25 Munitions)")
        else
            ESX.ShowNotification("~r~Action Impossible~s~ : Vous n'avez pas d'arme en ammuMenu !")
        end
    else
        ESX.ShowNotification("~r~Action Impossible~s~ : Ce type de munition ne convient pas !")
    end
end)