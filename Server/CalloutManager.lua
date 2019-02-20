local lastCalloutTime = 0;

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random((60000*2),(60000*5))) -- Wait to check issue a new call for service
		players = GetPlayers()
		for _, i in ipairs(players) do
		end
	end
end)