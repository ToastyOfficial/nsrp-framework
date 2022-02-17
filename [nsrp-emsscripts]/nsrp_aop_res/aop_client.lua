aop = 1
aopText = 'Blaine County'
peacetimeActive = false
tptimer = 0
countdown = 5

local drawX = 0.665
local drawY = 1.458

-- Functions

function getAOP()
  return aop, aopText
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

function DrawTextAOP(x, y, width, height, scale, text, r, g, b, a)

    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- Threads

Citizen.CreateThread(function()
  TriggerEvent('chat:addSuggestion', '/aop', '1 = Blaine County, 2 = Los Santos, 3 = statewide', {
    { name='number', help='1 = Blaine County, 2 = Los Santos, 3 = Statewide'},
})
  while true do

    Citizen.Wait(0)
    local player = GetPlayerPed(-1)

    -- Disable shooting
    if peacetimeActive then
      if IsControlPressed(0, 106) then
        ShowInfo("~r~Peacetime is enabled. ~n~~s~You can not shoot.") -- change to pnotify

        SetPlayerCanDoDriveBy(player, false)
        DisablePlayerFiring(player, true)
        SetPedConfigFlag(player, 122, true) -- Testing
        SetPlayerMeleeWeaponDamageModifier(player, 0.0) -- Testing

      end
    end

    --DrawTextAOP(drawX, drawY, 1.0,1.0,0.45, "~c~AOP: ~w~" .. aopText, 255, 255, 255, 200)

  end
end)

-- when client joins send AOP message

AddEventHandler('onClientMapStart', function()

    TriggerServerEvent('sync_AOP')
    TriggerEvent('join_message')
end)

-- Receive AOP from server (AOP sent from server to client)
RegisterNetEvent('get_AOP')
AddEventHandler('get_AOP', function(serverAOP, serverAOP_text)
    print('Getting AOP info from server')
    aopText = serverAOP_text
    aop = serverAOP
end)

-- message sent on join
RegisterNetEvent('join_message')
AddEventHandler('join_message', function()
    Wait(1000)
    showNotification('Current AOP: ' .. aopText, 'info', 10000)
    TriggerEvent("chatMessage", "\n —————————————————————— \n Current RP Area is : " .. aopText .. " \n ——————————————————————", {156, 168, 226}) -- change to not deprecated
end)

-- message if no AOP perms
RegisterNetEvent('noPerms')
AddEventHandler('noPerms', function()
  showNotification('Only staff can change AOP!', 'error', 10000)
end)


RegisterNetEvent('aopNotification')
AddEventHandler('aopNotification', function(text)
  print('test')
  print(text)
  showNotification('AOP is now: ' .. text, 'info', 10000)
  Citizen.Wait(2000)
  if not aop == 3 then
    showNotification('Please move there now!', 'warning', 10000)
  end
end)

RegisterCommand('tp', function()
  local ped = GetPlayerPed(-1)
  if tptimer < 6 then
    if not IsPedInAnyVehicle(ped, true) then
      countdown = 5
      showNotification('Teleporting in '.. countdown ..'s. Stay still!', 'warning', 1500)
      tptimer = 60
      while countdown > 0 do
        Citizen.Wait(1000)
        print('test')
        if IsPedStill(ped) then
          if not IsPedInAnyVehicle(ped, true) then
            countdown = countdown - 1
            showNotification('Teleporting in '.. countdown ..'s. Stay still!', 'warning', 1500)
          else
            showNotification('Teleport canceled... Stay out of vehicles.', 'error', 10000)
            tptimer = 5
            return
          end
        else
          showNotification('Teleport canceled... Stay still!', 'error', 10000)
          tptimer = 5
          return
        end
      end
      respawn()
      showNotification('Teleported! You can do this again in 1 min.', 'success', 10000)
      -- remove XP
    else
      showNotification('You cannot teleport in a vehicle...', 'error', 10000)
    end
  else
    showNotification('You must wait to do that again!', 'error', 10000)
  end
  while tptimer > 0 do
    Citizen.Wait(1000)
    tptimer = tptimer - 1
    print('Time before next teleport: ' .. tptimer)
  end
end, false)
