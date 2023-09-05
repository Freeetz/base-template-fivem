TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local isCutted = false

RegisterNetEvent('altix:useciseaux', function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local Ply = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local prop_name = "p_cs_scissors_s"

        if closestPlayer ~= -1 and closestDistance <= 3.0 then

            ExecuteCommand('me utilise des ciseaux')
            ciseau = CreateObject(GetHashKey("p_cs_scissors_s"), x, y, z,  true,  true, true)
            AttachEntityToEntity(ciseau, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.0, 0.03, 0.03, 0, -270.0, -20.0, true, true, false, true, 1, true)
            ESX.Streaming.RequestAnimDict('misshair_shop@barbers', function()
                TaskPlayAnim(Ply, 'misshair_shop@barbers', 'keeper_idle_b', 2.0, 2.0, 10000, 48, 0, false, false, false)
            end)
            Wait(10000)
            DeleteObject(ciseau)
            TriggerServerEvent('altix:haircut', GetPlayerServerId(closestPlayer))
        else
            ESX.ShowNotification('Impossible personne a proximité de vous.')
        end
end)

RegisterNetEvent('altix:haircut', function()
    isCutted = true
    TriggerEvent('skinchanger:change', 'hair_1', 199)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)

function GetCiseaux()
    return isCutted
end

Citizen.CreateThread(function()
    while isCutted do
        isCutted = true
        Citizen.SetTimeout(360000, function() isCutted = false end)
        Wait(0)
    end
end)