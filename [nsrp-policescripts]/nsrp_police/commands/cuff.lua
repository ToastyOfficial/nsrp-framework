-- statebag
local player = Entity(PlayerPedId())
player.state:set('cuffed', false, true)

-- CreateThread(function()
--   while true do Wait(2000)
--     local player = Entity(PlayerPedId())
--     print(player.state.cuffed)
--   end
-- end)


-- Variable to keep track of the player's cuffed state.
local cuffed = false
-- local cuffer = GetPlayerPed(-1)

local cuffRange = 1.1
-- Creating variables for the animation and dictionary names
-- Saves a lot of trouble when these animation/dictionary names never change anyway.
local dict = "mp_arresting"
local anim = "idle"
-- Set the animation flag to 49, this will make it only show on the upper part of
-- the body, thus not affecting player's legs (movement).
local flags = 49
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

--------------------------
-------- Commands --------
--------------------------
--------------------------

RegisterKeyMapping('cuffkey', "Cuff (While shift pressed)", 'keyboard', 'G')
RegisterCommand('cuffkey', function()
	if IsControlPressed(0, 21) then
    ExecuteCommand('cuff')
  end
end, false
)


RegisterCommand('cuff', function()
	local player = Entity(PlayerPedId())
  if player.state.job == 'leo' then
  	local target, lastDistance = getNearestPlayerServerId()
  	print(target)
  	print(lastDistance)

    print("Target " .. target)
  	print("End target: " .. target)
  	if lastDistance < cuffRange then
    	TriggerServerEvent('cuff', target)
  	else
  		print('too far')
  	end
  else
    print('Not clocked in')
  end
end, false)


----------------------
------ Handlers ------
----------------------
----------------------

RegisterNetEvent('pc:cuffMe')
AddEventHandler('pc:cuffMe', function(target)

	print("Cuff triggered")
  local ped = PlayerPedId()

  if ped then
    -- Load the animation dictionary.
    RequestAnimDict(dict)
    -- If it's not loaded (yet), wait until it's done loading.
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    -- If the player is cuffed, then we want to uncuff them.
    if cuffed then

	    player.state:set('cuffed', false, true)


        -- Remove the "cuffed" task/animation.
        ClearPedTasks(ped)
        -- Re-enable the weapons wheel/starting of vehicles.
        SetEnableHandcuffs(ped, false)
        UncuffPed(ped)
        -- If the ped is the MP female ped, remove the handcuffs from the player
        -- model and set it back to whatever the previous value was.
        -- If it's not the MP female model, check for the MP male model instead.
        -- If that's the case, do the same thing but instead of resetting it to the
        -- female's previous style, set it to the male's previous style.
        if GetEntityModel(ped) == femaleHash then -- mp female
            SetPedComponentVariation(ped, 7, prevFemaleVariation, 0, 0)
        elseif GetEntityModel(ped) == maleHash then -- mp male
            SetPedComponentVariation(ped, 7, prevMaleVariation, 0, 0)
        end

    -- If the player wasn't cuffed before, we want to cuff them now.
    else
        -- prevention checks are done in a loop further down in the script.
        SetEnableHandcuffs(ped, true)
        -- Enable the handcuffed animation using the ped, dict, anim and flags variables (defined above).
				--print(dict)
				--print(anim)
				--print(ped)
        TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
    end

    -- Change the cuffed state to be the inverse of the previous state.
    cuffed = not cuffed
    -- statebag
    local player = Entity(ped)
    player.state:set('cuffed', cuffed, true)

  else
    print('Could not find a nearby ped')
  end
end)

----------------------
------ Threads ------
----------------------
----------------------

-- Slow loop to ensure cuffed animation
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1000)

          local ped = PlayerPedId()
          local player = Entity(ped)
					print(player.state.cuffed)
          -- if im cuffed but not playing cuffed animation reset it
          if player.state.cuffed and not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) then
              -- Wait 500ms before playing/setting the cuffed animation again.
              Citizen.Wait(500)
              TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
          end
    end
end)

local sleep = 200

-- fast cuffed thread for controls
Citizen.CreateThread(function()
  while true do Wait(sleep)
		local player = Entity(PlayerPedId())
    if player.state.cuffed then
        sleep = 0
        local ped = PlayerPedId()


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
        if DoesEntityExist(veh) and not IsEntityDead(veh) and GetPedInVehicleSeat(veh, -1) == ped then
            -- Disable A/D on keyboard & Joystick Left/Right on controller.
            DisableControlAction(0, 59, true)
            -- Show the notification, turning off the notification sound.
            ShowAlert("Your hands are ~r~cuffed~s~, you can't stear!", false)
        end
    else
      sleep = 200
    end
  end
end)
