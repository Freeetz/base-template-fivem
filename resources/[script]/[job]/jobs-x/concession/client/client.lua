local concess_voiture_menu = false
local concess_voiture = RageUI.CreateMenu("Concess Voiture", "Intéractions disponible :")
local menu_voiture_annonce = RageUI.CreateSubMenu(concess_voiture, "Concess Voiture", "Intéractions annonce : ")
local menu_voiture_vehicle = RageUI.CreateSubMenu(concess_voiture, "Concess Voiture", "Intéractions véhicule : ")
concess_voiture.Closed = function()
    concess_voiture_menu = false
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ConcessVoitureMenu()
    if concess_voiture_menu then 
        concess_voiture_menu = false 
        RageUI.Visible(concess_voiture, false)
        return
    else
        concess_voiture_menu = true
        RageUI.Visible(concess_voiture, true)
        Citizen.CreateThread(function()
            while concess_voiture_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(concess_voiture, function()

                    RageUI.Separator('Bienvenue ~r~'.. GetPlayerName(PlayerId()))
                    RageUI.Line()

                    RageUI.Button('Gestion Annonces', nil, {RightLabel = "→→→"}, true, {
                    }, menu_voiture_annonce)
                    RageUI.Button('Gestion Véhicules', nil, {RightLabel = "→→→"}, true, {
                    }, menu_voiture_vehicle)

                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        RageUI.Button('Facturer', nil, {RightLabel = "→→→"}, false, {
                            onSelected = function()
                            end
                        })
                    else
                        RageUI.Button('Facturer', nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                ExecuteCommand('e notepad')
                                local somme = CustomString()

                                if tonumber(somme) then
                                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_carshop', 'Concessionnaire Voiture', tonumber(somme))
                                    TriggerServerEvent('freetz:logs:concess:facture', tonumber(somme))
                                    ESX.ShowNotification("Vous avez ~g~créer~s~ une facture !")
                                end
                            end
                        })
                    end

                end)
                
                RageUI.IsVisible(menu_voiture_annonce, function()

                    RageUI.Separator("↓ ~r~Gestion Annonces~s~ ↓")

                    RageUI.Button('~g~Ouverture', nil, {RightLabel = "→→→"}, not cooldown, {
                        onSelected = function()
                            cooldown = true

                            TriggerServerEvent('freetz:concess:voiture', 'ouverture')
                            Citizen.SetTimeout(360000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button('~r~Fermeture', nil, {RightLabel = "→→→"}, not cooldown, {
                        onSelected = function()
                            cooldown = true

                            TriggerServerEvent('freetz:concess:voiture', 'fermeture')
                            Citizen.SetTimeout(360000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button('~b~Recrutement en cours', nil, {RightLabel = "→→→"}, not cooldown, {
                        onSelected = function()
                            cooldown = true

                            TriggerServerEvent('freetz:concess:voiture', 'recrutement')
                            Citizen.SetTimeout(360000, function() cooldown = false end)
                        end
                    })

                    RageUI.Line()

                end)

                RageUI.IsVisible(menu_voiture_vehicle, function()

                    RageUI.Separator("↓ ~g~Gestion Véhicules~s~ ↓")

                    local pPed = PlayerPedId()
                    local pCoords = GetEntityCoords(pPed)
                    local Vehicle = (GetClosestVehicle(pCoords))
                    local VehicleModel = GetEntityModel(Vehicle)

                    if GetDistanceBetweenCoords(pCoords, GetEntityCoords(GetClosestVehicle(pCoords))) < 15 then
                        if GetDisplayNameFromVehicleModel(VehicleModel) == nil or GetDisplayNameFromVehicleModel(VehicleModel) == 'CARNOTFOUND' then 
                            RageUI.Separator("Véhicule proche : ~r~Inconnu~s~")
                        else
                            RageUI.Separator("Véhicule proche : ".. GetDisplayNameFromVehicleModel(VehicleModel) .." - (~r~".. math.floor(GetDistanceBetweenCoords(pCoords, GetEntityCoords(GetClosestVehicle(pCoords)), true)) .."m~s~)")
                        end
                    else 
                        RageUI.Separator("Véhicule proche : ~r~Aucun~s~")
                    end

                    if GetDistanceBetweenCoords(pCoords, -918.5509, -2047.2017, 9.4050) < 50 then
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

                    if GetDistanceBetweenCoords(pCoords, -918.5509, -2047.2017, 9.4050) < 50 then
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

                    RageUI.Line()

                end)
            end
        end)
    end
end

local concess_avion_menu = false
local concess_avion = RageUI.CreateMenu("Concess Avion", "Intéractions disponible :")
local menu_avion_annonce = RageUI.CreateSubMenu(concess_avion, "Concess Avion", "Intéractions annonce : ")
local menu_avion_vehicle = RageUI.CreateSubMenu(concess_avion, "Concess Avion", "Intéractions véhicule : ")
concess_avion.Closed = function()
    concess_avion_menu = false
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ConcessAvionMenu()
    if concess_avion_menu then 
        concess_avion_menu = false 
        RageUI.Visible(concess_avion, false)
        return
    else
        concess_avion_menu = true
        RageUI.Visible(concess_avion, true)
        Citizen.CreateThread(function()
            while concess_avion_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(concess_avion, function()

                    RageUI.Separator('Bienvenue ~r~'.. GetPlayerName(PlayerId()))
                    RageUI.Line()

                    RageUI.Button('Gestion Annonces', nil, {RightLabel = "→→→"}, true, {
                    }, menu_avion_annonce)
                    RageUI.Button('Gestion Véhicules', nil, {RightLabel = "→→→"}, true, {
                    }, menu_avion_vehicle)

                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        RageUI.Button('Facturer', nil, {RightLabel = "→→→"}, false, {
                            onSelected = function()
                            end
                        })
                    else
                        RageUI.Button('Facturer', nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                ExecuteCommand('e notepad')
                                local somme = CustomString()

                                if tonumber(somme) then
                                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_planeshop', 'Concessionnaire Avion', tonumber(somme))
                                    TriggerServerEvent('freetz:logs:concess:facture', tonumber(somme))
                                end
                            end
                        })
                    end

                end)
                
                RageUI.IsVisible(menu_avion_annonce, function()

                    RageUI.Separator("↓ ~r~Gestion Annonces~s~ ↓")

                    RageUI.Button('~g~Ouverture', nil, {RightLabel = "→→→"}, not cooldown, {
                        onSelected = function()
                            cooldown = true

                            TriggerServerEvent('freetz:concess:avion', 'ouverture')
                            Citizen.SetTimeout(360000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button('~r~Fermeture', nil, {RightLabel = "→→→"}, not cooldown, {
                        onSelected = function()
                            cooldown = true

                            TriggerServerEvent('freetz:concess:avion', 'fermeture')
                            Citizen.SetTimeout(360000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button('~b~Recrutement en cours', nil, {RightLabel = "→→→"}, not cooldown, {
                        onSelected = function()
                            cooldown = true

                            TriggerServerEvent('freetz:concess:avion', 'recrutement')
                            Citizen.SetTimeout(360000, function() cooldown = false end)
                        end
                    })

                    RageUI.Line()

                end)

                RageUI.IsVisible(menu_avion_vehicle, function()

                    RageUI.Separator("↓ ~g~Gestion Véhicules~s~ ↓")

                    local pPed = PlayerPedId()
                    local pCoords = GetEntityCoords(pPed)
                    local Vehicle = (GetClosestVehicle(pCoords))
                    local VehicleModel = GetEntityModel(Vehicle)

                    if GetDistanceBetweenCoords(pCoords, GetEntityCoords(GetClosestVehicle(pCoords))) < 15 then
                        if GetDisplayNameFromVehicleModel(VehicleModel) == nil or GetDisplayNameFromVehicleModel(VehicleModel) == 'CARNOTFOUND' then 
                            RageUI.Separator("Véhicule proche : ~r~Inconnu~s~")
                        else
                            RageUI.Separator("Véhicule proche : ".. GetDisplayNameFromVehicleModel(VehicleModel) .." - (~r~".. math.floor(GetDistanceBetweenCoords(pCoords, GetEntityCoords(GetClosestVehicle(pCoords)), true)) .."m~s~)")
                        end
                    else 
                        RageUI.Separator("Véhicule proche : ~r~Aucun~s~")
                    end

                    if GetDistanceBetweenCoords(pCoords, -964.2524, -2950.1245, 13.9451) < 50 then
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

                    if GetDistanceBetweenCoords(pCoords, -964.2524, -2950.1245, 13.9451) < 50 then
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

                    RageUI.Line()

                end)
            end
        end)
    end
end

------------- ↓ FONCTION ↓ -------------------

function CustomString()
    local txt = nil
    AddTextEntry("CREATOR_TXT", "Quelle est le montant ?")
    DisplayOnscreenKeyboard(1, "CREATOR_TXT", '', "", '', '', '', 10)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        txt = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
	if  tonumber(txt) then -- PERMET DE NE PAS METTRE DES LETTRES DANS LE MONTANT !!
    	return txt
	else
		ESX.ShowNotification("Il ne s\'agit pas d\'une valeur valide !") 
	end
end

RegisterKeyMapping("f6voiture", "Menu Intéraction - Concessionnaire Voiture", "keyboard", "F6")
RegisterCommand("f6voiture", function(source)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'carshop' then
        if not isDead then
		    ConcessVoitureMenu()
        else
            ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir ce menu en étant dans le coma !")
        end
	end
end)

RegisterKeyMapping("f6avion", "Menu Intéraction - Concessionnaire Avion", "keyboard", "F6")
RegisterCommand("f6avion", function(source)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'planeshop' then
        if not isDead then
		    ConcessAvionMenu()
        else
            ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir ce menu en étant dans le coma !")
        end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function()
	IsDead = false
end)