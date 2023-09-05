local ESX = nil 
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end
end)

local OpenBoutique = false
local mainBoutique = RageUI.CreateMenu("", "Action Disponibles :", nil, 30, 'Freetz Commumenu', 'interaction_bgd', 255, 255, 255, 255)

mainBoutique.Closed = function()
    FreezeEntityPosition(PlayerPedId(), false)
    OpenBoutique = false
end

function OpenBoutiqueMenu()
    if OpenBoutique then 
        OpenBoutique = false 
        return
    else
        OpenBoutique = true 
        RageUI.Visible(mainBoutique, true)

        Citizen.CreateThread(function()
            while OpenBoutique do 
                Citizen.Wait(0)

                RageUI.IsVisible(mainBoutique, function()
                    
                    RageUI.Line()

                    RageUI.Separator("Numéro de compte : ~o~".. id)

                    RageUI.Line()

                    RageUI.Button("Boutique", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            ExecuteCommand('shop')
                            OpenBoutique = false
                            RageUI.CloseAll()
                        end
                    })

                    RageUI.Button("Caisse Mystère", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            ExecuteCommand('caseOpening')
                            OpenBoutique = false
                            RageUI.CloseAll()
                        end
                    })

                    RageUI.Line()

                    RageUI.Button("                     ~r~Fermer le menu", nil, {RightLabel = ""}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                            OpenBoutique = false
                        end
                    })
                end)
            end
        end)
    end
end

RegisterCommand("MenuBoutique", function(source)
	if not isDead then
		OpenBoutiqueMenu()
	end
end)

AddEventHandler('playerSpawned', function()
    TriggerEvent('freetz:getinfo')
    isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

RegisterKeyMapping("MenuBoutique", "Menu Boutique", "keyboard", "F1")

AddEventHandler('playerSpawned', function()
    TriggerEvent('freetz:getid')
    isDead = false
end)

RegisterNetEvent('freetz:getid')
AddEventHandler('freetz:getid', function()
    ESX.TriggerServerCallback('freetz:get:id', function(cb)
        id = cb
    end)
end)