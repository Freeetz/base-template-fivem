-------- [Base Template] dev par Freetz -------


local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local isDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

function OpenShopMenuAccessory(accessory)
	local _accessory = string.lower(accessory)
	local restrict = {_accessory .. '_1', _accessory .. '_2'}

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = "Valider cet achat ?",
			elements = {
				{label = "Non", value = 'no'},
				{label = "Oui", rightlabel = {'~g~100$'}, value = 'yes'}
			}
		}, function(data2, menu2)
			ESX.UI.Menu.CloseAll()
			CurrentAction = 'shop_menu'

			if data2.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_accessories:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerServerEvent('esx_accessories:pay')
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_accessories:save', skin, accessory)
						end)
					else
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)
						ESX.ShowNotification("~r~Vous n\'avez pas assez d\'argent !")
					end
				end)
			end

			if data2.current.value == 'no' then
				local player = PlayerPedId()

				TriggerEvent('esx_skin:getLastSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)

				if accessory == "Ears" then
					ClearPedProp(player, 2)
				elseif accessory == "Mask" then
					SetPedComponentVariation(player, 1, 0 ,0, 2)
				elseif accessory == "Helmet" then
					ClearPedProp(player, 0)
				elseif accessory == "Glasses" then
					SetPedPropIndex(player, 1, -1, 0, 0)
				end
			end
		end, function(data, menu)
		end)
	end, function(data, menu)
	end, restrict)
end

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('esx_accessories:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = "Appuyez sur E pour accèder au menu"
	CurrentActionData = { accessory = zone }
end)

AddEventHandler('esx_accessories:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips --
Citizen.CreateThread(function()
	for k, v in pairs(ConfigMasques.ShopsBlips) do
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i])

			SetBlipSprite(blip, v.Blip.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.6)
			SetBlipColour(blip, 69)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName("Magasin de Masque")
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local interval = 2500

		for k, v in pairs(ConfigMasques.Zones) do
			for i = 1, #v.Pos, 1 do
				if #(plyCoords - v.Pos[i]) < 50 then
					interval = 0
					if #(plyCoords - v.Pos[i]) < ConfigMasques.DrawDistance then
						DrawMarker(ConfigMasques.MarkerType, v.Pos[i], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(0.5, 0.5, 0.5), ConfigMasques.MarkerColor.r, ConfigMasques.MarkerColor.g, ConfigMasques.MarkerColor.b, ConfigMasques.MarkerColor.a, false, false, 2, true, nil, nil, false)
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
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local currentZone

		for k, v in pairs(ConfigMasques.Zones) do
			for i = 1, #v.Pos, 1 do
				if #(plyCoords - v.Pos[i]) < ConfigMasques.MarkerSize.x then
					interval = 0
					isInMarker = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			interval = 0
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_accessories:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			interval = 0
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_accessories:hasExitedMarker', LastZone)
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
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and CurrentActionData.accessory then
				OpenShopMenuAccessory(CurrentActionData.accessory)
				CurrentAction = nil
			end
		end

		Wait(interval)
	end
end)