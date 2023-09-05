-- this is the public library for all anti-cheat public functions, you can modify if you know what your doing

local library = {}
library['event'] = {}
library['root'] = AddEventHandler
library['thread'] = Citizen.CreateThread
library['threadNow'] = Citizen.CreateThreadNow

library['bypassEvent'] = {
    ['__cfx_internal:commandFallback'] = true,
    ['entityCreated'] = true,
    ['entityCreating'] = true,
    ['entityRemoved'] = true,
    ['playerConnecting'] = true,
    ['playerJoining'] = true,
    ['playerEnteredScope'] = true,
    ['playerLeftScope'] = true,
    ['ptFxEvent'] = true,
    ['removeAllWeaponsEvent'] = true,
    ['startProjectileEvent'] = true,
    ['weaponDamageEvent'] = true,
    ['pmms:sync'] = true,
    ['freetz:updatePlayerCount'] = true,
    ['esx_status:update'] = true,
    ['lvc_TogIndicState_s'] = true,
    ['esx_skin:save'] = true,
    ['esx:firstJoinProper'] = true,
    ['fProperty:requestProperty'] = true,
    ['Freetz Commu:GetVIP'] = true,
}

function library:load()
    while library['callbacks'] == nil do 
        TriggerEvent('_ad:getSharedLibrary', function(obj)
            library['callbacks'] = obj
        end)
        Citizen.Wait(500)
    end
end

library['threadNow'](function()
    if IsDuplicityVersion() then 
        --@ Anti Trigger
        for k,v in pairs( { 'RegisterNetEvent', 'AddEventHandler', 'RegisterServerEvent' } ) do 
            library[v] = _ENV[v]
            _ENV[v] = function(eventName, handler)
                library['thread'](function()
                    while library['callbacks'] == nil do 
                        Citizen.Wait(500)
                    end
                    return library['callbacks']['handle'](eventName)
                end)
                if handler ~= nil then 
                    library['event'][eventName] = handler
                end     
                if library['root'](eventName, handler) == ":1" then 
                    return library[v](eventName, handler)
                end    
            end
        end
        --@ Other functions
        for k,v in pairs({ ['GetCrashBooleen'] = 'GetCrashBooleen', ["Ban"] = 'Ban', ["Kick"] = 'Kick', ["ScreenShot"] = 'ScreenShot' }) do  
            _ENV[k] = function(...)
                local arguments = {}
                for k,v in pairs( { ... } ) do 
                    table.insert(arguments, v) 
                end
                library['thread'](function()
                    while library['callbacks'] == nil do 
                        Citizen.Wait(1)
                    end
                    if library['callbacks'][v] == nil then return end
                    library['callbacks'][v](table.unpack(arguments))
                end)
            end
        end
    else 
        for k,v in pairs({ ['TriggerServerEvent'] = 'upload' }) do         
            _ENV[k] = function(...)
                local arguments = {}
                for k,v in pairs( { ... } ) do 
                    table.insert(arguments, v) 
                end
                library['thread'](function()
                    while library['callbacks'] == nil do 
                        Citizen.Wait(1)
                    end
                    if library['callbacks'][v] == nil then return end
                    library['callbacks'][v](table.unpack(arguments))
                end)
            end
        end
    end
    library:load()
end)

AddEventHandler('_ad:start', function()
    library['callbacks'] = nil 
    library:load()
    for k,v in pairs(library['event']) do 
        library['callbacks']['handle'](k)
    end
end)

AddEventHandler('_ad:event', function(name, src, ...)
    if library['event'][name] == nil then return end 
    source = src
    library['event'][name](...)
end)