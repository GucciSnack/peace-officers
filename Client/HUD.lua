-- HUD Functions
HUD = {};

-- Game tips
HUD.Tips = {}
HUD.Tips.howToArrest = true;

function HUD.Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function HUD.DrawText(x, y, text, r, g, b, a, textJustification, scale)
	scale = scale or 0.3;
	r = r or 255;
	g = g or 255;
	b = b or 255;
	a = a or 255;
	textJustification = textJustification or 1;

	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextJustification(textJustification);
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

-- Game info text
Citizen.CreateThread(function()
	while true do
		HUD.DrawText(0.45, 0.005, "Rank: ~b~".. PlayerProperties.rank, 255, 255, 255, 150, 0, 0.25)
		HUD.DrawText(0.55, 0.005, "~b~".. PlayerProperties.exp .."~w~/~b~".. PlayerProperties.expGoal .." ~w~Until Next Level", 255, 255, 255, 150, 0, 0.25)
		HUD.DrawText(0.18, 0.93, "No Current Assignment", 255, 255, 255, 150)
		HUD.DrawText(0.18, 0.96, "Peace Officers BETA 1.0.0")
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('notification')
AddEventHandler('notification', function(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end)