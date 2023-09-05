-- Le menu as était supprimer, car un jobs police seras mis en vente, je vous laisse en faire un vous meme en RageUI, je vous ai fait une petite base : 
-- Il n'y as dans cette base aucun sous menu, uniquement le menu principal afin de vous faire une idée de ceux à quoi cela ressemble et comment vous pouvez améliorer le menu.

local police_menu = false
local menu_police = RageUI.CreateMenu("Police", "Intéractions disponible")
local menu_police_citoyens = RageUI.CreateSubMenu(menu_police, "Police", "Intéractions citoyens : ")
local menu_police_citoyens_fouiller = RageUI.CreateSubMenu(menu_police_citoyens, "Police", "Inventaire : ")
local menu_police_vehicule = RageUI.CreateSubMenu(menu_police, "Police", "Intéractions véhicules : ")
local menu_police_annonce = RageUI.CreateSubMenu(menu_police, "Police", "Intéractions annonce : ")
local menu_police_renfort = RageUI.CreateSubMenu(menu_police, "Police", "Intéractions renfort : ")
local menu_police_hautgrade = RageUI.CreateSubMenu(menu_police, "Police", "Intéractions divers : ")
local menu_police_chien = RageUI.CreateSubMenu(menu_police, "Police", "Intéractions chien : ")
menu_police.Closed = function()
    police_menu = false
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function PoliceMenu()
    if police_menu then 
        police_menu = false 
        RageUI.Visible(menu_police, false)
        return
    else
        police_menu = true 
        RageUI.Visible(menu_police, true)

        Citizen.CreateThread(function()
            while police_menu do 
                Citizen.Wait(1)

                RageUI.IsVisible(menu_police, function()

					RageUI.Line()
					RageUI.Separator("Bienvenue ~b~".. GetPlayerName(PlayerId()) .."~s~ !")
                    RageUI.Button('Intéraction Citoyens', nil, {RightLabel = "→→→"}, true, {
                    }, menu_police_citoyens)   
					RageUI.Button('Intéraction Véhicules', nil, {RightLabel = "→→→"}, true, {
                    }, menu_police_vehicule)   
					RageUI.Button('Gestion des Annonces', nil, {RightLabel = "→→→"}, true, {
                    }, menu_police_annonce)   
					RageUI.Button('Demande de Renfort', nil, {RightLabel = "→→→"}, true, {
                    }, menu_police_renfort)
					RageUI.Button('Gestion Chien', nil, {RightLabel = "→→→"}, true, {
					}, menu_police_chien)
					if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'intendent' then
						RageUI.Button('Gestion Divers', nil, {RightLabel = "→→→"}, true, {
						}, menu_police_hautgrade)
					else
						RageUI.Button('Gestion Divers', nil, {RightLabel = "→→→"}, false, {
						}, menu_police_hautgrade)
					end
					RageUI.Line()

				end)
			end
        end)
    end
end