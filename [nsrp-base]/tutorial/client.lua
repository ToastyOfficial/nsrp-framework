RegisterNetEvent("tutorial:spawn")
AddEventHandler("tutorial:spawn", function()

    local aop = exports.nsrp_aop_res:getAOP()
    print(aop)
    DoScreenFadeOut(1000)

    if aop == 1 then
      SetNewWaypoint(166.96, 2754.02)
    else
      SetNewWaypoint(166.96, 2754.02)
    end

    Citizen.Wait(1000)
    DoScreenFadeIn(1000)

end)



-- CreateThread( function()
--   while true do
--     Wait(1000)
--     print("hello")
--   end
-- end)
