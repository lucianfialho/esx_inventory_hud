fx_version 'adamant'

game 'gta5'

description 'ESX Boilerplate'

server_scripts {
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
}

shared_scripts {
	'@es_extended/locale.lua',
	'@es_extended/locales/en.lua',
	'@es_extended/config.lua',
	'@es_extended/config.weapons.lua',
}

ui_page 'inventory_hud/dist/index.html'

files {
	'inventory_hud/dist/index.html'
}

dependencies {
	'es_extended',
}