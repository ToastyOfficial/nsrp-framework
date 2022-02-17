local capacity = 0

local ply = Entity(PlayerPedId())

local itemNames = {
  iFirearms = 'Firearms',
  iWeapons = 'Weapons',
  iWeed = 'Weed',
  iWeed2 = 'Weed',
  iMeth = 'Meth',
  iMeth2 = 'Meth',
  iMoneyBags = 'Bags of Money'
}

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

AddEventHandler('playerSpawned', function()
  Wait(4000)
  print('inv: ' .. PlayerId())
  print('inv: ' .. GetPlayerServerId(PlayerId()))
  TriggerServerEvent('initMyInv', GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('invUpdated')
AddEventHandler('invUpdated', function(item, amount, total, type, addremove)

  print()
  print('I got ' .. amount .. ' ' .. itemNames[item])
  print('I have ' .. total .. ' ' .. itemNames[item])


    if type == 1 then -- if items were added
      capacity = capacity + amount
      if capacity > 200 then
        capacity = 200
      else
        SendNUIMessage({
          type = 'showItem',
          item = item,
          amount = total,
        })
        showNotification('You gained ' .. amount .. " " .. itemNames[item], 'success')
      end
    elseif type == 2 then -- if items were taken
      capacity = capacity - amount
      if total == 0 then
        SendNUIMessage({
          type = 'hideItem',
          item = item,
          amount = total,
        })
      end
      showNotification('You lost ' .. amount .. " " .. itemNames[item], 'error')
    end

  SendNUIMessage({
    type = 'updateItem',
    item = item,
    amount = total,
  })
  -- this needs testing : )
  SendNUIMessage({
    type = 'updateCapacity',
    capacity = capacity,
  })
end)

RegisterNetEvent('setName')
AddEventHandler('setName', function(name)
  print("Name: " .. name)
  SendNUIMessage({
    type = 'setName',
    name = name,
  })
end)

-- CreateThread(function()
--   while true do Wait(1000)
--     print("Drugs: " .. ply.state['iDrugs'])
--   end
-- end)

local invJustOpened = false
local keyPressed = false

RegisterKeyMapping('+showInv', 'Show Inventory', 'keyboard', 'I')
RegisterCommand('+showInv', function()
  invJustOpened = true
  keyPressed = true
  startTimer(100)
  TriggerScreenblurFadeIn(100.0)
  SendNUIMessage({
    type = 'showInv',
  })
end)

RegisterCommand('-showInv', function()
  keyPressed = false
  if not InvJustOpened then
    TriggerScreenblurFadeOut(750.0)
    SendNUIMessage({
      type = 'hideInv',
    })
  end
end)

function startTimer(time)
  CreateThread(function()
    Wait(time)
    invJustOpened = false
    if not keyPressed then
      TriggerScreenblurFadeOut(750.0)
      SendNUIMessage({
        type = 'hideInv',
      })
    end
  end)
end
