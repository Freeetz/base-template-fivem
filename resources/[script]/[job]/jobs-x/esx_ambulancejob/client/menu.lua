

------------ ↓ RageUI Menu ↓ --------------- 

local ems_menu = false
local ems_main_menu = RageUI.CreateMenu("EMS", "Intéractions disponible")
local ems_citizen_menu = RageUI.CreateSubMenu(ems_main_menu, "EMS", "Intéractions citoyen : ")
local ems_annonce_menu = RageUI.CreateSubMenu(ems_main_menu, "EMS", "Intéractions annonce : ")

ems_main_menu.Closed = function()
    ems_menu = false
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

function EMSMainMenu()
    if ems_menu then 
        ems_menu = false 
        RageUI.Visible(ems_main_menu, false)
        return
    else
        ems_menu = true 
        RageUI.Visible(ems_main_menu, true)

        Citizen.CreateThread(function()
            while ems_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(ems_main_menu, function()

					RageUI.Checkbox("~b~→→~s~ Prendre son service", "Prennez en charge votre ~b~service~s~ !", isService, {}, {
						onChecked = function(index, items)
							isService = true
						end,
						onUnChecked = function(index, items)
							isService = false
						end
					})

					

					if isService then

						RageUI.Line()
						RageUI.Separator("Bienvenue ~b~".. GetPlayerName(PlayerId()) .."~s~ !")
                        RageUI.Separator("Votre métier : ~b~E.M.S")

						RageUI.Button('Intéraction Citoyens', nil, {RightLabel = "→→→"}, true, {
                    	}, ems_citizen_menu)   


						RageUI.Button('Gestion des Annonces', nil, {RightLabel = "→→→"}, true, {
                    	}, ems_annonce_menu)   

					end

					RageUI.Line()

				end)
				RageUI.IsVisible(ems_annonce_menu, function()

					RageUI.Button("Annonce d\'~g~ouverture", nil, {RightLabel = "~g~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceOuvertEMS')
                            cooldown = true
                            ESX.ShowNotification("Annonce d\'~g~ouverture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~r~fermeture", nil, {RightLabel = "~r~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceFermerEMS')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~r~fermeture~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Button("Annonce de ~b~recrutement", nil, {RightLabel = "~b~→→"}, not cooldown, {
                        onSelected = function()
                            TriggerServerEvent('AnnonceRecrutementEMS')

                            cooldown = true
                            ESX.ShowNotification("Annonce de ~b~recrutement~s~, effectué !")
                            Citizen.SetTimeout(60000, function() cooldown = false end)
                        end
                    })

                    RageUI.Line()

				end)

				RageUI.IsVisible(ems_citizen_menu, function()
			
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer > 3.0 then
						RageUI.Button('Réanimer l\'individu', nil, {RightLabel = "~r~→→"}, true, {
							onSelected = function()
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPed = GetPlayerPed(closestPlayer)
										local isDead = IsPlayerDead(closestPlayer)
									
										if isDead then
											local playerPed = PlayerPedId()
										
											IsBusy = true
											ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('revive_inprogress'), 'CHAR_CALL911', 1)
											ExecuteCommand("me réanime la personne au sol")
											exports['progressBars']:startUI(1000, "Vous réanimez la personne..")
											TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ambulance', 'Ambulance', 10000)
											ESX.ShowNotification("~g~Facture envoyé !")
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(1000)
											ClearPedTasks(playerPed)
										
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
											IsBusy = false
										
											if ConfigAmbulance.ReviveReward > 0 then
												ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), ConfigAmbulance.ReviveReward))
											else
												ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
											end
										else
											ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('player_not_unconscious'), 'CHAR_CALL911', 1)
										end
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('not_enough_medikit'), 'CHAR_CALL911', 1)
									end
								end, 'medikit')
							end
						})   
					else
						RageUI.Button('Réanimer l\'individu', nil, {RightLabel = "~r~→→"}, false, {
						})
					end

					if closestPlayer > 3.0 then
						RageUI.Button('Soigner l\'individu (~r~Gros soin~s~)', nil, {RightLabel = "~r~→→"}, true, {
							onSelected = function()
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
			
										if health > 0 then
											local playerPed = PlayerPedId()
			
											IsBusy = true
											ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('heal_inprogress'), 'CHAR_CALL911', 1)
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ambulance', 'Ambulance', 7000)
											ESX.ShowNotification("~g~Facture envoyé !")
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
			
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('player_not_conscious'), 'CHAR_CALL911', 1)
										end
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('not_enough_medikit'), 'CHAR_CALL911', 1)
									end
								end, 'medikit')
							end
						})   
					else
						RageUI.Button('Soigner l\'individu (~r~Gros soin~s~)', nil, {RightLabel = "~r~→→"}, false, {
						})
					end

					if closestPlayer > 3.0 then
						RageUI.Button('Soigner l\'individu (~g~Petit soin~s~)', nil, {RightLabel = "~r~→→"}, true, {
							onSelected = function()
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
			
										if health > 0 then
											local playerPed = PlayerPedId()
			
											IsBusy = true
											ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('heal_inprogress'), 'CHAR_CALL911', 1)
											TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ambulance', 'Ambulance', 3000)
											ESX.ShowNotification("~g~Facture envoyé !")
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
			
											TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('player_not_conscious'), 'CHAR_CALL911', 1)
										end
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', _U('not_enough_bandage'), 'CHAR_CALL911', 1)
									end
								end, 'bandage')
							end
						})   
					else
						RageUI.Button('Soigner l\'individu (~g~Petit soin~s~)', nil, {RightLabel = "~r~→→"}, false, {
						})
					end

					RageUI.Button("Créer une facture", nil, {RightLabel = "~g~→→"}, true, {
						onSelected = function()
							local amount = CustomString4()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if tonumber(amount) then 
								if closestPlayer > 3.0 then
									if amount > 200000 then 
										ESX.ShowNotification("~r~Montant trop élevé !")
									else
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ambulance', 'Ambulance', amount)
										ESX.ShowAdvancedNotification('Ambulance', 'Message', "Facture d\'un montant de ~g~".. amount .."~s~$ envoyée !", 'CHAR_CALL911', 1)
									end
								else
									ESX.ShowNotification("~r~Aucun joueur aux alentours.")
								end
							end
						end
					})

				end)
			end
		end)
	end
end

RegisterKeyMapping("f6ems", "Menu Intéraction - E.M.S", "keyboard", "F6")
RegisterCommand('f6ems', function()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not isDead then
		EMSMainMenu()
	end
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

function CustomString4()
    local txt = nil
    AddTextEntry("CREATOR_TXT", "Quelle est le montant ?")
    DisplayOnscreenKeyboard(1, "CREATOR_TXT", '', "", '', '', '', 2)
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