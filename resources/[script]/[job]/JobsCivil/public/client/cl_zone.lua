ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(0)
	end
end)


function HelpMsg(msg)
	AddTextEntry('LocationNotif', msg)
	BeginTextCommandDisplayHelp('LocationNotif')
	EndTextCommandDisplayHelp(0, false, true, -1)
end


function CreateCamera()
	Wait(1)
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x+2.0, coords.y+2.0, coords.z+2.0)
    SetCamFov(cam, 50.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z+1.0)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end


DecorRegister("Yay", 4)
Heading = 206.31968688965
pedHash = "a_f_y_business_02"


zone = {
    Lifeinveders = vector3(-266.1607, -961.8145, 30.22313),
    Chantier = vector3(-509.94, -1001.59, 22.55),
    Jardinier = vector3(-1347.78, 113.09, 55.37),
    bucheron = vector3(-572.0383, 5366.553, 69.22131),
    mine = vector3(2945.1030, 2746.9294, 43.3794),
}

local travailleZone = {
    {
        zone = vector3(-509.94, -1001.59, 22.55),
        nom = "Chantier",
        blip = 175,
        couleur = 44,
    },
    {
        zone = vector3(-1347.78, 113.09, 55.37),
        nom = "Golf",
        blip = 109,
        couleur = 43,
    },
    {
        zone = vector3(-570.853, 5367.214, 70.21643),
        nom = "Bucheron",
        blip = 477,
        couleur = 21,
    },
    {
        zone = vector3(2945.1030, 2746.9294, 43.3794),
        nom = "Mine",
        blip = 477, -- 800
        couleur = 47, -- 47
    },
}


Citizen.CreateThread(function()
    LoadModel(pedHash)
    local ped = CreatePed(2, GetHashKey(pedHash), zone.Lifeinveders, Heading, 0, 0)
    DecorSetInt(ped, "Yay", 5431)
    FreezeEntityPosition(ped, 1)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, 1)

    local blip = AddBlipForCoord(zone.Lifeinveders)
    SetBlipSprite(blip, 590)
    SetBlipScale(blip, 0.85)
    SetBlipShrink(blip, true)
    SetBlipColour(blip, 11)

    for k,v in pairs(travailleZone) do
        local blip = AddBlipForCoord(v.zone)
        SetBlipSprite(blip, v.blip)
        SetBlipScale(blip, 0.85)
        SetBlipShrink(blip, true)
        SetBlipColour(blip, v.couleur)
        SetBlipAsShortRange(blip, true)


        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.nom)
        EndTextCommandSetBlipName(blip)
    end

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Emploie intérimaire")
    EndTextCommandSetBlipName(blip)
end)


function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(100)
    end
end