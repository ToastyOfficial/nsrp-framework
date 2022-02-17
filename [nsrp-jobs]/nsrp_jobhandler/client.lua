local player = Entity(PlayerPedId())
player.state:set('job', 'none', true)

local myJob = nil

hasJob = false
debug = false
local pLevel = 1

function getHasJob()
  return hasJob
end

function setHasJob(bool)
  hasJob = bool
end

-- RegisterNetEvent('doesClientHaveJob')
-- AddEventHandler('doesClientHaveJob', function(callback)
--   callback(hasJob)
-- end)

CreateThread(function()
  while debug do
    Wait(5000)
    if hasJob then
      print('You have a job.')
    else
      print('You dont have a job.')
    end
  end
end)


function returnPlayerLevel()
  return pLevel
end

RegisterNetEvent('recPlayerLevel')
AddEventHandler('recPlayerLevel', function(level)
  pLevel = level
  --print(pLevel)
end)

CreateThread(function()
  while true do
    if not hasJob then
      print('Getting level for jobs')
      TriggerServerEvent('jobs:getLevel', GetPlayerServerId(PlayerId()))
    end
    Wait(120000)
  end
end)

CreateThread(function()
  while true do
    local player = Entity(PlayerPedId())
    myJob = player.state.job
    print("My Job: " .. tostring(myJob))
    Wait(15000)
  end
end)
