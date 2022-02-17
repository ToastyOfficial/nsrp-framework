local seated = false

--------------------------
-------- Commands --------
--------------------------
--------------------------

RegisterCommand('seat', function()
  local player = Entity(PlayerPedId())
  if player.state.job == 'leo' then
    -- statebag
    local ped = PlayerPedId()
    local player = Entity(ped)
    local target = player.state.dragging
    print('Seat target (draggedPed) =' .. target)

    TriggerServerEvent('seat', target)

  else
    print('Not clocked in')
  end
end)

RegisterCommand('unseat', function()
  local player = Entity(PlayerPedId())
  if player.state.job == 'leo' then
    local ped = PlayerPedId()
    local playerLoc = GetEntityCoords(ped)

    local target = getNearestPlayerServerId()

    TriggerServerEvent('unseat', target)
  else
    print('Not clocked in')
  end
end)

----------------------
------ Handlers ------
----------------------
----------------------

RegisterNetEvent('pc:seatMe')
AddEventHandler('pc:seatMe', function()
  print('Seat triggered')
  if dragged then
    print("seating")

    local ped = PlayerPedId()
    local playerLoc = GetEntityCoords(ped)
    local drawVector = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(playerLoc.x, playerLoc.y, playerLoc.z, drawVector.x, drawVector.y, drawVector.z, 10, ped, 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)

    if vehicleHandle ~= nil then
      print(vehicleHandle)
      dragged = false
      SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 1)
      seated = true
    else
      print('No vehicle found in front of you.')
    end
  else
    print('Someone tried to seat me but theyre not dragging me')
  end
end)

RegisterNetEvent('pc:unseatMe')
AddEventHandler('pc:unseatMe', function(vehicle)
  if seated then
    local ped = PlayerPedId()

    ClearPedTasksImmediately(ped)
  	local playerLoc = GetEntityCoords(ped,  true)
  	local xnew = playerLoc.x+2
  	local ynew = playerLoc.y+2

  	SetEntityCoords(ped, xnew, ynew, playerLoc.z)
  else
    print('Someone unseat me but im not seated')
  end
end)


----------------------
------ Threads ------
----------------------
----------------------
