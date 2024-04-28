--[[ ===================================================== ]]--
--[[           MH NPC Services Script by MaDHouSe          ]]--
--[[             Some changes made by Tnoxious             ]]--
--[[ ===================================================== ]]--

Config = {}
Config.UseTarget              = true             -- Defalt false, if you want to use target for cellphones
Config.Debug                  = false            -- Defalt false, debug in console (client/server)
Config.InteractDiustance      = 2.5              -- Default 2.5, the distance when you can interact with the npc ped driver
Config.MinOnlineEMS           = 1                -- Defalt 1, How many ems people have to be online, to iqnore the npc services.
Config.Cooldown               = 350000           -- Defalt 25000, A cooldown, (5mins) this is so players can't spam it.
Config.AutoCallAmbulance      = true             -- Defalt true, if true, it calls the ambulance automatically for you (Won't work if you have EMS online).
Config.AutoCallTimer          = 15000            -- Defalt 20000, A timer to call ambulance automatically after 20secs.
Config.ForceFirstperson       = false            -- Default false, it force firstperon when inside a job vehicle.
Config.MinDamageForFlatbed    = 650              -- Defalt 750, a flatbed is comming if the vehicle damage is below this value.
Config.RadialMenuIcone        = "star-of-life"   -- Defalt "star-of-life", icon form the radial menu.
Config.PhoneModel             = "prop_amb_phone" -- Default prop_amb_phone, hand phone, if you have a other phone model, you can use it here
Config.StuckTimerCheck        = 15               -- Default 15, a stuck timer check.
Config.StuckResetTimer        = 15               -- Default 15, reset stuck time.
Config.UseUnlimitHealth       = false             -- if true, all service peds and vehicles will have unlimited health - best leave false incase npc is stuck so player can kill them.
Config.UseCallForOtherPlayers = false            -- if false, players can't call the service for other players
Config.UseServicesForJobs     = true             -- if true, your are able to call a services while on a job 
Config.UsePoliceAssist        = true            -- if true, a police player can let a police ped drive the player to the jail
Config.UseAutoJail            = true            -- Default false, if you dont have police you can set this true (You have to check jail spawns below " police " area if on)
Config.MinJailTime            = 120              -- 2 min min jail time (Default: 120)
Config.MaxJailTime            = 350              -- 5 min max jail time (Default: 350)

Config.JobPeds = {
    ['police']        = {models = {"ig_trafficwarden"}},
    ['ambulance']     = {models = {"s_m_m_paramedic_01"}},
    ['mechanic']      = {models = {"s_m_m_autoshop_02"}},
    ['taxi']          = {models = {"a_m_y_hipster_01"}},
    ['limousine']     = {models = {"a_m_y_business_02"}},
}

Config.Vehicles = {   -- Job Vehicles
    ['police']        = {models = {"policet"}},
    ['ambulance']     = {models = {"ambulance"}},
    ['mechanic']      = {models = {"flatbed"}},-- dont change the order, you can change the model but keep it as it is.(flatbed best used here)
    ['taxi']          = {models = {"taxi"}},
    ['limousine']     = {models = {"stretch"}},
}

Config.CallAnimation = { -- Call Aminations
    call    = {dictionary = "cellphone@", animation = "cellphone_call_listen_base"},
    jobcall = {dictionary = "random@arrests", animation = "generic_radio_enter"}
}

-- Cop Weapons
Config.Weapons = {"WEAPON_PISTOL", "WEAPON_STUNGUN"}

 -- Job Service data.
Config.Service = {                           
    ['ambulance'] = {
        name        = "Ambulance",                           -- name of the company
        job         = "ambulance",                           -- the job name.
        plate       = "NPC-",                            -- vehicle plate.
        color       = 3,                                     -- blip color
        speed       = 35.0,                                  -- drive speed.
        price       = 0,                                   -- cost..
        spawnRadius = 350,                                   -- spawn Radius around the player
        spotRadius  = 10,                                    -- the radius a ped spots a player
        driveStyle  = 787007,                                   -- if you want to chang this go to: https://www.vespura.com/fivem/drivingstyle/ or try 524863 - 537133628 - 262447 - 262204 
        walkStyle   = 786603,                                -- walk style (running)
        passengerSeat = 1,                                   -- -1 is the driver
        home        = vector3(366.28, -591.97, 28.7), -- home location for the company (you may need to need to adjust this)
        checkin     = vector3(308.19, -595.13, 43.29), -- checkin for hospital (you may need to need to adjust this)
    },
    ['police'] = {
        name        = "Police",
        job         = "police",
        plate       = "NPC-",
        color       = 38,
        speed       = 30.0,
        price       = 0,
        spawnRadius = 350,
        spotRadius  = 15,
        driveStyle  = 787007,            
        walkStyle   = 786603,
        passengerSeat = 2, -- -1 is the driver
        home        = vector3(1860.15, 2584.31, 45.67),         -- home location for the company (you may need to need to adjust this)
        checkin     = vector3(1749.69, 2545.68, 45.56),          -- checkin police hq jail (you may need to need to adjust this)
        checkout    = vector4(1838.91, 2585.44, 45.89, 273.48), -- checkout after jail
    },

    ['mechanic'] = {
        name        = "Mechanic",
        job         = "mechanic",
        plate       = "NPC-",
        color       = 41,
        speed       = 20.0,
        price       = 2500,
        spawnRadius = 350,
        spotRadius  = 10,
        driveStyle  = 536871359, --525119, --524863,            
        walkStyle   = 786603,
        passengerSeat = 0, -- -1 is the driver
        home        = vector3(-1116.76, -2011.59, 13.18),           -- home location for the company (you may need to need to adjust this)
        vehicleDrop = vector4(-1143.34, -1974.29, 13.16, 211.49), -- drop location for the player vehicle. (you may need to need to adjust this)
        truck_offset = { -- for the vehicle position on the flatbed
            x = -0.5,    -- left/right
            y = -5.0,    -- front/back
            z = 1.4,     -- up/down
        },
    },

    ['taxi'] = {
        name        = "Taxi",
        job         = "taxi",
        plate       = "NPC-",
        color       = 46,
        speed       = 25.0,
        price       = 1000,
        spawnRadius = 450,
        spotRadius  = 10,
        driveStyle  = 536871359,
        walkStyle   = 786603,
        passengerSeat = 2, -- -1 is the driver
        home        = vector3(894.41, -186.37, 73.73), --  (you may need to need to adjust this)
    },

    ['limousine'] = {
        name        = "limousine",
        job         = "limousine",
        plate       = "NPC-",
        color       = 25,
        speed       = 30.0,
        price       = 5000,
        spawnRadius = 450,
        spotRadius  = 10,
        driveStyle  = 536871359,
        walkStyle   = 786603,
        passengerSeat = 2, -- -1 is the driver
        home        = vector3(-1151.45, -210.44, 37.96), -- (you may need to need to adjust this)
    }
}
