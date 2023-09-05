ConfigHoldup = {}
Translation = {}

ConfigHoldup.Shopkeeper = 2119136831 -- hash of the shopkeeper ped
ConfigHoldup.Locale = 'fr' -- 'en', 'sv' or 'custom'

ConfigHoldup.Shops = {
    -- {coords = vector3(x, y, z), heading = peds heading, money = {min, max}, cops = amount of cops required to rob, blip = true: add blip on map false: don't add blip, name = name of the store (when cops get alarm, blip name etc)}
    {coords = vector3(24.03, -1345.63, 29.5-0.98), heading = 266.0, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-705.73, -914.91, 19.22-0.98), heading = 91.0, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1222.9043, -909.1501, 12.32-0.98), heading = 35.80, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1134.1626, -983.6140, 46.41-0.98), heading = 282.00, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-47.3581, -1758.8680, 29.4210-0.98), heading = 55.80, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(2555.3430, 380.7774, 108.6230-0.98), heading = 6.5273, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(373.0284, 328.3384, 103.5664-0.98), heading = 254.8974, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1819.2892, 793.2596, 138.0848-0.98), heading = 138.8287, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(549.3241, 2669.5037, 42.1565-0.98), heading = 99.4317, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(2676.0764, 3280.3542, 55.2411-0.98), heading = 329.6968, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1959.1626, 3741.4143, 32.3437-0.98), heading = 301.6968, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1728.5930, 6416.9199, 35.0372-0.98), heading = 234.3470, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1164.9458, -323.7384, 69.2051-0.98), heading = 96.1598, money = {5000, 18000}, cops = 3, blip = false, name = 'Stagiaire en formation', cooldown = {hour = 2, minute = 30, second = 0}, robbed = false}
}

Translation = {
    ['fr'] = {
        ['shopkeeper'] = 'commerçant',
        ['robbed'] = "Je vien déjà de me faire ~r~dévaliser~s~ ! Je suis désoler, je ~r~n\'ai plus~s~ d\'argent !",
        ['cashrecieved'] = 'Vous avez :',
        ['currency'] = '$',
        ['scared'] = 'Bang:',
        ['no_cops'] = 'Il n\'y a ~ r ~ pas ~ w ~ assez d\'agents en ligne !',
        ['cop_msg'] = "Une ~r~supérette~s~ est entrain de ce faire braquer ! Nous vous avons rentrez la position ~b~GPS~s~ !",
        ['set_waypoint'] = 'Définir un point vers le magasin',
        ['hide_box'] = "Masquer cette boîte",
        ['robbery'] = 'SUPÉRETTE',
        ['walked_too_far'] = 'Vous avez marché trop loin !'
    }
}