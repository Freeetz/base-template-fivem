local taxi_menu = false
local menu_taxi = RageUI.CreateMenu("Taxi", "Intéractions disponible")
local menu_taxi_annonce = RageUI.CreateSubMenu(menu_taxi, "Taxi", "Intéractions annonces : ")
local menu_taxi_vehicule = RageUI.CreateSubMenu(menu_taxi, "Taxi", "Intéractions véhicules : ")
local cooldown = false
local price = 0
local timeout = 1000

menu_taxi.Closed = function()
    taxi_menu = false
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

local isService = false

function OpenTaxiMenu()
    if taxi_menu then 
        taxi_menu = false 
        RageUI.Visible(menu_taxi, false)
        return
    else
        taxi_menu = true 
        RageUI.Visible(menu_taxi, true)

        Citizen.CreateThread(function()
            while taxi_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(menu_taxi, function()

					RageUI.Checkbox("~y~→→~s~ Prendre son service", "Prennez en charge votre ~y~service~s~ !", isService, {}, {
						onChecked = function(index, items)
							isService = true
						end,
						onUnChecked = function(index, items)
							isService = false
						end
					})

					

					if isService then

						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						RageUI.Line()
						RageUI.Separator("Bienvenue ~y~".. GetPlayerName(PlayerId()) .."~s~ !")
                        RageUI.Separator("Votre métier : ~y~Taxi")

						if IsPedInAnyTaxi(PlayerPedId()) == 1 and isService then 
							RageUI.Button('Intéraction Véhicules', nil, {RightLabel = "~y~→→→"}, true, {
                    		}, menu_taxi_vehicule)
						else
							RageUI.Button('Intéraction Véhicules', nil, {RightLabel = "~y~→→→"}, false, {
                    		}, menu_taxi_vehicule)
						end

						if closestDistance > 3.0 then
							RageUI.Button('Créer une facture', nil, {RightLabel = "~y~→→"}, true, {
								onSelected = function()
									if not IsPedInAnyVehicle(PlayerPedId()) then
										ExecuteCommand('e notepad')
									end

									local amount = CustomString()

									if tonumber(amount) then 
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', amount)
										ESX.ShowNotification("Une facture de ~g~".. amount .."~s~$, à était créer avec ~g~succès~s~ !")
									else
										RageUI.CloseAll()
										ESX.ShowNotification("~r~Veuillez entrez une valeur valide !!")
									end
								end
                    		})
						else
							RageUI.Button('Créer une facture', nil, {RightLabel = "~y~→→"}, false, {
                    		})
						end

						RageUI.Button('Gestion des Annonces', nil, {RightLabel = "~y~→→→"}, true, {
                    	}, menu_taxi_annonce)   

					end

					RageUI.Line()
				end)

				RageUI.IsVisible(menu_taxi_vehicule, function()

					RageUI.Button('~g~Déverouiller~s~/~r~Vérouiller~s~ le véhicule', nil, {RightLabel = "~y~→→"}, true, {
						onSelected = function()
							if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() or not IsPedInAnyVehicle(PlayerPedId()) then

								local playerPed = PlayerPedId()
								local coords = GetEntityCoords(playerPed)
								local vehicle

								if IsPedInAnyVehicle(PlayerPedId(), false) then 
									vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
								else
									vehicle = GetClosestVehicle(coords, 8.0, 0, 71)
								end

								local lockStatus = GetVehicleDoorLockStatus(vehicle)

								if lockStatus == 1 then -- Si le véhicule est déverouiller 
									SetVehicleDoorsLocked(vehicle, 2)
									SetVehicleDoorsLockedForAllPlayers(vehicle, true)
									
									SetVehicleLights(vehicle, 2)
									Citizen.Wait(250)
									SetVehicleLights(vehicle, 0)
									Citizen.Wait(250)
									StartVehicleHorn (vehicle, 500, "NORMAL", -1)
									PlayVehicleDoorCloseSound(vehicle, 1)
									PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)

									ESX.ShowNotification("Vous avez ~r~fermé~s~ votre véhicule !")

								elseif lockStatus == 2 then -- Si le véhicule est vérouiller 

									SetVehicleDoorsLocked(vehicle, 1)
									SetVehicleDoorsLockedForAllPlayers(vehicle, false)

									SetVehicleLights(vehicle, 2)
									Citizen.Wait(250)
									SetVehicleLights(vehicle, 0)
									Citizen.Wait(250)
									StartVehicleHorn (vehicle, 500, "NORMAL", -1)
									PlayVehicleDoorOpenSound(vehicle, 0)
									PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)

									ESX.ShowNotification("Vous avez ~g~ouvert~s~ votre véhicule !")

								end

							else
								ESX.ShowNotification("Vous n\'êtes pas le conducteur du véhicule !")
							end
						end
					})

				end)

                RageUI.IsVisible(menu_taxi_annonce, function()
                
                    RageUI.Button("Annonce d\'~g~ouverture", nil, {RightLabel = "~g~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceOuvertTAXI')
                            cooldown = true
                            ESX.ShowNotification("Annonce d\'~g~ouverture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~r~fermeture", nil, {RightLabel = "~r~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceFermerTAXI')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~r~fermeture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~b~recrutement", nil, {RightLabel = "~b~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceRecrutementTAXI')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~b~recrutement~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Line()

                end)
            end
        end)
    end
end

RegisterKeyMapping("f6taxi", "Menu Intéraction - LS Custom", "keyboard", "F6")
RegisterCommand("f6taxi", function(source)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' and not isDead then
		OpenTaxiMenu()
	end
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

function CustomString()
    local txt = nil
    AddTextEntry("CREATOR_TXT", "Montant :")
    DisplayOnscreenKeyboard(1, "CREATOR_TXT", '', "", '', '', '', 30)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        txt = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return txt
end