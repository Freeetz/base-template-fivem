RMenu.Add('Jardinier', 'main', RageUI.CreateMenu("Jardinier", " "))
RMenu:Get('Jardinier', 'main'):SetSubtitle("~b~Manageur du Golf")
RMenu:Get('Jardinier', 'main').EnableMouse = false;
RMenu:Get('Jardinier', 'main').Closed = function()
    RenderScriptCams(0, 1, 1500, 1, 1)
    DestroyCam(cam, 1)
    SetBlockingOfNonTemporaryEvents(Ped, 1)
end

local vehicle = nil
local ZoneDeSpawn = vector3(-1336.572, 118.7055, 56.51094)

aGolf = {}


Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local dest = zone.Jardinier
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 3 then
            interval = 200
        else
            interval = 1
            if distance < 1.5 then  
                AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 51) then
                    aGolf.Boss()
                end
            end
        end
        Citizen.Wait(interval)
    end
end)

aGolf.Boss = function()
    Boss = RageUI.CreateMenu("Manageur du Golf", "Manageur du Golf")
    Boss.Closed = function()
        RenderScriptCams(0, 1, 1500, 1, 1)
        DestroyCam(cam, 1)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    RageUI.Visible(Boss, not RageUI.Visible(Boss))
    while Boss do
        Wait(1) 
        RageUI.IsVisible(Boss, function()
            if not AuTravailleJardinier then
                RageUI.Button("Demander à travailler sur le golf", nil, {}, true, {
                    onSelected = function()
                        ESX.ShowNotification("Alors comme ça tu veux bosser sur le ~g~Golf~s~ hein ? Très bien, changes-toi !")
                        RageUI.CloseAll()
                        RenderScriptCams(0, 1, 1500, 1, 1)
                        DestroyCam(cam, 1)
                        AuTravailleJardinier = true

                        local ped = PlayerPedId()
                        local Male = GetHashKey("mp_m_freemode_01")
                        local Female = GetHashKey("mp_f_freemode_01")
                        local CurrentModel = GetEntityModel(ped)

                        if CurrentModel == Male then
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                local clothesSkin = {
                                    ['bags_1'] = 0, ['bags_2'] = 0,
                                    ['tshirt_1'] = 76, ['tshirt_2'] = 0,
                                    ['torso_1'] = 186, ['torso_2'] = 0,
                                    ['arms'] = 73,
                                    ['pants_1'] = 117, ['pants_2'] = 0,
                                    ['shoes_1'] = 89, ['shoes_2'] = 0,
                                    ['mask_1'] = 0, ['mask_2'] = 0,
                                    ['bproof_1'] = 0, ['bproof_2'] = 0,
                                    ['helmet_1'] = 0, ['helmet_2'] = 0,
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                local spawnRandom = vector3(ZoneDeSpawn.x+math.random(1,15), ZoneDeSpawn.y+math.random(1,15), ZoneDeSpawn.z)
                                ESX.Game.SpawnVehicle(1783355638, spawnRandom, 274.95318603516, function(veh)
                                    vehicle = NetworkGetNetworkIdFromEntity(veh)
                                    local blip = AddBlipForEntity(veh)
                                    SetBlipSprite(blip, 559)
                                    SetBlipFlashes(blip, true)
                                end)
                                StartTravailleJardinier()
                            end)
                        elseif CurrentModel == Female then 
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                local clothesSkin = {
                                    ['bags_1'] = 0, ['bags_2'] = 0,
                                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                                    ['torso_1'] = 180, ['torso_2'] = 0,
                                    ['arms'] = 17,
                                    ['pants_1'] = 97, ['pants_2'] = 0,
                                    ['shoes_1'] = 40, ['shoes_2'] = 0,
                                    ['mask_1'] = 0, ['mask_2'] = 0,
                                    ['bproof_1'] = 0, ['bproof_2'] = 0,
                                    ['helmet_1'] = 1, ['helmet_2'] = 0,
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                local spawnRandom = vector3(ZoneDeSpawn.x+math.random(1,15), ZoneDeSpawn.y+math.random(1,15), ZoneDeSpawn.z)
                                ESX.Game.SpawnVehicle(1783355638, spawnRandom, 274.95318603516, function(veh)
                                    vehicle = NetworkGetNetworkIdFromEntity(veh)
                                    local blip = AddBlipForEntity(veh)
                                    SetBlipSprite(blip, 559)
                                    SetBlipFlashes(blip, true)
                                end)
                                StartTravailleJardinier()
                            end)
                        else
                            print("[WARNING] - Erreur, impossible de détecter le sexe de votre personnage ! (Veuillez contactez Freetz#9999)")
                        end
                    end,
                })
            else 
                RageUI.Button("Arreter de travailler", nil, {}, true, {
                    onSelected = function()
                        ESX.ShowNotification("Ahah ! Tu t'arrêtes déjà ! Allez prend ton argent ! Merci de ton aide, revient quand tu veux.")
                        RageUI.CloseAll()
                        RenderScriptCams(0, 1, 1500, 1, 1)
                        DestroyCam(cam, 1)
                        AuTravailleJardinier = false
                        ESX.Game.DeleteVehicle(NetworkGetEntityFromNetworkId(vehicle))
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            local isMale = skin.sex == 0
                            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                    TriggerEvent('esx:restoreLoadout')
                                end)
                            end)
                        end)
                    end,
                })
            end
        end)
        if not RageUI.Visible(Boss) then
            Boss = RMenu:DeleteType("Boss", true)
        end 
    end
end