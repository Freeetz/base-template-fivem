
local config = {
    Heading = 85.79,
    pedHash = "s_m_y_construct_01",
    AuTravailleMine = false,
    ArgentMin = 150,
    ArgentMax = 365,
}

local workzone = {
    {
        pos = vector3(2926.8086, 2794.8572, 39.7566),
        Heading = 96.3413,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
    {
        pos = vector3(2937.8611, 2775.7175, 38.2215),
        Heading = 182.6458,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
    {
        pos = vector3(2952.1072, 2769.7656, 38.0496),
        Heading = 251.4689,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
    {
        pos = vector3(2970.0679, 2773.6345, 37.0489),
        Heading = 58.6798,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
    {
        pos = vector3(2972.5991, 2797.4922, 40.1960),
        Heading = 6.3881,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
    {
        pos = vector3(2937.9148, 2814.5813, 42.2886),
        Heading = 159.7371,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
}



local WorkerChillPos = {
    ped1 = {
        pos = vector3(2943.4858, 2743.7180, 42.3281),
        Heading = 340.3936,
    },
    ped2 = {
        pos = vector3(2953.5806, 2757.8093, 42.7182),
        Heading = 3.2642,
    },
    ped3 = {
        pos = vector3(2958.0186, 2744.9216, 42.5829),
        Heading = 306.0536,
    },
    ped4 = {
        pos = vector3(2965.1824, 2755.1099, 42.2678),
        Heading = 250.2878,
    },
    ped5 = {
        pos = vector3(2945.1030, 2746.9294, 42.3794),
        Heading = 270.2878,
    },
}

local WorkerWorkingPos = {
    ped1 = {
        pos = vector3(2941.1716, 2747.3101, 42.2160),
        Heading = 118.3520,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
    --[[ped2 = {
        pos = vector3(-494.18, -984.56, 28.13),
        Heading = 181.04,
        scenario = "WORLD_HUMAN_WELDING",
    },
    ped3 = {
        pos = vector3(-462.95, -998.48, 22.74),
        Heading = 90.48,
        scenario = "WORLD_HUMAN_HAMMERING",
    },
    ped4 = {
        pos = vector3(-447.86, -1015.17, 22.99),
        Heading = 176.85,
        scenario = "WORLD_HUMAN_HAMMERING",
    },
    ped5 = {
        pos = vector3(-450.17, -1002.06, 23.11),
        Heading = 191.62,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },
    ped6 = {
        pos = vector3(-447.62, -1005.67, 23.03),
        Heading = 52.82,
        scenario = "WORLD_HUMAN_CONST_DRILL",
    },--]]
}



RegisterNetEvent("aJobs:MineAntiDump")
AddEventHandler("aJobs:MineAntiDump", function()
    TriggerClientEvent("aJobs:MineAntiDump", source, config, workzone, WorkerChillPos, WorkerWorkingPos)
end)

RegisterNetEvent("Mine:Freetz")
AddEventHandler("Mine:Freetz", function()
    local resultat = math.random(1, 10)
    local xPlayer = ESX.GetPlayerFromId(source)

    if resultat == 3 then 
        xPlayer.addInventoryItem('pierre', 1)
        xPlayer.showNotification("Vous avez gagner ~y~x1~b~ pierre~s~ !")
    elseif resultat == 8 then 
        xPlayer.addInventoryItem('charbon', 1)
        xPlayer.showNotification("Vous avez gagner ~y~x1~b~ charbon~s~ !")
    end
end)