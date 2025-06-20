-- Variable to keep track of the player's cuffed state.
local cuffed = false
local cuffer = GetPlayerPed(-1)

-- local player = Entity(PlayerPedId())
-- player.state.set('cuffed', 0, true)

local cuffRange = 1.1

-- Creating variables for the animation and dictionary names
-- Saves a lot of trouble when these animation/dictionary names never change anyway.
local dict = "mp_arresting"
local anim = "idle"

-- Set the animation flag to 49, this will make it only show on the upper part of
-- the body, thus not affecting player's legs (movement).
local flags = 49

-- Creating variable to be used/updated throughout the script.
ped = PlayerPedId()


-- This variable is used to keep track of changes in the cuffed state.
-- Needed to make sure certain checks are only ran once but should still
-- be in a timer/loop.
local changed = false

-- Set the default MP ped's "teeth" skin variations for male/female MP ped.
-- This is done so we can switch to the handcuffs (if the ped is MP male/female model)
-- when the ped gets cuffed, and switch back to whatever their previous "teeth"
-- skin customization was. Due to different amount of total skin variations for male/female
-- peds, 2 variables are needed to keep track of both.
local prevMaleVariation = 0
local prevFemaleVariation = 0

-- Loading the hashes for female/male MP peds once.
local femaleHash = GetHashKey("mp_f_freemode_01")
local maleHash = GetHashKey("mp_m_freemode_01")

-- Event: "anim:cuff" used to toggle between cuffed/uncuffed state.
-- Server scripts can trigger this event.
-- local function getClosestPlayerId()
-- 	local playerPed = PlayerPedId()
--   local playerLoc = GetEntityCoords(playerPed)
--
--   local target = nil
--   local activePlayers = GetActivePlayers()
--   local lastDistance = 999
-- 	local distance = nil
--
--   for k, v in ipairs(activePlayers) do
--
--     local targetPed = GetPlayerPed(v)
--     local targetLoc = GetEntityCoords(targetPed)
--
-- 		print("Player Ped: "  .. playerPed)
-- 		print("Target Ped: " .. targetPed)
--
-- 		if targetPed ~= playerPed then
-- 			print("Loop: " .. k)
-- 			print("Target ID: " .. GetPlayerServerId(v))
-- 			print("Player Location: " .. playerLoc)
-- 			print("Target Location: " .. targetLoc)
--
-- 			distance = GetDistanceBetweenCoords(playerLoc, targetLoc)
--
-- 			print("LastDistance: ".. lastDistance)
-- 			print("Distance: " ..distance)
-- 			if distance < lastDistance then
-- 				lastDistance = distance
-- 				print("Was less")
-- 				target = GetPlayerServerId(v)
-- 			end
-- 		end
--   end
-- 	return target, lastDistance
-- end
--
--
-- RegisterKeyMapping('cuffkey', "Cuff (While shift pressed)", 'keyboard', 'F')
-- RegisterCommand('cuffkey', function()
-- 	if IsControlPressed(0, 21) then
--     ExecuteCommand('cuff')
--   end
-- end)
--
-- RegisterCommand('cuff', function()
--
-- 	local target, lastDistance = getClosestPlayerId()
-- 	print(target)
-- 	print(lastDistance)
--
--   --print("Target " .. target)
-- 	print("End target: " .. target)
-- 	if lastDistance < cuffRange then
--   	TriggerServerEvent('cuff', target)
-- 	else
-- 		print('too far')
-- 	end
-- end, false)
--
-- RegisterNetEvent('pc:cuffMe')
-- AddEventHandler('pc:cuffMe', function(target)
--
-- 	print("Cuff triggered")
--   local ped = PlayerPedId()
--
--   --ped = PlayerPedId()
--
-- 	--print (cuffer)
-- 	--print (ped)
--   if ped then
--
--     -- Load the animation dictionary.
--     RequestAnimDict(dict)
--     -- If it's not loaded (yet), wait until it's done loading.
--     while not HasAnimDictLoaded(dict) do
--         Citizen.Wait(0)
--     end
--     -- If the player is cuffed, then we want to uncuff them.
--     if cuffed then
-- 			-- local player = Entity(PlayerPedId())
-- 	    -- player.state.set('cuffed', 0, true)
--
--         -- Remove the "cuffed" task/animation.
--         ClearPedTasks(ped)
--         -- Re-enable the weapons wheel/starting of vehicles.
--         SetEnableHandcuffs(ped, false)
--         -- Not sure if this is needed, but I'm adding it anyway in case the option
--         -- above didn't change the ped's cuff state for some reason.
--         UncuffPed(ped)
--         -- If the ped is the MP female ped, remove the handcuffs from the player
--         -- model and set it back to whatever the previous value was.
--         if GetEntityModel(ped) == femaleHash then -- mp female
--             SetPedComponentVariation(ped, 7, prevFemaleVariation, 0, 0)
--         -- If it's not the MP female model, check for the MP male model instead.
--         -- If that's the case, do the same thing but instead of resetting it to the
--         -- female's previous style, set it to the male's previous style.
--         elseif GetEntityModel(ped) == maleHash then -- mp male
--             SetPedComponentVariation(ped, 7, prevMaleVariation, 0, 0)
--         end
--
--     -- If the player wasn't cuffed before, we want to cuff them now.
--     else
-- 			-- local player = Entity(PlayerPedId())
-- 	    -- player.state.set('cuffed', 1, true)
--         -- If it's the female MP model, set the previous skin variation to the
--         -- currently used values (this value will be used later when uncuffing)
--         -- Next, enable the handcuff models.
--         -- if GetEntityModel(ped) == femaleHash then -- mp female
--         --     prevFemaleVariation = GetPedDrawableVariation(ped, 7)
--         --     SetPedComponentVariation(ped, 7, 25, 0, 0)
--         -- -- If it's the male MP model, do the same thing as above, but for the Male ped instead.
--         -- elseif GetEntityModel(ped) == maleHash then -- mp male
--         --     prevMaleVariation = GetPedDrawableVariation(ped, 7)
--         --     SetPedComponentVariation(ped, 7, 41, 0, 0)
--         -- end
--         -- Enable handcuffs using the native. This makes it so you can't start a
--         -- vehicle if the engine is off and you're handcuffed. You can also not pull out any
--         -- weapons when on foot. In a vehicle this is broken however so more attack/weapon
--         -- prevention checks are done in a loop further down in the script.
--         SetEnableHandcuffs(ped, true)
--         -- Enable the handcuffed animation using the ped, dict, anim and flags variables (defined above).
-- 				print(dict)
-- 				print(anim)
-- 				print(ped)
--         TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
--     end
--     -- Change the cuffed state to be the inverse of the previous state.
--     cuffed = not cuffed
--     -- Set changed to true, this is used for something that is only ran once but still needs to be in a slow loop.
--     changed = true
--   else
--     print('Could not find a nearby ped')
--   end
-- end)

RegisterNetEvent('seat')
AddEventHandler('seat', function()

	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)

	if vehicleHandle ~= nil then
		SetPedIntoVehicle(GetPlayerPed(-1), vehicleHandle, 1)
	end
end)

RegisterNetEvent('unseat')
AddEventHandler('unseat', function(target)

  local playerPed = PlayerPedId()
  local playerLoc = GetEntityCoords(playerPed)

  local target = nil
  local activePlayers = GetActivePlayers()
  local lastDistance = 999

  for _, targetId in ipairs(activePlayers) do

    local targetPed = GetPlayerPed(targetId)
    local targetLoc = GetEntityCoords(targetPed)
    print("Player coords " .. playerLoc)
    print("Target coords " .. targetLoc)
    local distance = #(playerLoc - targetLoc)
    print("Distance: " .. distance)

    if distance < lastDistance then
      target = targetId
    end
  end

	ClearPedTasksImmediately(target)
	playerLoc = GetEntityCoords(GetPlayerPed(-1),  true)
	local xnew = playerLoc.x-2
	local ynew = playerLoc.y-2

	SetEntityCoords(GetPlayerPed(-1), xnew, ynew, playerLoc.z)
end)

-- Create the slow loop. This will check every 500ms if the player's state is "cuffed".
-- If that's the case, then it makes sure the animation is playing properly.
Citizen.CreateThread(function()
    while true do
        -- This doesn't have to be run every frame, so a 500ms delay is good enough.
        Citizen.Wait(1000)
				--print("slow loop")

        -- If changed is false (the status hasn't been changed recently) check if the
        -- ped is currently cuffed. If so, check if the player is NOT playing the animation
        -- if it is NOT playing it, and it should be (according to the cuffed state variable)
        -- Wait 500ms and play the animation again.
        --if not changed then
            -- Resetting the ped to the current player ped again (buggy shit be buggy)
            local ped = PlayerPedId()

            -- Check if the player is cuffed according to the native IsPlayerCuffed()
            -- Which returns true if you ran SetEnableHandcuffs(ped, true).
            -- Returns false if that function hasn't been called or if the UncuffPed()
            -- function was called (or SetEnableHandcuffs(ped, false)).


            if cuffed and not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) then
							print('true')
                -- Wait 500ms before playing/setting the cuffed animation again.
                Citizen.Wait(500)
                TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
            end

        -- If the player's cuff state has been changed in the past 500ms then don't run the code above,
        -- instead set the changed value to false, and continue the loop. This will add another 500ms
        -- before this check is ran again to make sure that the cuff animation has time to start.
        -- If we didn't do this, the player would glitch out a lot because the animation never had time
        -- to start 100% before being re-tasked to re-start the animation.
        --else
            --changed = false
        --end
    end
end)


-- Create another loop, this one has to be ran every tick.
Citizen.CreateThread(function()
  while true do
    -- Wait 0ms, makes the loop run every tick.
    Citizen.Wait(0)
    -- If the player is currently cuffed....
    if cuffed then
				--print("cuffed")
        local ped = PlayerPedId()

	--SetPedMoveRateOverride(ped(),0.25)
	--print "slowed them"
        -- ...don't allow them to do one of the following actions by
        -- disabling all of those buttons on controller/keyboard+mouse.
        -- We don't want them to be able to use any type of attack,
        -- obviously you can't pull out your rocket launcher if you're cuffed.....
        DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
        DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
        DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
        DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
        DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
        DisableControlAction(0, 257, true) -- INPUT_ATTACK2
        DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
        DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
        DisableControlAction(0, 24, true) -- INPUT_ATTACK
        DisableControlAction(0, 25, true) -- INPUT_AIM
				DisableControlAction(0, 21, true) -- disable sprint
				DisableControlAction(0, 303, true) -- disable sprint
				DisableControlAction(0, 22, true) -- disable u
				DisableControlAction(0, 29, true) -- disable b
				DisableControlAction(0, 23, true) -- disable f
				DisableControlAction(0, 19, true) -- disable left alt
				DisableControlAction(0, 48, true) -- disable z

        -- If the ped had any weapon in their hands before being cuffed, they will drop
        -- the weapon (ammo will fall on the ground, not the actual gun. However the gun
        -- will be removed from their inventory.)
        SetPedDropsWeapon(ped)
				SetPedMoveRateOverride(ped,0.70)

        -- Get the vehicle the player is currently in (if in any)
        local veh = GetVehiclePedIsIn(ped, false)

        -- If the vehicle exists and it's still drivable, and the player is in the drivers seat, we want
        -- to disable steering. As you obviously can't steer a car when your hands are tied behind your back.
        -- We'll also notify te user by showing a notification without the 'bleep' sound.
        -- In case the animation is broken for whatever reason, the notification will make sure they know
        -- why they can't steer the vehicle.
        if DoesEntityExist(veh) and not IsEntityDead(veh) and GetPedInVehicleSeat(veh, -1) == ped then

            -- Disable A/D on keyboard & Joystick Left/Right on controller.
            DisableControlAction(0, 59, true)

            -- Show the notification, turning off the notification sound.
            ShowHelp("Your hands are ~r~cuffed~s~, you can't stear!", false)
        end
    end
  end
end)


-- Show a help message (top left corner).
-- This is a simplefied version. Input text length is limited.
function ShowHelp(text, bleep)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

function returnIsClientCuffed()
	return cuffed
end

exports('returnIsClientCuffed', returnIsClientCuffed)


CreateThread(function()
	while true do Wait(0)
		if IsControlPressed(0, 25) then
			print('hello')
			DisableControlAction(0, 140)
		end
	end
end)
