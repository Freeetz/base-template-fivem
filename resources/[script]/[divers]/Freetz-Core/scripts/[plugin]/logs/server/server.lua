ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- LOGS CONSOLE
AddEventHandler('playerConnecting', function(t,t2,t3)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    local name = GetPlayerName(source)
    local playerIp = GetPlayerEndpoint(source)
    local playerPing = GetPlayerPing(source)

    print('Le joueur ^2'.. name ..'^0 vien de se connecter !') -- Print console
end)

AddEventHandler('playerDropped', function(reason)
    local source = source 
    local name = GetPlayerName(source)
    local raison = reason 

    if raison == 'Exiting' then 
        raison = 'Alt F4 / F8 Quit'
    end 
    
    print('Le joueur ^2'.. name ..'^0 vien de se déconnecter (Raison : ^1'.. raison ..' ^0)')
end)

AddEventHandler('playerDropped', function(reason)
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        if xPlayer.job.name == "police" or xPlayer.job.name == "fbi" or xPlayer.job.name == "vinewood" or xPlayer.job.name == "bcso" then
            --print('non')
        else
            xPlayer.removeWeapon('WEAPON_NIGHTSTICK')
            xPlayer.removeWeapon('WEAPON_FLASHLIGHT')
            xPlayer.removeWeapon('WEAPON_STUNGUN')
            xPlayer.removeWeapon('WEAPON_COMBATPISTOL')
            xPlayer.removeWeapon('WEAPON_ADVANCEDRIFLE')
            xPlayer.removeWeapon('WEAPON_PUMPSHOTGUN')
            xPlayer.removeWeapon('WEAPON_CARBINERIFLE')
            xPlayer.removeWeapon('WEAPON_TACTICALRIFLE')
        end
    end
end)

-- FIN LOGS CONSOLE

AddEventHandler('playerConnecting', function(t,t2,t3)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    local name = GetPlayerName(source)
    local playerIp = GetPlayerEndpoint(source)
    local playerPing = GetPlayerPing(source)

    PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Connexion**__",description="\nPseudo : "..name.. "\nIdentifiant : ``"..identifier.. "``",color=16711680}}}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function(reason)
    local lPlayer = ESX.GetPlayerFromId(source)

    if lPlayer then
        local identifier = lPlayer.identifier
        local name = GetPlayerName(source)
        local playerIp = GetPlayerEndpoint(source)
        local playerPing = GetPlayerPing(source)

        PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Déconnexion**__",description="\nPseudo : "..name.. " - `ID : ["..source.."]`\nIdentifiant : ``"..identifier.. "``\nRaison: "..reason.."",color=16711680}}}), { ['Content-Type'] = 'application/json' })
    else
        --print('^7 Un joueur c\'est déconnecté dans le loading screen !')
    end
end)

AddEventHandler('chatMessage', function(source, name, message)
    if message == '/revive' then
    elseif message == '/-staffmenu' then
    elseif message == '/-noclip-admin' then
    elseif message == '/dv' then
    elseif message == '/radio' then
    elseif message == '/menuf6police' then
    elseif message == '/menuf6ambulance' then
    elseif message == '/menuf6taxi' then
    else
    PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Chats**__",description="\nPseudo : "..name.. "`["..source.."]`\nMessage: "..message.."",color=16711680}}}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('freetz:aimlogs')
AddEventHandler('freetz:aimlogs', function(pedId)
    local name,id = GetPlayerName(source), ESX.GetPlayerFromId(source)
    local tname,tid = GetPlayerName(pedId), ESX.GetPlayerFromId(pedId)

    PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Tirs**__",description="\nJoueur : "..name.. " - `[ID : "..id.source.."]`\nà tiré sur : **"..tname.."** - `[ ID : "..tid.source.."]`",color=16711680}}}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('freetz:killlogs')
AddEventHandler('freetz:killlogs', function(message, weapon)
    local time = os.date('*t')
    local hour = time.hour

    if weapon == nil then
        PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Mort**__",description="\n"..message.. "\nArme utilisé : ***Arme Inconnu***\n\nHoraire : "..hour..":"..time.min,color=16711680}}}), { ['Content-Type'] = 'application/json' })
    else
        PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Mort**__",description="\n"..message.. "\nArme utilisé : ***"..weapon.."***\n\nHoraire : "..hour..":"..time.min,color=16711680}}}), { ['Content-Type'] = 'application/json' })
    end
end)

AddEventHandler('onResourceStart', function()
    PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Débug**__",description="\n***__Liaison Discord <-> FREETZ BASE TEMPLATE établie !__***",color=16711680}}}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('onResourceStop', function()
    PerformHttpRequest('https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF', function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Logs - Débug**__",description="\n***__|| La ressource à était stopé ! ||__***",color=16711680}}}), { ['Content-Type'] = 'application/json' })
end)