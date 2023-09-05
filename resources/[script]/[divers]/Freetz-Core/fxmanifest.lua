fx_version "adamant"

game "gta5"

author "Freetz#9999"

this_is_a_map('yes')

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
    "scripts/**/client/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "scripts/**/server/*.lua",
}

shared_scripts {
    '@es_extended/locale.lua',
    "scripts/[plugin]/essence/config.lua",
    "scripts/[plugin]/farming/config.lua",
    "scripts/[plugin]/deconnexion/config.lua",
    "scripts/[plugin]/brasdefer/config.lua",
    "scripts/[esx]/[jobs]/esx_unicornjob/config.lua",
    "scripts/[esx]/[magasins]/esx_accessories/configmasques.lua",
    "scripts/[plugin]/pneux-vehicle/config.lua",
    "scripts/[esx]/[magasins]/ikea/config.lua",
    "scripts/[esx]/[magasins]/esx_tattoosShops/config.lua",
    "scripts/[esx]/[magasins]/esx_clotheshop/confighabis.lua",
    "scripts/[esx]/[libs]/esx_rpchat/config.lua",
    "scripts/[esx]/[base]/esx_vehiclelock/config.lua",
    "scripts/[esx]/[magasins]/fAmmu/config.lua",
    "scripts/[esx]/[base]/esx_location/config.lua",
    "scripts/[esx]/[base]/esx_carlock/config.lua",
    "scripts/[esx]/[base]/braquage-banque/config.lua",
    "scripts/[esx]/[magasins]/esx_barbershop/config.lua",
    "scripts/[esx]/[base]/esx_holdup/config.lua",
    "scripts/[esx]/[jobs]/esx_vehicleshop/config.lua",
    "scripts/[esx]/[magasins]/esx_shops/config.lua",
    "scripts/[esx]/[base]/esx_moneywash/config.lua",
    "scripts/[esx]/[base]/esx_advancedgarage/config.lua",
    "scripts/locales/fr.lua",
}

exports {
	"GetCiseaux",
    "GeneratePlate",
    "GenerateSocietyPlate",
    "GetVIP"
}

files {
    'popcycle.dat',
    'relationships.dat'
}

data_file 'POPSCHED_FILE' 'popcycle.dat'

-------------- DIVERS MAPPING GTA 5 HISTOIRE & ONLINE ---------------------
client_script('scripts/[esx]/[libs]/bob74_ipl/lib/common.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/client.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/base.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/ammunations.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/floyd.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/franklin.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/franklin_aunt.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/graffitis.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/lester_factory.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/michael.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/north_yankton.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/red_carpet.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/simeon.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/stripclub.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/trevors_trailer.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/ufo.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gtav/zancudo_gates.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/apartment_hi_1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/apartment_hi_2.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_2.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_3.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_4.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_5.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_6.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_7.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_hi_8.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_mid_1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/gta_online/house_low_1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_high_life/apartment1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_high_life/apartment2.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_high_life/apartment3.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_high_life/apartment4.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_high_life/apartment5.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_high_life/apartment6.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_heists/carrier.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_heists/yacht.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_executive/apartment1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_executive/apartment2.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_executive/apartment3.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_finance/office1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_finance/office2.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_finance/office3.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_finance/office4.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_finance/organization.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/cocaine.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/counterfeit_cash.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/document_forgery.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/meth.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/weed.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/clubhouse1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/clubhouse2.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_bikers/gang.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_import/garage1.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_import/garage2.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_import/garage3.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_import/garage4.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_import/vehicle_warehouse.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_gunrunning/bunkers.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_gunrunning/yacht.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_smuggler/hangar.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_doomsday/facility.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_arena/arena_c.lua')
client_script('scripts/[esx]/[libs]/bob74_ipl/dlc_afterhours/nightclubs.lua')