local unicorn_menu = false
local menu_unicorn = RageUI.CreateMenu("Unicorn", "Intéractions disponible :")
local menu_unicorn_annonce = RageUI.CreateSubMenu(menu_unicorn, "Unicorn", "Intéractions annonce : ")
local menu_unicorn_citoyen = RageUI.CreateSubMenu(menu_unicorn, "Unicorn", "Intéractions citoyen : ")
local menu_unicorn_soiree = RageUI.CreateSubMenu(menu_unicorn, "Unicorn", "Intéractions soirée : ")
local IsInPed = false

menu_unicorn.Closed = function()
    unicorn_menu = false
end


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function UnicornMainMenu()
    if unicorn_menu then 
        unicorn_menu = false 
        RageUI.Visible(menu_unicorn, false)
        return
    else
        unicorn_menu = true
        RageUI.Visible(menu_unicorn, true)
        Citizen.CreateThread(function()
            while unicorn_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(menu_unicorn, function()

                    RageUI.Separator('Bienvenue ~p~'.. GetPlayerName(PlayerId())..' ~s~!')
                    RageUI.Separator('Métier : ~p~Unicorn')
                    RageUI.Separator("_________________")

                    RageUI.Button('Gestion Citoyens', nil, {RightLabel = "~p~→→"}, true, {
                    }, menu_unicorn_citoyen)
                    RageUI.Button('Gestion Annonces', nil, {RightLabel = "~p~→→"}, true, {
                    }, menu_unicorn_annonce)

                    if PlayerData.job.grade_name == 'boss' then
                        RageUI.Button('Gestion Soirée', nil, {RightLabel = "~p~→→"}, true, {
                        }, menu_unicorn_soiree)
                    else
                        RageUI.Button('Gestion Soirée', nil, {RightLabel = "~p~→→"}, false, {
                        }, menu_unicorn_soiree)
                    end

                end)

                RageUI.IsVisible(menu_unicorn_soiree, function()
                    
                    RageUI.Button('~p~→~s~ Récupérer votre apparence', nil, {RightLabel = "~p~→→"}, IsInPed, {
                        onSelected = function()
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                local isMale = skin.sex == 0
        
                                TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                        TriggerEvent('skinchanger:loadSkin', skin)
                                        TriggerEvent('esx:restoreLoadout')
                                    end)
                                end)

                                ESX.ShowNotification("Vous avez repris votre ~p~apparence~s~ !")
                            end)

                            IsInPed = false
                        end
                    })

                    RageUI.Separator("______________")

                    RageUI.Button('~b~→~s~ Danceuse', nil, {RightLabel = "~p~→→"}, not IsInPed, {
                        onSelected = function()
                            RageUI.CloseAll()
                            IsInPed = true

                            local peds = 's_f_y_stripper_01'
                            local xPlayer = PlayerId()
                            local ped = GetHashKey(peds)

                            RequestModel(ped)
                            while not HasModelLoaded(ped) do 
                                Wait(100)
                            end

                            SetPlayerModel(xPlayer, ped)
                            SetModelAsNoLongerNeeded(ped)

                            ESX.ShowNotification("Vous avez ~b~équiper~s~ une apparence de ~r~danceuse~s~ !")
                        end
                    })

                    RageUI.Button('~b~→~s~ Danceuse 2', nil, {RightLabel = "~p~→→"}, not IsInPed, {
                        onSelected = function()
                            RageUI.CloseAll()
                            IsInPed = true

                            local peds = 's_f_y_stripper_02'
                            local xPlayer = PlayerId()
                            local ped = GetHashKey(peds)

                            RequestModel(ped)
                            while not HasModelLoaded(ped) do 
                                Wait(100)
                            end

                            SetPlayerModel(xPlayer, ped)
                            SetModelAsNoLongerNeeded(ped)

                            ESX.ShowNotification("Vous avez ~b~équiper~s~ une apparence de ~r~danceuse~s~ !")
                        end
                    })

                    RageUI.Button('~b~→~s~ Danceuse 3', nil, {RightLabel = "~p~→→"}, not IsInPed, {
                        onSelected = function()
                            RageUI.CloseAll()
                            IsInPed = true

                            local peds = 's_f_y_hooker_02'
                            local xPlayer = PlayerId()
                            local ped = GetHashKey(peds)

                            RequestModel(ped)
                            while not HasModelLoaded(ped) do 
                                Wait(100)
                            end

                            SetPlayerModel(xPlayer, ped)
                            SetModelAsNoLongerNeeded(ped)

                            ESX.ShowNotification("Vous avez ~b~équiper~s~ une apparence de ~r~danceuse~s~ !")
                        end
                    })


                end)
                RageUI.IsVisible(menu_unicorn_annonce, function()
                
					RageUI.Button("Annonce d\'~g~ouverture", nil, {RightLabel = "~g~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('freetz:unicorn:ouverture')
                            cooldown = true
                            ESX.ShowNotification("Annonce d\'~g~ouverture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~r~fermeture", nil, {RightLabel = "~r~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('freetz:unicorn:fermeture')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~r~fermeture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~b~recrutement", nil, {RightLabel = "~b~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('freetz:unicorn:recrutement')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~b~recrutement~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Separator("_________________")

                end)

                RageUI.IsVisible(menu_unicorn_citoyen, function()
                    
                    local player, distance = ESX.Game.GetClosestPlayer()

                    if distance <= 3.0 then
                        RageUI.Button('~p~→~s~ Carte D\'identité', nil, {RightLabel = "~p~→→"}, true, {
                            onSelected = function()
                                ExecuteCommand('me prend la carte d\'identité de l\'individu')
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
                            end
                        })
                    else
                        RageUI.Button('~p~→~s~ Carte D\'identité', nil, {RightLabel = "~p~→→"}, false, {
                        })
                    end

                    if distance <= 3.0 then
                        RageUI.Button('~p~→~s~ Facturer', nil, {RightLabel = "~p~→→"}, true, {
                            onSelected = function()
                                ExecuteCommand('e notepad')
                                local somme = CustomString()

                                if tonumber(somme) then
                                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_unicorn', 'Unicorn', tonumber(somme))
                                end
                            end
                        })
                    else
                        RageUI.Button('~p~→~s~ Facturer', nil, {RightLabel = "~p~→→"}, false, {
                            onSelected = function()
                            end
                        })
                    end
                end)

            end
        end)
    end
end

RegisterKeyMapping("f6unicorn", "Menu Intéraction - Unicorn", "keyboard", "F6")
RegisterCommand('f6unicorn', function()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' and not isDead then
		UnicornMainMenu()
	end
end)

CreateThread(function()
    while true do 
        local interval = 5000

        if IsInPed then 
            interval = 1000 

            local plyCoords = GetEntityCoords(PlayerPedId(), false)

            if #(plyCoords - ConfigAmmu.Coords[i]) > 100 then 
                TriggerServerEvent('freetz:leaveunicorn')
            end
        end 

        Wait(interval)
    end 
end)

function CustomString()
    local txt = nil
    AddTextEntry("CREATOR_TXT", "Montant")
    DisplayOnscreenKeyboard(1, "CREATOR_TXT", '', "", '', '', '', 6)
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