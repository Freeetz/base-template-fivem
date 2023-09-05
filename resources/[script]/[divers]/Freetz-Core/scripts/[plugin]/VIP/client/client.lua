Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent('Freetz Commu:GetVIP')
    Wait(10000)
end)
IsVip = false

function GetVIP()
    return IsVip
end

RegisterNetEvent('freetz:updateVIP')
AddEventHandler('freetz:updateVIP',function(vip)
    IsVip = vip
end)

RegisterCommand("vip", function() 
    if GetVIP() then
        --OpenPedsMenu()
        ESX.ShowNotification("Bonjour ~g~".. GetPlayerName(PlayerId()) .."~s~ !\nVous possèdez actuellement un grade : ~y~V.I.P~s~\n\n ~b~Merci de votre soutien envers notre serveur~s~ !")
    else
        ESX.ShowNotification("Vous ne possèdez aucun grade ~y~V.I.P~s~ !") 
    end
end)

local rgb = false
RegisterCommand("rgb", function(source)
    if GetVIP() then
        if rgb == true then 
            rgb = false 
            ESX.ShowNotification("Le mode RGB, est désormais ~r~désactiver~s~ !")
        elseif rgb == false then 
            rgb = true 
            ESX.ShowNotification("Le mode RGB, est désormais ~g~activer~s~ !")
        end
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        ToggleVehicleMod(veh, 22, true)
        SetVehicleNeonLightEnabled(veh, 0, true)
        SetVehicleNeonLightEnabled(veh, 1, true)
        SetVehicleNeonLightEnabled(veh, 2, true)
        SetVehicleNeonLightEnabled(veh, 3, true)
    else
        ESX.ShowNotification("Vous devez possèdez un grade ~y~V.I.P~s~, afin d\'accéder à ceci !")
    end
end)

local valeur = 1

CreateThread(function()
    while true do 
        if GetVIP() then
            interval = 2500
            if rgb then 
                interval = 1

                while rgb do 
                    if valeur == 0 then 
                        valeur = 1
                    elseif valeur == 12 then 
                        valeur = 1
                    end

                    valeur = valeur + 1
                    local veh = GetVehiclePedIsUsing(PlayerPedId())
                
                    SetVehicleHeadlightsColour(veh, valeur)
                    SetVehicleNeonLightsColour(veh, 222, 222, 255)
                    Wait(150)
                    SetVehicleNeonLightsColour(veh, 2, 1, 255)
                    Wait(150)
                    SetVehicleNeonLightsColour(veh, 255, 255, 0)
                    Wait(150)
                    SetVehicleNeonLightsColour(veh, 255, 1, 1)
                    Wait(150)
                    SetVehicleNeonLightsColour(veh, 35, 1, 255)
                    Wait(150)
                    SetVehicleNeonLightsColour(veh, 0, 255, 140)
                    Wait(150)
                    SetVehicleNeonLightsColour(veh, 255, 50, 100)
                    Wait(150)
                    SetVehicleNeonLightsColour(veh, 15, 3, 255)
                    Wait(150)
                end
            end
        else
            interval = 30000
        end
        Wait(interval)
    end 
end)


TriggerEvent('chat:addSuggestion', '/rgb', 'Activer le mode RGB (VIP)', {})
TriggerEvent('chat:addSuggestion', '/vip', 'Ouvrir le menu VIP', {})