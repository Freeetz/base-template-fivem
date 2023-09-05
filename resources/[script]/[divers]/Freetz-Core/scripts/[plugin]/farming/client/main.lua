-------- [Base Template] dev par Freetz -------


local HasAlreadyEnteredMarker = false
local lastZone, lastType = nil

local CurrentAction = {zone = nil, type = nil}
local CurrentActionMsg = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

function PlayAnim(personne, animDict, animName, duration)
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(0)
	end

	TaskPlayAnim(personne, animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

function PlayFarmAnim()
	Citizen.CreateThread(function()
		ExecuteCommand("e pickup")
		Citizen.Wait(ConfigFarming.FarmTime)
		ClearPedTasks(PlayerPedId())
	end)
end

AddEventHandler('farming:hasEnteredMarker', function(zone, type)
	CurrentAction = {zone = zone, type = type}
	CurrentActionMsg = ('Appuyez sur ~INPUT_CONTEXT~ pour %s'):format(ConfigFarming.Zones[zone][type].ActionHelp)
end)

AddEventHandler('farming:hasExitedMarker', function(zone, type)
	CurrentAction = {zone = nil, type = nil}
	TriggerServerEvent('farming:stopAction', zone, type)
end)

RegisterNetEvent('farming:changeMarker')
AddEventHandler('farming:changeMarker', function(zone, type)
	ConfigFarming.Zones[zone][type].ActionCoords = ConfigFarming.Zones[zone][type].RandomCoords[math.random(1, #ConfigFarming.Zones[zone][type].RandomCoords)]
end)

Citizen.CreateThread(function()
	while true do
		local plyCoords = GetEntityCoords(PlayerPedId())
		local interval = 2500

		for k, v in pairs(ConfigFarming.Zones) do
			for k2, v2 in pairs(v) do
				if #(plyCoords - v2.ActionCoords) < ConfigFarming.DrawDistance and v2.ActionPed == nil then
					interval = 0
					DrawMarker(ConfigFarming.MarkerType, v2.ActionCoords.x, v2.ActionCoords.y, v2.ActionCoords.z - 1.05, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigFarming.MarkerSize, ConfigFarming.MarkerColor.r, ConfigFarming.MarkerColor.g, ConfigFarming.MarkerColor.b, 255, false, false, 2, false, false, false, false)
				end
			end
		end

		for i = 1, #ConfigFarming.Peds, 1 do
			if #(plyCoords - ConfigFarming.Peds[i].Coords) < ConfigFarming.DrawTextDistance then
				interval = 0
				ESX.Game.Utils.DrawText3D(vector3(ConfigFarming.Peds[i].Coords.x, ConfigFarming.Peds[i].Coords.y, ConfigFarming.Peds[i].Coords.z + 2.05), ConfigFarming.Peds[i].Name)
			end
		end

		Wait(interval)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #ConfigFarming.Blips, 1 do
		ConfigFarming.Blips[i].Handle = AddBlipForCoord(ConfigFarming.Blips[i].Coords)

		SetBlipSprite(ConfigFarming.Blips[i].Handle, ConfigFarming.Blips[i].Sprite)
		SetBlipDisplay(ConfigFarming.Blips[i].Handle, 4)
		SetBlipScale(ConfigFarming.Blips[i].Handle, ConfigFarming.Blips[i].Size)
		SetBlipColour(ConfigFarming.Blips[i].Handle, ConfigFarming.Blips[i].Color)
		SetBlipAsShortRange(ConfigFarming.Blips[i].Handle, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(ConfigFarming.Blips[i].Label)
		EndTextCommandSetBlipName(ConfigFarming.Blips[i].Handle)
	end
end)

Citizen.CreateThread(function()
	while true do
		local plyCoords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone = nil
		local interval = 2500
		local currentType = nil

		for k, v in pairs(ConfigFarming.Zones) do
			for k2, v2 in pairs(v) do
				if #(plyCoords - v2.ActionCoords) < ConfigFarming.MarkerSize.x * 3 then
					interval = 0
					isInMarker = true
					currentZone = k
					currentType = k2
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			interval = 0
			hasAlreadyEnteredMarker = true
			lastZone = currentZone
			lastType = currentType
			TriggerEvent('farming:hasEnteredMarker', currentZone, currentType)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			interval = 0
			hasAlreadyEnteredMarker = false
			TriggerEvent('farming:hasExitedMarker', lastZone, lastType)
		end

		Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 2000

		if CurrentAction.zone ~= nil and CurrentAction.type ~= nil then
			interval = 0
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and IsPedOnFoot(PlayerPedId()) then
				TriggerServerEvent('farming:startAction', CurrentAction.zone, CurrentAction.type)
				ConfigFarming.Zones[CurrentAction.zone][CurrentAction.type].ActionCB()
				CurrentAction = {zone = nil, type = nil}
			end
		end

		Wait(interval)
	end
end)