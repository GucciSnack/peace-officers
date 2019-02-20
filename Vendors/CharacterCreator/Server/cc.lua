RegisterServerEvent('selectCharacter')
RegisterServerEvent('saveCharacter')

AddEventHandler('selectCharacter', function(args)

    local mySource = source
    local playerID = GetPlayerIdentifier(mySource)

    -- todo: add player to instance.
    -- place player in separate instance
    --CreateInstance("character_creator", mySource, {});
    --AddPlayerToInstance(mySource, mySource);

    MySQL.ready(function()
        MySQL.Async.fetchAll('SELECT dna, rank, exp, exp_goal FROM characters WHERE player_id=@id', { ['@id'] = playerID }, function(characters)

            if next(characters) ~= nil then
                local sString = characters[1].dna
                local playerRank = characters[1].rank
                local exp = characters[1].exp
                local expGoal = characters[1].exp_goal
                TriggerClientEvent('loadCharacter', mySource, sString, playerRank, exp, expGoal)
            else
                TriggerClientEvent('createCharacter', mySource)
            end
        end)
    end)
end)

AddEventHandler('saveCharacter', function(superString)
    local mySource = source
    local playerID = GetPlayerIdentifier(mySource)

    MySQL.ready(function()
        MySQL.Async.execute('INSERT INTO characters(player_id,dna) VALUES (@id,@dna);', {
            ['id']  = playerID,
            ['dna'] = superString
        }, function(rowsChanged)
        end)
    end)
end)