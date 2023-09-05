-------- [Base Template] dev par Freetz -------


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(2000)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #ConfigLocation.LocationsBlips, 1 do
		local blip = AddBlipForCoord(ConfigLocation.LocationsBlips[i])

		SetBlipSprite(blip, 171)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Location de véhicule')
		EndTextCommandSetBlipName(blip)
	end
end)

local pos = "Sud"

Citizen.CreateThread(function()
	while true do
		local interval = 2000

		for i = 1, #ConfigLocation.Locations, 1 do
			local distance = #(GetEntityCoords(PlayerPedId(), false) - ConfigLocation.Locations[i].coords)

			if distance < ConfigLocation.DrawDistance then
				interval = 0
				DrawMarker(ConfigLocation.Locations[i].type, ConfigLocation.Locations[i].coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigLocation.Locations[i].size, ConfigLocation.Locations[i].color.r, ConfigLocation.Locations[i].color.g, ConfigLocation.Locations[i].color.b, 100, false, true, 2, false, false, false, false)

				if distance < 1.95 then
					ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour louer un véhicule')

					if IsControlJustReleased(0, 38) then
						pos = "Sud"

						if not cooldown then
							openLocation()
						else
							ESX.ShowNotification("⏲ | Veuillez patienter avant de réouvrir le menu de location !")
						end
					end
				end
			end
		end

		Wait(interval)
	end
end)

local result = math.random(100, 999)
local plate = 'LOCA'.. result

openLocation = function()
	menulocation = RageUI.CreateMenu('', 'Voici les véhicules disponibles :', 0, 0, 'Freetz Commumenu', 'location', 255, 255, 255, 255)

	menulocation.Closed = function()
		local xPlayer = PlayerPedId(source)
		FreezeEntityPosition(xPlayer, false)
	end

	RageUI.Visible(menulocation, not RageUI.Visible(menulocation))

	while menulocation do
		Wait(0)
        RageUI.IsVisible(menulocation, function()
			local xPlayer = PlayerPedId(source)
			FreezeEntityPosition(xPlayer, true)
			--RageUI.Separator("Bienvenue")
			RageUI.Separator("↓ ~g~Voitures~s~ ↓")

			RageUI.Button("~g~>~s~ Panto", nil, {RightLabel = "~g~2\'500$~s~"}, true, {
				onSelected = function()
					local vehicles = GetClosestVehicle(vector3(-1292.6182, 283.5505, 64.8017), 3.0, 0, 71)


					Wait(500)
					if not DoesEntityExist(vehicles) then
						TriggerServerEvent('freetz:PayeLoca:Panto')

						ESX.Game.SpawnVehicle('panto', vector3(-1292.6182, 283.5505, 64.8017), 244.14, function(vehicle)
							local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
							SetVehicleNumberPlateText(vehicle, newPlate)
							local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
						end)

						RageUI.CloseAll()
						local xPlayer = PlayerPedId(source)
						FreezeEntityPosition(xPlayer, false)
						cooldown = true
					else
						ESX.ShowNotification('Il y a déja un véhicule de ~r~sorti~s~ !')
					end
				end
			}, menulocation)

			RageUI.Button("~g~>~s~ Sultan", nil, {RightLabel = "~g~7\'500$~s~"}, true, {
				onSelected = function()
					local vehicles = GetClosestVehicle(vector3(-1292.6182, 283.5505, 64.8017), 3.0, 0, 71)

					Wait(500)
					if not DoesEntityExist(vehicles) then
						TriggerServerEvent('freetz:PayeLoca:Sultan')
						ESX.Game.SpawnVehicle('sultan', vector3(-1292.6182, 283.5505, 64.8017), 244.14, function(vehicle)
							local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
							SetVehicleNumberPlateText(vehicle, newPlate)
							local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
						end)
						RageUI.CloseAll()
						local xPlayer = PlayerPedId(source)
						FreezeEntityPosition(xPlayer, false)
						cooldown = true
					else
						ESX.ShowNotification('Il y a déja un véhicule de ~r~sorti~s~ !')
					end
				end
			}, menulocation)

			RageUI.Button("~g~>~s~ Buffalo", nil, {RightLabel = "~g~5\'000$~s~"}, true, {
				onSelected = function()

						local vehicles = GetClosestVehicle(vector3(-1292.6182, 283.5505, 64.8017), 3.0, 0, 71)


					Wait(500)
					if not DoesEntityExist(vehicles) then
						TriggerServerEvent('freetz:PayeLoca:Buffalo')


							ESX.Game.SpawnVehicle('buffalo', vector3(-1292.6182, 283.5505, 64.8017), 244.14, function(vehicle)
								local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
								SetVehicleNumberPlateText(vehicle, newPlate)
								local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

							end)

						RageUI.CloseAll()
						local xPlayer = PlayerPedId(source)
						FreezeEntityPosition(xPlayer, false)
						cooldown = true
					else
						ESX.ShowNotification('Il y a déja un véhicule de ~r~sorti~s~ !')
					end
				end
			}, menulocation)

			RageUI.Separator("↓ ~g~Motos~s~ ↓")

			RageUI.Button("~g~>~s~ Faggio", nil, {RightLabel = "~g~800$~s~"}, true, {
				onSelected = function()

						local vehicles = GetClosestVehicle(vector3(-1292.6182, 283.5505, 64.8017), 3.0, 0, 71)


					Wait(500)
					if not DoesEntityExist(vehicles) then
						TriggerServerEvent('freetz:PayeLoca:Faggio')


							ESX.Game.SpawnVehicle('faggio', vector3(-1292.6182, 283.5505, 64.8017), 244.14, function(vehicle)
								local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
								SetVehicleNumberPlateText(vehicle, newPlate)
								local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

							end)

						RageUI.CloseAll()
						local xPlayer = PlayerPedId(source)
						FreezeEntityPosition(xPlayer, false)
						cooldown = true
					else
						ESX.ShowNotification('Il y a déja un véhicule de ~r~sorti~s~ !')
					end
				end
			}, menulocation)

			RageUI.Button("~g~>~s~ Sanchez", nil, {RightLabel = "~g~2\'000$~s~"}, true, {
				onSelected = function()
					if pos == "Sud" then
						local vehicles = GetClosestVehicle(vector3(-1292.6182, 283.5505, 64.8017), 3.0, 0, 71)
					else
						local vehicles = GetClosestVehicle(vector3(760.2264, 3401.4685, 62.6774), 3.0, 0, 71)
					end

					Wait(500)
					if not DoesEntityExist(vehicles) then
						TriggerServerEvent('freetz:PayeLoca:Sanchez')


							ESX.Game.SpawnVehicle('sanchez', vector3(-1292.6182, 283.5505, 64.8017), 244.14, function(vehicle)
								local newPlate = exports['Freetz-Core']:GenerateSocietyPlate(plate)
								SetVehicleNumberPlateText(vehicle, newPlate)
								local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

							end)

						RageUI.CloseAll()
						local xPlayer = PlayerPedId(source)
						FreezeEntityPosition(xPlayer, false)
						cooldown = true
					else
						ESX.ShowNotification('Il y a déja un véhicule de ~r~sorti~s~ !')
					end
				end
			}, menulocation)

			RageUI.Separator("___________")

			RageUI.Button("Fermer le menu", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					local xPlayer = PlayerPedId(source)
					FreezeEntityPosition(xPlayer, false)
					RageUI.CloseAll()
				end
			}, menulocation)

		end, function()
		end)
		if not RageUI.Visible(menulocation) then
            menulocation = RMenu:DeleteType("menulocation", true)
		end
	end
end

CreateThread(function()
	while cooldown do 
		Wait(120000)
		cooldown = false
	end
end)