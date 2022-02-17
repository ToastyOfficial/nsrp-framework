
-- Choose aop at line 34
-- Fix notifications for pNotify
-- change 58 to new chat chatMessage

-- Death Vars


local isDead = false
local time_of_death = nil
local first_spawn = true
local respawn_timer = 30000 -- minutes converted to seconds (change first number)
local commands = {
    revive = 'two',
    revive_requires_ace = true
}
local respawnLoc = nil


local p = Player(-1)
p.state:set('dead', false, true)
print(p.state.dead)

-- Death Functions

-- On death, triggers when game ped registers as dead
function onDeath()
    TriggerServerEvent('deathXP', 1000)

    if GlobalState.emsCount > 0 then
      print("EMS available")
      respawn_timer = 120000
      print(respawn_timer)
    else
      print("EMS not available")
      respawn_timer = 30000
      print(respawn_timer)
    end

    local p = Entity(PlayerPedId())
    p.state:set('dead', true, true)
    print(p.state.dead)
    isDead = true

    time_of_death = GetGameTimer()
    local player_ped = GetPlayerPed(-1)
    SetPlayerInvincible(player_ped, true)
    SetEntityHealth(player_ped, 1)
    ClearPedTasksImmediately(player_ped)
    StartScreenEffect('DeathFailOut', 0, false)

    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local streetName = GetStreetNameAtCoord(x, y, z)
  	streetName = GetStreetNameFromHashKey(streetName)
  	if streetName == nil or streetName == "" then
  		streetName = "Unknown"
  	end
    TriggerServerEvent('reviveEMSCall', PlayerPedId(), "^3" .. streetName, x, y)
  	TriggerServerEvent('createEMSBlipServer', x, y, z)

    -- remove xp

end

-- Respawn function
function respawn(x, y, z, h)
    print('respawn triggerd')
    print('AOP: = ' .. aop)
    -- set dead false to reset
    isDead = false
    local p = Entity(PlayerPedId())
    p.state:set('dead', false, true)
    print(p.state.dead)

    -- if not statewide
    if aop ~= 3 then
      -- pick table to read from based on aop int
      current_AOP_Table = respawnLocations[aop]
      --print('AOP from aop_client: ' .. aop)
      --print(current_AOP_Table)

      respawnLoc = current_AOP_Table[math.random(#current_AOP_Table)]
      --print(respawnLoc.x .. respawnLoc.y .. respawnLoc.z .. respawnLoc.h)

    else
      current_AOP_Table = respawnLocations[math.random(2)]
      respawnLoc = current_AOP_Table[math.random(#current_AOP_Table)]
      --print(respawnLoc.x .. respawnLoc.y .. respawnLoc.z .. respawnLoc.h)
    end

    -- wait for coords from AOP
    local player_ped = GetPlayerPed(-1)

    -- choose location based on AOP

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    -- Teleport
    SetEntityCoordsNoOffset(player_ped, respawnLoc.x, respawnLoc.y, respawnLoc.z, false, false, false, true)
    -- Revive
    NetworkResurrectLocalPlayer(respawnLoc.x, respawnLoc.y, respawnLoc.z, respawnLoc.h, true, false)
    -- Set player vulnerable
    SetPlayerInvincible(player_ped, false)
    -- Do something
    TriggerEvent('playerSpawned', respawnLoc.x, respawnLoc.y, respawnLoc.z, respawnLoc.h)
    -- Clean up ped
    ClearPedBloodDamage(player_ped)

    StopScreenEffect('DeathFailOut')
    DoScreenFadeIn(800)

    TriggerServerEvent('clearInv', GetPlayerServerId(PlayerId()))
    TriggerEvent('chatMessage', 'SYSTEM', {200, 0, 0},'Respawned... you are now a new person. Remember the New Life Rule')

end

-- Draw timer FUNCTION

function drawDeathTimer(text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.8)
end


-- revive FUNCTION

function revive()
    StopScreenEffect('DeathFailOut')
    DoScreenFadeIn(800)
    isDead = false
    local p = Entity(PlayerPedId())
    p.state:set('dead', false, true)
    print(p.state.dead)

    local player_ped = GetPlayerPed(-1)
    local player_pos = GetEntityCoords(player_ped, true)

    NetworkResurrectLocalPlayer(player_pos, true, true, false)
    SetPlayerInvincible(player_ped, false)
    ClearPedBloodDamage(player_ped)
    TriggerEvent('playerSpawned', player_pos.x, player_pos.y, player_pos.z, player_pos.heading)
end

-- Thread

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local player_ped = GetPlayerPed(-1)

        -- If player is dead and var "isDead" is false trigger death function
        if IsEntityDead(player_ped) and isDead == false then
            onDeath()
        end

        -- Once dead = true then
        if isDead then
            -- set time of death
            if time_of_death ~= nil then
                -- get game time
                local current_time = GetGameTimer()
                -- set wait time to time of death plus respawn time
                local respawn_time = time_of_death + 120000

                -- if game time is (before) respawn time time then
                if current_time < respawn_time then
                    -- seconds left = respawn time minus current time
                    local secs = math.ceil((respawn_time - current_time) / 1000)
                    local minutes = 0
                    local seconds = 0
                    -- set message
                    local message = ""

                    while secs >= 60 do
                        secs = secs - 60;
                        minutes = minutes + 1
                    end

                    seconds = secs

                    if minutes > 0 then
                        message = "~b~" .. minutes .. ' minute'

                        if minutes > 1 then
                            message = message .. 's'
                        end

                        message = message .. '~s~'
                    end

                    if seconds > 0 then
                        if message ~= "" then
                            message = message .. " and "
                        end

                        message = message .. "~b~" .. seconds .. " second"

                        if seconds > 1 then
                            message = message .. 's'
                        end

                        message = message .. '~s~'
                    end

                    if GlobalState.emsCount > 0 then
                      message = "EMS IS ONLINE! You may respawn in " .. message .. " if they don't show up."
                    else
                      message = "You may respawn in " .. message .. " IF EMS is unavailable."
                    end
                    drawDeathTimer(message)
                else
                    -- once timer is completed
                    drawDeathTimer("Press ~b~E~s~ to respawn in AOP.")

                    -- respawn on press
                    if IsControlJustReleased(0, 86) then
                      --print('e pressed')
                        -- Trigger respawn
                      respawn()
                      Citizen.Wait(200)
                      showNotification('Respawned!', 'success')
                      Citizen.Wait(1000)
                      showNotification('Remember to follow the new life rule!', 'warning')
                    end
                end
            end
        end
    end
end)


-- not sure what this does, seems important

AddEventHandler('playerSpawned', function()
  print('playerSpawned triggered.')
    isDead = false
    local p = Entity(PlayerPedId())
    p.state:set('dead', false, true)
    print(p.state.dead)

    if first_spawn then
        first_spawn = false

        exports.spawnmanager:setAutoSpawn(false)
    end
end)


-- revives client and sends chat message to revived player when server revives them

RegisterNetEvent('reviveClient')
AddEventHandler('reviveClient', function(by)
    print('reviveClient triggered.')
    revive()
    if by ~= nil then
      TriggerEvent('chatMessage', 'SAFR', {200, 0, 0}, by .. ' have revived you!')
      showNotification(by .. 'has revived you!', 'success')
    end
end)
