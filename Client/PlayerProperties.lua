playerPed = nil;

--Player Properties Value Container
PlayerProperties = {};
PlayerProperties.rank = 0;
PlayerProperties.exp = 0;
PlayerProperties.expGoal = 0;

--Player Rank
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        playerPed = GetPlayerPed(-1);
        -- remove any player wanted level
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false);
            SetPlayerWantedLevelNow(PlayerId(), false);
        end
        -- verify user rank, exp, and goal are set
        if(PlayerProperties.rank == 0)then
            -- todo: remove this comment to force spawn if data is improper
            --SpawnManager.InitializePlayer();
        end
    end
end)

local function applyRankGoal()
    if(PlayerProperties.exp > PlayerProperties.expGoal)then
        PlayerProperties.rank = PlayerProperties + 1;
        PlayerProperties.expGoal = PlayerProperties.exp * 2;
        TriggerServerEvent('savePlayerRank', PlayerProperties.rank, PlayerProperties.exp, PlayerProperties.expGoal)
    end
end

function PlayerProperties.addExp(points)
    PlayerProperties.exp = PlayerProperties.exp + points;
    applyRankGoal();
end