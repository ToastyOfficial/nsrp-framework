local serverId = GetPlayerServerId(PlayerId())
local jailed = false
local timer = 1
local sleep = 1000
local player = Entity(PlayerPedId())

--CONFIG
local jailLocation = vector3(1779.52, 2583.76, 44.8)
local textDrawLocation = vector3(1779.6, 2577.06, 46.55)
local jailOutLocation = vector3(1849.58, 2585.89, 44.67)
local bookLoc = vector3(1788.13, 2594.52, 44.8) -- update in server.lua as well
local drawDist = 15
local jailTime = 60
local allowedDist = 34
local xpReward = 250

function niceTP(ped, coords, time)
  DoScreenFadeOut(time)
  Wait(time)
  SetEntityCoords(ped, coords, false, false, false, true)
  DoScreenFadeIn(time)
end

function showAlert(message, playNotificationSound)
   SetTextComponentFormat('STRING')
   AddTextComponentString(message)
   DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end

function showNotification(message, type)
  TriggerEvent("pNotify:SendNotification", {
    text = message,
    type = type,
    timeout = 10000,
    layout = "centerLeft",
    animation = {
      open = "gta_effects_fade_in",
      close = "gta_effects_fade_out",
    },
  })
end

RegisterNetEvent('jailMe')
AddEventHandler('jailMe', function()
  if not jailed then
    local player = Entity(PlayerPedId())
    player.state:set('cuffed', false, true)
    dragged = false
    local ped = PlayerPedId()
    niceTP(ped, jailLocation, 500)
    Wait(500)
    timer = jailTime
    jailed = true

    TriggerServerEvent('clearInv', GetPlayerServerId(PlayerId()))
  end
end)

RegisterNetEvent('unjailMe')
AddEventHandler('unjailMe', function()
  local ped = PlayerPedId()
  if jailed then
    niceTP(ped, jailOutLocation, 500)
    jailed = false
    TriggerServerEvent('addJailXP', xpReward)
    showNotification('You regained ' .. xpReward .. ' XP.', 'info')
  end
end)

-- thread
CreateThread(function()
  while true do Wait(1000)

    if jailed then
      local ped = PlayerPedId()
      local pedLocation = (GetEntityCoords(ped))
      local dist = #(pedLocation - jailLocation)

      print(dist)
      print(timer)

      if dist > allowedDist then -- if player is outside of range then add time and move back to jail
        niceTP(ped, jailLocation, 500)
        timer = timer + 15
      end



      timer = timer - 1 -- increment time

      if timer == 0 then -- if time is up then unjail and set as not jailed
        TriggerEvent('unjailMe')
        jailed = false
      end

    end

  end
end)

CreateThread(function()
  while true do Wait(0)
    if jailed then
      exports.motiontext:Draw3DText({
        xyz = textDrawLocation,
        text = {
          content=timer,
          rgb={255,255,255},
          textOutline=false,
          scaleMultiplier=7,
          font=0,
        },
        perspectiveScale=4,
        radius=300
      })
    end
  end
end)

CreateThread(function()
  while true do Wait(sleep)

    if player.state.job == 'leo' then
      local ped = PlayerPedId()
      local pedCoords = GetEntityCoords(ped)
      local distanceFromBookLoc = GetDistanceBetweenCoords(pedCoords, bookLoc)

      if distanceFromBookLoc < drawDist then
        sleep = 0
        DrawMarker(1, bookLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 1.5, 95, 112, 185, 100, false, true, 2, false, nil, nil, false)
        if distanceFromBookLoc < 1.5 then
          showAlert('Type /jail [id] to jail the suspect.', true)
        end
      else -- if not in draw distance
        sleep = 1000
      end
    else -- if not clocked in
      sleep = 1000
      --print('Not Clocked In')
    end
  end
end)

CreateThread(function()
  while true do Wait(5000)
    player = Entity(PlayerPedId())
  end
end)
