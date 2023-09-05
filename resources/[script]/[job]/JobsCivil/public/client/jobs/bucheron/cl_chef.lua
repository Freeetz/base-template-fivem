aBucheron = {}



BossZone = {
    bucheron = vector3(-570.853, 5367.214, 69.21643),
}


Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local dest = BossZone.bucheron
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 3 then
            interval = 200
        else
            interval = 1
            if distance < 1.5 then  
                AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 51) then
                    aBucheron.Boss()
                end
            end
        end
        Citizen.Wait(interval)
    end
end)

aBucheron.Boss = function()
    Boss = RageUI.CreateMenu("Manager des bucherons", "Manager des bucherons")
    Boss.Closed = function()
        RenderScriptCams(0, 1, 1500, 1, 1)
        DestroyCam(cam, 1)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    RageUI.Visible(Boss, not RageUI.Visible(Boss))
    while Boss do
        Wait(1) 
        RageUI.IsVisible(Boss, function()
            if not AuTravaillebucheron then 
                RageUI.Button("~b~→→~s~ Demander à travailler pour les bucherons", nil, {}, true, {
                    onSelected = function()
                        ESX.ShowNotification("Alors comme ça tu veux bosser pour les ~g~bucherons~s~ hein ? Très bien, met un casque et prends t'es outils ! Je te préviens c'est pas pour les petite merdes !")
                        RageUI.CloseAll()
                        RenderScriptCams(0, 1, 1500, 1, 1)
                        DestroyCam(cam, 1)
                        AuTravaillebucheron = true

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
                                StartTravaillebucheron()
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
                                StartTravaillebucheron()
                            end)
                        else
                            print("[WARNING] - Erreur, impossible de détecter le sexe de votre personnage ! (Veuillez contactez Freetz#9999)")
                        end
                    end,
                })
            else 
                RageUI.Button("Arrêter de travailler", nil, {}, true, {
                    onSelected = function()
                        ESX.ShowNotification("haha ! Tu stop déja ! Allez prends ta paye feignant ! Merci de ton aide, revient quand tu veux.")
                        RageUI.Visible(RMenu:Get('bucheron', 'main'), not RageUI.Visible(RMenu:Get('bucheron', 'main')))
                        RenderScriptCams(0, 1, 1500, 1, 1)
                        DestroyCam(cam, 1)
                        AuTravaillebucheron = false
                        endwork()
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




