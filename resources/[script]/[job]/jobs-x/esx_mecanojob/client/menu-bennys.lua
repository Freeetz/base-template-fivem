local bennys_menu = false
local menu_bennys = RageUI.CreateMenu("Benny\'s", "Intéractions disponible")
local menu_bennys_vehicle = RageUI.CreateSubMenu(menu_bennys, "Benny\'s", "Intéractions véhicules : ")
local menu_bennys_vehicle2 = RageUI.CreateSubMenu(menu_bennys, "Benny\'s", "Intéractions véhicules : ")
local menu_bennys_annonce = RageUI.CreateSubMenu(menu_bennys, "Benny\'s", "Intéractions annonces : ")

menu_bennys.Closed = function()
    bennys_menu = false
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

function BennysMenu()
    if bennys_menu then 
        bennys_menu = false 
        RageUI.Visible(menu_bennys, false)
        return
    else
        bennys_menu = true 
        RageUI.Visible(menu_bennys, true)

        Citizen.CreateThread(function()
            while bennys_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(menu_bennys, function()

					RageUI.Checkbox("~o~→→~s~ Prendre son service", "Prennez en charge votre ~o~service~s~ !", isService, {}, {
						onChecked = function(index, items)
							isService = true
						end,
						onUnChecked = function(index, items)
							isService = false
						end
					})

					

					if isService then

						RageUI.Line()
						RageUI.Separator("Bienvenue ~o~".. GetPlayerName(PlayerId()) .."~s~ !")
                        RageUI.Separator("Votre métier : ~o~Benny\'s")

						RageUI.Button('Intéraction Véhicules', nil, {RightLabel = "→→→"}, true, {
                    	}, menu_bennys_vehicle)   


						RageUI.Button('Gestion des Annonces', nil, {RightLabel = "→→→"}, true, {
                    	}, menu_bennys_annonce)   

                        RageUI.Button('Mettre une facture', nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                local somme = FactureInput()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                if tonumber(somme) then
                                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano', "Benny\'s", somme)
                                    ESX.ShowNotification("Facture ~g~créer~s~ !")
                                else
                                    RageUI.CloseAll()
                                    ESX.ShowNotification("~r~Veuillez entrer un montant valide !")
                                end
                            end
                        })

					end

					RageUI.Line()
				end)

                RageUI.IsVisible(menu_bennys_annonce, function()
                
                    RageUI.Button("Annonce d\'~g~ouverture", nil, {RightLabel = "~g~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceOuvertMECANO')
                            cooldown = true
                            ESX.ShowNotification("Annonce d\'~g~ouverture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~r~fermeture", nil, {RightLabel = "~r~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceFermerMECANO')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~r~fermeture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~b~recrutement", nil, {RightLabel = "~b~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceRecrutementMECANO')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~b~recrutement~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Line()

                end)

                RageUI.IsVisible(menu_bennys_vehicle, function()
                    
                    RageUI.Separator("↓ ~g~Gestion Véhicules~s~ ↓")

                    local pPed = PlayerPedId()
                    local pCoords = GetEntityCoords(pPed)
                    local Vehicle = (GetClosestVehicle(pCoords))
                    local VehicleModel = GetEntityModel(Vehicle)

                    if GetDistanceBetweenCoords(pCoords, GetEntityCoords(GetClosestVehicle(pCoords))) < 15 then
					else
                        if GetDisplayNameFromVehicleModel(VehicleModel) == nil or GetDisplayNameFromVehicleModel(VehicleModel) == 'CARNOTFOUND' then 
                            RageUI.Separator("Véhicule proche : ~r~Inconnu~s~")
                        else
                            RageUI.Separator("Véhicule proche : ".. GetDisplayNameFromVehicleModel(VehicleModel) .." - (~r~".. math.floor(GetDistanceBetweenCoords(pCoords, GetEntityCoords(GetClosestVehicle(pCoords)), true)) .."m~s~)")
                        end
                    --else 
                        --RageUI.Separator("Véhicule proche : ~r~Aucun~s~")
                    end

                    if GetDistanceBetweenCoords(pCoords, -244.6307, -1327.0721, 31.2892) < 50 then
                        RageUI.Button('Réparer le véhicule', nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local vehicle = ESX.Game.GetVehicleInDirection()
                                local coords = GetEntityCoords(playerPed, false)
                
                                if IsPedSittingInAnyVehicle(playerPed) then
                                    ESX.ShowNotification("~r~Vous devez sortir du véhicule !")
                                    return
                                end
                
                                if DoesEntityExist(vehicle) then
                                    ExecuteCommand("me vérifie l\'état du moteur du véhicule")
                                    exports['progressBars']:startUI(35000, "Vous réparez le véhicule..")
                                    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

                                    local result = math.random(1, 3)
                                    Citizen.CreateThread(function()
                                        Citizen.Wait(35000)

                                        if result == 1  or result == 2 then
                
                                            SetVehicleFixed(vehicle)
                                            SetVehicleDeformationFixed(vehicle)
                                            SetVehicleUndriveable(vehicle, false)
                                            SetVehicleEngineOn(vehicle, true, true)
                                            ClearPedTasksImmediately(playerPed)
                                            
                                            ESX.ShowNotification("~g~Véhicule réparer !")
                                        elseif result == 3 then 
                                            ESX.ShowNotification("~r~Réparation échouer..")
                                        end
                                    end)
                                else
                                    ESX.ShowNotification("~r~Aucun véhicule proche !")
                                end
                            end
                        })
                    else
                        RageUI.Button('Réparer le véhicule', nil, {RightLabel = "→→→"}, false, {
                            onSelected = function()
                            end
                        })
                    end

                    if GetDistanceBetweenCoords(pCoords, -244.6307, -1327.0721, 31.2892) < 50 then
                        RageUI.Button('Nettoyer le véhicule', nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local vehicle = ESX.Game.GetVehicleInDirection()
                                local coords = GetEntityCoords(playerPed, false)
                
                                if IsPedSittingInAnyVehicle(playerPed) then
                                    ESX.ShowNotification("~r~Vous devez sortir du véhicule !")
                                    return
                                end
                
                                if DoesEntityExist(vehicle) then
                                    ExecuteCommand("me met un coup de nettoyant sur le véhicule")
                                    exports['progressBars']:startUI(15000, "Vous nettoyez le véhicule..")
                                    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)

                                    local result = math.random(1, 3)
                                    Citizen.CreateThread(function()
                                        Citizen.Wait(15000)

                                        if result == 1  or result == 2 then
                
                                            SetVehicleDirtLevel(vehicle, 0)
                                            ClearPedTasksImmediately(playerPed)
                                            
                                            ESX.ShowNotification("~g~Véhicule Nettoyer !")
                                        elseif result == 3 then 
                                            ESX.ShowNotification("~r~Nettoyage échouer..")
                                        end
                                    end)
                                else
                                    ESX.ShowNotification("~r~Aucun véhicule proche !")
                                end
                            end
                        })
                    else
                        RageUI.Button('Nettoyer le véhicule', nil, {RightLabel = "→→→"}, false, {
                            onSelected = function()
                            end
                        })
                    end

                    if GetDistanceBetweenCoords(pCoords, -244.6307, -1327.0721, 31.2892) < 50 then
                        RageUI.Button('Mettre en fourrière', nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local vehicle = ESX.Game.GetVehicleInDirection()
                                local coords = GetEntityCoords(playerPed, false)
                
                                if IsPedSittingInAnyVehicle(playerPed) then
                                    ESX.ShowNotification("~r~Vous devez sortir du véhicule !")
                                    return
                                end
                
                                if DoesEntityExist(vehicle) then
                                    ExecuteCommand("me place le véhicule en fourrière")
                                    exports['progressBars']:startUI(15000, "Vous déplacez le véhicule..")

                                    TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

                                    Wait(15000)

                                    Citizen.CreateThread(function()
                                        local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                                        NetworkRequestControlOfEntity(veh)
                                        while not NetworkHasControlOfEntity(veh) do
                                            Wait(1)
                                        end
                                        DeleteEntity(veh)
                                    end)

                                    ESX.ShowNotification("Véhicule placer en ~o~fourrière~s~ !")
                                    ClearPedTasksImmediately(PlayerPedId())
                                    ClearPedTasks(PlayerPedId())
                                else
                                    ESX.ShowNotification("~r~Aucun véhicule proche !")
                                end
                            end
                        })
                    else
                        RageUI.Button('Mettre en fourrière', nil, {RightLabel = "→→→"}, false, {
                            onSelected = function()
                            end
                        })
                    end

                    RageUI.Line()

                end)
            end
        end)
    end
end

RegisterKeyMapping("f6bennys", "Menu Intéraction - Benny\'s", "keyboard", "F6")
RegisterCommand("f6bennys", function(source)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' and not isDead then
		BennysMenu()
	end
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

function FactureInput()
    local txt = nil
    AddTextEntry("CREATOR_TXT", "Montant")
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