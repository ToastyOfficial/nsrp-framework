
GlobalState.emsCount = 0
----------------------------
----------------------------
------- CPR AND SUCH -------
----------------------------
----------------------------
RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(vehicle)
  print("Player left vehicle")
  TriggerClientEvent('ems:setAmbulance', source, vehicle)
end)

-----------------------------
-----------------------------
------- PATIENT STUFF -------
-----------------------------
-----------------------------

RegisterNetEvent('ems:revivePlayer')
AddEventHandler('ems:revivePlayer', function(target, vehicle)
  TriggerClientEvent('reviveClient', target, source)
  TriggerClientEvent('tendMe', target, vehicle)
end)

RegisterNetEvent('ems:falseRevive')
AddEventHandler('ems:falseRevive', function(target)
  print(source)
  print("ems:falseRevive Target: " .. target)
  TriggerClientEvent('falseReviveMe', target)
end)

RegisterNetEvent('patient:setCPR_Tries')
AddEventHandler('patient:setCPR_Tries', function(target, tries)
  TriggerClientEvent('setMyCPR', target, tries)
end)

RegisterNetEvent('patient:setStateTended')
AddEventHandler('patient:setStateTended', function(target, bool)
  print(source)
  print("patient:setStateTended Target: " .. target)
  local entity = Entity(GetPlayerPed(target))
  entity.state.tended = bool

end)

RegisterNetEvent('patient:setIntoAmbulance')
AddEventHandler('patient:setIntoAmbulance', function(target, vehicle)
  TriggerClientEvent('transportMe', target, vehicle)
end)

RegisterNetEvent('hosPatient')
AddEventHandler('hosPatient', function(target)
  TriggerClientEvent('hosMe', target)
end)
----------------------------------
----------------------------------
------- ON DEATH EMS CALLS -------
----------------------------------
----------------------------------

RegisterServerEvent('reviveEMSCall')
AddEventHandler('reviveEMSCall', function(playerPed, message, x, y)
	TriggerClientEvent('paramedicEMSPageClient', -1, x, y)
  --TriggerClientEvent('chatMessage', -1, '', {255, 255, 255}, '^8[SAFR]^2 ' .. GetPlayerName(source) .. '^0 has been reported unconcious near ' .. message)
end)


RegisterServerEvent('createEMSBlipServer')
AddEventHandler('createEMSBlipServer', function(x, y, z)
	TriggerClientEvent('createEMSBlip', -1, x, y, z, GetPlayerName(source))
end)

--------------------------------
--------------------------------
------- CLOCK IN AND OUT -------
--------------------------------
--------------------------------

local updating = false

RegisterNetEvent('updateMedicCount')
AddEventHandler('updateMedicCount', function(increase)
  if increase then
    GlobalState.emsCount = GlobalState.emsCount + 1
    if updating == false then
      exports.nsrp_hud:updateEMS(GlobalState.emsCount, false)
      --print("Global State EMS Count: " .. GlobalState.emsCount)
    end
  else
    GlobalState.emsCount = GlobalState.emsCount - 1
    if updating == false then
      exports.nsrp_hud:updateEMS(GlobalState.emsCount, false)
      --print("Global State EMS Count: " .. GlobalState.emsCount)
    end
  end
end)

CreateThread(function()
  while true do
    local allPlayers = GetPlayers()
    if #allPlayers > 0 then
      updating = true
      GlobalState.emsCount = 0
      for k, v in pairs(GetPlayers()) do
        TriggerClientEvent('e:returnClientClocked', v, updating)
        Wait(200)
      end
      --print("Number of EMS updated to: " .. GlobalState.emsCount)
      exports.nsrp_hud:updateEMS(GlobalState.emsCount, true)
      updating = false
    end
    Wait(20000)
  end
end)

-- Check perms for clock in, then tell client to clock in, if no perms show error
RegisterCommand('fdclockin', function(source)
  perms = IsPlayerAceAllowed(source, "command.fdclockin")
  if perms then
    local allPlayers = GetPlayers()
    if GlobalState.emsCount < #allPlayers / 2 then
      TriggerClientEvent('e:clockMeIn', source)
      local player = Entity(GetPlayerPed(source))
      player.state.job = 'ems'
    else
      TriggerClientEvent('e:tooMany', source)
    end
  else
    TriggerClientEvent('e:noClockPerms', source)
  end
end, false)

-- Check perms for clock in, then tell client to clock out
RegisterCommand('fdclockout', function(source)
  local player = Entity(GetPlayerPed(source))
  if player.state.job == 'ems' then
    TriggerClientEvent('e:clockMeOut', source)

    player.state.job = 'none'
  end

end, false)
