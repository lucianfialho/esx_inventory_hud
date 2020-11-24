fx_version 'adamant'

game 'gta5'

description 'ESX Boilerplate'

server_scripts {
	'server/*.lua'
}

client_scripts {
	'client/*.lua',
}

shared_script {
	'locale.lua',
	'locales/*.lua',
	'config.lua',
}

ui_page 'inventory_hud/dist/index.html'

files {
	'inventory_hud/dist/index.html',
	'inventory_hud/dist/images/*.svg'
}

dependencies {
	'es_extended',
}