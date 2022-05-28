Config = Config or {}

Config.UseTarget = false -- Use qb-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)

Config.Cityhalls = {
    { -- Cityhall 1
        coords = vec3(-265.0, -963.6, 31.2),
        showBlip = true,
        blipData = {
            sprite = 487,
            display = 4,
            scale = 0.65,
            colour = 0,
            title = "City Services"
        },
        licenses = {
            ["id_card"] = {
                label = "ID Card",
                cost = 2500,
            },
            ["driver_license"] = {
                label = "Driver License",
                cost = 2500,
                metadata = "driver"
            },
            ["weaponlicense"] = {
                label = "Weapon License",
                cost = 5000,
                metadata = "weapon"
            },
        }
    },
}

Config.DrivingSchools = {
    { -- Driving School 1
        coords = vec3(240.3, -1379.89, 33.74),
        showBlip = false,
        blipData = {
            sprite = 225,
            display = 4,
            scale = 0.65,
            colour = 3,
            title = "Driving School"
        },
        instructors = {
            "DJD56142",
            "DXT09752",
            "SRI85140",
        }
    },
}

Config.Peds = {
    -- Cityhall Ped
    -- {
    --     model = 'a_m_m_hasjew_01',
    --     coords = vec4(-262.79, -964.18, 30.22, 181.71),
    --     scenario = 'WORLD_HUMAN_STAND_MOBILE',
    --     cityhall = true,
    --     zoneOptions = { -- Used for when UseTarget is false
    --         length = 3.0,
    --         width = 3.0,
    --         debugPoly = false
    --     }
    -- },
    -- -- Driving School Ped
    -- {
    --     model = 'a_m_m_eastsa_02',
    --     coords = vec4(240.91, -1379.2, 32.74, 138.96),
    --     scenario = 'WORLD_HUMAN_STAND_MOBILE',
    --     drivingschool = true,
    --     zoneOptions = { -- Used for when UseTarget is false
    --         length = 3.0,
    --         width = 3.0
    --     }
    -- }
}

Config.StartLocation = vector3(-941.52, -2955.85, 13.95)

Config.PlaneSpawn = vector4(-966.59, -2987.82, 13.95, 107.57)


Config.PlaneCheckPoints = {

	{
		Pos = vector3(-1024.25, -2970.32, 14.47),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Taxi to the runway', 5000)
            timeLeft = timeLeft + 20
		end
	},

	{
		Pos = vector3(-1053.78, -3104.56, 16.39),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Take off', 5000)
            timeLeft = timeLeft + 15
		end
	},

	{
		Pos = vector3(-1339.68, -2946.29, 21.81),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 10
		end
	},
	{
		Pos = vector3(-1809.6, -2548.38, 124.17),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(-2002.9, -1122.34, 173.19),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-1821.06, 78.73, 263.71),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-942.17, 478.62, 257.28),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 20
		end
	},
	{
		Pos = vector3(171.45, 239.01, 230.7),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(622.45, -360.06, 163.97),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(416.27, -1083.41, 95.42),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 10
		end
	},
	{
		Pos = vector3(8.46, -1839.02, 77.49),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-343.79, -2354.89, 31.65),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-429.53, -3084.86, 87.44),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 30
		end
	},
	{
		Pos = vector3(670.41, -3100.14, 134.14),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 30
		end
	},
	{
		Pos = vector3(805.93, -3860.72, 107.43),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 30
		end
	},
	{
		Pos = vector3(12.83, -3862.77, 70.18),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-916.38, -3384.59, 28.86),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Go to the next point', 5000)
            timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-1236.93, -3200.56, 17.33),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Land the plane', 5000)
            timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(-1584.39, -3000.63, 15.96),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Taxi across the runways', 5000)
            timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(-1591.5, -2893.2, 15.2),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Taxi across the airport', 5000)
            timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(-1488.94, -2822.13, 15.49),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Taxi to the hanger', 5000)
            timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(-1167.17, -2976.79, 16.69),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Park in the hanger', 5000)
            timeLeft = timeLeft + 10
		end
	},
	{
		Pos = vector3(-974.52, -2993.57, 14.44),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			-- DrawMissionText('Go to the next point', 5000)
		end
	},


	-- {
	-- 	Pos = {x = -73.542, y = -1364.335, z = 27.789},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		-- DrawMissionText(_U('stop_for_passing'), 5000)
	-- 		PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
	-- 		-- FreezeEntityPosition(vehicle, true)
	-- 		-- Citizen.Wait(6000)
	-- 		-- FreezeEntityPosition(vehicle, false)
	-- 	end
	-- },

}

Config.HeliCheckPoints = {

	{
		Pos = vector3(-1017.96, -2976.61, 18.03),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Fly out of the hanger', 5000)
			timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-1084.29, -2941.65, 50.06),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Gain altitude', 5000)
			timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-1321.05, -2801.38, 218.27),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 10
		end
	},
	{
		Pos = vector3(-1897.26, -1383.73, 267.12),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-1737.68, 312.18, 331.0),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-441.41, 443.99, 348.82),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(626.11, 132.31, 257.9),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(624.96, -612.58, 100.6),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(571.02, -853.9, 23.61),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(591.82, -1023.34, 20.1),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(563.01, -1207.76, 22.56),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(627.93, -1477.89, 87.97),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(471.61, -1956.88, 120.12),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 15
		end
	},
	{
		Pos = vector3(-365.32, -2338.17, 31.62),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-785.42, -2732.22, 93.05),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 25
		end
	},
	{
		Pos = vector3(-1061.67, -2967.5, 21.72),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
			timeLeft = timeLeft + 20
		end
	},
	{
		Pos = vector3(-966.96, -2999.47, 13.95),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			DrawMissionText('Follow the checkpoints', 5000)
		end
	}

}

Config.BuyWeaponLicense = {
    coords = vector3(-261.3436, -964.9681, 31.2240)
}
