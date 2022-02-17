----------------------------------
----------------------------------
---------- INGELLIGENCE ----------
----------------------------------
----------------------------------
local me = Entity(PlayerPedId())
me.state:set('possibleCriminal', false, true)

--local lights = false
local targetLoc = vector3(0, 0, 0)

-- AddEventHandler('p:lightson', function()
--   print("Lights on")
--   lights = true
-- end)
--
-- AddEventHandler('p:lightsoff', function()
--   print("Lights off")
--   lights = false
-- end)


-- -- ray cast thread while lights are on
-- CreateThread(function()
--   while true do Wait(500)
--
--     if lights and IsPedInAnyVehicle(PlayerPedId()) then
--       local ped = PlayerPedId()
--       local vehicle = GetVehiclePedIsIn(ped)
--       local vehLoc = GetEntityCoords(vehicle)
--
--       -- caluclate ray values
--       local forwardVector = GetEntityForwardVector(vehicle)
--       local rayStart = forwardVector * 2 + vehLoc
--       local rayEnd = forwardVector * 100 + vehLoc
--
--       -- cast ray and return results
--       DrawLine(rayStart, rayEnd, 0, 255, 255, 255)
--       local ray = StartShapeTestRay(rayStart, rayEnd, 2, vehicle, 0)
--       print()
--       local _, hit, _, _, targetVeh = GetShapeTestResult(ray)
--       print("Hit?: " .. hit)
--       print("Entity: " .. targetVeh)
--
--       local targetLoc = GetEntityCoords(targetVeh)
--
--       local driver = GetPedInVehicleSeat(targetVeh, -1)
--       if driver then
--         local player = Entity(driver)
--         player.state:set('possibleCriminal', true, true)
--       end
--     end
--   end
-- end)



-- CreateThread(function()
--   while true do Wait(2000)
--     local player = Entity(PlayerPedId())
--     print("Am I possible criminal: " .. tostring(player.state.possibleCriminal))
--   end
-- end)

CreateThread(function()
  while true do Wait(10000)
    local player = Entity(PlayerPedId())
    if player.state.job == 'leo' then
      clockedIn = true
    else
      clockedIn = false
    end
  end
end)
