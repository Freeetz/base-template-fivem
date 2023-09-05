local status = 'open'
local LastStatus = nil
local firstPrint = true

Citizen.CreateThread(function()
    while true do

        if LastStatus == nil then
            LastStatus = status
        end

        if firstPrint or LastStatus ~= status then
            if status == 'open' then
                Wait(2000)
                print('^2Aucune maintenance^7 détecter sur le serveur !')
                Wait(15000)
            elseif status == 'maintenance' then
                Wait(2000)
                print('^3Maintenance en cours !')
                Wait(15000)
            end
            LastStatus = status
            firstPrint = false
        end

        Wait(0)
    end
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local _src = source
    local name = GetPlayerName(source)

    deferrals.defer()
    deferrals.update("Vérification du status du serveur.. (Veuillez patienter)")
    Wait(2500)
    if status == 'open' then
        deferrals.update("Vérification de "..name.." en cours...")
        Wait(3000)
        deferrals.update("Accès au serveur..")
        Wait(2000)
        deferrals.update("3️⃣")
        Wait(1000)
        deferrals.update("2️⃣")
        Wait(1000)
        deferrals.update("1️⃣")
        Wait(1000)
        deferrals.done()
    elseif status == 'maintenance' then
        deferrals.done('\nLe serveur est actuellement en maintenance !\nVous ne pouvez pas vous connectez pour le moment.')
    end
end)

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'mode' then
		if args[1] ~= nil then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

            if args[1] == 'ouvert' or args[1] == 'ferme' then 

                if args[1] == 'ouvert' then 
                    status = 'open'
                elseif args[1] == 'ferme' then 
                    status = 'maintenance'
                end

                RconPrint(tostring('Mode du serveur modifié !\n'))
            else
                RconPrint("Ceci n\'est pas un type valide !!\n")
                RconPrint("Liste des type : ^3ouvert^7 & ^3ferme^7")
                CancelEvent()
                return
			end
		else
			RconPrint("Utilisation : mode [TYPE]\n")
            RconPrint("Liste des type : ^3ouvert^7 & ^3ferme^7")
			CancelEvent()
			return
		end

		CancelEvent()
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(5000)
        print('^1<^7=============== ^4FREETZ BASE TEMPLATE^7 ===============^1>^7')
        print('')
        print('Version : ^21.0^7')
        print('Discord : ^4discord.gg/freetz^7')
        print('Développeur : ^6Freetz^7')
        print('')
        print('^3Merci d\' utiliser notre base, en cas de problème rejoignez le discord et utilisez les salons ^1AIDES^7 !')
        print('')
        print('^1<^7=============== ^4FREETZ BASE TEMPLATE^7 ===============^1>^7')
    end
end)