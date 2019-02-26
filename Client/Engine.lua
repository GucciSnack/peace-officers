---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Palm Beah Games.
--- DateTime: 2/26/2019 3:07 AM
---
RegisterNetEvent('Engine.addToWanted')
AddEventHandler('Engine.addToWanted', function(target)
    AddTargetToWanted(target)
end)
function AddTargetToWanted(target)
    if (IsEntityAPed(target) == 1) then
        --SetPedRelationshipGroupHash(target, GetHashKey("SUSPECTS"))
        -- store to suspects array
        local suspectId = tonumber(#suspects) + 1;
        suspects[suspectId]                 = {}
        suspects[suspectId]['id']           = suspectId
        suspects[suspectId]['ped']          = target
        entityBlip[target]                  = AddBlipForEntity(target, true)
        suspects[suspectId]['blip']         = entityBlip[target]
        suspects[suspectId]['action_code']  = "";
        HUD.SetAssignment(1)
    end
end
function AddTargetToDetained(target, arrestingOfficer)
    if (IsEntityAPed(target) == 1) then
        -- store to detained array
        local detainedId = tonumber(#detained) + 1;
        detained[detainedId]                 = {}
        detained[detainedId]['id']           = detainedId
        detained[detainedId]['ped']          = target
        entityBlip[target]                   = AddBlipForEntity(target, true)
        SetBlipScale(entityBlip[target], 0.4);
        detained[detainedId]['blip']         = entityBlip[target]
        detained[detainedId]['action_code']  = "follow";
        detained[detainedId]['arresting_officer']  = arrestingOfficer;
        TaskSetBlockingOfNonTemporaryEvents(target, true)
        SetPedFleeAttributes(target, 0, 0)
        HUD.SetAssignment(2)
    end
end
function RemoveTargetFromWanted(target)
    local suspectId = GetSuspectId(target)
    if(DoesBlipExist(entityBlip[target]) == 1)then
        RemoveBlip(entityBlip[target]);
    end
    if(suspectId ~= nil)then
        suspects[suspectId] = nil
    end
end
function RemoveTargetFromDetained(target)
    local detainedId = GetDetainedId(target)
    if(DoesBlipExist(entityBlip[target]) == 1)then
        RemoveBlip(entityBlip[target]);
    end
    if(detainedId ~= nil)then
        detained[detainedId] = nil
    end
end
function GetSuspectId(target)
    local suspectId = nil;
    for i, suspect in ipairs(suspects)do
        if(suspect['ped'] == target)then
            suspectId = i
        end
    end
    return suspectId;
end
function GetDetainedId(target)
    local detainedId = nil;
    for i, subject in ipairs(detained)do
        if(subject['ped'] == target)then
            detainedId = i
        end
    end
    return detainedId;
end
function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end
function GetNearbyPeds(X, Y, Z, Radius)
    local NearbyPeds = {}
    if tonumber(X) and tonumber(Y) and tonumber(Z) then
        if tonumber(Radius) then
            for Ped in EnumeratePeds() do
                if DoesEntityExist(Ped) then
                    local PedPosition = GetEntityCoords(Ped, false)
                    local pedDistance = Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z);
                    if (pedDistance <= Radius and IsEntityAPed(Ped) == 1 and Ped ~= playerPed and IsPedAPlayer(Ped) ~= true and GetPedType(Ped) ~= 20 and GetPedType(Ped) ~= 21 and GetPedType(Ped) ~= 27 and GetPedType(Ped) ~= 6) then
                        table.insert(NearbyPeds, Ped)
                    end
                end
            end
        else
            print("GetNearbyPeds was given an invalid radius!")
        end
    else
        print("GetNearbyPeds was given invalid coordinates!")
    end
    return NearbyPeds
end
function GetNearbyPed(X, Y, Z, Radius)
    local NearbyPed = nil;
    local closestPed = Radius;
    if tonumber(X) and tonumber(Y) and tonumber(Z) then
        if tonumber(Radius) then
            for Ped in EnumeratePeds() do
                if DoesEntityExist(Ped) then
                    local PedPosition = GetEntityCoords(Ped, false)
                    local pedDistance = Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z);
                    if (pedDistance <= Radius and pedDistance < closestPed and IsEntityAPed(Ped) == 1 and Ped ~= playerPed and IsPedAPlayer(Ped) ~= true and GetPedType(Ped) ~= 20 and GetPedType(Ped) ~= 21 and GetPedType(Ped) ~= 27 and GetPedType(Ped) ~= 6) then
                        closestPed = pedDistance;
                        NearbyPed = Ped;
                    end
                end
            end
        else
            print("GetNearbyPed was given an invalid radius!")
        end
    else
        print("GetNearbyPed was given invalid coordinates!")
    end
    return NearbyPed
end
function GetNearbyOfficers(X, Y, Z, Radius, Max)
    local NearbyPeds = {}
    Max = Max or 2
    if tonumber(X) and tonumber(Y) and tonumber(Z) then
        if tonumber(Radius) then
            for Ped in EnumeratePeds() do
                if(#NearbyPeds < Max)then
                    if DoesEntityExist(Ped) then
                        local PedPosition = GetEntityCoords(Ped, false)
                        local pedDistance = Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z);
                        if (pedDistance <= Radius and IsEntityAPed(Ped) == 1 and (IsPedAPlayer(Ped) == true or GetPedType(Ped) == 6)) then
                            table.insert(NearbyPeds, Ped)
                        end
                    end
                end
            end
        else
            print("GetNearbyPeds was given an invalid radius!")
        end
    else
        print("GetNearbyPeds was given invalid coordinates!")
    end
    return NearbyPeds
end
function GetNearbyOfficer(X, Y, Z, Radius)
    local NearbyPed = nil;
    local closestPed = Radius;
    if tonumber(X) and tonumber(Y) and tonumber(Z) then
        if tonumber(Radius) then
            for Ped in EnumeratePeds() do
                if DoesEntityExist(Ped) then
                    local PedPosition = GetEntityCoords(Ped, false)
                    local pedDistance = Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z);
                    if (pedDistance <= Radius and pedDistance < closestPed and IsEntityAPed(Ped) == 1 and (IsPedAPlayer(Ped) == true or GetPedType(Ped) == 6)) then
                        closestPed = pedDistance;
                        NearbyPed = Ped;
                    end
                end
            end
        else
            print("GetNearbyOfficer was given an invalid radius!")
        end
    else
        print("GetNearbyOfficer was given invalid coordinates!")
    end
    return NearbyPed
end
function GetNearbyAIPolice(X, Y, Z, Radius)
    local NearbyPolice = {}
    if tonumber(X) and tonumber(Y) and tonumber(Z) then
        if tonumber(Radius) then
            for Ped in EnumeratePeds() do
                if DoesEntityExist(Ped) then
                    local PedPosition = GetEntityCoords(Ped, false)
                    local pedDistance = Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z);
                    if (pedDistance <= Radius and IsEntityAPed(Ped) == 1 and Ped ~= playerPed and IsPedAPlayer(Ped) ~= true and GetPedType(Ped) == 6) then
                        table.insert(NearbyPolice, Ped)
                    end
                end
            end
        else
            print("GetNearbyAIPolice was given an invalid radius!")
        end
    else
        print("GetNearbyAIPolice was given invalid coordinates!")
    end
    return NearbyPolice
end
function GetDistancesFromPeds(ped1, ped2)
    local ped1Vector = GetEntityCoords(ped1, false)
    local ped2Vector = GetEntityCoords(ped2, false)
    local pedDistance = Vdist(ped1Vector.x, ped1Vector.y, ped1Vector.z, ped2Vector.x, ped2Vector.y, ped2Vector.z);
    return pedDistance;
end
function ShowTip(tipVariable, message)
    if (HUD.Tips[tipVariable] == true) then
        HUD.Tips[tipVariable] = false;
        HUD.Notification(message);
    end
end