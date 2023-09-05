RegisterCommand('afk', function()
    OpenAFKMenu()
    SetNewWaypoint(242.7446, -392.1819, 46.3055)
end)
RegisterCommand('invest', function()
    OpenAFKMenu()
    SetNewWaypoint(242.7446, -392.1819, 46.3055)
end)
RegisterCommand('investissement', function()
    OpenAFKMenu()
    SetNewWaypoint(242.7446, -392.1819, 46.3055)
end)

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(10)
    end
end)

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

local AfkTime = 0
local InAfkZone = false

RegisterNetEvent('requestClientAfkTime')
AddEventHandler('requestClientAfkTime', function(result)
    AfkTime = result
end)

RegisterNetEvent('ForceLunchInvest')
AddEventHandler('ForceLunchInvest', function(result)
    local playerPed = PlayerPedId()
    InAfkZone = true
    InAFK = true
    --Wait(300)
    --FreezeEntityPosition(playerPed, true)
    Wait(150)
    OpenAFKMenuInvest()
end)


Citizen.CreateThread(function()
    while InAfkZone do 
        TriggerClientEvent('esx_basicneeds:healPlayer')
        Wait(10000)
    end
end)

Citizen.CreateThread(function()
	while true do
		if InAfkZone then
            --TriggerEvent("esx_basicneeds:healPlayer")
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30, true) -- MoveLeftRight
			DisableControlAction(0, 31, true) -- MoveUpDown
			DisableControlAction(0, 21, true) -- disable sprint
            DisableControlAction(0, 20, true) -- Z
            DisableControlAction(0, 31, true) -- S
            DisableControlAction(0, 34, true) -- S
            DisableControlAction(0, 30, true) -- D
            DisableControlAction(0, 44, true) -- D
            DisableControlAction(0, 52, true) -- D
            DisableControlAction(0, 232, true) -- W
            DisableControlAction(0, 233, true) -- S
            DisableControlAction(0, 234, true) -- A
            DisableControlAction(0, 235, true) -- D
            DisableControlAction(0, 236, true) -- V
            DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle

            DisableControlAction(0, 32, true)
			DisableControlAction(0, 34, true) 
			DisableControlAction(0, 31, true) 
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 22, true) 
			DisableControlAction(0, 44, true)
        else
            Wait(5000)
		end
		Citizen.Wait(10)
	end
end)

Citizen.CreateThread(function()
    Wait(2500)
    TriggerServerEvent("requteInvestTime")
    while true do
        if InAfkZone then
            if AfkTime >= 1 then
                Wait(60000)
                AfkTime = AfkTime - 1
                TriggerServerEvent("UpdateAfkTick", AfkTime)
            end
        end
        Wait(2500)
    end
end)

function OpenAFKMenu()
    if #(GetEntityCoords(PlayerPedId()) - eInvest.PositionCommand) < eInvest.MaxDistance then

        local menuinvest = RageUI.CreateMenu('Investissement', '')
        local playerPed = PlayerPedId()
        local name = GetPlayerName(PlayerId())

        RageUI.Visible(menuinvest, not RageUI.Visible(menuinvest))

        while menuinvest do
            Citizen.Wait(0)
            if #(GetEntityCoords(PlayerPedId()) - eInvest.PositionCommand) > eInvest.MaxDistance then
                RageUI.CloseAll()
            end
            RageUI.IsVisible(menuinvest, function()
                --RageUI.Separator(eInvest.FirstMessageMenu)
                --RageUI.Separator(eInvest.TwoMessageMenu)
                RageUI.Separator('')
                RageUI.Separator('Bienvenue : ~p~'.. name)
                if AfkTime <= 0 then
                    for k,v in pairs(eInvest.ListInvest) do
                        RageUI.Button(v.label, nil, {RightLabel = v.heures}, true, {onSelected = function()
                            InAfkZone = true
                            --FreezeEntityPosition(playerPed, true)
                            TriggerServerEvent("GoInvest", v.type)
                           -- FreezeEntityPosition(playerPed, true)
                            RageUI.CloseAll()
                            InAFK = true
                            --FreezeEntityPosition(playerPed, true)
                            Wait(150)
                            OpenAFKMenuInvest()
                        end})
                    end
                else
                    RageUI.Separator(eInvest.HaveInvest)
                    RageUI.Button(eInvest.RestartInvest, nil, {}, true, {onSelected = function()
                        InAfkZone = true
                        RageUI.CloseAll()
                        InAFK = true
                        Wait(150)
                        OpenAFKMenuInvest()
                    end})
                end
            end, function()
            end)

            if not RageUI.Visible(menuinvest) then
                menuinvest = RMenu:DeleteType('menuinvest', true)
            end
        end
    else
        ESX.ShowNotification(eInvest.ZoneSafeMessage)
    end
end

local InAFK = false
Citizen.CreateThread(function()
    while true do
        local interval = 2500
        if InAfkZone then
            interval = 0
            if AfkTime >= 1 then
                if #(GetEntityCoords(PlayerPedId()) - eInvest.Position) > 50 then
                    SetEntityCoords(PlayerPedId(), eInvest.Position)
                end
                if eInvest.Lang == 'FR' then
                    DrawMissionText('~s~Vous êtes dans la ~g~Zone Investissement~s~ !\nTemps restant ~g~'..AfkTime..' ~s~minutes ', 100)
                elseif eInvest.Lang == 'EN' then
                    DrawMissionText('~s~You are in the ~g~Zone Investment ~s~ !\nYour investment is finished in ~g~'..AfkTime..' ~s~minutes', 100)
                end
                InAFK = true
            else
                InAFK = false
            end
        else
            InAFK = false
        end
        if InAfkZone and AfkTime >= 1 then
            Wait(0)
        else
            Wait(2500)
        end
        Wait(interval)
    end
end)

function OpenAFKMenuInvest()
	local menuinvest = RageUI.CreateMenu(eInvest.TitleMenu, eInvest.DescriptionMenu)
    local playerPed = PlayerPedId()
    menuinvest.Closable = false
    RageUI.Visible(menuinvest, not RageUI.Visible(menuinvest))

	while menuinvest do
		Citizen.Wait(0)
        RageUI.IsVisible(menuinvest, function()
            RageUI.Separator('')
            RageUI.Separator(eInvest.FirstMessageInInvestMenu)
            RageUI.Separator('')
            RageUI.Separator(eInvest.TwoMessageInInvestMenu)
            RageUI.Separator('')
            RageUI.Button(eInvest.ReturnMessage, eInvest.ReturnDescription, {}, true, {onSelected = function()
                InAfkZone = false
                FreezeEntityPosition(playerPed, false)
                SetEntityCoords(PlayerPedId(), eInvest.ReturnPosition)
                RageUI.CloseAll()
            end})
            if AfkTime <= 0 then 
                RageUI.CloseAll()
            end
        end, function()
        end)

        if not RageUI.Visible(menuinvest) then
            menuinvest = RMenu:DeleteType('menuinvest', true)
        end
    end
end