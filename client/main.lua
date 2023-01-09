local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isLoggedIn = LocalPlayer.state.isLoggedIn
local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
local closestCityhall = nil
local closestDrivingSchool = nil
local inCityhallPage = false
local inRangeCityhall = false
local inRangeDrivingSchool = false
local pedsSpawned = false
local table_clone = table.clone
local blips = {}

-- Flight school
local inRangeFlight = false
local headerOpen = false
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint, DriveErrors = 0, 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local fail = false
timeLeft = 45

-- Functions

local function getClosestHall()
    local distance = #(playerCoords - Config.Cityhalls[1].coords)
    local closest = 1
    for i = 1, #Config.Cityhalls do
        local hall = Config.Cityhalls[i]
        local dist = #(playerCoords - hall.coords)
        if dist < distance then
            distance = dist
            closest = i
        end
    end
    return closest
end

DrawText3Ds = function(coords, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(coords.x, coords.y, coords.z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

local function getClosestSchool()
    local distance = #(playerCoords - Config.DrivingSchools[1].coords)
    local closest = 1
    for i = 1, #Config.DrivingSchools do
        local school = Config.DrivingSchools[i]
        local dist = #(playerCoords - school.coords)
        if dist < distance then
            distance = dist
            closest = i
        end
    end
    return closest
end

local function setCityhallPageState(bool, message)
    if message then
        local action = bool and "open" or "close"
        SendNUIMessage({
            action = action
        })
    end
    SetNuiFocus(bool, bool)
    inCityhallPage = bool
    inRangeCityhall = false
    if not Config.UseTarget or bool then return end
end

local function createBlip(options)
    if not options.coords or type(options.coords) ~= 'table' and type(options.coords) ~= 'vector3' then return error(('createBlip() expected coords in a vector3 or table but received %s'):format(options.coords)) end
    local blip = AddBlipForCoord(options.coords.x, options.coords.y, options.coords.z)
    SetBlipSprite(blip, options.sprite or 1)
    SetBlipDisplay(blip, options.display or 4)
    SetBlipScale(blip, options.scale or 1.0)
    SetBlipColour(blip, options.colour or 1)
    SetBlipAsShortRange(blip, options.shortRange or false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(options.title or 'No Title Given')
    EndTextCommandSetBlipName(blip)
    return blip
end

local function deleteBlips()
    if not next(blips) then return end
    for i = 1, #blips do
        local blip = blips[i]
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    blips = {}
end

local function initBlips()
    for i = 1, #Config.Cityhalls do
        local hall = Config.Cityhalls[i]
        if hall.showBlip then
            blips[#blips+1] = createBlip({
                coords = hall.coords,
                sprite = hall.blipData.sprite,
                display = hall.blipData.display,
                scale = hall.blipData.scale,
                colour = hall.blipData.colour,
                shortRange = true,
                title = hall.blipData.title
            })
        end
    end
    for i = 1, #Config.DrivingSchools do
        local school = Config.DrivingSchools[i]
        if school.showBlip then
            blips[#blips+1] = createBlip({
                coords = school.coords,
                sprite = school.blipData.sprite,
                display = school.blipData.display,
                scale = school.blipData.scale,
                colour = school.blipData.colour,
                shortRange = true,
                title = school.blipData.title
            })
        end
    end
end

local function spawnPeds()
    if not Config.Peds or not next(Config.Peds) or pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        current.model = type(current.model) == 'string' and joaat(current.model) or current.model
        RequestModel(current.model)
        while not HasModelLoaded(current.model) do
            Wait(0)
        end
        local ped = CreatePed(0, current.model, current.coords.x, current.coords.y, current.coords.z, current.coords.w, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, current.scenario, true, true)
        current.pedHandle = ped
        if Config.UseTarget then
            local opts = nil
            if current.drivingschool then
                opts = {
                    label = 'Take Driving Lessons',
                    icon = 'fa-solid fa-car-side',
                    action = function()
                        -- TriggerServerEvent('qb-cityhall:server:sendDriverTest', Config.DrivingSchools[closestDrivingSchool].instructors)
                    end
                }
            elseif current.cityhall then
                opts = {
                    label = 'Open Cityhall',
                    icon = 'fa-solid fa-city',
                    action = function()
                        inRangeCityhall = true
                        setCityhallPageState(true, true)
                    end
                }
            end
            if opts then
                exports['qb-target']:AddTargetEntity(ped, {
                    options = {opts},
                    distance = 2.0
                })
            end
        else
            local options = current.zoneOptions
            if options then
                local zone = BoxZone:Create(current.coords.xyz, options.length, options.width, {
                    name = "zone_cityhall_"..ped,
                    heading = current.coords.w,
                    debugPoly = false,
                    minZ = current.coords.z - 3.0,
                    maxZ = current.coords.z + 2.0
                })
                zone:onPlayerInOut(function(inside)
                    if isLoggedIn and closestCityhall and closestDrivingSchool then
                        if inside then
                            if current.drivingschool then
                                inRangeDrivingSchool = true
                                exports['qb-core']:DrawText('[E] Take Driving Lessons')
                            elseif current.cityhall then
                                inRangeCityhall = true
                                exports['qb-core']:DrawText('[E] Open Cityhall')
                            end
                        else
                            exports['qb-core']:HideText()
                            if current.drivingschool then
                                inRangeDrivingSchool = false
                            elseif current.cityhall then
                                inRangeCityhall = false
                            end
                        end
                    end
                end)
            end
        end
    end
    pedsSpawned = true
end

local function deletePeds()
    if not Config.Peds or not next(Config.Peds) or not pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        if current.pedHandle then
            DeletePed(current.pedHandle)
        end
    end
    pedsSpawned = false
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    isLoggedIn = true
    spawnPeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    isLoggedIn = false
    deletePeds()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('qb-cityhall:client:getIds', function()
    TriggerServerEvent('qb-cityhall:server:getIDs')
end)

RegisterNetEvent('qb-cityhall:client:sendDriverEmail', function(charinfo)
    SetTimeout(math.random(2500, 4000), function()
        local gender = Lang:t('email.mr')
        if PlayerData.charinfo.gender == 1 then
            gender = Lang:t('email.mrs')
        end
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Lang:t('email.sender'),
            subject = Lang:t('email.subject'),
            message =  Lang:t('email.message', {gender = gender, lastname = charinfo.lastname, firstname = charinfo.firstname, phone = charinfo.phone}),
            button = {}
        })
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteBlips()
    deletePeds()
end)

-- NUI Callbacks

RegisterNUICallback('close', function(_, cb)
    setCityhallPageState(false, false)
    if not Config.UseTarget and inRangeCityhall then exports['qb-core']:DrawText('[E] Open Cityhall') end -- Reopen interaction when you're still inside the zone
    cb('ok')
end)

RegisterNUICallback('requestId', function(id, cb)
    local license = Config.Cityhalls[closestCityhall].licenses[id.type]
    if inRangeCityhall and license and id.cost == license.cost then
        TriggerServerEvent('qb-cityhall:server:requestId', id.type, closestCityhall)
        QBCore.Functions.Notify(('You have received your %s for $%s'):format(license.label, id.cost), 'success', 3500)
    else
        QBCore.Functions.Notify(Lang:t('error.not_in_range'), 'error')
    end
    cb('ok')
end)

RegisterNUICallback('requestLicenses', function(_, cb)
    local licensesMeta = PlayerData.metadata["licences"]
    local availableLicenses = table_clone(Config.Cityhalls[closestCityhall].licenses)
    for license, data in pairs(availableLicenses) do
        if data.metadata and not licensesMeta[data.metadata] then
            availableLicenses[license] = nil
        end
    end
    cb(availableLicenses)
end)

RegisterNUICallback('applyJob', function(job, cb)
    if inRangeCityhall then
        TriggerServerEvent('qb-cityhall:server:ApplyJob', job, Config.Cityhalls[closestCityhall].coords)
    else
        QBCore.Functions.Notify(Lang:t('error.not_in_range'), 'error')
    end
    cb('ok')
end)

-- Threads

CreateThread(function()
    while true do
        if isLoggedIn then
            playerPed = PlayerPedId()
            playerCoords = GetEntityCoords(playerPed)
            closestCityhall = getClosestHall()
            closestDrivingSchool = getClosestSchool()
        end
        Wait(1000)
    end
end)

CreateThread(function()
    initBlips()
    spawnPeds()
    QBCore.Functions.TriggerCallback('qb-cityhall:server:receiveJobs', function(result)
        SendNUIMessage({
            action = 'setJobs',
            jobs = result
        })
    end)
    if not Config.UseTarget then
        while true do
            local sleep = 1000
            if isLoggedIn and closestCityhall and closestDrivingSchool then
                if inRangeCityhall then
                    if not inCityhallPage then
                        sleep = 0
                        
                        if IsControlJustPressed(0, 38) then
                            setCityhallPageState(true, true)
                            exports['qb-core']:KeyPressed()
                            Wait(500)
                            exports['qb-core']:HideText()
                            sleep = 1000
                        end
                    end
                elseif inRangeDrivingSchool then
                    sleep = 0
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent('qb-cityhall:server:sendDriverTest', Config.DrivingSchools[closestDrivingSchool].instructors)
                        sleep = 5000
                        exports['qb-core']:KeyPressed()
                        Wait(500)
                        exports['qb-core']:HideText()
                    end
                end
            end
            Wait(sleep)
        end
    end
end)

CreateThread(function()
    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        inRange = false
        local inCloseRange = false

        local dist = #(pos - Config.Cityhalls[1].coords)
        local dist2 = #(pos - Config.DrivingSchools[1].coords)

        if dist < 20 then
            inRange = true
            DrawMarker(2, Config.BuyWeaponLicense.coords.x, Config.BuyWeaponLicense.coords.y, Config.BuyWeaponLicense.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 152, 234, 155, false, false, false, true, false, false, false)
            DrawMarker(2, Config.Cityhalls[1].coords.x, Config.Cityhalls[1].coords.y, Config.Cityhalls[1].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 152, 234, 155, false, false, false, true, false, false, false)
            if #(pos - vector3(Config.BuyWeaponLicense.coords.x, Config.BuyWeaponLicense.coords.y, Config.BuyWeaponLicense.coords.z)) < 1.5 then
                DrawText3Ds(Config.BuyWeaponLicense.coords, '~g~E~w~ - Obtain Weapons License Permission')
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('qb-cityhall:server:grantWeaponsLicense')
                end
            end
            if #(pos - Config.Cityhalls[1].coords) < 1.5 then
                DrawText3Ds(Config.Cityhalls[1].coords, '~g~E~w~ - Open City Services Menu')
                inCloseRange = true
                inRangeCityhall = true
                -- exports['qb-core']:DrawText('[E] Open Cityhall')
            end
        elseif dist2 < 20 then
            inRange = true
            DrawMarker(2, Config.DrivingSchools[1].coords.x, Config.DrivingSchools[1].coords.y, Config.DrivingSchools[1].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 152, 234, 155, false, false, false, true, false, false, false)
            if #(pos - Config.DrivingSchools[1].coords) < 1.5 then
                DrawText3Ds(Config.DrivingSchools[1].coords, '~g~E~w~ - Open Driving School')
                inCloseRange = true
                inRangeDrivingSchool = true
                -- exports['qb-core']:DrawText('[E] Take Driving Lessons')
            end
        end

        if not inCloseRange then
            exports['qb-core']:HideText()
            inRangeDrivingSchool = false
            inRangeCityhall = false
            if current and current.drivingschool then
                inRangeDrivingSchool = false
            elseif current and current.cityhall then
                inRangeCityhall = false
            end
        end

        if not inRange then
            Wait(1000)
            current = nil
        end



        Wait(2)
    end
end)

local function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end


function drawRectangle(width)
    -- BeginTextCommandDisplayHelp("STRING")
    -- AddTextComponentSubstringPlayerName(msg)
    -- EndTextCommandDisplayHelp(0, 0, 1, -1)
    if not fail then
        DrawRect(0.5, 0.1, width, 0.05, 100, 100, 255, 100)
    end
end

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

-- marker on ground to open first menu
Citizen.CreateThread(function()
    while true do 
        local sleep = 5000
        local pos = GetEntityCoords(PlayerPedId())
        if #(pos - Config.StartLocation) < 15 then
            sleep = 5
            DrawMarker(1, Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z - 1.02, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.9, 77, 181, 255, 0.8, false, false, 2,false, nil, nil, false)
            if #(pos - Config.StartLocation) < 2 then
                inRangeFlight = true
            else
                inRangeFlight = false
            end
            if inRangeFlight and not headerOpen then
                headerOpen = true
                
                exports['qb-menu']:showHeader({
                    {
                        header = 'Flight School',
                        txt = 'Open Menu',
                        params = {
                            event = "qb-flighttest:client:openMenu"
                        }
                    }
                })
            end
            if not inRangeFlight and headerOpen then
                headerOpen = false
                exports['qb-menu']:closeMenu()
            end

        end
        Wait(sleep)
    end
end)

RegisterNetEvent('qb-flighttest:client:openMenu', function()
    local menu = {
        {
            header = 'Flight School',
            isMenuHeader = true,
        },
        {
            header = 'Take Flight Test',
            txt = 'Plane Test: $250,000',
            params = {
                event = "qb-flighttest:client:takePlaneTest",
            }
        },
        {
            header = 'Take Helicopter Test',
            txt = 'Heli Test: $300,000',
            params = {
                event = "qb-flighttest:client:takeHeliTest",
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('qb-flighttest:client:takePlaneTest', function()
    QBCore.Functions.TriggerCallback('qb-flighttest:server:payFee', function(result)
        if result then
            -- print('begin test')
            takePlaneTest()
        else
            QBCore.Functions.Notify('You do not have enough money', 'error')
        end
    end, 250000)
end)

local function startTimer()
    local gameTimer = GetGameTimer()
    CreateThread(function()
        while CurrentTest == 'plane' or CurrentTest == 'heli' do
            if GetGameTimer() < gameTimer + tonumber(1000 * timeLeft) then
                local secondsLeft = GetGameTimer() - gameTimer
                drawTxt('Time Remaining: '..math.ceil(timeLeft - secondsLeft / 1000), 4, 0.5, 0.05, 0.50, 255, 255, 255, 180)
            else
                fail = true
            end
            Wait(0)
        end
    end)
end

RegisterNetEvent('qb-flighttest:client:takeHeliTest', function()
    QBCore.Functions.TriggerCallback('qb-flighttest:server:payFee', function(result)
        if result then
            -- print('begin test')
            takeHeliTest()
        else
            QBCore.Functions.Notify('You do not have enough money', 'error')
        end
    end, 300000)
end)

function takePlaneTest()
    QBCore.Functions.SpawnVehicle('mammatus', function(veh)
        local ped = PlayerPedId()
        TaskWarpPedIntoVehicle(ped, veh, -1)
        SetVehicleEngineOn(veh, true, true)
        -- SetVehicleFuelLevel(veh, 100.0 )
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        CurrentTest = 'plane'
        timeLeft = 45
        DrawMissionText('Taxi to the runway', 5000)
        Wait(5000)
        DrawMissionText('Follow the markers', 5000)
        fail = false
        startTimer()
    end, Config.PlaneSpawn, true)
end

function takeHeliTest()
    QBCore.Functions.SpawnVehicle('maverick', function(veh)
        local ped = PlayerPedId()
        TaskWarpPedIntoVehicle(ped, veh, -1)
        SetVehicleEngineOn(veh, true, true)
        -- SetVehicleFuelLevel(veh, 100.0 )
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        timeLeft = 60
        CurrentTest = 'heli'
        DrawMissionText('Follow the markers', 5000)
        startTimer()
        fail = false
    end, Config.PlaneSpawn, true)
end


-- Drive test
Citizen.CreateThread(function()
	while true do
        local sleep = 250

		if CurrentTest == 'plane' then
            -- if not fail then 
            --     DrawRect(0.5, 0.1, 0.5, 0.05, 255, 255, 200, 50)
            -- end
            sleep = 0
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.PlaneCheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				-- ESX.ShowNotification(_U('driving_test_complete'))
                -- print("test done")
                -- print(fail)
                local veh = GetVehiclePedIsIn(playerPed)
                if GetVehicleEngineHealth(veh) < 900.0 or GetVehicleBodyHealth(veh) < 900.0 or fail then
                    -- fail
                    QBCore.Functions.Notify("Looks like you failed this one")
                else 
                    -- give license
                    TriggerServerEvent('qb-flighttest:server:giveLicense', 'plane')
                end
                FreezeEntityPosition(veh, true)
                TaskLeaveVehicle(playerPed, veh, 1)
                Wait(5000)
                QBCore.Functions.DeleteVehicle(veh)

				-- if DriveErrors < Config.MaxErrors then
				-- 	StopDriveTest(true)
				-- else
				-- 	StopDriveTest(false)
				-- end
			else
				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.PlaneCheckPoints[nextCheckPoint].Pos.x, Config.PlaneCheckPoints[nextCheckPoint].Pos.y, Config.PlaneCheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end
                local distance = #(coords - Config.PlaneCheckPoints[nextCheckPoint].Pos)
				-- local distance = GetDistanceBetweenCoords(coords, Config.PlaneCheckPoints[nextCheckPoint].Pos.x, Config.PlaneCheckPoints[nextCheckPoint].Pos.y, Config.PlaneCheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 2000.0 then
					DrawMarker(6, Config.PlaneCheckPoints[nextCheckPoint].Pos.x, Config.PlaneCheckPoints[nextCheckPoint].Pos.y, Config.PlaneCheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 10.5, 10.5, 10.5, 102, 204, 102, 255, false, true, 2, false, false, false, false)
				end

				if distance <= 10.0 then
					Config.PlaneCheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end
            

		end

        if CurrentTest == 'heli' then
            -- DrawRect(0.5, 0.1, 0.5, 0.05, 255, 255, 200, 50)
            sleep = 0
            local playerPed      = PlayerPedId()
            local coords         = GetEntityCoords(playerPed)
            local nextCheckPoint = CurrentCheckPoint + 1

            if Config.HeliCheckPoints[nextCheckPoint] == nil then
                if DoesBlipExist(CurrentBlip) then
                    RemoveBlip(CurrentBlip)
                end

                CurrentTest = nil

                -- ESX.ShowNotification(_U('driving_test_complete'))
                -- print("test done")
                -- print(fail)
                local veh = GetVehiclePedIsIn(playerPed)
                if GetVehicleEngineHealth(veh) < 900.0 or GetVehicleBodyHealth(veh) < 900.0 then
                    -- fail
                else 
                    -- give license
                    TriggerServerEvent('qb-flighttest:server:giveLicense', 'heli')
                end
                FreezeEntityPosition(veh, true)
                TaskLeaveVehicle(playerPed, veh, 1)
                Wait(5000)
                QBCore.Functions.DeleteVehicle(veh)

                -- if DriveErrors < Config.MaxErrors then
                -- 	StopDriveTest(true)
                -- else
                -- 	StopDriveTest(false)
                -- end
            else
                if CurrentCheckPoint ~= LastCheckPoint then
                    if DoesBlipExist(CurrentBlip) then
                        RemoveBlip(CurrentBlip)
                    end

                    CurrentBlip = AddBlipForCoord(Config.HeliCheckPoints[nextCheckPoint].Pos.x, Config.HeliCheckPoints[nextCheckPoint].Pos.y, Config.HeliCheckPoints[nextCheckPoint].Pos.z)
                    SetBlipRoute(CurrentBlip, 1)

                    LastCheckPoint = CurrentCheckPoint
                end
                local distance = #(coords - Config.HeliCheckPoints[nextCheckPoint].Pos)
                -- local distance = GetDistanceBetweenCoords(coords, Config.HeliCheckPoints[nextCheckPoint].Pos.x, Config.HeliCheckPoints[nextCheckPoint].Pos.y, Config.HeliCheckPoints[nextCheckPoint].Pos.z, true)

                if distance <= 2000.0 then
                    DrawMarker(6, Config.HeliCheckPoints[nextCheckPoint].Pos.x, Config.HeliCheckPoints[nextCheckPoint].Pos.y, Config.HeliCheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 10.5, 10.5, 10.5, 102, 204, 102, 255, false, true, 2, false, false, false, false)
                end

                if distance <= 10.0 then
                    Config.HeliCheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
                    CurrentCheckPoint = CurrentCheckPoint + 1
                end
            end
        end

        -- not currently taking driver test
        Wait(sleep)
	end
end)

-- Citizen.CreateThread(function()
--     while true do 
--         local sleep = 5000
--         if CurrentTest == "plane" then
--             sleep = 0
--             -- 0.5 max
--             -- 0.0 min
--             -- 20000 ms * x = 0.5
--             timeLeft = timeLeft + 2
--             drawRectangle(0.5 - (timeLeft * 0.000025))
--             if 0.5 - (timeLeft * 0.000025) <= 0.0 then fail = true end
--         end
--         Wait(sleep)
--     end
-- end)