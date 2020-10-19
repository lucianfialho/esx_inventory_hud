fx_version 'adamant'

game 'gta5'

description 'ESX Boilerplate'

server_scripts {
	'server/main.lua'
}

client_scripts {
	'client/weapon.lua',
	'client/camera.lua',
	'client/main.lua',
}

shared_script {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
}

ui_page 'inventory_hud/dist/index.html'

files {
	'inventory_hud/dist/index.html'
}

dependencies {
	'es_extended',
}