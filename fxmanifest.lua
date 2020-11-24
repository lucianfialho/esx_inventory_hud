fx_version 'adamant'

game 'gta5'

description 'ESX Boilerplate'

server_scripts {
	'locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/*.lua',
}

ui_page 'inventory_hud/dist/index.html'

files {
	'inventory_hud/dist/index.html',
	'inventory_hud/dist/images/*.svg'
}

dependencies {
	'es_extended',
}