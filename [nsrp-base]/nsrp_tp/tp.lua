
e_countdown = 5
teleported = false

function nsrpTeleport(ped, time, x, y, z)
      teleported = false
      e_countdown = time

      showNotification('Teleporting in '.. e_countdown ..'s. Stay still!', 'warning', 1500)
      e_tptimer = 60
      while e_countdown > 0 do
        Citizen.Wait(1000)
        print('c_countdown')
        if not IsControlJustReleased(0, 72)then
            e_countdown = e_countdown - 1
            showNotification('Teleporting in '.. e_countdown ..'s. Stay still!', 'warning', 1500)

        else
          e_tptimer = time
          return
        end
      end
      -- Teleport

      if IsPedInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped)
        DeleteVehicle(veh)
      else
          print("Not in vehicle")
      end

      SetEntityCoordsNoOffset(ped, x, y, z, false, false, false, true)
      showNotification('Teleported!', 'success', 10000)
      teleported = true



  return teleported
end


function testExport(text)
  print(text)
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
