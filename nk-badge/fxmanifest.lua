fx_version 'adamant'

game 'gta5'

version '1.0.0'

client_scripts {
    'cl_badge.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'sv_badge.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/fonts/roboto/*.woff',
	'html/assets/fonts/roboto/*.woff2',
	'html/assets/fonts/justsignature/JustSignature.woff',
	'html/assets/images/*.png'
}

-- fanmade nopixel badge system 
-- by yldrmm#4571