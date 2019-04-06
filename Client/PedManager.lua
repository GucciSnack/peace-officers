---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Palm Beah Games.
--- DateTime: 2/26/2019 12:15 AM
---
PedManager = {}
PedManager.pedActors = {}

-- Sets ped to fight players
RegisterNetEvent('PedManager.PedAttackOfficers')
AddEventHandler('PedManager.PedAttackOfficers', function(target, weaponHash)
    PedManager.PedAttackOfficers(target, weaponHash)
end)
function PedManager.PedAttackOfficers(target, weaponHash)
    weaponHash = weaponHash or 0;
    suspects[GetSuspectId(target)]['action_code'] = 'attack_players'
    TaskSetBlockingOfNonTemporaryEvents(target, true)
    SetPedFleeAttributes(target, 0, 0)
    SetPedCombatAttributes(target, 46, 1)
    SetPedCombatAttributes(target, 1424, 1)
    if(weaponHash ~= 0)then
        SetPedCanSwitchWeapon(target, true)
        GiveDelayedWeaponToPed(target,  GetHashKey(weaponHash), math.random(50, 1000), false)
    end
    ClearPedTasks(target)
end
-- Sets ped to surrender to arrest
RegisterNetEvent('PedManager.PedSurrenderToArrest')
AddEventHandler('PedManager.PedSurrenderToArrest', function(target)
    PedManager.PedSurrenderToArrest(target)
end)
function PedManager.PedSurrenderToArrest(target)
    LoadAnimDict( "random@arrests" )
    LoadAnimDict( "random@arrests@busted" )
    TaskPlayAnim( target, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait (4000)
    TaskPlayAnim( target, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait (500)
    TaskPlayAnim( target, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait (1000)
    TaskPlayAnim( target, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
    ShowTip("placing_in_restraints", "Press E again once a suspect has surrendered to restrain the individual.")
end
-- Sets ped to stand in cuffs
RegisterNetEvent('PedManager.pedStandInCuffs')
AddEventHandler('PedManager.pedStandInCuffs', function(target, arrestingOfficer)
    PedManager.PedStandInCuffs(target, arrestingOfficer)
end)
function PedManager.PedStandInCuffs(target, arrestingOfficer)
    RequestAnimDict("mp_arresting")
    while not HasAnimDictLoaded("mp_arresting") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(target, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
    SetEnableHandcuffs(target, true)
    Wait (3000)
    LoadAnimDict( "random@arrests" )
    LoadAnimDict( "random@arrests@busted" )
    TaskPlayAnim( target, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait (3000)
    TaskPlayAnim( target, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )

    -- remove as suspect
    RemoveTargetFromWanted(target)
    -- add to detained
    AddTargetToDetained(target, arrestingOfficer)
    -- remove target auto todo: add dropoff points to map
    Citizen.Wait(5000)
    RemoveTargetFromDetained(target)
    DeletePed(target)
    if(HUD.assignmentCode == 2)then
        HUD.SetAssignment(0)
    end
end
-- Sets ped to flee
RegisterNetEvent('PedManager.makeSubjectFleeFromPed')
AddEventHandler('PedManager.makeSubjectFleeFromPed', function(target, ped)
    PedManager.MakeSubjectFlee(target, ped)
end)
function PedManager.MakeSubjectFleeFromPed(target, ped)
    TaskSetBlockingOfNonTemporaryEvents(target, true)
    SetPedFleeAttributes(target, 1, 1)
    SetPedCombatAttributes(target, 46, 0)
    SetPedCombatAttributes(target, 1424, 0)
    local actorId = AddTargetToActors(target)
    PedManager.pedActors[actorId]["action_code"] = "flee_from_ped"
    SetEntityData(target, 'fleeing_from', ped)
end

-- PED ACTIONS
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(800)
        -- handle suspect actions
        for i, suspect in ipairs(suspects)do
            if(DoesEntityExist(suspect['ped']) == 1 and IsEntityAPed(suspect['ped']) == 1 and IsPedDeadOrDying(suspect['ped'], 1) ~= 1)then
                -- perform action code
                if(suspect['action_code'] == 'attack_players') then
                    local x, y, z = table.unpack(GetEntityCoords(suspect['ped'], true));
                    local officerTarget = GetNearbyOfficer(x, y, z, 100)
                    TaskCombatPed(suspect['ped'], officerTarget, 0, 1)
                    RegisterTarget(suspect['ped'], officerTarget)
                    SetPedFleeAttributes(target, 0, 0)
                end
            end
        end
        -- handle detained actions
        for i, subject in ipairs(detained)do
            if(DoesEntityExist(subject['ped']) == 1 and IsEntityAPed(subject['ped']) == 1 and IsPedDeadOrDying(subject['ped'], 1) ~= 1)then
                SetEnableHandcuffs(subject['ped'], true)
                -- perform action code
                if(subject['action_code'] == 'follow') then
                    TaskGoToEntity(subject['ped'], subject['arresting_officer'], -1, 0.5, 10.0, 1073741824.0, 0)
                    SetPedKeepTask(subject['ped'], true)
                end
            end
        end
        -- handle actor actions
        for i, subject in ipairs(PedManager.pedActors)do
            if(DoesEntityExist(subject['ped']) == 1 and IsEntityAPed(subject['ped']) == 1 and IsPedDeadOrDying(subject['ped'], 1) ~= 1)then
                -- perform action code
                if(subject['action_code'] == 'flee_from_officer') then
                    TaskSmartFleePed(subject['ped'], GetEntityData(subject['ped'], 'fleeing_from'), -1, 0.5, 10.0, 1073741824.0, 0)
                    SetPedKeepTask(subject['ped'], true)
                end
            end
        end
    end
end)

function PedManager.PushPedToNetwork(ped)
    if not NetworkGetEntityIsNetworked(ped) then
        NetworkRegisterEntityAsNetworked(ped)
    end
end