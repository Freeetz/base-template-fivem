local cached_players = {}

RegisterNetEvent("utils:playerDisconnect")
AddEventHandler("utils:playerDisconnect", function(player, info)
    cached_players[player] = info
    StartLoop(player)
end)

function StartLoop(player)
    Citizen.CreateThread(function()
        Wait(ConfigDeco.TimeToDispair)
        if cached_players[player] ~= nil then
            cached_players[player] = nil
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local pNear = false
        --local name = GetPlayerName(source)

        for k,v in pairs(cached_players) do
            if #(v.pos - pCoords) < ConfigDeco.DrawDistance then
                pNear = true
                DrawText3D2(v.pos.x, v.pos.y, v.pos.z+0.07, "ID Du Joueur :~s~ ~g~".. k)
                DrawText3DSecond(v.pos.x, v.pos.y, v.pos.z+0.15, ConfigDeco.Translation.FirstDraw)
                DrawText3D(v.pos.x, v.pos.y, v.pos.z, "~s~"..ConfigDeco.Translation.reason.." "..v.res.. "\n"..ConfigDeco.Translation.time..""..v.date)
            end
        end


        if pNear then
            Wait(1)
        else
            Wait(2000)
        end
    end
end)

function DrawText3DSecond(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextColour(255, 0, 0, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3D2(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end