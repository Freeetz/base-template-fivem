CreateThread(function()
    while true do

        local interval = 2500
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            interval = 10
            local veh = GetVehiclePedIsIn(PlayerPedId(),false)
            if GetPedInVehicleSeat(veh, -1) ~= 0 and not ConfigPneuxVeh.NoBrake[GetVehicleClass(veh)] then
                interval = 10
                local vehSpeed = math.ceil(GetEntitySpeed(veh) * 3.6)
                if HasEntityCollidedWithAnything(veh) and vehSpeed >= ConfigPneuxVeh.BreakSpeed  then
                    local result = math.random(0, 3)
                    if result == 1 then
                        local chance = math.random(0,3)
                        BreakOffVehicleWheel(veh,chance,true,false,true,false)
                        --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 45.0/3.6)
                    end
                    interval = 2500
                end
                if HasEntityCollidedWithAnything(veh) and vehSpeed >= ConfigPneuxVeh.BreakSpeed - 10  then
                    local result = math.random(0, 3)
                    if result == 1 then
                        local chance = math.random(0,3)
                        SetVehicleTyreBurst(veh,chance,true)
                        --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 30.0/3.6)
                    end
                    interval = 2500
                end
                if HasEntityCollidedWithAnything(veh) and vehSpeed >= ConfigPneuxVeh.BreakSpeed - 30  then
                    local result = math.random(0, 3)
                    if result == 1 then
                        local chance = math.random(0,3)
                        SetVehicleTyreBurst(veh,chance,false)
                        --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 10.0/3.6)
                    end
                    interval = 2500
                end
            end
        end

        Wait(interval)
    end
end)