Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

    while true do 
        ESX.PlayerData = ESX.GetPlayerData()
        Wait(500)
    end
end)

local isDead = false
local boostV = false
local pma = exports["pma-voice"]
local currentChannel = 0
local itemCooldown = false
local annonceCooldown = false
local invisible = false
local gmode = false
local tpcooldown = false

local IDCARD = false 
local PERMISC = false 
local PERMISA = false

------------------- ENTREPRISES ------------------------ 

local statustaxi = "[~r~FERMÉ~s~]"
local statusvigneron = "[~r~FERMÉ~s~]"
local statuspolice = "[~r~FERMÉ~s~]"
local statustabac = "[~r~FERMÉ~s~]"
local statusbcso = "[~r~FERMÉ~s~]"
local statussheriff = "[~r~FERMÉ~s~]"
local statusunicorn = "[~r~FERMÉ~s~]"
local statusweazelnews = "[~r~FERMÉ~s~]"
local statusbahamas = "[~r~FERMÉ~s~]"
local statusvoiture = "[~r~FERMÉ~s~]"
local statusavion = "[~r~FERMÉ~s~]"
local statusbateau = "[~r~FERMÉ~s~]"
local statusbennys = "[~r~FERMÉ~s~]"
local statuslscustom = "[~r~FERMÉ~s~]"
local statusautotuners = "[~r~FERMÉ~s~]"
local statusems = "[~r~FERMÉ~s~]"
local statusburgershot = "[~r~FERMÉ~s~]"
local statusagenceimmo = "[~r~FERMÉ~s~]"

--------------------------------------------------------

local VIPWeapons = {
	['WEAPON_APPISTOL'] = true,
	['WEAPON_SPECIALCARBINE'] = true,
	['WEAPON_COMBATPDW'] = true,
	['WEAPON_ASSAULTRIFLE'] = true,
	['WEAPON_HEAVYSHOTGUN'] = true,
	['WEAPON_HEAVYSNIPER'] = true,
	['WEAPON_SAWNOFFSHOTGUN'] = true,
	['WEAPON_MILITARYRIFLE'] = true,
	['WEAPON_COMBATPISTOL'] = true,
	['WEAPON_STUNGUN'] = true,
	['WEAPON_ADVANCEDRIFLE'] = true,
	['WEAPON_PUMPSHOTGUN'] = true,
	['WEAPON_NIGHTSTICK'] = true,
	['WEAPON_CARBINERIFLE'] = true,
	['WEAPON_TACTICALRIFLE'] = true,
	['WEAPON_NAVYREVOLVER'] = true,
	['WEAPON_GUSENBERG'] = true,
	['WEAPON_PRECISIONRIFLE'] = true,
	['WEAPON_DOUBLEACTION'] = true,
	['WEAPON_MAZE'] = true,
	['WEAPON_SCAR17'] = true,
	['WEAPON_MILITARM4'] = true,
	['WEAPON_KINETIC'] = true,
	['WEAPON_BLACKSNIPER'] = true,
	['WEAPON_SHOTGUNK'] = true,
	['WEAPON_HELLSNIPER'] = true,
	['WEAPON_HELL'] = true,
	['WEAPON_SPECIALHAMMER'] = true,
	['WEAPON_HELLDOUBLEACTION'] = true
}

otopiaMenu = {

    Indexaccesories = 1,
    IndexClothes = 1,
    Indexinvetory = 1,
    IndexVetement = 1,
    Accesoires = 1,
    Indexdoor = 1,
    LimitateurIndex = 1,
    Item = true,
    Weapon = true,
    Radar = true,
    Vetement = true,
    AccesoiresMenu = true,
    Report = true,
    ui = true,
    TickRadio = false,
    InfosRadio = false,
    Bruitages = true,
    Statut = "~b~Allumé",
    VolumeRadio = 1,
    jobChannels = {
        {job = "police", min=1, max=10},
        {job = "sheriff", min=1, max=10},
        {job = "fbi", min=1, max=10},
        {job = "ambulance", min=1, max=10},
        {job = "gouvernement", min=1, max=10}
    },

    DoorState = {
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false
    },

    voiture_limite = {
        "50 km/h",
        "80 km/h",
        "130 km/h",
        "Personalisée",
        "Désactiver"
    },
}
function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end
Masque = true 

function KeyboardInput()
    local v = nil
    AddTextEntry("CUSTOM_AMOUNT", "Quelle somme?")
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 15)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        v = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return v
end

function KeyboardInput2()
    local v = nil
    AddTextEntry("CUSTOM_AMOUNT", "Nouveau nom :")
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 15)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        v = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return v
end

function KeyboardInput3()
    local v = nil
    AddTextEntry("CUSTOM_AMOUNT", "Indiquer la vitesse maximum")
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 15)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        v = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return v
end

function KeyboardInput4()
    local v = nil
    AddTextEntry("CUSTOM_AMOUNT", "Veuillez indiquer le message")
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 90)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        v = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return v
end

function KeyboardInput5()
    local v = nil
    AddTextEntry("CUSTOM_AMOUNT", "Indiquer le nombre à donner")
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 15)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        v = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return v
end

function GetCurrentWeight()
	local currentWeight = 0
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
		end
	end
	return currentWeight
end

local BillData = {}

openMenuF5 = function()

    local mainf5 = RageUI.CreateMenu("", "Voici les actions disponibles :")
    
    --Menu Principaux
    local invetory = RageUI.CreateSubMenu(mainf5, "", "Voici votre inventaire")
    local portefeuille = RageUI.CreateSubMenu(mainf5, "", "Voici votre portefeuille")
    local vehicle = RageUI.CreateSubMenu(mainf5, "", "Voici les actions disponibles")
    local vetmenu = RageUI.CreateSubMenu(mainf5, "Vos vêtements", "Actions vêtements")
    local radio = RageUI.CreateSubMenu(mainf5, "", "Voici les actions disponibles")
    local diversmenu = RageUI.CreateSubMenu(mainf5, "", "Voici les actions disponibles")
    local tpmenu = RageUI.CreateSubMenu(mainf5, "", "Voici les téléportations disponibles")
    local parammenu = RageUI.CreateSubMenu(diversmenu, "", "Voici les actions disponibles :")
    local fpsmenu = RageUI.CreateSubMenu(diversmenu, "", "Voici les actions disponibles :")
    local adminmenu = RageUI.CreateSubMenu(mainf5, "", "Voici les actions d\'administration :")
    local pubs = RageUI.CreateSubMenu(mainf5, "", "Voici les actions disponibles")
    local graphicmenu = RageUI.CreateSubMenu(mainf5, "", "Voici les actions disponibles")
    local entreprisemenu = RageUI.CreateSubMenu(mainf5, "", "Voici les actions disponibles")
    --local pass = RageUI.CreateSubMenu(mainf5, "", "Passe de Combat")

    local actioninventory = RageUI.CreateSubMenu(invetory, "", "Voici les actions disponibles")
    local infojob = RageUI.CreateSubMenu(portefeuille, "", "Voici les information sur votre travail")
    local infojob2 = RageUI.CreateSubMenu(portefeuille, "", "Voici les information sur votre organisation")
    local gestionjob = RageUI.CreateSubMenu(mainf5, "", "Voici les information sur votre entreprise")
    local gestionjob2 = RageUI.CreateSubMenu(mainf5, "", "Voici les information sur votre organisation")
    local billingmenu = RageUI.CreateSubMenu(portefeuille, "", "Voici vos facture")
    local actionweapon = RageUI.CreateSubMenu(invetory, "", "Voici les actions dipsonibles")
    local gestionlicense = RageUI.CreateSubMenu(portefeuille, "", "Voici vos license")
    mainf5.Closed = function()end 
    radio.EnableMouse = true
    mainf5:SetTotalItemsPerPage(13)
    RageUI.Visible(mainf5, not RageUI.Visible(mainf5))

    while mainf5 do
        Wait(0)

        RageUI.IsVisible(mainf5, function()

            RageUI.Separator("Votre pseudo : ~g~".. GetPlayerName(PlayerId()) .."")
            RageUI.Separator("Votre ID : ~g~"..GetPlayerServerId(PlayerId()).."~s~")

            RageUI.Button("> Inventaire", "Accéder à votre inventaire", {RightLabel = "→→→"}, true, {}, invetory)

            RageUI.Button("> Portefeuille", "Votre Portefeuille", {RightLabel = "→→→"}, true, {}, portefeuille) 

            RageUI.Button("> Entreprises", "Vous permet de voir la liste des Entreprises ainsi que leur status", {RightLabel = "→→→"}, true, {}, entreprisemenu)

            if IsPedSittingInAnyVehicle(PlayerPedId()) then 
                RageUI.Button('> Gestion véhicule', 'Actions sur le véhicule', {RightLabel = "→→→"}, true, {}, vehicle)
            end

            RageUI.Button("> Vêtements", "Actions sur vos vêtements", {RightLabel = "→→→"}, true, {}, vetmenu)

            --RageUI.Button("> Radio", "Accéder à la radio", {RightLabel = "→→→"}, otopiaMenu.InfosRadio, {
            --    onSelected = function()
            --    end
            --}, radio)
            --if ESX.PlayerData.job.name == not "unemployed" then
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
                RageUI.Button("> Pubs", "Effectuez des publicités pour vos entreprises.", {RightLabel = "→→→"}, true, {}, pubs)
            end

            RageUI.Button("> Graphisme", nil, {RightLabel = "→→→"}, true, {}, graphicmenu)

            --RageUI.Button("> Passe De Combat", "Gagnez des articles en fonctions de votre niveau d\'XP sur le serveur !", {RightLabel = "→→→"}, true, {}, pass)
            
            if ESX.PlayerData.group ~= nil and (ESX.PlayerData.group == '_dev') then
                RageUI.Button("> Administration", "Actions d\'administration", {RightLabel = "→→→"}, true, {}, adminmenu)
            end

            RageUI.Button("> Téléportation", "Vous permez de vous téléportez à certain lieu. (Vous devez vous trouvez en ~g~Safe-Zone~s~)", {RightLabel = "→→→"}, true, {}, tpmenu)

            RageUI.Button("> Divers", "Actions diverses", {RightLabel = "→→→"}, true, {}, diversmenu)

            RageUI.Separator("_______________")

            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then 
                RageUI.Button("> Gestion Entreprise", nil, {RightLabel = "→→→"}, true, {
                    onSelected = function()
                        RefreshMoney()
                    end
                }, gestionjob)
            end

            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job2.grade_name == "boss" then
                RageUI.Button("> Gestion Organisation", nil, {RightLabel = "→→→"}, true, {
                    onSelected = function()
                        RefreshMoney2()
                    end
                }, gestionjob2)
            end
        
        end, function()
        end)

        RageUI.IsVisible(invetory, function()
            ESX.PlayerData = ESX.GetPlayerData()

            RageUI.Separator('Poids > '.. GetCurrentWeight() + 0.0 .. '/' .. ESX.PlayerData.maxWeight + 0.0)

            RageUI.List("Filtre", {"Aucun", "Inventaire", "Armes"}, otopiaMenu.Indexinvetory, nil, {}, true, {
                onListChange = function(index)
                    otopiaMenu.Indexinvetory = index 
                    if index == 1 then 
                        otopiaMenu.Item, otopiaMenu.Weapon, otopiaMenu.Vetement, otopiaMenu.AccesoiresMenu = true, true, true, true
                    elseif index == 2 then 
                        otopiaMenu.Item, otopiaMenu.Weapon, otopiaMenu.Vetement, otopiaMenu.AccesoiresMenu = true, false, false, false
                    elseif index == 3 then 
                        otopiaMenu.Item, otopiaMenu.Weapon, otopiaMenu.Vetement, otopiaMenu.AccesoiresMenu = false, true, false, false
                    elseif index == 4 then 
                        otopiaMenu.Item, otopiaMenu.Weapon, otopiaMenu.Vetement, otopiaMenu.AccesoiresMenu = false, false, true, false
                    end
                end
            })

            if otopiaMenu.Item then 
                if #ESX.PlayerData.inventory > 0 then 
                    RageUI.Separator("↓ Item ↓")
                    for k, v in pairs(ESX.PlayerData.inventory) do 
                        if v.count > 0 then 
                            RageUI.Button("> "..v.label.."", nil,  {RightLabel = "Quantité : ~g~x"..v.count..""}, not itemCooldown, {
                                onSelected = function()
                                    count = v.count 
                                    label  = v.label
                                    name = v.name
                                    remove = v.canRemove
                                    Wait(100)
                                end
                            }, actioninventory)
                        end
                    end
                else
                    RageUI.Separator("~r~Aucun Item")
                end
            end

            --[[if otopiaMenu.Weapon then 
                local Player = GetPlayerServerId()
                local WeaponData = ESX.GetWeaponList()
                local tkt = ESX.GetPlayerData().loadout 
                if #WeaponData > 0 then
                    RageUI.Separator("↓ Armes ↓")
                    for d = 1, #tkt do
                        --if HasPedGotWeapon(PlayerPedId(), WeaponData[i].hash, true) then
                            local ammo = GetAmmoInPedWeapon(PlayerPedId(), WeaponData[i].hash)
                            RageUI.Button("> "..WeaponData[i].label, nil, { RightLabel = "Munition(s) : ~r~x"..ammo }, true, {
                                onSelected = function()
                                    ammoo = ammo 
                                    name = WeaponData[i].name 
                                    label = WeaponData[i].label
                                end
                            }, actionweapon)
                        --end
                    end
                else
                    RageUI.Separator("~r~Aucune Armes")
                end
            end--]]

            if otopiaMenu.Weapon then 
                RageUI.Separator("↓ Armes ↓")
                local WeaponData = ESX.GetPlayerData().loadout 
                    for i = 1, #WeaponData do
                        local ammo = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(WeaponData[i].name))
                        RageUI.Button("> "..WeaponData[i].label, nil, { RightLabel = "Munition(s) : ~g~x"..ammo }, true, {
                            onSelected = function()
                                if VIPWeapons[WeaponData[i].name] == true then
                                    ESX.ShowNotification("~r~Il s\'agit d\'une arme permanente !")
                                else
                                    ammoo = ammo 
                                    name = WeaponData[i].name 
                                    label = WeaponData[i].label
                                end
                            end
                        }, actionweapon)
                    end
            --else
                --RageUI.Separator("~r~Aucune Armes")
            end

            --[[
            if otopiaMenu.Weapon then 
                local WeaponData = ESX.GetPlayerData().loadout 
                    for i = 1, #WeaponData do
                        local ammo = GetAmmoInPedWeapon(PlayerPedId(), WeaponData[i].hash)
                        RageUI.Button("> "..WeaponData[i].label, nil, { RightLabel = "Munition(s) : ~r~x"..ammo }, true, {
                            onSelected = function()
                                ammoo = ammo 
                                name = WeaponData[i].name 
                                label = WeaponData[i].label
                            end
                        }, actionweapon) 
                    end
            else
                RageUI.Separator("~r~Aucune Armes")
            end
            --]]

            if otopiaMenu.Vetement then 
                --[[if ClothesPlayer ~= nil  then 
                    RageUI.Separator("↓ Vetement(s) ↓")
                    for k, v in pairs(ClothesPlayer) do 
                        if v.label ~= nil and v.type == "vetement" and v.equip ~= "n" then 
                            RageUI.List("> Tenue "..v.label, {"Equiper", "Renomer", "Supprimer", "Donner"}, otopiaMenu.IndexVetement, nil, {}, true, {
                                onListChange = function(Index)
                                    otopiaMenu.IndexVetement = Index
                                end,
                                onSelected = function(Index)
                                    if Index == 1 then 
                                        startAnimAction('clothingtie', 'try_tie_neutral_a')
                                        Wait(1000)
                                        ExecuteCommand("me équipe une tenue")
                                        TriggerEvent("skinchanger:getSkin", function(skin)
                                            TriggerEvent("skinchanger:loadClothes", skin, json.decode(v.skin))
                                        end)
                                        TriggerEvent("skinchanger:getSkin", function(skin)
                                            TriggerServerEvent("esx_skin:save", skin)
                                        end)
                                    elseif Index == 2 then 
                                        local newname = KeyboardInput2("Nouveau nom","Nouveau nom", "", 15)
                                        if newname then 
                                            TriggerServerEvent("ewen:RenameTenue", v.id, newname)
                                        end
                                    elseif Index == 3 then 
                                        TriggerServerEvent('ronflex:deletetenue', v.id)
                                    elseif Index == 4 then 
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                        if closestDistance ~= -1 and closestDistance <= 3 then
                                            local closestPed = GetPlayerPed(closestPlayer)
                                            TriggerServerEvent("ronflex:donnertenue", GetPlayerServerId(closestPlayer), v.id)
                                            RageUI.CloseAll()
                                        else
                                            ESX.ShowNotification("Personne aux alentours")
                                        end
                                    end
                                end,
                              
                            })
                        end
                    end
                else
                    RageUI.Separator("~r~Aucune Tenue")
                end--]]
            end

            --[[if otopiaMenu.AccesoiresMenu then 
                if ClothesPlayer ~= nil then 
                    RageUI.Separator("Accesoires")
                    if not ClothesPlayer ~= nil then
                        for k, v in pairs(ClothesPlayer) do 
                            if v.label ~= nil and v.type ~= "vetement" then 
                                RageUI.List("> "..v.type..' '..v.label, {"Equiper", "Renomer", "Supprimer", "Donner"}, otopiaMenu.IndexVetement, nil, {}, true, {
                                    onListChange = function(Index)
                                        otopiaMenu.IndexVetement = Index
                                    end,
                                    onSelected = function(Index)
                                        if Index == 1 then 
                                            startAnimAction('clothingtie', 'try_tie_neutral_a')
                                            Wait(1000)
                                            ExecuteCommand("me équipe un "..v.type)
                                            TriggerEvent("skinchanger:getSkin", function(skin)
                                                TriggerEvent("skinchanger:loadClothes", skin, json.decode(v.skin))
                                            end)
                                            TriggerEvent("skinchanger:getSkin", function(skin)
                                                TriggerServerEvent("esx_skin:save", skin)
                                            end)
                                        elseif Index == 2 then 
                                            local newname = KeyboardInput2("Nouveau nom","Nouveau nom", "", 15)
                                            if newname then 
                                                TriggerServerEvent("ewen:RenameTenue", v.id, newname)
                                            end
                                        elseif Index == 3 then 
                                            ExecuteCommand("me supprime le/la "..v.type.." ")
                                            TriggerServerEvent('ronflex:deletetenue', v.id)
                                        elseif Index == 4 then 
                                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                            if closestDistance ~= -1 and closestDistance <= 3 then
                                                local closestPed = GetPlayerPed(closestPlayer)
                                                TriggerServerEvent("ronflex:donnertenue", GetPlayerServerId(closestPlayer), v.id)
                                                RageUI.CloseAll()
                                            else
                                                ESX.ShowNotification("Personne aux alentours")
                                            end
                                        end
                                    end
                                })
                            end
                        end
                    end
                else
                    RageUI.Separator("~r~Aucun Accésoire")
                end
            end--]]

        end, function()
        end)

        RageUI.IsVisible(portefeuille, function()

            local player, closestplayer = ESX.Game.GetClosestPlayer()

            RageUI.Separator('→ ~g~Votre Argent~s~ ←')

            for i = 1, #ESX.PlayerData.accounts, 1 do
                if ESX.PlayerData.accounts[i].name == 'bank'  then
                    RageUI.Button('Argent en banque: ~b~'..ESX.PlayerData.accounts[i].money.."$", nil, {RightLabel = ""}, true, {})
                end
            end
			
            for i = 1, #ESX.PlayerData.accounts, 1 do
                if ESX.PlayerData.accounts[i].name == 'cash'  then
                    RageUI.Button('Argent en liquide: ~g~'..ESX.PlayerData.accounts[i].money.."$", nil, {RightLabel = ""}, true, {
                        onActive = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3 then
                                PlayerMakrer(closestPlayer)
                            end
                        end,
                        onSelected = function()
                            local check, quantity = CheckQuantity(KeyboardInput("Quelle somme ?", '', '', 100))
                            if check then 
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
                                    if not IsPedSittingInAnyVehicle(closestPed) then
                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', "cash", quantity)
                                        RageUI.GoBack()
                                    else
                                        ESX.ShowNotification("~r~Vous ne pouvez pas faire ceci dans un véhicule !")
                                    end
                                else
                                    ESX.ShowNotification('Aucun joueur proche !')
                                end
                            else
                                ESX.ShowNotification("Arguments Insufisant")
                            end
                        end
                    })
                end
            end

            for i = 1, #ESX.PlayerData.accounts, 1 do
                if ESX.PlayerData.accounts[i].name == 'dirtycash'  then
                    RageUI.Button('Argent non déclaré: ~r~'..ESX.PlayerData.accounts[i].money.."$", nil, {RightLabel = ""}, true, {
                        onActive = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3 then
                                PlayerMakrer(closestPlayer)
                            end
                        end,
                        onSelected = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            local check, quantity = CheckQuantity(KeyboardInput("Quelle somme ?", '', '', 100))
                            if check then 
                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
                                    if not IsPedSittingInAnyVehicle(closestPed) then
                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', "dirtycash", quantity)
                                        RageUI.GoBack()
                                    else
                                        ESX.ShowNotification("~r~Vous ne pouvez pas faire ceci dans un véhicule !")
                                    end
                                else
                                    ESX.ShowNotification('Aucun joueur proche !')
                                end
                            else
                                ESX.ShowNotification("Arguments Inssufisant")
                            end
                        end
                    })
                end
            end
			
            RageUI.Button("→ Accéder à vos factures", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    ESX.TriggerServerCallback('ewen:getFactures', function(bills) BillData = bills end)
                end
            }, billingmenu)

            RageUI.Separator("→ ~g~Vos Information Personnelles~s~ ←")

            RageUI.Button("→ Information Métier", "Accéder aux information de votre métier", {RightLabel = "→→→"}, true, {onSelected = function()RefreshMoney()end}, infojob)

            RageUI.Button("→ Information Organisation", "Accéder aux information de votre organisation", {RightLabel = "→→→"}, true, {onSelected = function()RefreshMoney2()end}, infojob2)

            RageUI.Button("→ Gestion License", nil, {RightLabel = "→→→"}, true, {}, gestionlicense)

            RageUI.Separator("____________")

        end, function()
        end)

        RageUI.IsVisible(vehicle, function()

            local playerPed = PlayerPedId()
            local engineHealth = GetVehicleEngineHealth(GetPlayersLastVehicle(playerPed, true))
            
            if engineHealth / 10 == 0 then
                RageUI.Separator("État du moteur : ~r~0~s~%")
            else
                RageUI.Separator("État du moteur : ~r~".. math.floor(tonumber(engineHealth / 10)) .."~s~%")
            end
            
            local pVeh = GetVehiclePedIsUsing(PlayerPedId())

            RageUI.Button("Allumer / Eteindre le moteur", nil, {RightLabel = otopiaMenu.Statut}, true, {
                onSelected = function()
                    if GetIsVehicleEngineRunning(pVeh) then
                        otopiaMenu.Statut = "~r~Eteint"

                        SetVehicleEngineOn(pVeh, false, false, true)
                        SetVehicleUndriveable(pVeh, true)
                    elseif not GetIsVehicleEngineRunning(pVeh) then
                        otopiaMenu.Statut = "~b~Allumé"

                        SetVehicleEngineOn(pVeh, true, false, true)
                        SetVehicleUndriveable(pVeh, false)
                    end
                end
            })

            RageUI.List("Ouvrir / Fermer porte", {"Avant gauche", "Avant Droite", "Arrière Gauche", "Arrière Droite", "Capot", "Coffre"}, otopiaMenu.Indexdoor, nil, {}, true, {
                onListChange = function(index)
                    otopiaMenu.Indexdoor = index 
                end,
                onSelected = function(index)
                    
                    if index == 1 then
                        if not otopiaMenu.DoorState.FrontLeft then
                            otopiaMenu.DoorState.FrontLeft = true
                            SetVehicleDoorOpen(pVeh, 0, false, false)
                        elseif otopiaMenu.DoorState.FrontLeft then
                            otopiaMenu.DoorState.FrontLeft = false
                            SetVehicleDoorShut(pVeh, 0, false, false)
                        end
                    elseif index == 2 then
                        if not otopiaMenu.DoorState.FrontRight then
                            otopiaMenu.DoorState.FrontRight = true
                            SetVehicleDoorOpen(pVeh, 1, false, false)
                        elseif otopiaMenu.DoorState.FrontRight then
                            otopiaMenu.DoorState.FrontRight = false
                            SetVehicleDoorShut(pVeh, 1, false, false)
                        end
                    elseif index == 3 then
                        if not otopiaMenu.DoorState.BackLeft then
                            otopiaMenu.DoorState.BackLeft = true
                            SetVehicleDoorOpen(pVeh, 2, false, false)
                        elseif otopiaMenu.DoorState.BackLeft then
                            otopiaMenu.DoorState.BackLeft = false
                            SetVehicleDoorShut(pVeh, 2, false, false)
                        end
                    elseif index == 4 then
                        if not otopiaMenu.DoorState.BackRight then
                            otopiaMenu.DoorState.BackRight = true
                            SetVehicleDoorOpen(pVeh, 3, false, false)
                        elseif otopiaMenu.DoorState.BackRight then
                            otopiaMenu.DoorState.BackRight = false
                            SetVehicleDoorShut(pVeh, 3, false, false)
                        end
                    elseif index == 5 then 
                        if not otopiaMenu.DoorState.Hood then
                            otopiaMenu.DoorState.Hood = true
                            SetVehicleDoorOpen(pVeh, 4, false, false)
                        elseif otopiaMenu.DoorState.Hood then
                            otopiaMenu.DoorState.Hood = false
                            SetVehicleDoorShut(pVeh, 4, false, false)
                        end
                    elseif index == 6 then 
                        if not otopiaMenu.DoorState.Trunk then
                            otopiaMenu.DoorState.Trunk = true
                            SetVehicleDoorOpen(pVeh, 5, false, false)
                        elseif otopiaMenu.DoorState.Trunk then
                            otopiaMenu.DoorState.Trunk = false
                            SetVehicleDoorShut(pVeh, 5, false, false)
                        end
                    end
                end
            })

            RageUI.Button("Fermer toutes les portes", nil, {RightLabel =  "→→→"}, true, {
                onSelected = function ()
                    for door = 0, 7 do
                        SetVehicleDoorShut(pVeh, door, false)
                    end
                end
            })

            RageUI.List("Limitateur", otopiaMenu.voiture_limite, otopiaMenu.LimitateurIndex, nil, {}, true, {
                onListChange = function(i, item)
                    otopiaMenu.LimitateurIndex = i
                end,

                onSelected = function(i, item)
                    if i == 1 then
                        SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 50.0/3.6)
                        ESX.ShowNotification("Limitateur de vitesse défini sur ~g~50 km/h")
                    elseif i == 2 then  
                        SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 80.0/3.6)
                        ESX.ShowNotification("Limitateur de vitesse défini sur ~g~80 km/h")
                    elseif i == 3  then
                        SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 130.0/3.6)
                        ESX.ShowNotification("Limitateur de vitesse défini sur ~g~130 km/h")
                    elseif i == 4 then
                        local speed = KeyboardInput3("Indiquer la vitesse", "Indiquer la viteese", "", 10)
                        if speed ~= nil or speed ~= tostring("") then 
                            SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), ESX.Math.Round(speed, 1)/3.6)
                            ESX.ShowNotification("Limitateur de vitesse défini sur ~g~"..speed..'km/h')
                        else
                            return
                        end
                    elseif i == 5 then 
                        SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 10000.0/3.6)    
                        ESX.ShowNotification("Limitateur de vitesse désactivé")
                    end
                end
            })

            RageUI.Separator("________________")
        
        end, function()
        end)

        RageUI.IsVisible(vetmenu, function()

            RageUI.List(" Vetement", {"Haut", "Bas", "Chaussures", "Sac", "Giltet par balle"}, otopiaMenu.IndexClothes, nil, {LeftBadge = RageUI.BadgeStyle.Clothes}, true, {
                onListChange = function(index)
                    otopiaMenu.IndexClothes = index 
                end, 
                onSelected = function(index)
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
                        TriggerEvent("skinchanger:getSkin", function(skina)
                            if index == 1 then 
                                if skin.torso_1 ~= skina.torso_1 then
                                    ExecuteCommand("me remet son Haut")
                                    TriggerEvent("skinchanger:loadClothes", skina, { ["torso_1"] = skin.torso_1, ["torso_2"] = skin.torso_2, ["tshirt_1"] = skin.tshirt_1, ["tshirt_2"] = skin.tshirt_2, ["arms"] = skin.arms })
                                else
                                    ExecuteCommand("me retire son Haut")
                                    if skin.sex == 0 then
                                        TriggerEvent("skinchanger:loadClothes", skina, { ["torso_1"] = 204, ["torso_2"] = 0, ["tshirt_1"] = 15, ["tshirt_2"] = 0, ["arms"] = 15 })
                                    else
                                        TriggerEvent("skinchanger:loadClothes", skina, { ["torso_1"] = 204, ["torso_2"] = 0, ["tshirt_1"] = 15, ["tshirt_2"] = 0, ["arms"] = 15 })
                                    end
                                end
                            elseif index == 2 then 
                                if skin.pants_1 ~= skina.pants_1 then
                                    ExecuteCommand("me remet son Pantalon")
                                    TriggerEvent("skinchanger:loadClothes", skina, { ["pants_1"] = skin.pants_1, ["pants_2"] = skin.pants_2 })
                                else
                                    ExecuteCommand("me retire son Pantalon")
                                    if skin.sex == 0 then
                                        TriggerEvent("skinchanger:loadClothes", skina, { ["pants_1"] = 14, ["pants_2"] = 0 })
                                    else
                                        TriggerEvent("skinchanger:loadClothes", skina, { ["pants_1"] = 14, ["pants_2"] = 0 })
                                    end
                                end
                            elseif index == 3 then 
                                if skin.shoes_1 ~= skina.shoes_1 then
                                    ExecuteCommand("me remet ses Chaussures")
                                    TriggerEvent("skinchanger:loadClothes", skina, { ["shoes_1"] = skin.shoes_1, ["shoes_2"] = skin.shoes_2 })
                                else
                                    if skin.sex == 0 then
                                        ExecuteCommand("me enlève ses Chaussures")
                                        TriggerEvent("skinchanger:loadClothes", skina, { ["shoes_1"] = 6, ["shoes_2"] = 0 })
                                    else
                                        TriggerEvent("skinchanger:loadClothes", skina, { ["shoes_1"] = 6, ["shoes_2"] = 0 })
                                    end
                                end
                            elseif index == 4 then
                                if skin.bags_1 ~= skina.bags_1 then
                                    ExecuteCommand("me retire son Sac")
                                    TriggerEvent("skinchanger:loadClothes", skina, { ["bags_1"] = skin.bags_1, ["bags_2"] = skin.bags_2 })
                                else
                                    ExecuteCommand("me retire son Sac")
                                    TriggerEvent("skinchanger:loadClothes", skina, { ["bags_1"] = 40, ["bags_2"] = 40 })
                                end
                            elseif index == 5 then 
                                if skin.bproof_1 ~= skina.bproof_1 then
                                    ExecuteCommand("me retire son Gilet par balle")
                                    TriggerEvent("skinchanger:loadClothes", skina, { ["bproof_1"] = skin.bproof_1, ["bproof_2"] = skin.bproof_2 })
                                else
                                    ExecuteCommand("me retire son Gilet par balle")
                                    TriggerEvent("skinchanger:loadClothes", skina, { ["bproof_1"] = 0, ["bproof_2"] = 0 })
                                end
                            end
                        end)
                    end)
                end
            })

            RageUI.List(' Accesoires', {"Masque","Chapeau", "Lunette", "Boucle d'oreilles", "Chaine"}, otopiaMenu.Indexaccesories, nil, {LeftBadge = RageUI.BadgeStyle.Mask}, true, {
                onListChange = function(Index)
                    otopiaMenu.Indexaccesories = Index;
                end,

                onSelected = function(Index)
                    if Index == 1 then
                        Wait(250)
                        setAccess('mask', plyPed)
                    elseif Index == 2 then
                        Wait(250)
                        setAccess('helmet', plyPed)
                    elseif Index == 3 then
                        Wait(250)
                        setAccess('glasses', plyPed)
                    elseif Index == 4 then
                        Wait(250)
                        setAccess('ears', plyPed)
                    elseif Index == 5 then
                        Wait(250)
                        setAccess('chain', plyPed)
                    end
                end
            })

        end, function()
        end)

        RageUI.IsVisible(radio, function()
            
            RageUI.Separator("")

            RageUI.Button("Allumer / Eteindre", "Vous permet d'allumer ou d'éteindre la radio", {RightLabel = "→→→"}, true, {
                onSelected = function()
                    if not otopiaMenu.TickRadio then 
                        otopiaMenu.TickRadio = true 
                        pma:setVoiceProperty("radioEnabled", true)
                        ESX.ShowNotification("~n~Radio Allumé !")
                    else
                        otopiaMenu.TickRadio = false
                        pma:setRadioChannel(0)
                        pma:setVoiceProperty("radioEnabled", false)
                        ESX.ShowNotification("~n~Radio Eteinte !")
                    end
                end
            })

            if otopiaMenu.TickRadio then
                RageUI.Separator("Radio: ~b~Allumée")

                if otopiaMenu.Bruitages then 
                    RageUI.Separator("Bruitages: ~b~Activés")
                else
                    RageUI.Separator("Bruitages: ~r~Désactivés")
                end

                if otopiaMenu.VolumeRadio*100 <= 20 then 
                    ColorRadio = "~b~" 
                elseif otopiaMenu.VolumeRadio*100 <= 45 then 
                    ColorRadio ="~b~" 
                elseif otopiaMenu.VolumeRadio*100 <= 65 then 
                    ColorRadio ="~o~" 
                elseif otopiaMenu.VolumeRadio*100 <= 100 then 
                    ColorRadio ="~r~" 
                end 

                RageUI.Separator("Volume: "..ColorRadio..ESX.Math.Round(otopiaMenu.VolumeRadio*100).."~s~ %")

                RageUI.Button("Se connecter à une fréquence ", "Choissisez votre fréquence", {RightLabel = otopiaMenu.Frequence}, true, {
                    onSelected = function()
                                local verif, Frequence = CheckQuantity(KeyboardInput("Frequence", "Frequence", "", 10))
                                local PlayerData = ESX.GetPlayerData(_source)
                                local restricted = {}
                                
                                if Frequence > 500 then
                                    return
                                end
                                
                                for i,v in pairs(otopiaMenu.jobChannels) do
                                    if Frequence >= v.min and Frequence <= v.max then
                                        table.insert(restricted, v)
                                    end
                                end
                            
                                if #restricted > 0 then
                                    for i,v in pairs(restricted) do
                                        if PlayerData.job.name == v.job and Frequence >= v.min and Frequence <= v.max then
                                            otopiaMenu.Frequence = tostring(Frequence)
                                            pma:setRadioChannel(Frequence)
                                            ESX.ShowNotification("Fréquence définie sur "..Frequence.." MHZ")
                                            currentChannel = Frequence
                                            break
                                        elseif i == #restricted then
                                            ESX.ShowNotification('Échec de la connexion a la fréquence')
                                            break
                                        end
                                    end
                                else
                                    otopiaMenu.Frequence = tostring(Frequence)
                                    pma:setRadioChannel(Frequence)
                                    ESX.ShowNotification("~n~Fréquence définie sur "..Frequence.." MHZ")
                                    currentChannel = Frequence
                                end
                    end
                })

                RageUI.Button("Se déconnecter de la fréquence", "Vous permet de déconnecter de votre fréquence actuelle", {RightLabel = "→→→"}, true, {
                    onSelected = function()
                        pma:setRadioChannel(0)
                        otopiaMenu.Frequence = "0"
                        ESX.ShowNotification("Vous vous êtes déconnecter de la fréquence")
                    end
                })

                RageUI.Button("Activer les bruitages", "Vous permet d'activer les bruitages'", {RightLabel = "→→→"}, true, {
                    onSelected = function()
                        if otopiaMenu.Bruitages then 
                            otopiaMenu.Bruitages = false
                            pma:setVoiceProperty("micClicks", false)
                            ESX.ShowNotification("Bruitages radio désactives")
                        else
                            otopiaMenu.Bruitages = true 
                            ESX.ShowNotification("Bruitages radio activés")
                            pma:setVoiceProperty("micClicks", true)
                        end
                    end
                })
            else
                RageUI.Separator("Radio: ~r~Eteinte")
            end

            RageUI.Separator("________________")

        end, function()
            RageUI.PercentagePanel(otopiaMenu.VolumeRadio, 'Volume', '0%', '100%', {
                onProgressChange = function(Percentage)
                    otopiaMenu.VolumeRadio = Percentage
                    pma:setRadioVolume(Percentage)
                end
            }, 5) 
        end)

        RageUI.IsVisible(graphicmenu, function()
        
            RageUI.Checkbox('Vue & lumières améliorées', nil, vue1, {}, {
                onChecked = function()
                    SetTimecycleModifier('tunnel')
                    vue1 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue1 = false
                end,
            })

            RageUI.Checkbox('Vue & lumières améliorées 2', nil, vue2, {}, {
                onChecked = function()
                    SetTimecycleModifier('CS3_rail_tunnel')
                    vue2 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue2 = false
                end,
            })

            RageUI.Checkbox('Vue & lumières améliorées 3', nil, vue3, {}, {
                onChecked = function()
                    SetTimecycleModifier('MP_lowgarage')
                    vue3 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue3 = false
                end,
            })

            RageUI.Checkbox('Vue lumineux', nil, vue4, {}, {
                onChecked = function()
                    SetTimecycleModifier('rply_vignette_neg')
                    vue4 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue4 = false
                end,
            })

            RageUI.Checkbox('Vue lumineux 2', nil, vue5, {}, {
                onChecked = function()
                    SetTimecycleModifier('rply_saturation_neg')
                    vue5 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue5 = false
                end,
            })

            RageUI.Checkbox('Couleurs amplifiées', nil, vue6, {}, {
                onChecked = function()
                    SetTimecycleModifier('rply_saturation')
                    vue6 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue6 = false
                end,
            })

            RageUI.Checkbox('Noir & blancs', nil, vue7, {}, {
                onChecked = function()
                    SetTimecycleModifier('rply_saturation_neg')
                    vue7 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue7 = false
                end,
            })

            RageUI.Checkbox('Visual 1', nil, vue8, {}, {
                onChecked = function()
                    SetTimecycleModifier('yell_tunnel_nodirect')
                    vue8 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue8 = false
                end,
            })

            RageUI.Checkbox('Blanc', nil, vue9, {}, {
                onChecked = function()
                    SetTimecycleModifier('rply_contrast_neg')
                    vue9 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue9 = false
                end,
            })

            RageUI.Checkbox('Dégats', nil, vue10, {}, {
                onChecked = function()
                    SetTimecycleModifier('rply_vignette')
                    vue10 = true
                end,
                onUnChecked = function()
                    SetTimecycleModifier('')
                    vue10 = false
                end,
            })

        end, function()
        end)

        RageUI.IsVisible(pubs, function()

            --[[RageUI.Button("Twt", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    local info = 'Twitter'
                    local message = KeyboardInput('Veuillez mettre le messsage à envoyer', '', '', 250)
                    if message ~= nil and message ~= "" then
                        TriggerServerEvent('Twt', info, message)
                    end
                end
            })

            RageUI.Button("Twt Anonyme", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    local info = 'Anonyme'
                    local message = KeyboardInput('Veuillez mettre le messsage à envoyer', '', '', 250)
                    if message ~= nil and message ~= "" then
                        TriggerServerEvent('Ano', info, message)
                    end
                end
            })--]]

            --[[RageUI.Button("Pub entreprise", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    local info = 'Entreprise'
                    local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                    if message ~= nil and message ~= "" then
                        TriggerServerEvent('Entreprise', info, message)
                    end
                end
            })--]]


            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("LSPD", nil, {RightLabel = "→→→"}, not annonceCooldown, { -- true,
                    onSelected = function()
                        annonceCooldown = true
                        local info = 'LSPD'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Police', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'vinewood') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Shériff", nil, {RightLabel = "→→→"}, not annonceCooldown, { -- true,
                    onSelected = function()
                        annonceCooldown = true
                        local info = 'Shériff'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Sheriff', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'carshop') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Concessionaire Voiture", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'CONCESSIONAIRE VOITURE'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('ConcessV', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Benny\'s", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'Benny\'s'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Bennys', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'automotors') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Auto Motors", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'Auto Motors'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('AutoMotors', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'autotuners') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Auto Tuners", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'Auto Tuners'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('AutoTuners', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'lscustom') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("LS Custom", nil, {RightLabel = "→→→"}, not annonceCooldown, { --
                    onSelected = function()
                        local info = 'LS Custom'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('LSCustom', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("E.M.S", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'AMBULANCE'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Ambulance', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("E.M.S", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'TAXI'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Taxi', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Unicorn", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'UNICORN'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Unicorn', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Vigneron", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'VIGNERON'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Vigneron', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Burger-Shot", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'BURGER SHOT'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Burgershot', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'realestateagent') then
                RageUI.Separator("↓ ~r~Actions Disponible~s~ ↓")
                RageUI.Button("Agence Immobilière", nil, {RightLabel = "→→→"}, not annonceCooldown, {
                    onSelected = function()
                        local info = 'AGENCE IMMOBILIERE'
                        local message = KeyboardInput4('Veuillez mettre le messsage à envoyer', '', '', 250)
                        if message ~= nil and message ~= "" then
                            TriggerServerEvent('Agence', info, message)
                        end
                        Citizen.SetTimeout(360000, function() annonceCooldown = false end)
                    end
                })
            end

            if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'unemployed') then
                RageUI.Separator("")
                RageUI.Separator("~r~Vous n\'avez pas de métier !")
                RageUI.Separator("")
            end

        end, function()
        end)

        RageUI.IsVisible(pass, function()

            --RageUI.Button("~g~Niveau 5~s~ → x1 Couteau", nil, {RightLabel = "→→→"}, true, {
            --    onSelected = function()
            --        TriggerServerEvent('freetz:Niveau5')
            --        ESX.ShowNotification("Oui sa marche !")
            --    end
            --})

            RageUI.Separator("~r~Prochainement disponile !")

        end, function()
        end)

        RageUI.IsVisible(diversmenu, function()

            RageUI.Checkbox("Activer le radar", "Vous permet d'activer ou de désactiver la minimap", otopiaMenu.Radar, {}, {
                onChecked = function()
                end,
                onUnChecked = function()
                end,
                onSelected = function(Index)
                    DisplayRadar(otopiaMenu.Radar)
                    otopiaMenu.Radar = Index
                end
                
            })

            --RageUI.Checkbox("Activer l'HUD", "Vous permet d'activer ou de désactiver l'HUD", otopiaMenu.ui, {}, {
            --    onChecked = function()
            --    end,
            --    onUnChecked = function()
            --    end,
            --    onSelected = function(Index)
            --        TriggerEvent("tempui:toggleUi", not otopiaMenu.ui)
            --        otopiaMenu.ui = Index
            --    end

            --})

            RageUI.Checkbox('Mode cinématique', nil, cinemamode, {}, {
                onChecked = function()
                    ExecuteCommand('noir')
                    ExecuteCommand('hud')
                    cinemamode = true
                end,
                onUnChecked = function()
                    ExecuteCommand('noir')
                    ExecuteCommand('hud')
                    cinemamode = false
                end,
            })
            RageUI.Checkbox('Désactiver l\'HUD', nil, huddesac, {}, {
                onChecked = function()
                    ExecuteCommand('hud')
                    huddesac = true
                end,
                onUnChecked = function()
                    ExecuteCommand('hud')
                    huddesac = false
                end,
            })
            --[[RageUI.Checkbox('Mode drift', nil, driftmode, {}, {
                onChecked = function()
                    driftmode = not driftmode
                end,
                onUnChecked = function()
                    driftmode = false
                end,
                onSelected = function(Index)
                    driftmode = Index
                end
            })
            RageUI.Checkbox('Désactiver les coups de crosse', nil, coupCrosse, {}, {
                onChecked = function()
                    Citizen.CreateThread(function()
                        while coupCrosse do
                            Citizen.Wait(0)
                            local ped = PlayerPedId()
                            if IsPedArmed(ped, 6) then
                                DisableControlAction(1, 140, true)
                                DisableControlAction(1, 141, true)
                                DisableControlAction(1, 142, true)
                            end
                        end
                    end)
                end,
                onUnChecked = function()
                    coupCrosse = false
                end,
                onSelected = function(Index)
                    coupCrosse = Index
                end
            })--]]

            RageUI.Button("> Paramètres", "Actions diverses & paramètres", {RightLabel = "→→→"}, true, {}, parammenu)
            RageUI.Button("> Optimisation", "Permet de optimiser votre jeu", {RightLabel = "→→→"}, true, {}, fpsmenu)

        end, function()
        end)

        RageUI.IsVisible(tpmenu, function()

            RageUI.Separator("↓ ~g~Téléportation Disponible~s~ ↓")

            RageUI.Button("Zone de Gun-Fight", nil, {RightLabel = "→→→"}, not tpcooldown, {
                onSelected = function()
                    if exports.Freetz Commu:GetSafeZone() then
                        tpcooldown = true

                        local coords = GetEntityCoords(PlayerPedId())
                        ESX.ShowNotification("~r~Ne bougez pas.")
                        ESX.ShowNotification("~r~3")
                        Wait(1000)
                        if GetEntityCoords(PlayerPedId()) == coords then 
                            ESX.ShowNotification("~o~2")
                            Wait(1000)
                            if GetEntityCoords(PlayerPedId()) == coords then 
                                ESX.ShowNotification("~g~1")
                                Wait(1000)
                                if GetEntityCoords(PlayerPedId()) == coords then 
                                    SetEntityCoords(PlayerPedId(), 920.1010, 3092.0767, 41.2784) 
                                    ESX.ShowNotification("Vous avez était ~g~téléporter~s~ en zone de Gun-Fight !")                   
                                    Citizen.SetTimeout(360000, function() tpcooldown = false end)
                                else
                                    ESX.ShowNotification("~r~Vous avez bougez, action annulé.")
                                end
                            else
                                ESX.ShowNotification("~r~Vous avez bougez, action annulé.")
                            end
                        else
                            ESX.ShowNotification("~r~Vous avez bougez, action annulé.")
                        end
                    else
                        ESX.ShowNotification("~r~Vous ne vous trouvez pas en Safe-Zone !")
                    end
                end
            })

            RageUI.Button("Zone d'investissement", nil, {RightLabel = "→→→"}, not tpcooldown, {
                onSelected = function()
                    if exports.Freetz Commu:GetSafeZone() then
                        tpcooldown = true

                        local coords = GetEntityCoords(PlayerPedId())
                        ESX.ShowNotification("~r~Ne bougez pas.")
                        ESX.ShowNotification("~r~3")
                        Wait(1000)
                        if GetEntityCoords(PlayerPedId()) == coords then 
                            ESX.ShowNotification("~o~2")
                            Wait(1000)
                            if GetEntityCoords(PlayerPedId()) == coords then 
                                ESX.ShowNotification("~g~1")
                                Wait(1000)
                                if GetEntityCoords(PlayerPedId()) == coords then 
                                    SetEntityCoords(PlayerPedId(), 246.8358, -383.0282, 44.5912) 
                                    ESX.ShowNotification("Vous avez était ~g~téléporter~s~ en zone d'investissement !")                   
                                    Citizen.SetTimeout(360000, function() tpcooldown = false end)
                                else
                                    ESX.ShowNotification("~r~Vous avez bougez, action annulé.")
                                end
                            else
                                ESX.ShowNotification("~r~Vous avez bougez, action annulé.")
                            end
                        else
                            ESX.ShowNotification("~r~Vous avez bougez, action annulé.")
                        end
                    else
                        ESX.ShowNotification("~r~Vous ne vous trouvez pas en Safe-Zone !")
                    end
                end
            })
        end, function()
        end)

        RageUI.IsVisible(parammenu, function()

            RageUI.Separator("↓ ~g~Rockstar Editor~s~ ↓")

            RageUI.Button("> ~g~Lancer~s~ un enregistrement", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    ExecuteCommand("stream")
                end
            })

            RageUI.Button("> ~r~Stopper~s~ un enregistrement", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    ExecuteCommand("stream")
                end
            })

            RageUI.Button("> Ouvrir Rockstar Editor", "Cette action vous déconnecteras du serveur !!", {RightLabel = "→→→"}, true, {
                onSelected = function()
                    NetworkSessionLeaveSinglePlayer()
                    ActivateRockstarEditor()
                end
            })

            RageUI.Checkbox('> Debug (~r~Si vous passez sous la map~s~)', nil, true, {}, {

                onChecked = function()
                    SetFocusEntity(GetPlayerPed(-1))
                end,
                onUnChecked = function()
                    SetFocusEntity(GetPlayerPed(-1))
                end,                    

            })

            --RageUI.Button("> ~g~Activer~s~/~r~Désactiver~s~ l\'Anti Car-Kill !", {RightLabel = "→→→"}, true {
            --    onSelected = function()
            --        ExecuteCommand('carkill')
            --    end
            --})


        end, function()
        end)

        RageUI.IsVisible(entreprisemenu, function()

            RageUI.Button("Taxi - ".. statustaxi, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(910.3391, -176.7213)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Vigneron - ".. statusvigneron, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-1911.2552, 2040.4266)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("L.S.P.D - ".. statuspolice, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(656.4426, -17.3958)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Tabac - ".. statustabac, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    ESX.ShowNotification("~r~Cette entreprise n\'est pour le moment pas disponible sur le serveur !")
                end
            })

            RageUI.Button("B.C.S.O - ".. statusbcso, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(1847.9834, 3666.1628)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Shériff - ".. statussheriff, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-438.1752, 6027.5063)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Unicorn - ".. statusunicorn, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(129.8508, -1300.6324)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Weazel News - ".. statusweazelnews, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-604.1379, -932.7489)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Concessionnaire Voiture - ".. statusvoiture, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-910.4163, -2043.6245)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Concessionnaire Bateau - ".. statusbateau, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-816.3124, -1345.6335)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Concessionnaire Avion - ".. statusavion, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-943.2192, -2957.4263)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Benny\'s - ".. statusbennys, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-247.6844, -1328.6332)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("LS Custom - ".. statuslscustom, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-359.1089, -133.5955)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("E.M.S - ".. statusems, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-667.8240, 310.4682)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Burger Shot - ".. statusburgershot, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-1179.1025, -884.1266)
                    SetNewWaypoint(coords)
                end
            })

            RageUI.Button("Agence Immobilière - ".. statusagenceimmo, nil, {RightLabel = "~b~→→→"}, true, {
                onSelected = function()
                    local coords = vector2(-927.7307, -458.3013)
                    SetNewWaypoint(coords)
                end
            })

        end, function()
        end)

        RageUI.IsVisible(fpsmenu, function()

            RageUI.Separator('___________________')

            RageUI.Button("> Optimisation légère", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    CascadeShadowsClearShadowSampleType()
                    CascadeShadowsSetAircraftMode(false)
                    CascadeShadowsEnableEntityTracker(true)
                    CascadeShadowsSetDynamicDepthMode(false)
                    CascadeShadowsSetEntityTrackerScale(5.0)
                    CascadeShadowsSetDynamicDepthValue(3.0)
                    CascadeShadowsSetCascadeBoundsScale(3.0)
              
                    SetFlashLightFadeDistance(3.0)
                    SetLightsCutoffDistanceTweak(3.0)
                    DistantCopCarSirens(false)
                    SetArtificialLightsState(false)
                end
            })
            
            RageUI.Button("> Optimisation médium", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    CascadeShadowsClearShadowSampleType()
                    CascadeShadowsSetAircraftMode(false)
                    CascadeShadowsEnableEntityTracker(true)
                    CascadeShadowsSetDynamicDepthMode(false)
                    CascadeShadowsSetEntityTrackerScale(0.0)
                    CascadeShadowsSetDynamicDepthValue(0.0)
                    CascadeShadowsSetCascadeBoundsScale(0.0)
              
                    SetFlashLightFadeDistance(2.0)
                    SetLightsCutoffDistanceTweak(0.0)
                    DistantCopCarSirens(false)
                    SetArtificialLightsState(false)
                end
            })

            RageUI.Button("> Grosse Optimisation", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    SetTimecycleModifier('tunnel')
                    RopeDrawShadowEnabled(false)
            
                    CascadeShadowsClearShadowSampleType()
                    CascadeShadowsSetAircraftMode(false)
                    CascadeShadowsEnableEntityTracker(true)
                    CascadeShadowsSetDynamicDepthMode(false)
                    CascadeShadowsSetEntityTrackerScale(0.0)
                    CascadeShadowsSetDynamicDepthValue(0.0)
                    CascadeShadowsSetCascadeBoundsScale(0.0)
              
                    SetFlashLightFadeDistance(5.0)
                    SetLightsCutoffDistanceTweak(5.0)
                    DistantCopCarSirens(false)
                end
            })

            RageUI.Separator('___________________')
            RageUI.Separator('~r~Action Irréversible !!~s~')
        end, function()
        end)

        RageUI.IsVisible(adminmenu, function()

            RageUI.Button("> Afficher les coordonnés", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    ESX.ShowNotification("Ta cru quoi?")
                end
            })

            RageUI.Button("> Réparer le véhicule", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    local plyPed = PlayerPedId()
                    local plyVeh = GetVehiclePedIsIn(plyPed, false)
                    SetVehicleFixed(plyVeh)
                    SetVehicleDirtLevel(plyVeh, 0.0)
                end
            })

            --[[RageUI.Button("> Mode Invisible", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    local plyPed = PlayerPedId()
                    if invisible then
                        invisible = true
                        SetEntityVisible(plyPed, false, 0)
                        ESX.ShowNotification("Mode fantome ~g~on~s~ !")
                    else
                        invisible = false
                        SetEntityVisible(plyPed, true, 0)
                        ESX.ShowNotification("Mode fantome ~r~off~s~ !")
                    end
                end
            })--]]

            RageUI.Checkbox('Mode Invisible', nil, invisiblemode, {}, {
                onChecked = function()
                    local plyPed = PlayerPedId()
                    invisiblemode = true
                    SetEntityVisible(plyPed, true, 0)
                    ESX.ShowNotification("Mode fantome ~g~on~s~ !")
                end,
                onUnChecked = function()
                    local plyPed = PlayerPedId()
                    invisiblemode = false
                    SetEntityVisible(plyPed, false, 0)
                    ESX.ShowNotification("Mode fantome ~r~off~s~ !")
                end,
            })

            RageUI.Checkbox('Mode Invincible', nil, gmode, {}, {
                onChecked = function()
                    local plyPed = PlayerPedId()
                    gmode = true
                    SetEntityInvincible(plyPed, true)
                    ESX.ShowNotification("Godmode ~g~on~s~ !")
                end,
                onUnChecked = function()
                    local plyPed = PlayerPedId()
                    gmode = false
                    SetEntityInvincible(plyPed, false)
                    ESX.ShowNotification("Godmode ~r~off~s~ !")
                end,
            })
        
        end, function()
        end)
        
        RageUI.IsVisible(gestionjob, function()
        
            if ESX.PlayerData.job.grade_name == "boss" then 

                if societymoney ~= nil then
                    RageUI.Separator("Argent dans la société : ~g~"..societymoney.."$")
                end

                RageUI.Separator("[Entreprise]")

                RageUI.Button("Recruter un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_recruterplayer", GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name)
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })

                RageUI.Button("Virer un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_virerplayer", GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })

                RageUI.Button("Promouvroir un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_promouvoirplayer", GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })

                RageUI.Button("Rétrograder un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_destituerplayer", GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })
            end
        end, function()
        end)


        RageUI.IsVisible(gestionjob2, function()

            if ESX.PlayerData.job2.grade_name == "boss" then 

                RageUI.Separator("~r~Aucune Coffre~s~")
                --if societymoney2 ~= nil then
                  --  RageUI.Separator("Argent dans le coffre~s~ : ~g~"..societymoney2.."$")
                --end

                RageUI.Separator("[Organisation]")

                RageUI.Button("Recruter un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_recruterplayer2", GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name)
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })

                RageUI.Button("Virer un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_virerplayer2", GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })

                RageUI.Button("Promouvroir un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_promouvoirplayer2", GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })

                RageUI.Button("Rétrograder un employé", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end, 
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            TriggerServerEvent("FreetZ-PersonalMenu:Boss_destituerplayer2", GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Aucun joueur à proximité")
                        end
                    end
                })
            end

        end, function()
        end)

        RageUI.IsVisible(actioninventory, function()

            RageUI.Separator("Nom : ~g~"..tostring(label).." ~s~/ Quantité : ~g~"..tostring(count).."")

            RageUI.Button("> Utiliser", nil, {RightLabel = "→→→"}, not itemCooldown, {
                onSelected = function()
                    itemCooldown = true
                    typee = "use"
                    TriggerServerEvent('esx:useItem', name)
                    ExecuteCommand("me utilise x1 "..label)
                    count = count - 1
                    RageUI.CloseAll()
                    if count < 0 then 
                        RageUI.GoBack()
                    end
                    Citizen.SetTimeout(3000, function() itemCooldown = false end)
                end
            })

            RageUI.Button("> Donner", nil, {RightLabel = "→→→"}, not itemCooldown, {
                onActive = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        PlayerMakrer(closestPlayer)
                    end
                end,
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    local check, quantity = CheckQuantity(KeyboardInput5("", "Indiquer le nombre à donner", "", 20))
                    if check then 
                        local closestPed = GetPlayerPed(closestPlayer)
                        if tonumber(quantity) > tonumber(count) then 
                            ESX.ShowNotification('Vous n\'en n\'avez pas asser')
                            RageUI.GoBack()
                        else
                            if name == 'idcard' or name == 'bankcard' or name == 'ppa' then
                                ESX.ShowNotification("~r~Vous ne pouvez pas donner cette objet !")
                            else
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    itemCooldown = true
                                    TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', name, quantity)
                                    ExecuteCommand("me donne un/une "..label.." à la personne")
                                    RageUI.CloseAll()
                                    Citizen.SetTimeout(3000, function() itemCooldown = false end)
                                else
                                    ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                end
                            end
                        end
                    else
                        ESX.ShowNotification('Arguments Manquants !')
                    end
                end
            })
            
        end , function()
        end)

        RageUI.IsVisible(actionweapon, function()
            RageUI.Separator("Nom : ~g~"..tostring(label).." ~s~/ Balles : ~g~"..tostring(ammoo).."")

    --        if PermanantWeapon[name] ~= nil then 
  --              RageUI.Separator("Vous ne pouvez pas donner cette arme")
--
        --    else
                RageUI.Button("> Donner", nil, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            PlayerMakrer(closestPlayer)
                        end
                    end,
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            local closestPed = GetPlayerPed(closestPlayer)
                            TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_weapon", name, nil)
                            RageUI.CloseAll()
                        else
                            ESX.ShowNotification("Personne aux alentours")
                        end
                    end
                })
        --    end

        end, function()
        end)

        RageUI.IsVisible(infojob, function()
            ESX.PlayerData = ESX.GetPlayerData()
            
            RageUI.Button("Votre Métier: ", nil, {RightLabel = "~g~"..ESX.PlayerData.job.label}, true, {})
            RageUI.Button("Votre Grade: ", nil, {RightLabel = "~g~"..ESX.PlayerData.job.grade_label}, true, {})

        end, function()
        end)


        RageUI.IsVisible(infojob2, function()
            
            RageUI.Button("Votre Organisation: ", nil, {RightLabel = "~g~"..ESX.PlayerData.job2.label}, true, {})
            RageUI.Button("Votre Rang: ", nil, {RightLabel = "~g~"..ESX.PlayerData.job2.grade_label}, true, {})

            
        end, function()
        end)

        RageUI.IsVisible(billingmenu, function()
            if #BillData ~= 0 then
                for i = 1, #BillData, 1 do
                    RageUI.Button(BillData[i].label, nil, {RightLabel = '$' .. ESX.Math.GroupDigits(BillData[i].amount)}, true, {
                        onSelected = function()
                        ESX.TriggerServerCallback('esx_billing:payBill', function()
                            RageUI.GoBack()
                        end, BillData[i].id)
                    end})
                end
            else
                RageUI.Separator('~r~')
                RageUI.Separator('~r~Vous n\'avez pas de facture')
                RageUI.Separator('~r~')
            end
        end, function()
        end)
        
        RageUI.IsVisible(gestionlicense, function()

            RageUI.Separator("~g~↓ Carte D'identité ↓")
            
            RageUI.Button("> Montrer sa carte d'identité", nil, {RightLabel = '→→→'}, IDCARD, {
                onActive = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        PlayerMakrer(closestPlayer)
                    end
                end,
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                        ExecuteCommand("e idcarde")
                    else
                        ESX.ShowNotification("Aucun joueurs aux alentours")
                    end
                end
            })

            RageUI.Button("> Regarder sa carte d'identité", nil, {RightLabel = "→→→"}, IDCARD, {
                onSelected = function()
                    TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                end
            })

            RageUI.Separator("~g~↓ Permis de conduire ↓")

            RageUI.Button("> Montrer son permis de conduire", nil, {RightLabel = '→→→'}, PERMISC, {
                onActive = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        PlayerMakrer(closestPlayer)
                    end
                end,
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), "driver")
                        ExecuteCommand('e idcardi')
                    else
                        ESX.ShowNotification("Aucun joueurs aux alentours")
                    end
                end
            })

            RageUI.Button("> Regarder son permis de conduire", nil, {RightLabel = "→→→"}, PERMISC, {
                onSelected = function()
                    TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), "driver")
                end
            })

            RageUI.Separator("~g~↓ Permis de port d'armes ↓")

            RageUI.Button("> Montrer son permis de port d'armes", nil, {RightLabel = '→→→'}, PERMISA, {
                onActive = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        PlayerMakrer(closestPlayer)
                    end
                end,
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), "weapon")
                    else
                        ESX.ShowNotification("Aucun joueurs aux alentours")
                    end
                end
            })

            RageUI.Button("> Regarder son permis de port d'armes", nil, {RightLabel = "→→→"}, PERMISA, {
                onSelected = function()
                    TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), "weapon")
                end
            })
        
        end, function()
        end)
        if not RageUI.Visible(mainf5) and 
        not RageUI.Visible(invetory) and 
        not RageUI.Visible(portefeuille) and 
        not RageUI.Visible(vetmenu) and 
        not RageUI.Visible(vehicle) and
        not RageUI.Visible(radio) and
        not RageUI.Visible(pubs) and 
        not RageUI.Visible(graphicmenu) and
        not RageUI.Visible(pass) and
        not RageUI.Visible(diversmenu) and
        not RageUI.Visible(tpmenu) and
        not RageUI.Visible(parammenu) and
        not RageUI.Visible(fpsmenu) and
        not RageUI.Visible(adminmenu) and

        not RageUI.Visible(actioninventory) and 
        not RageUI.Visible(infojob) and 
        not RageUI.Visible(infojob2) and 
        not RageUI.Visible(gestionjob) and
        not RageUI.Visible(gestionjob2) and 
        not RageUI.Visible(entreprisemenu) and
        not RageUI.Visible(billingmenu) and 

        not RageUI.Visible(actionweapon) and 
        not RageUI.Visible(gestionlicense) then 
            mainf5 = RMenu:DeleteType("mainf5")
        end
    end
end

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

RegisterKeyMapping("f5", "Menu F5", "keyboard", "F5")
RegisterCommand("f5", function(source)
	if not isDead then
        TriggerEvent('freetz:fetch:info')
		openMenuF5()
    else
        ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir ce menu dans le coma !")
	end
end)

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

local reason = nil
local NoCourir = false
local cash = 0
Citizen.CreateThread(function()
    while true do 
        Wait(5000)
        TriggerEvent("skinchanger:getSkin", function(skin)
            if skin.bags_1 == 0 then
                if ESX.PlayerData.maxWeight ~= 40 then 
                    TriggerServerEvent('ewen:ChangeWeightInventory', 40)
                end
            else
                if exports['Freetz-Core']:GetVIP() then
                    if ESX.PlayerData.maxWeight ~= 200 then 
                        TriggerServerEvent('ewen:ChangeWeightInventory', 200)
                    end
                else
                    if ESX.PlayerData.maxWeight ~= 128 then 
                        TriggerServerEvent('ewen:ChangeWeightInventory', 128)
                    end
                end
            end
        end)
        if GetCurrentWeight() > ESX.PlayerData.maxWeight then
            reason = 'POIDS'
            NoCourir = true
        else 
            NoCourir = false
        end

        ESX.TriggerServerCallback('freetz:getcash', function(cb)
            cash = cb
        end, i)

        if cash >= 500000 then 
            reason = 'CASH'
            NoCourir = true
        else 
            NoCourir = false
        end

        if reason == 'POIDS' then
            DrawMissionText('~g~Vous êtes trop lourd, Vous ne pouver plus courir', 5000)
        elseif reason == 'CASH' then 
            DrawMissionText('~o~Vous avez trop de billets en poche, Vous ne pouver plus courir', 5000)
        elseif reason == 'WEAPON' then
            DrawMissionText('~r~Vous avez trop d\'armes, Vous ne pouver plus courir', 5000)
        end
        
        Citizen.CreateThread(function()
            while NoCourir do
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 61, true)
                DisableControlAction(0, 131, true)
                DisableControlAction(0, 155, true)
                DisableControlAction(0, 209, true)
                DisableControlAction(0, 254, true)
                DisableControlAction(0, 311, true)
                DisableControlAction(0, 340, true)
                DisableControlAction(0, 352, true)
                DisableControlAction(0, 21, true) -- INPUT_SPRINT
                DisableControlAction(0, 22, true) -- INPUT_JUMP
                DisableControlAction(0, 24, true) -- INPUT_ATTACK
                DisableControlAction(0, 44, true) -- INPUT_COVER
                DisableControlAction(0, 45, true) -- INPUT_RELOAD
                DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
                DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
                DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
                DisableControlAction(0, 143, true) -- INPUT_MELEE_BLOCK
                DisableControlAction(0, 144, true) -- PARACHUTE DEPLOY
                DisableControlAction(0, 145, true) -- PARACHUTE DETACH
                DisableControlAction(0, 243, true) -- INPUT_ENTER_CHEAT_CODE
                DisableControlAction(0, 257, true) -- INPUT_ATTACK2
                DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
                DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
                DisableControlAction(0, 73, true) -- INPUT_X
                Wait(1)
            end
        end)
    end
end)

RegisterKeyMapping("e handsup", "Levez les mains", "keyboard", "O")

CreateThread(function()
    while true do 
        ExecuteCommand('refreshhh') -- Refresh liste des entreprises
        Wait(800000)
    end 
end)

RegisterCommand('refreshhh', function()
    ESX.TriggerServerCallback('freetz:status:taxi', function(cb)
        cbTaxi = cb
    end, i)

    if cbTaxi == true then
        statustaxi = "[~g~OUVERT~s~]"
    elseif cbTaxi == false then
        statustaxi = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:vigneron', function(cb)
        cbVigne = cb
    end, i)

    if cbVigne == true then
        statusvigneron = "[~g~OUVERT~s~]"
    elseif cbVigne == false then
        statusvigneron = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:police', function(cb)
        cbPolice = cb
    end, i)

    if cbPolice == true then
        statuspolice = "[~g~OUVERT~s~]"
    elseif cbPolice == false then
        statuspolice = "[~r~FERMÉ~s~]"
    end

--[[Wait(1000)
    ESX.TriggerServerCallback('freetz:status:tabac', function(cb)
        cbTabac = cb
    end, i)

    if cbTabac == true then
        statustabac = "[~g~OUVERT~s~]"
    elseif cbTabac == false then
        statustabac = "[~r~FERMÉ~s~]"
    end ]]

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:bcso', function(cb)
        cbBcso = cb
    end, i)

    if cbBcso == true then
        statusbcso = "[~g~OUVERT~s~]"
    elseif cbBcso == false then
        statusbcso = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:sheriff', function(cb)
        cbSheriff = cb
    end, i)

    if cbSheriff == true then
        statussheriff = "[~g~OUVERT~s~]"
    elseif cbBcso == false then
        statussheriff = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:unicorn', function(cb)
        cbUnicorn = cb
    end, i)

    if cbUnicorn == true then
        statusunicorn = "[~g~OUVERT~s~]"
    elseif cbUnicorn == false then
        statusunicorn = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:WeazelNews', function(cb)
        cbWeazel = cb
    end, i)

    if cbWeazel == true then
        statusweazelnews = "[~g~OUVERT~s~]"
    elseif cbWeazel == false then
        statusweazelnews = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:Bahamas', function(cb)
        cbBahamas = cb
    end, i)

    if cbBahamas == true then
        statusbahamas = "[~g~OUVERT~s~]"
    elseif cbBahamas == false then
        statusbahamas = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:ConcessVoiture', function(cb)
        cbVoiture = cb
    end, i)

    if cbVoiture == true then
        statusvoiture = "[~g~OUVERT~s~]"
    elseif cbVoiture == false then
        statusvoiture = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:ConcessBateau', function(cb)
        cbBateau = cb
    end, i)

    if cbBateau == true then
        statusbateau = "[~g~OUVERT~s~]"
    elseif cbBateau == false then
        statusbateau = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:ConcessAvion', function(cb)
        cbAvion = cb
    end, i)

    if cbAvion == true then
        statusavion = "[~g~OUVERT~s~]"
    elseif cbAvion == false then
        statusavion = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:Bennys', function(cb)
        cbBennys = cb
    end, i)

    if cbBennys == true then
        statusbennys = "[~g~OUVERT~s~]"
    elseif cbBennys == false then
        statusbennys = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:LsCustom', function(cb)
        cbCustom = cb
    end, i)

    if cbCustom == true then
        statuslscustom = "[~g~OUVERT~s~]"
    elseif cbCustom == false then
        statuslscustom = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:AutoTuners', function(cb)
        cbAutoTuners = cb
    end, i)

    if cbAutoTuners == true then
        statusautotuners = "[~g~OUVERT~s~]"
    elseif cbAutoTuners == false then
        statusautotuners = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:EMS', function(cb)
        cbEms = cb
    end, i)

    if cbEms == true then
        statusems = "[~g~OUVERT~s~]"
    elseif cbEms == false then
        statusems = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:BurgerShot', function(cb)
        cbBurger = cb
    end, i)

    if cbBurger == true then
        statusburgershot = "[~g~OUVERT~s~]"
    elseif cbBurger == false then
        statusburgershot = "[~r~FERMÉ~s~]"
    end

    Wait(1000)
    ESX.TriggerServerCallback('freetz:status:AgenceImmo', function(cb)
        cbAgenceImmo = cb
    end, i)

    if cbAgenceImmo == true then
        statusagenceimmo = "[~g~OUVERT~s~]"
    elseif cbAgenceImmo == false then
        statusagenceimmo = "[~r~FERMÉ~s~]"
    end
end)

RegisterNetEvent('freetz:fetch:info')
AddEventHandler('freetz:fetch:info', function()

    ESX.TriggerServerCallback('freetz:cartei', function(cb)
        IDCARD = cb
    end, i)

    ESX.TriggerServerCallback('freetz:permic', function(cb)
        PERMISC = cb
    end, i)

    ESX.TriggerServerCallback('freetz:permia', function(cb)
        PERMISA = cb
    end, i)
    
end)
