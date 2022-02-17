RegisterNetEvent('b:checkVehicle')
AddEventHandler('b:checkVehicle', function(canSteal)
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped)
  local vehClass = GetVehicleClass(vehicle)

  print("Vehicle resClass: " .. vehClass)

  if GetSeatPedIsTryingToEnter(ped) == -1 then

    if vehClass == 18 then -- if its a police car or ems car
      local entity = Entity(PlayerPedId())
      print("My job: " .. entity.state.job)
      if entity.state.job == 'leo' or entity.state.job == 'ems' then -- if the player is neither LEO nor EMS
      else
        print("Can Steal?: " .. tostring(canSteal))
        if not canSteal then -- if they can't steal cars
          ClearPedTasksImmediately(ped)
          showNotification('Only verified civs can steal police cars.', 'error')
        end
      end
    end
  end
end)

function showNotification(message, type)
  TriggerEvent("pNotify:SendNotification", {
    text = message,
    type = type,
    timeout = 5000,
    layout = "centerLeft",
    animation = {
      open = "gta_effects_fade_in",
      close = "gta_effects_fade_out",
    },
  })
end
