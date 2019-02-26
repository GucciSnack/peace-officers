resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	--peace officer core scripts
	"Server/GameManager.lua",
	"Server/CalloutManager.lua",
	"Server/PedManager.lua",

	--database
	'@mysql-async/lib/MySQL.lua',

	--character creator
	'Vendors/CharacterCreator/Server/cc.lua',
}

client_scripts {
	--peace officer core scripts
	"Client/Engine.lua",
	"Client/PlayerProperties.lua",
	"Client/Commands.lua",
	"Client/HUD.lua",
	"Client/Spawn.lua",
	"Client/Interactions.lua",
	"Client/PedManager.lua",

	--Entity enumerator
	"Vendors/Entityiter/entityiter.lua",

	--character creator
	'Vendors/CharacterCreator/Client/warmenu.lua',
	'Vendors/CharacterCreator/Client/cc.lua',

	--json extension
	'Vendors/JSON/json.lua',
}

