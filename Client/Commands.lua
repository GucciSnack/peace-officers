-- Player's patrol vehicle
local playerVehicle = nil;

RegisterCommand('car', function(source, args, rawCommand)
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local veh = args[1]
    if veh == nil then
        veh = "police"
    end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)

    --remove existing vehicle
    if (playerVehicle ~= nil) then
        DeleteVehicle(playerVehicle);
    end

    Citizen.CreateThread(function()
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end
        playerVehicle = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId()) + 90, 1, 0)
    end)
end)

RegisterCommand('incident', function(source, args, rawCommand)
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local type = args[1]
    if type == nil then
        type = 7
    elseif type == "police" then
        type = 7
    elseif type == "fire" then
        type = 3
    elseif type == "medic" then
        type = 5
    end
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true));
    local outIncidentId
    CreateIncident(type, x, y, z, 0, 6.0, outIncidentId);
end)

RegisterCommand('mkcriminal', function(source, args, rawCommand)
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true));
    local newCriminal = GetNearbyPed(x, y, z, 50.0)
    if (IsEntityAPed(newCriminal) == 1) then
        TriggerServerEvent('PedManager.makeSuspect', newCriminal)
    end
end)

RegisterCommand('mkshooter', function(source, args, rawCommand)
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true));
    local newCriminal = GetNearbyPed(x, y, z, 50.0)
    if (IsEntityAPed(newCriminal) == 1) then
        TriggerServerEvent('PedManager.makeSuspectShooter', newCriminal)
    end
end)