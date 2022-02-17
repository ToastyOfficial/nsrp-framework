-- statebag
local player = Entity(PlayerPedId())
player.state:set('dragging', nil, true)

local dragRange = 1.5

dragged = false
local dragger = nil
--------------------------
-------- Commands --------
--------------------------
--------------------------

RegisterCommand('drag', function()
  local player = Entity(PlayerPedId())
  if player.state.job == 'leo' then
  	local target, lastDistance = getNearestPlayerServerId()
  	print("Distance: " .. lastDistance)
    print("Target " .. target)
  	--print("End target: " .. target)
    print(lastDistance)
    print(dragRange)
  	if lastDistance < dragRange then
      print('Triggering s:drag on server.')
    	TriggerServerEvent('s:drag', target)
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

RegisterNetEvent('pc:dragMe')
AddEventHandler('pc:dragMe', function(dragger)
  local draggerPlayer = GetPlayerFromServerId(dragger)
  draggerPed = GetPlayerPed(draggerPlayer)
  if not dragged then
    print('Im not dragged')
    dragged = true
  else
    print('Im dragged')
    dragged = false
  end
end)

----------------------
------ Threads ------
----------------------
----------------------

local sleep = 200

CreateThread( function()
  while true do Wait(sleep)
    if dragged then
      sleep = 0

      AttachEntityToEntity(PlayerPedId() --[[ Entity ]], draggerPed --[[ Entity ]], 11816 --[[ integer]], 0.45 --[[ number ]], 0.45 --[[ number ]], 0.00 --[[ number ]], 0.00 --[[ number ]], 0.00 --[[ number ]], 0.00 --[[ number ]], false --[[ boolean ]], false --[[ boolean ]], false --[[ boolean ]], false --[[ boolean ]], 2 --[[ integer ]], true --[[ boolean ]])
    else
      sleep = 200
      if not IsPedInParachuteFreeFall(PlayerPedId()) then
        DetachEntity(PlayerPedId(), true, false)
      end
    end
  end
end)
