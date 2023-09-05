ConfigBrasDeFer = {

  language = 'fr',




      --Set up new line to add a table, xyz are the coordinate, model is the props used as table. The 3 tables for armwrestling are 

                                                    -- 'prop_arm_wrestle_01' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_01a' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_02a' --

  props = { 
    
    {x = -71.8787, y = -1341.1460, z = 29.2569, model = 'prop_arm_wrestle_01'},
    {x = 254.3935, y = -1799.3245, z = 27.1131, model = 'prop_arm_wrestle_01'},
    {x = 331.6204, y = -1159.6149, z = 29.2919, model = 'prop_arm_wrestle_01'},
    {x = -356.5731, y = -359.1218, z = 31.5574, model = 'prop_arm_wrestle_01'},
    {x = -334.7416, y = 288.6397, z = 85.7933, model = 'prop_arm_wrestle_01'},
    {x = -605.8405, y = 338.4024, z = 85.1166, model = 'prop_arm_wrestle_01'},
    {x = 375.2343, y = 284.1109, z = 103.1818, model = 'prop_arm_wrestle_01'},
    {x = 976.1367, y = -138.6455, z = 74.1998, model = 'prop_arm_wrestle_01'},
    {x = -229.7982, y = -1384.8442, z = 31.2582, model = 'prop_arm_wrestle_01'},
    {x = -1081.0748, y = -1046.2659, z = 2.1496, model = 'prop_arm_wrestle_01'},
    {x = -1314.5991, y = -914.3590, z = 11.3092, model = 'prop_arm_wrestle_01'},

  },


  showBlipOnMap = true, -- Set to true to show blip for each table

  blip = { --Blip info

    title="Bras de fer",  
    colour=0, -- 
    id=311 

  }

}

text = { 
  ['en'] = {
    ['win'] = "You win !",
    ['lose'] = "You lost",
    ['full'] = "A wrestling match is already in progress",
    ['tuto'] = "To win, quickly press ",
    ['wait'] = "Waiting for an opponent",
  },
  ['fr'] = {
    ['win'] = "Vous avez gagné !",
    ['lose'] = "Vous avez perdu",
    ['full'] = "Un bras de fer est déjà en cours",
    ['tuto'] = "Pour gagner, appuyez rapidement sur ",
    ['wait'] = "En attente d'un adversaire",
  },
  ['cz'] = {
    ['win'] = "Vyhrál jsi !",
    ['lose'] = "Prohrál jsi",
    ['full'] = "Zápasový zápas již probíhá",
    ['tuto'] = "Chcete-li vyhrát, rychle stiskněte ",
    ['wait'] = "Čekání na protivníka",
  },
  ['de'] = {
    ['win'] = "Du hast gewinnen !",
    ['lose'] = "Du hast verloren",
    ['full'] = "Ein Wrestling Match ist bereits im Gange",
    ['tuto'] = "Um zu gewinnen, drücken Sie schnell ",
    ['wait'] = "Warten auf einen Gegner",
  },

}