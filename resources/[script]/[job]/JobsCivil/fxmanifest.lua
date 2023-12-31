shared_script 'library_ad.lua'





































fx_version 'cerulean'
games {'gta5'}




client_scripts {
	'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
}



client_scripts {
    '@es_extended/locale.lua',
    "public/client/cl_zone.lua",
    "public/client/cl_menu.lua",
    "public/client/jobs/**/cl_*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "public/server/sv_*.lua",
}

