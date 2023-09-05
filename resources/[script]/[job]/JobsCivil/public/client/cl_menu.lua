aPublic = {}




local metier = {
    chantier = {
        nom = "Travailler au chantier",
        desc = "Viens travailler au chantier, avoir des muscles dans les bras est obligatoire ! Pas pour les feignants !",
        coords = zone.Chantier,
    },
    jardinier = {
        nom = "Nettoyer le golf",
        desc = "Viens aider les jardiniers du golf à faire leur travaille ! Travaille assez posé dans un environnement agréable, véhicule fourni sans diplôme demandé.",
        coords = zone.Jardinier,
    },
    Bucheron = {
        nom = "Travailler en tant que bucheron",
        desc = "Viens travailler dans la forêt ! Permis de conduire pour se rendre sur place demandé !",
        coords = zone.bucheron,
    },
    Mine = {
        nom = "Travailler en tant que mineur",
        desc = "Viens travailler dans la mine ! Aucun permis nécessaire !",
        coords = zone.mine,
    },
}

Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local dest = zone.Lifeinveders
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 3 then
            interval = 500
        else
            interval = 1
            if distance < 1.5 then  
                AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 51) then
                    aPublic.openLife()
                end
            end
        end
        Citizen.Wait(interval)
    end
end)



aPublic.openLife = function()
    Public = RageUI.CreateMenu("Marina", "Marina")
    RageUI.Visible(Public, not RageUI.Visible(Public))
    Public.Closed = function()
        RenderScriptCams(0, 1, 1500, 1, 1)
        DestroyCam(cam, 1)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while Public do 
        Wait(1)
        RageUI.IsVisible(Public, function()
            RageUI.Separator("↓ Emplois libre ↓")
            for _,v in pairs(metier) do
                RageUI.Button(v.nom, v.desc, {}, true, {
                    onSelected = function()
                        SetNewWaypoint(v.coords)
                        RageUI.CloseAll()
                        RenderScriptCams(0, 1, 1500, 1, 1)
                        DestroyCam(cam, 1)
                        ESX.ShowNotification("Vous avez choisis de ~b~"..v.nom.."~s~ ? Très bien, je vous ai donné les coordonées GPS sur votre téléphone. ~g~Merci d'utiliser les services LifeInvaders !")
                    end,
                })
            end
            RageUI.Separator("___________")
            RageUI.Button("Fermer le menu", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    RageUI.CloseAll()
                end
            }, main)
        end)

        if not RageUI.Visible(Public) then
            Public = RMenu:DeleteType("Public", true)
        end 
    end
end

