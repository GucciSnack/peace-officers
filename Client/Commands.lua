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

RegisterCommand('mkcriminal', function(source, args, rawCommand)
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true));
    local newCriminal = GetNearbyPed(x, y, z, 50.0)
    if (IsEntityAPed(newCriminal) == 1) then
        TriggerServerEvent('PedManager.makeSuspect', newCriminal)
    end
end)