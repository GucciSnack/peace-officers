---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Palm Beah Games.
--- DateTime: 2/19/2019 5:18 PM
---

PedManager = {}

-- Ped Suspects
PedManager.suspects = {}

-- when making a ped a suspect
RegisterServerEvent('PedManager.makeSuspect')
AddEventHandler('PedManager.makeSuspect', function(target)
    PedManager.MakeSuspect(target)
end)
function PedManager.MakeSuspect(target)
    PedManager.suspects[target] = true;
    -- add suspect each player machine
    local players = GetPlayers()
    for _, player in ipairs(players) do
        TriggerClientEvent('Engine.addToWanted', player, target)
    end
end
-- when making a ped a flee
RegisterServerEvent('PedManager.makeSubjectFleeFromPed')
AddEventHandler('PedManager.makeSubjectFleeFromPed', function(target, ped)
    PedManager.MakeSubjectFleeFromPed(target, ped)
end)
function PedManager.MakeSubjectFleeFromPed(target, ped)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        TriggerClientEvent('PedManager.makeSubjectFleeFromPed', player, target, ped)
    end
end
-- when making a ped a suspect fighter
RegisterServerEvent('PedManager.PedAttackOfficers')
AddEventHandler('PedManager.PedAttackOfficers', function(target, weaponHash)
    weaponHash = weaponHash or nil
    PedManager.PedAttackOfficers(target, weaponHash)
end)
function PedManager.PedAttackOfficers(target, weaponHash)
    PedManager.PedAttackOfficers(target)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        TriggerClientEvent('PedManager.PedAttackOfficers', player, target, weaponHash)
    end
end
-- when making a ped surrender
RegisterServerEvent('PedManager.PedSurrenderToArrest')
AddEventHandler('PedManager.PedSurrenderToArrest', function(target)
    PedManager.PedSurrenderToArrest(target)
end)
function PedManager.PedSurrenderToArrest(target)
    PedManager.PedSurrenderToArrest(target)
    -- cooperate
    local players = GetPlayers()
    for _, player in ipairs(players) do
        TriggerClientEvent('PedManager.PedSurrenderToArrest', player, target)
    end
end

-- when placing a ped under arrest
RegisterServerEvent('PedManager.orderArrest')
AddEventHandler('PedManager.orderArrest', function(target)
    PedManager.OrderArrest(target)
end)
function PedManager.OrderArrest(target)
    if(false)then -- attack todo: fix issue where melee doesn't work

    elseif(math.random(0, 4) == 3)then -- attack with gun
        PedManager.MakeSuspect(target)
        PedManager.PedAttackOfficers(target, "WEAPON_PISTOL")
    else
        PedManager.PedSurrenderToArrest(target)
    end
end

-- when placing a ped under arrest
RegisterServerEvent('PedManager.orderDetain')
AddEventHandler('PedManager.orderDetain', function(target)
    PedManager.OrderDetain(target)
end)
function PedManager.OrderDetain(target)
    if(false)then -- attack todo: fix issue where melee doesn't work
    elseif(false and math.random(0, 4) == 3)then -- attack with gun
        PedManager.MakeSuspect(target)
        PedManager.PedAttackOfficers(target, "WEAPON_PISTOL")
    elseif(true or math.random(0, 4) == 3)then -- flees
        PedManager.MakeSuspect(target)
        PedManager.makeSubjectFleeFromPed(target, source)
    else
        -- cooperate
    end
end

-- when placing a ped in cuffs
RegisterServerEvent('PedManager.placeCuffs')
AddEventHandler('PedManager.placeCuffs', function(target)
    PedManager.PlaceCuffs(target)
end)
function PedManager.PlaceCuffs(target)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        TriggerClientEvent('PedManager.pedStandInCuffs', player, target, source)
    end
end
