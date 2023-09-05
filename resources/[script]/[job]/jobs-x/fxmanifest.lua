fx_version 'adamant'
game 'gta5'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua", 
}

client_scripts {
    '@es_extended/locale.lua',
    'warmenu.lua',

    'fr.lua',

    'esx_policejob/configpolice.lua',
    'esx_policejob/client/main.lua',
    'esx_policejob/client/menu.lua',

    'esx_ambulancejob/configambulance.lua',
    'esx_ambulancejob/client/main.lua',
    'esx_ambulancejob/client/menu.lua',

    'esx_mecanojob/configmecano.lua',
    'esx_mecanojob/client/main.lua',

    'esx_vigneronjob/config.lua',
	'esx_vigneronjob/client/main.lua',

    'esx_avocatjob/config.lua',
    'esx_avocatjob/client/main.lua',

    'esx_taxijob/configtaxi.lua',
    'esx_taxijob/client/main.lua',
    'esx_taxijob/client/menu.lua',

    'concession/client/client.lua',

    ----------- ↓ MENU DES MECANOS ↓ ----------------- 
    'esx_mecanojob/client/menu-bennys.lua',
    'esx_mecanojob/client/menu-autotuners.lua',
    'esx_mecanojob/client/menu-lscustom.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',

    'fr.lua',

    'esx_ambulancejob/configambulance.lua',
    'esx_ambulancejob/server/main.lua',

    'esx_policejob/configpolice.lua',
    'esx_policejob/server/main.lua',

    'esx_mecanojob/configmecano.lua',
    'esx_mecanojob/server/main.lua',

    'esx_vigneronjob/config.lua',
	'esx_vigneronjob/server/main.lua',

    'esx_avocatjob/config.lua',
    'esx_avocatjob/server/main.lua',

    'esx_taxijob/configtaxi.lua',
    'esx_taxijob/server/main.lua',

    'concession/server/server.lua'
  
}

client_scripts {
    '@es_extended/locale.lua',

    'fr.lua',
}

exports {
    'GetStatusTaxi',
    'GetEMSState'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',

    'fr.lua',

}