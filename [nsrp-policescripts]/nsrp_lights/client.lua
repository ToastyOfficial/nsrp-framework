-- keys will always tigger the same extras for consistency
-- 5 = 126 = extra 8
-- 6 = 125 = extra 9
-- 7 = 117 = extra 10
-- 8 = 127 = extra 11
-- 9 = 118 = extra 12

-------------------------
------ CONFIG/DATA ------
-------------------------

vehicles = {
  {
    name = 'rambulance2',
    repair = true,
    buttons = {
      {
        label = 'INTERIOR',
        key = 127, -- num 8
        extra = 11
      },
      {
        label = 'SCENE',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'pdram',
    repair = false,
    buttons = {
      {
        label = 'STAGE 2',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'AMBER',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'AUX',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'BED',
        key = 127, -- num 8
        extra = 11
      },
     {
        label = 'SCENE',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'sp20',
    repair = false,
    buttons = {
      {
        label = 'STAGE 2',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'TA',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'AUX',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'AUX 2',
        key = 127, -- num 8
        extra = 11
      },
     {
        label = 'FLOOD',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'sp16',
    repair = false,
    buttons = {
      {
        label = 'STAGE 2',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'TA',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'AUX',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'AUX 2',
        key = 127, -- num 8
        extra = 11
      },
     {
        label = 'FLOOD',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'pd20',
    repair = false,
    buttons = {
      {
        label = 'STAGE 2',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'TA',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'AUX',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'AUX 2',
        key = 127, -- num 8
        extra = 11
      },
     {
        label = 'FLOOD',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'pd16',
    repair = false,
    buttons = {
      {
        label = 'STAGE 2',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'TA',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'AUX',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'AUX 2',
        key = 127, -- num 8
        extra = 11
      },
     {
        label = 'FLOOD',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'spchrg18',
    repair = false,
    buttons = {
      {
        label = 'STAGE 2',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'TA',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'AUX',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'AUX 2',
        key = 127, -- num 8
        extra = 11
      },
     {
        label = 'FLOOD',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'pdchrg18',
    repair = false,
    buttons = {
      {
        label = 'STAGE 2',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'TA',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'AUX',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'AUX 2',
        key = 127, -- num 8
        extra = 11
      },
     {
        label = 'FLOOD',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
  {
    name = 'fdrescue2',
    repair = false,
    buttons = {
      {
        label = 'FRONT',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'LEFT',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'RIGHT',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'REAR',
        key = 127, -- num 8
        extra = 11
      },
    }
  },
  {
    name = 'fdfpiu2',
    repair = false,
    buttons = {
      {
        label = 'TA',
        key = 126, -- num 5
        extra = 8
      },
      {
        label = 'FLOOD',
        key = 125, -- num 6
        extra = 9
      },
      {
        label = 'SBURN',
        key = 117, -- num 7
        extra = 10
      },
     {
        label = 'PARK',
        key = 118, -- num 9
        extra = 12
      },
    }
  },
}


local vehConfig = nil
local lights = false
local startPed = PlayerPedId()

if IsPedInAnyVehicle(startPed) then
  TriggerServerEvent('baseevents:enteredVehicle')
end
----------------------
------- EVENTS -------
----------------------

AddEventHandler('p:lightson', function()
  print("Lights on")
  lights = true
  SendNUIMessage({
    type = 'toggleIndicator',
    state = lights
  })

end)

AddEventHandler('p:lightsoff', function()
  print("Lights off")
  lights = false
  SendNUIMessage({
    type = 'toggleIndicator',
    state = lights
  })

end)


-- when ped enters vechile get recieve this event from server
RegisterNetEvent('el:checkVehicle')
AddEventHandler('el:checkVehicle', function()
  --print('hi')
  local vehHasLights = false
  -- get stuff
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped)
  local class = GetVehicleClass(vehicle)
  local player = Entity(PlayerPedId())
  local model = GetEntityModel(vehicle)

  -- clear any existing buttons from hud
  SendNUIMessage({
    type = 'clearButtons',
  })

  CreateThread(function()

    -- if on duty
    --if player.state.job == 'leo' then
      -- if the vehicle is an emergency vehicle
      if class == 18 then
        -- loop through vehicles table to find if players vehicle is included

        for k, v in pairs(vehicles) do
          --print('My vehicle hash: ' .. model)

          --print(v.name)
          --print(GetHashKey(v.name))
          if model == GetHashKey(v.name) then -- if the vehicle is a supporter vehicle
            --print('Vehicle found in table.')
            vehHasLights = true
            vehConfig = v
            break
          else
            print('Vehicle not in table.')
            vehHasLights = false
          end
        end

        local myPed = PlayerPedId()
        local myVeh = GetVehiclePedIsIn(myPed)
        local driverPed = GetPedInVehicleSeat(myVeh, -1)

        if vehHasLights and myPed == driverPed then
          -- loop through buttons and add them to UI
          for k2, button in pairs(vehConfig.buttons) do

          local extraState = IsVehicleExtraTurnedOn(vehicle, button.extra)
          --print(extraState)
          SendNUIMessage({
            type = 'addButton',
            label = button.label,
            key = button.key,
            state = extraState
          })

          end

          -- show hud
          SendNUIMessage({
            type = 'showLightsHUD',
          })
          Wait(4000)
          -- hide helpers
          SendNUIMessage({
            type = 'hideHelpers',
          })
        end
      else
        print('Not an emergency vehicle.')
      end
    --end
  end)
end)


RegisterNetEvent('el:cleanupHUD')
AddEventHandler('el:cleanupHUD', function()
  -- hide hud
  SendNUIMessage({
    type = 'hideLightsHUD',
  })
end)
-----------------------
------ FUNCTIONS ------
-----------------------

function toggleStage(extra, key)
    -- get stuff
  local ped = PlayerPedId()
  local veh = GetVehiclePedIsIn(ped)
  local state = IsVehicleExtraTurnedOn(veh, extra) -- returns true if enabled

  -- disable or enable extras repairing vehicle based on vehicle
  --print()
  --print(vehConfig)
  --print(vehConfig.repair)
  if vehConfig.repair then
    SetVehicleAutoRepairDisabled(veh, false)
  else
    SetVehicleAutoRepairDisabled(veh, true)
  end

  -- toggle extra
  SetVehicleExtra(veh, extra, state) -- false is actually enabled (disabled = false)
  -- play beep
  PlaySoundFrontend(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)

  -- send message to JS to update HUD
  --print(not state)
  SendNUIMessage({
    type = 'toggleButton',
    key = key,
    state = not state
  })

  if extra == 12 then
    if not state then
      TriggerEvent('c:sceneOn')
    else
      TriggerEvent('c:sceneOff')
    end
  end
end

-----------------------
------ KEYBINDS -------
-----------------------

RegisterKeyMapping('el:num5', 'Toggle Main Lighting', 'keyboard', 'NUMPAD5')
RegisterCommand('el:num5', function()
  print('Num5')
  toggleStage(8, 126) -- extra 8, num5, main
end)

RegisterKeyMapping('el:num6', 'Toggle TA', 'keyboard', 'NUMPAD6')
RegisterCommand('el:num6', function()
  print('Num6')
  toggleStage(9, 125) -- extra 9, num6, TA
end)

RegisterKeyMapping('el:num7', 'Toggle AUX 1', 'keyboard', 'NUMPAD7')
RegisterCommand('el:num7', function()
  print('Num7')
  toggleStage(10, 117) -- extra 10, num7, aux1
end)

RegisterKeyMapping('el:num8', 'Toggle AUX 2', 'keyboard', 'NUMPAD8')
RegisterCommand('el:num8', function()
  print('Num8')
  toggleStage(11, 127) -- extra 11, num8, aux2
end)

RegisterKeyMapping('el:num9', 'Toggle Scene Lighting', 'keyboard', 'NUMPAD9')
RegisterCommand('el:num9', function()
  print('Num9')
  toggleStage(12, 118) -- extra 12, num9, scene
end)

CreateThread(function()
  local lastVehicle = nil
  while true do Wait(500)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then
      local vehicle = GetVehiclePedIsIn(ped)
      --print(vehicle)
      --print(lastVehicle)
      if vehicle ~= lastVehicle then
        TriggerServerEvent('baseevents:enteredVehicle')
      end
      lastVehicle = GetVehiclePedIsIn(ped)
    end
  end
end)
