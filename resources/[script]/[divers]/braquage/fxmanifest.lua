fx_version 'adamant'

game 'gta5'

client_scripts {
    "src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",

    "src/client/components/*.lua",

    "src/client/menu/elements/*.lua",

    "src/client/menu/items/*.lua",

    "src/client/menu/panels/*.lua",

    "src/client/menu/windows/*.lua",

}

client_scripts {
    'config.lua',
    'client/braquage/client.lua',
    'client/bijouteri/client.lua',
}

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
	'config.lua',
}