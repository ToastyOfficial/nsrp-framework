--[[------------------------------------------------------------------------

	ActionMenu - v1.0.1

------------------------------------------------------------------------]]--

-- Define the variable used to open/close the menu
local menuEnabled = false

-- AOP
local aop = nil
local aopText = nil

-- Markers
local markerDrawDistance = 30
local markerSize = 2.0
local sleep = 1000
local closestSpawner = nil

-- Other Variables


--[[------------------------------------------------------------------------
	ActionMenu Toggle
	Calling this function will open or close the ActionMenu.
------------------------------------------------------------------------]]--
function ToggleActionMenu()
	-- Make the menuEnabled variable not itself
	-- e.g. not true = false, not false = true
		menuEnabled = not menuEnabled

		if ( menuEnabled ) then
			-- Focuses on the NUI, the second parameter toggles the
			-- onscreen mouse cursor.
			SetNuiFocus( true, true )

			-- load vehicles
			local source = GetPlayerServerId(PlayerId())
			TriggerServerEvent('GetSaves', source)

			-- Sends a message to the JavaScript side, telling it to
			-- open the menu.
			SendNUIMessage({
				showmenu = true
			})
		else
			-- Bring the focus back to the game
			SetNuiFocus( false )

			-- Sends a message to the JavaScript side, telling it to
			-- close the menu.
			SendNUIMessage({
				hidemenu = true
			})
		end
end

function showNotification(message, type, time)
  TriggerEvent("pNotify:SendNotification", {
    text = message,
    type = type,
    timeout = time,
    layout = "centerLeft",
    animation = {
      open = "gta_effects_fade_in",
      close = "gta_effects_fade_out",
    },
  })
end

RegisterNetEvent('c:notification')
AddEventHandler('c:notification', function(message, type)
	showNotification(message, type, 5000)
end)

RegisterNetEvent('levelWarn')
AddEventHandler('levelWarn', function(levelNeeded)
	showNotification('You must be level ' .. levelNeeded .. " to spawn that.", 'error', 5000)
end)

RegisterNetEvent('noVehWarn')
AddEventHandler('noVehWarn', function(name)
	showNotification('Couldnt find ' .. levelNeeded .. " in your saved vehicles.", 'error', 5000)
end)

--[[ MARKERS / BLIPS]]

function makeBlip(x, y, z, sprite, color, name)

	local blip = AddBlipForCoord(x, y, z)

	SetBlipSprite(blip, sprite) -- Blip Sprite
	SetBlipColour(blip, color) -- Blip Color
	SetBlipAsShortRange(blip, true)


	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)

	return(blip)
end

function showAlert(message, playNotificationSound)
   SetTextComponentFormat('STRING')
   AddTextComponentString(message)
   DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end

--[[ SPAWNING VEHICLES ]]

-- get level for new spawning
function getVehicleData(name, level, coords, heading)
	local levelNeeded = level

	-- for k, v in  pairs(vehicles) do
	-- 	if v.spawn == name then
	-- 		levelNeeded = v.level
	-- 	 	break
	-- 	end
	-- end

	--print(levelNeeded)
	TriggerServerEvent('requestVehicle', GetPlayerServerId(PlayerId()), name, levelNeeded, coords, heading)
end

RegisterNetEvent('v:spawnVehicle')
AddEventHandler('v:spawnVehicle', function(name)
	local coords = closestSpawner.spawn
	local h = closestSpawner.h
	spawnVehicle(name, coords.x, coords.y, coords.z, h)
end)

function spawnVehicle(name, x, y, z, heading)

	-- if they are already in a vehicle, delete it
	if IsPedInAnyVehicle(PlayerPedId()) then
		local vehToDelete = GetVehiclePedIsIn(PlayerPedId())
		DeleteVehicle(vehToDelete)
	end

	-- load model
	model = GetHashKey(name)
	print("[spawnVehicle] Model: " .. model)
	RequestModel(model)
	print("[spawnVehicle] Name: " .. name)
	print("X: " .. x)
	print("Y: " .. y)
	print("Z: " .. z)
	print("H: " .. heading)
	-- wait for model to load
	while not HasModelLoaded(name) do
			Citizen.Wait(1000)
			print('loading')
	end
	-- spawn vehicle
	local vehicle = CreateVehicle(model, x, y, z, heading, true, true)
	print('created' .. vehicle)

	SetEntityAsMissionEntity(vehicle, true, true)
	SetModelAsNoLongerNeeded(model)

	SetPedIntoVehicle(playerId, vehicle, -1)

	return vehicle
end

function spawnVehicleByModel(model, x, y, z, heading)

	local model = tonumber(model)
	-- if they are already in a vehicle, delete it
	if IsPedInAnyVehicle(PlayerPedId()) then
		local vehToDelete = GetVehiclePedIsIn(PlayerPedId())
		DeleteVehicle(vehToDelete)
	end

	-- load model
	print("Model: " .. model)
	RequestModel(model)
	print("X: " .. x)
	print("Y: " .. y)
	print("Z: " .. z)
	print("H: " .. heading)
	-- wait for model to load
	while not HasModelLoaded(model) do
			Citizen.Wait(1000)
			print('loading')
	end
	-- spawn vehicle
	local vehicle = CreateVehicle(model, x, y, z, heading, true, true)
	print('created' .. vehicle)

	SetEntityAsMissionEntity(vehicle, true, true)
	SetModelAsNoLongerNeeded(model)

	SetPedIntoVehicle(playerId, vehicle, -1)

	return vehicle
end

--[[ VEHICLE SAVING SHIT]]

-- get vehicle data
function getVehicleProperties(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		-- local extras = {}

		-- for extraId=0, 12 do
		-- 	if DoesExtraExist(vehicle, extraId) then
		-- 		local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
		-- 		extras[tostring(extraId)] = state
		-- 	end
		-- end

		return {
			model             = GetEntityModel(vehicle),

			plate             = GetVehicleNumberPlateText(vehicle),

			color1            = colorPrimary,
			color2            = colorSecondary,

			wheels            = GetVehicleWheelType(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),

			modLivery         = GetVehicleLivery(vehicle),

			extra1 = not IsVehicleExtraTurnedOn(vehicle, 1),
			extra2 = not IsVehicleExtraTurnedOn(vehicle, 2),
			extra3 = not IsVehicleExtraTurnedOn(vehicle, 3),
			extra4 = not IsVehicleExtraTurnedOn(vehicle, 4),
			extra5 = not IsVehicleExtraTurnedOn(vehicle, 5),
			extra6 = not IsVehicleExtraTurnedOn(vehicle, 6),
			extra7 = not IsVehicleExtraTurnedOn(vehicle, 7),
			extra8 = not IsVehicleExtraTurnedOn(vehicle, 8),
			extra9 = not IsVehicleExtraTurnedOn(vehicle, 9),
			extra10 = not IsVehicleExtraTurnedOn(vehicle, 10),
			extra11 = not IsVehicleExtraTurnedOn(vehicle, 11),
			extra12 = not IsVehicleExtraTurnedOn(vehicle, 12),

			spoiler = GetVehicleMod(vehicle, 0),
			bumperF = GetVehicleMod(vehicle, 1),
			bumperR = GetVehicleMod(vehicle, 2),
			skirts = GetVehicleMod(vehicle, 3),
			exhaust = GetVehicleMod(vehicle, 4),
			grille = GetVehicleMod(vehicle, 6),
			hood  = GetVehicleMod(vehicle, 7),
			roof = GetVehicleMod(vehicle, 10)

		}
	else
		return
	end
end

-- function GetVehicleData(vehicle)
-- 	if DoesEntityExist(vehicle) then
-- 		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
-- 		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
-- 		local extras = {}
--
-- 		for extraId=0, 12 do
-- 			if DoesExtraExist(vehicle, extraId) then
-- 				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
-- 				extras[tostring(extraId)] = state
-- 			end
-- 		end
--
-- 		return {
-- 			model             = GetEntityModel(vehicle),
--
-- 			plate             = GetVehicleNumberPlateText(vehicle),
-- 			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
--
-- 			-- bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
-- 			-- engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),
-- 			-- tankHealth        = ESX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),
-- 			--
-- 			-- fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
-- 			-- dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
-- 			color1            = colorPrimary,
-- 			color2            = colorSecondary,
--
-- 			pearlescentColor  = pearlescentColor,
-- 			wheelColor        = wheelColor,
--
-- 			wheels            = GetVehicleWheelType(vehicle),
-- 			windowTint        = GetVehicleWindowTint(vehicle),
-- 			xenonColor        = GetVehicleXenonLightsColour(vehicle),
--
-- 			neonEnabled       = {
-- 				IsVehicleNeonLightEnabled(vehicle, 0),
-- 				IsVehicleNeonLightEnabled(vehicle, 1),
-- 				IsVehicleNeonLightEnabled(vehicle, 2),
-- 				IsVehicleNeonLightEnabled(vehicle, 3)
-- 			},
--
-- 			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
-- 			extras            = extras,
-- 			-- tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),
--
-- 			modSpoilers       = GetVehicleMod(vehicle, 0),
-- 			modFrontBumper    = GetVehicleMod(vehicle, 1),
-- 			modRearBumper     = GetVehicleMod(vehicle, 2),
-- 			modSideSkirt      = GetVehicleMod(vehicle, 3),
-- 			modExhaust        = GetVehicleMod(vehicle, 4),
-- 			modFrame          = GetVehicleMod(vehicle, 5),
-- 			modGrille         = GetVehicleMod(vehicle, 6),
-- 			modHood           = GetVehicleMod(vehicle, 7),
-- 			modFender         = GetVehicleMod(vehicle, 8),
-- 			modRightFender    = GetVehicleMod(vehicle, 9),
-- 			modRoof           = GetVehicleMod(vehicle, 10),
--
-- 			modEngine         = GetVehicleMod(vehicle, 11),
-- 			modBrakes         = GetVehicleMod(vehicle, 12),
-- 			modTransmission   = GetVehicleMod(vehicle, 13),
-- 			modHorns          = GetVehicleMod(vehicle, 14),
-- 			modSuspension     = GetVehicleMod(vehicle, 15),
-- 			modArmor          = GetVehicleMod(vehicle, 16),
--
-- 			modTurbo          = IsToggleModOn(vehicle, 18),
-- 			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
-- 			modXenon          = IsToggleModOn(vehicle, 22),
--
-- 			modFrontWheels    = GetVehicleMod(vehicle, 23),
-- 			modBackWheels     = GetVehicleMod(vehicle, 24),
--
-- 			modPlateHolder    = GetVehicleMod(vehicle, 25),
-- 			modVanityPlate    = GetVehicleMod(vehicle, 26),
-- 			modTrimA          = GetVehicleMod(vehicle, 27),
-- 			modOrnaments      = GetVehicleMod(vehicle, 28),
-- 			modDashboard      = GetVehicleMod(vehicle, 29),
-- 			modDial           = GetVehicleMod(vehicle, 30),
-- 			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
-- 			modSeats          = GetVehicleMod(vehicle, 32),
-- 			modSteeringWheel  = GetVehicleMod(vehicle, 33),
-- 			modShifterLeavers = GetVehicleMod(vehicle, 34),
-- 			modAPlate         = GetVehicleMod(vehicle, 35),
-- 			modSpeakers       = GetVehicleMod(vehicle, 36),
-- 			modTrunk          = GetVehicleMod(vehicle, 37),
-- 			modHydrolic       = GetVehicleMod(vehicle, 38),
-- 			modEngineBlock    = GetVehicleMod(vehicle, 39),
-- 			modAirFilter      = GetVehicleMod(vehicle, 40),
-- 			modStruts         = GetVehicleMod(vehicle, 41),
-- 			modArchCover      = GetVehicleMod(vehicle, 42),
-- 			modAerials        = GetVehicleMod(vehicle, 43),
-- 			modTrimB          = GetVehicleMod(vehicle, 44),
-- 			modTank           = GetVehicleMod(vehicle, 45),
-- 			modWindows        = GetVehicleMod(vehicle, 46),
-- 			modLivery         = GetVehicleLivery(vehicle)
-- 		}
-- 	else
-- 		return
-- 	end
-- end

-- set vehicle data
function SetVehicleProperties(vehicle, model, plate, color1, color2, livery, wheel_type, wheels_f, e_1, e_2, e_3, e_4, e_5, e_6, e_7, e_8, e_9, e_10, e_11, e_12, spoiler, bumper_f, bumper_r, exhaust, grille, hood, roof)

	CreateThread( function()
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if plate then SetVehicleNumberPlateText(vehicle, plate) end
		-- if data.bodyHealth then SetVehicleBodyHealth(vehicle, data.bodyHealth + 0.0) end
		-- if data.engineHealth then SetVehicleEngineHealth(vehicle, data.engineHealth + 0.0) end
		-- if data.tankHealth then SetVehiclePetrolTankHealth(vehicle, data.tankHealth + 0.0) end
		-- if data.fuelLevel then SetVehicleFuelLevel(vehicle, data.fuelLevel + 0.0) end
		-- if data.dirtLevel then SetVehicleDirtLevel(vehicle, data.dirtLevel + 0.0) end
		if color1 then SetVehicleColours(vehicle, color1, colorSecondary) end
		if color2 then SetVehicleColours(vehicle, color1 or colorPrimary, color2) end
		if wheel_type then SetVehicleWheelType(vehicle, wheel_type) end

		print("1: " .. e_1)
		print("2: " .. e_2)
		print("3: " .. e_3)
		print("4: " .. e_4)
		print("5: " .. e_5)
		print("6: " .. e_6)
		print("7: " .. e_7)
		print("8: " .. e_8)
		print("9: " .. e_9)
		print("10: " .. e_10)
		print("11: " .. e_11)
		print("12: " .. e_12)

		SetVehicleExtra(vehicle, 1, e_1)
		SetVehicleExtra(vehicle, 2, e_2)
		SetVehicleExtra(vehicle, 3, e_3)
		SetVehicleExtra(vehicle, 4, e_4)
		SetVehicleExtra(vehicle, 5, e_5)
		SetVehicleExtra(vehicle, 6, e_6)
		SetVehicleExtra(vehicle, 7, e_7)
		SetVehicleExtra(vehicle, 8, e_8)
		SetVehicleExtra(vehicle, 9, e_9)
		SetVehicleExtra(vehicle, 10, e_10)
		SetVehicleExtra(vehicle, 11, e_11)
		SetVehicleExtra(vehicle, 12, e_12)

		SetVehicleMod(vehicle, 11, 3, false)
		SetVehicleMod(vehicle, 12, 2, false)
		SetVehicleMod(vehicle, 13, 2, false)

		SetVehicleMod(vehicle, 0, spoiler, false)
		SetVehicleMod(vehicle, 1, bumper_f, false)
		SetVehicleMod(vehicle, 2, bumper_r, false)
		SetVehicleMod(vehicle, 4, exhaust, false)
		SetVehicleMod(vehicle, 6, grille, false)
		SetVehicleMod(vehicle, 7, hood, false)
		SetVehicleMod(vehicle, 10, roof, false)


		if wheels_f then SetVehicleMod(vehicle, 23, wheels_f, false) end

		if livery then
			SetVehicleMod(vehicle, 48, livery, false)
			SetVehicleLivery(vehicle, livery)
		end
	end
	end)
end

-- function SetVehicleData(vehicle, data)
-- 	if DoesEntityExist(vehicle) then
-- 		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
-- 		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
-- 		SetVehicleModKit(vehicle, 0)
--
-- 		if data.plate then SetVehicleNumberPlateText(vehicle, data.plate) end
-- 		if data.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, data.plateIndex) end
-- 		-- if data.bodyHealth then SetVehicleBodyHealth(vehicle, data.bodyHealth + 0.0) end
-- 		-- if data.engineHealth then SetVehicleEngineHealth(vehicle, data.engineHealth + 0.0) end
-- 		-- if data.tankHealth then SetVehiclePetrolTankHealth(vehicle, data.tankHealth + 0.0) end
-- 		-- if data.fuelLevel then SetVehicleFuelLevel(vehicle, data.fuelLevel + 0.0) end
-- 		-- if data.dirtLevel then SetVehicleDirtLevel(vehicle, data.dirtLevel + 0.0) end
-- 		if data.color1 then SetVehicleColours(vehicle, data.color1, colorSecondary) end
-- 		if data.color2 then SetVehicleColours(vehicle, data.color1 or colorPrimary, data.color2) end
-- 		if data.pearlescentColor then SetVehicleExtraColours(vehicle, data.pearlescentColor, wheelColor) end
-- 		if data.wheelColor then SetVehicleExtraColours(vehicle, data.pearlescentColor or pearlescentColor, data.wheelColor) end
-- 		if data.wheels then SetVehicleWheelType(vehicle, data.wheels) end
-- 		if data.windowTint then SetVehicleWindowTint(vehicle, data.windowTint) end
--
-- 		if data.neonEnabled then
-- 			SetVehicleNeonLightEnabled(vehicle, 0, data.neonEnabled[1])
-- 			SetVehicleNeonLightEnabled(vehicle, 1, data.neonEnabled[2])
-- 			SetVehicleNeonLightEnabled(vehicle, 2, data.neonEnabled[3])
-- 			SetVehicleNeonLightEnabled(vehicle, 3, data.neonEnabled[4])
-- 		end
--
-- 		if data.extras then
-- 			for extraId,enabled in pairs(data.extras) do
-- 				if enabled then
-- 					SetVehicleExtra(vehicle, tonumber(extraId), 0)
-- 				else
-- 					SetVehicleExtra(vehicle, tonumber(extraId), 1)
-- 				end
-- 			end
-- 		end
--
-- 		if data.neonColor then SetVehicleNeonLightsColour(vehicle, data.neonColor[1], data.neonColor[2], data.neonColor[3]) end
-- 		if data.xenonColor then SetVehicleXenonLightsColour(vehicle, data.xenonColor) end
-- 		if data.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
-- 		-- if data.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, data.tyreSmokeColor[1], data.tyreSmokeColor[2], data.tyreSmokeColor[3]) end
-- 		if data.modSpoilers then SetVehicleMod(vehicle, 0, data.modSpoilers, false) end
-- 		if data.modFrontBumper then SetVehicleMod(vehicle, 1, data.modFrontBumper, false) end
-- 		if data.modRearBumper then SetVehicleMod(vehicle, 2, data.modRearBumper, false) end
-- 		if data.modSideSkirt then SetVehicleMod(vehicle, 3, data.modSideSkirt, false) end
-- 		if data.modExhaust then SetVehicleMod(vehicle, 4, data.modExhaust, false) end
-- 		if data.modFrame then SetVehicleMod(vehicle, 5, data.modFrame, false) end
-- 		if data.modGrille then SetVehicleMod(vehicle, 6, data.modGrille, false) end
-- 		if data.modHood then SetVehicleMod(vehicle, 7, data.modHood, false) end
-- 		if data.modFender then SetVehicleMod(vehicle, 8, data.modFender, false) end
-- 		if data.modRightFender then SetVehicleMod(vehicle, 9, data.modRightFender, false) end
-- 		if data.modRoof then SetVehicleMod(vehicle, 10, data.modRoof, false) end
-- 		if data.modEngine then SetVehicleMod(vehicle, 11, data.modEngine, false) end
-- 		if data.modBrakes then SetVehicleMod(vehicle, 12, data.modBrakes, false) end
-- 		if data.modTransmission then SetVehicleMod(vehicle, 13, data.modTransmission, false) end
-- 		if data.modHorns then SetVehicleMod(vehicle, 14, data.modHorns, false) end
-- 		if data.modSuspension then SetVehicleMod(vehicle, 15, data.modSuspension, false) end
-- 		if data.modArmor then SetVehicleMod(vehicle, 16, data.modArmor, false) end
-- 		if data.modTurbo then ToggleVehicleMod(vehicle,  18, data.modTurbo) end
-- 		if data.modXenon then ToggleVehicleMod(vehicle,  22, data.modXenon) end
-- 		if data.modFrontWheels then SetVehicleMod(vehicle, 23, data.modFrontWheels, false) end
-- 		if data.modBackWheels then SetVehicleMod(vehicle, 24, data.modBackWheels, false) end
-- 		if data.modPlateHolder then SetVehicleMod(vehicle, 25, data.modPlateHolder, false) end
-- 		if data.modVanityPlate then SetVehicleMod(vehicle, 26, data.modVanityPlate, false) end
-- 		if data.modTrimA then SetVehicleMod(vehicle, 27, data.modTrimA, false) end
-- 		if data.modOrnaments then SetVehicleMod(vehicle, 28, data.modOrnaments, false) end
-- 		if data.modDashboard then SetVehicleMod(vehicle, 29, data.modDashboard, false) end
-- 		if data.modDial then SetVehicleMod(vehicle, 30, data.modDial, false) end
-- 		if data.modDoorSpeaker then SetVehicleMod(vehicle, 31, data.modDoorSpeaker, false) end
-- 		if data.modSeats then SetVehicleMod(vehicle, 32, data.modSeats, false) end
-- 		if data.modSteeringWheel then SetVehicleMod(vehicle, 33, data.modSteeringWheel, false) end
-- 		if data.modShifterLeavers then SetVehicleMod(vehicle, 34, data.modShifterLeavers, false) end
-- 		if data.modAPlate then SetVehicleMod(vehicle, 35, data.modAPlate, false) end
-- 		if data.modSpeakers then SetVehicleMod(vehicle, 36, data.modSpeakers, false) end
-- 		if data.modTrunk then SetVehicleMod(vehicle, 37, data.modTrunk, false) end
-- 		if data.modHydrolic then SetVehicleMod(vehicle, 38, data.modHydrolic, false) end
-- 		if data.modEngineBlock then SetVehicleMod(vehicle, 39, data.modEngineBlock, false) end
-- 		if data.modAirFilter then SetVehicleMod(vehicle, 40, data.modAirFilter, false) end
-- 		if data.modStruts then SetVehicleMod(vehicle, 41, data.modStruts, false) end
-- 		if data.modArchCover then SetVehicleMod(vehicle, 42, data.modArchCover, false) end
-- 		if data.modAerials then SetVehicleMod(vehicle, 43, data.modAerials, false) end
-- 		if data.modTrimB then SetVehicleMod(vehicle, 44, data.modTrimB, false) end
-- 		if data.modTank then SetVehicleMod(vehicle, 45, data.modTank, false) end
-- 		if data.modWindows then SetVehicleMod(vehicle, 46, data.modWindows, false) end
--
-- 		if data.modLivery then
-- 			SetVehicleMod(vehicle, 48, data.modLivery, false)
-- 			SetVehicleLivery(vehicle, data.modLivery)
-- 		end
-- 	end
-- end

RegisterNetEvent('receiveSaves')
AddEventHandler('receiveSaves', function(savedNames)
	local savedNames = savedNames

	-- for each saved vehicle send a message to create button and print name in console
	for k, v in pairs(savedNames) do
		SendNUIMessage({
			action = 'popSaves',
			name = v.name
		})
		print("Saved vehicle " .. k .. ': ' ..v.name)
	end

	-- send saves to NUI
end)

RegisterNetEvent('spawnFromSave')
AddEventHandler('spawnFromSave', function(model, plate, color1, color2, livery, wheel_type, wheels_f, e_1, e_2, e_3, e_4, e_5, e_6, e_7, e_8, e_9, e_10, e_11, e_12, spoiler, bumper_f, bumper_r, exhaust, grille, hood, roof)
	CreateThread(function()
		local coords = closestSpawner.spawn
		local vehicle = spawnVehicleByModel(model, coords.x, coords.y, coords.z, closestSpawner.h)
		Wait(1000)
		SetVehicleProperties(vehicle, model, plate, color1, color2, livery, wheel_type, wheels_f, e_1, e_2, e_3, e_4, e_5, e_6, e_7, e_8, e_9, e_10, e_11, e_12, spoiler, bumper_f, bumper_r, exhaust, grille, hood, roof)
	end)
end)
--[[------------------------------------------------------------------------
	ActionMenu HTML Callbacks
	This will be called every single time the JavaScript side uses the
	sendData function. The name of the data-action is passed as the parameter
	variable data.
------------------------------------------------------------------------]]--

RegisterNUICallback( "VehClick", function( data, cb )
	local name = data[1]
	local lvl = data[2]
	--local cat = json.encode( cdata )
	print(name)
	print(lvl)
	--print(cat)

	-- start process of checking player can spawn vehicle
	getVehicleData(name, lvl)

	-- This will only be called if any button other than the exit button is pressed
	ToggleActionMenu()
end)

RegisterNUICallback( "ButtonClick", function( data, cb )

	local result = nil

	if ( data == "b_save" ) then
		local vehToSave = GetVehiclePedIsIn(PlayerPedId())
		print('Save button pressed.')

		local plate = GetVehicleNumberPlateText(vehToSave)
		local vehicleData = getVehicleProperties(vehToSave)
		print(vehicleData)

		ToggleActionMenu()
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
		    while (UpdateOnscreenKeyboard() == 0) do
		        DisableAllControlActions(0);
		        Wait(0);
		    end
		    if (GetOnscreenKeyboardResult()) then
		        result = GetOnscreenKeyboardResult()
		    end

		TriggerServerEvent('saveVehicle', GetPlayerServerId(PlayerId()), plate, result, vehicleData)

	elseif ( data == "b_fix" ) then
		-- repair vehicle
		if IsPedInAnyVehicle(PlayerPedId()) then

			exports.v_failure:failureRepair()

			local vehToFix = GetVehiclePedIsIn(PlayerPedId())
			SetVehicleFixed(vehToFix) -- Repair
			SetVehicleEngineHealth(vehToFix, 1000) -- Revive engine

			SetVehicleTyreFixed(vehToFix, 0)	-- Fix tires
			SetVehicleTyreFixed(vehToFix, 1)
			SetVehicleTyreFixed(vehToFix, 2)
			SetVehicleTyreFixed(vehToFix, 3)
			SetVehicleTyreFixed(vehToFix, 4)
			SetVehicleTyreFixed(vehToFix, 5)
			SetVehicleTyreFixed(vehToFix, 45)
			SetVehicleTyreFixed(vehToFix, 47)

			SetVehicleDirtLevel(vehToFix, 0) -- Clean Vehicle

			-- Place
			SetEntityHeading(PlayerPedId(), closestSpawner.h)
			SetPedCoordsKeepVehicle(PlayerPedId(), closestSpawner.spawn)

		else
			-- show error if not in vehicle
		end

	elseif ( data == "b_delSave" ) then
		showNotification('Type /deleteSave [Save Name] to delete a save!', 'info', 5000)

		-- We toggle the ActionMenu and return here, otherwise the function
		-- call below would be executed too, which would just open the menu again
		ToggleActionMenu()
		return
	end

	-- This will only be called if any button other than the exit button is pressed
	ToggleActionMenu()
end )

RegisterNUICallback( "ExtraClick", function( data, cb)
	-- EXTRAS

	if ( data == "e_1" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 1) then
		SetVehicleExtra(vehicle, 1, true)
		else
			SetVehicleExtra(vehicle, 1, false)
		end

	elseif ( data == "e_2" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 2) then
		SetVehicleExtra(vehicle, 2, true)
		else
			SetVehicleExtra(vehicle, 2, false)
		end

	elseif ( data == "e_3" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 3) then
		SetVehicleExtra(vehicle, 3, true)
		else
			SetVehicleExtra(vehicle, 3, false)
		end


	elseif ( data == "e_4" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 4) then
		SetVehicleExtra(vehicle, 4, true)
		else
			SetVehicleExtra(vehicle, 4, false)
		end

	elseif ( data == "e_5" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 5) then
		SetVehicleExtra(vehicle, 5, true)
		else
			SetVehicleExtra(vehicle, 5, false)
		end

	elseif ( data == "e_6" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 6) then
		SetVehicleExtra(vehicle, 6, true)
		else
			SetVehicleExtra(vehicle, 6, false)
		end

	elseif ( data == "e_7" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 7) then
		SetVehicleExtra(vehicle, 7, true)
		else
			SetVehicleExtra(vehicle, 7, false)
		end

	elseif ( data == "e_8" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 8) then
		SetVehicleExtra(vehicle, 8, true)
		else
			SetVehicleExtra(vehicle, 8, false)
		end

	elseif ( data == "e_9" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 9) then
		SetVehicleExtra(vehicle, 9, true)
		else
			SetVehicleExtra(vehicle, 9, false)
		end

	elseif ( data == "e_10" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 10) then
		SetVehicleExtra(vehicle, 10, true)
		else
			SetVehicleExtra(vehicle, 10, false)
		end

	elseif ( data == "e_11" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 11) then
		SetVehicleExtra(vehicle, 11, true)
		else
			SetVehicleExtra(vehicle, 11, false)
		end

	elseif ( data == "e_12" ) then

		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsVehicleExtraTurnedOn(vehicle --[[ Vehicle ]], 12) then
		SetVehicleExtra(vehicle, 12, true)
		else
			SetVehicleExtra(vehicle, 12, false)
		end
	end
end )

RegisterNUICallback( "SaveClick", function( name, cb )
	print("Saved vehicle was pressed: " .. name)
	ToggleActionMenu()
	TriggerServerEvent('getVehicleFromData', GetPlayerServerId(PlayerId()), name)
	-- This will only be called if any button other than the exit button is pressed
	-- ToggleActionMenu()
end)

--[[------------------------------------------------------------------------
	ActionMenu Control and Input Blocking
	This is the main while loop that opens the ActionMenu on keypress. It
	uses the input blocking found in the ES Banking resource, credits to
	the authors.
------------------------------------------------------------------------]]--

--[[ ---------------------------------------------
-------------- COMMANDS AND EVENTS----------------
]]------------------------------------------------


--[[--------------------------------------------------
				THREADS
-----------------------------------------------------]]
-- Menu thread (disables controls)
Citizen.CreateThread( function()
	-- This is just in case the resources restarted whilst the NUI is focused.
	SetNuiFocus( false )

	while true do
	    if ( menuEnabled ) then
            local ped = GetPlayerPed( -1 )

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride
        end
		Citizen.Wait( 0 )
	end
end )

-- Populate menu thread
-- CreateThread( function()
-- 	-- on menu load
-- end)

-- Markers thread
CreateThread(function()
	-- Draw Blips
	for k, v in pairs(spawners) do
		makeBlip(v.marker.x, v.marker.y, 0, 473, 11, 'Vehicle Spawner')
	end

	while true do
		Wait(sleep)
		playerId = PlayerPedId()

		local playerCoordinates = GetEntityCoords(playerId)

		-- Find closest spawner
		local lastDistance = 9999
		closestSpawner = nil

			for k, v in pairs(spawners) do
			local distance = GetDistanceBetweenCoords(playerCoordinates, v.marker)

				if distance < lastDistance then
					lastDistance = distance
					--print(lastDistance)
					closestSpawner = v
				end
			end

		-- Check distance of player from closest spawner
		local distanceFromMarker = GetDistanceBetweenCoords(playerCoordinates, closestSpawner.marker, false)
		--print("Distance from closest marker: ".. distanceFromMarker)

		if distanceFromMarker < markerDrawDistance then
			-- check/do every frame
			sleep = 0
			-- draw marker
			DrawMarker(36, closestSpawner.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize, markerSize, markerSize, 95, 112, 185, 100, false, false, 2, true, nil, nil, false)
			-- is player within marker (based on marker size)?
			if distanceFromMarker < markerSize then
				showAlert('Press ~INPUT_PICKUP~ to spawn a vehicle.', true)
				if IsControlJustReleased(0, 38) then
					ToggleActionMenu()
				end
			end
		else
		-- if not close enough only check every second
			sleep = 1000
		end
	end
end)

function chatPrint( msg )
	TriggerEvent( 'chatMessage', "ActionMenu", { 255, 255, 255 }, msg )
end

function returnClosestSpawner()
	return closestSpawner
end

-- Tell JS player's level every 5 seconds
CreateThread(function()
	while true do
		local pLevel = exports.nsrp_xp:getLevel()
		Wait(100)
		SendNUIMessage({
			type = 'updateLevel',
			level = pLevel
		})
		Wait(4900)
	end
end)
