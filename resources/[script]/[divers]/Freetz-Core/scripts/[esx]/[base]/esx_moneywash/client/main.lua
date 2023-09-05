ESX = nil
local hasAlreadyEnteredMarker, lastZone
local currentAction, currentActionMsg, currentActionData = nil, nil, {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

-- Show / Hide text
Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local playerCoords = GetEntityCoords(PlayerPedId())
        local playerPed = PlayerPedId()

        if Vdist2(playerCoords.x, playerCoords.y, playerCoords.z, 1122.2667, -3194.6792, -40.3998) <= 30 then
            interval = 0
            if Vdist2(playerCoords.x, playerCoords.y, playerCoords.z, 1122.2667, -3194.6792, -40.3998) <= 3 then
                Draw3dText(1122.2667, -3194.6792, -40.3998, "Appuyez sur [~g~E~s~] pour blanchir votre argent !")
                if IsControlJustReleased(0, 38) then
                    FreezeEntityPosition(playerPed, true)
                    exports['progressBars']:startUI(40000, "Vous déposez les billets..")
                    Citizen.Wait(40500)
                    exports['progressBars']:startUI(2500, "Vous refermez la machine à laver..")
                    Citizen.Wait(2750)
                    exports['progressBars']:startUI(30000, "Vous patientez..")
                    Citizen.Wait(30500)
                    exports['progressBars']:startUI(5000, "Vous stopez la machine à lavez...")
                    Citizen.Wait(5500)
                    exports['progressBars']:startUI(3000, "Vous récupérer votre argent..")
                    Citizen.Wait(3500)
                    FreezeEntityPosition(playerPed, false)
                    TriggerServerEvent('esx_moneywash:cleanMoney', PlayerPedId())
                end
            end
        end

        Wait(interval)
	end
end)

-- 2 eme point de blanchiment 

Citizen.CreateThread(function()
	while true do
		local interval = 2500
		local playerCoords = GetEntityCoords(PlayerPedId())
        local playerPed = PlayerPedId()

        if Vdist2(playerCoords.x, playerCoords.y, playerCoords.z, -443.4113, 2015.1542, 123.5713) <= 40 then
            interval = 0
            if Vdist2(playerCoords.x, playerCoords.y, playerCoords.z, -443.4113, 2015.1542, 123.5713) <= ConfigBlanchiment.drawDistance then
                Draw3dText(-443.4113, 2015.1542, 123.5713, "Appuyez sur [~g~E~s~] pour blanchir votre argent !")
                if IsControlJustReleased(0, 38) then
                    FreezeEntityPosition(playerPed, true)
                    exports['progressBars']:startUI(40000, "Vous déposez les billets..")
                    Citizen.Wait(40500)
                    exports['progressBars']:startUI(2500, "Vous refermez la machine à laver..")
                    Citizen.Wait(2750)
                    exports['progressBars']:startUI(30000, "Vous patientez..")
                    Citizen.Wait(30500)
                    exports['progressBars']:startUI(5000, "Vous stopez la machine à lavez...")
                    Citizen.Wait(5500)
                    exports['progressBars']:startUI(3000, "Vous récupérer votre argent..")
                    Citizen.Wait(3500)
                    FreezeEntityPosition(playerPed, false)
                    TriggerServerEvent('esx_moneywash:cleanMoney2', PlayerPedId())
                end
            end
        end

        Wait(interval)
	end
end)

function Draw3dText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = Vdist2(p.z, p.y, p.z, x, y, z)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 150)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
