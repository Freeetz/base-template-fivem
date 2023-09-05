

fx_version 'cerulean'
game 'gta5'

shared_script 'config.lua'

client_scripts{
    'client/*.lua',
}

server_scripts{
    'server/*.lua',
}

ui_page{
    'ui/index.html'
} 

files {
    'ui/index.html',
    'ui/css/*.*',
    'ui/scripts/*.*',
    'ui/img/*.*',
    'ui/sounds/*.*',
}