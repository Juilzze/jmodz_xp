fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'jm_xp'

client_scripts {
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'config.lua',
	'server/main.lua',
	'@mysql-async/lib/MYSQL.lua'
}

shared_script {
	'es_extended'
}
