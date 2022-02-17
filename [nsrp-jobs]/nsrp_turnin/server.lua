-- change turn in location when robbery finishes
-- send location to clients
-- clients with moneybags > 0 get blip

RegisterNetEvent('turnin:xp')
AddEventHandler('turnin:xp', function(source, amount)
  exports.nsrp_xp:addXP(source, amount)
end)

-----------------------
-----------------------
-------- Money --------
-----------------------
-----------------------
local moneyTurnIns = {
  -- blaine county
  [1] = {
    vector3(1454.0, 1135.86, 113.33), -- 860 house
    vector3(-1938.15, 2050.8, 139.83), -- 832 house
    vector3(3311.48, 5176.06, 18.61), -- lighthouse
    vector3(-753.53, 5591.23, 40.65), -- 700 tourist building
    vector3(-275.89, 6635.95, 6.44), -- 706 end of dock
    vector3(3601.56, 3660.74, 32.87), -- humane labs
    vector3(1642.49, 4845.72, 44.48), -- grapeseed
    vector3(714.15, 4101.85, 34.79), -- dock north califia
    vector3(1509.34, 6326.72, 23.61), -- 713 hippie camp
    vector3(-1131.35, 2695.3, 17.8), -- 835 store
    vector3(-2571.15, 1866.56, 162.72), -- 834 mansion
    vector3(663.83, 1281.69, 359.3), -- 604 radio tower
    vector3(793.28, 2162.12, 53.09), -- 844 ranch house
    vector3(-24.08, 6481.96, 33.64), -- 707 rooftop
    vector3(6.08, 6508.43, 31.88), -- 708 clothing shop
    vector3(-419.7, 6325.13, 25.49), -- 706 portch
    vector3(425.35, 6472.46, 35.87), -- 712 barn
  },
  [2]  = {
    vector3(425.35, 6472.46, 35.87), -- temp
  },
}

local aopMoneyTurnIns = moneyTurnIns[GlobalState.aop]
local moneyTurnInIndex = math.random(1, #aopMoneyTurnIns)
local prevMoneyTurnInIndex = moneyTurnInIndex
local currentMoneyTurnIn = aopMoneyTurnIns[moneyTurnInIndex]-- pick random starting turn in

print(currentMoneyTurnIn)
RegisterNetEvent('money:updateTurnIn')
AddEventHandler('money:updateTurnIn', function()
  CreateThread( function()
    moneyTurnInIndex = math.random(1, #aopMoneyTurnIns)
    if moneyTurnInIndex ~= prevMoneyTurnInIndex then
      prevMoneyTurnInIndex = moneyTurnInIndex
      currentMoneyTurnIn = aopMoneyTurnIns[moneyTurnInIndex]
    end
    GlobalState.moneyTurnIn = currentMoneyTurnIn
    print(GlobalState.moneyTurnIn)

    Wait(1000)

    TriggerClientEvent('money:updateTurnInBlip', -1)
  end)
end)

CreateThread( function()
  Wait(1000)
  TriggerEvent('money:updateTurnIn')
end)

-----------------------
-----------------------
--------- WEED --------
-----------------------
-----------------------
local nextUpdateTime = os.time() + 900
local weedTurnIns = {
  -- blaine county
  [1] = {
    vector3(1454.0, 1135.86, 113.33), -- 860 house
    vector3(-1938.15, 2050.8, 139.83), -- 832 house
    vector3(3311.48, 5176.06, 18.61), -- lighthouse
    vector3(-753.53, 5591.23, 40.65), -- 700 tourist building
    vector3(-275.89, 6635.95, 6.44), -- 706 end of dock
    vector3(3601.56, 3660.74, 32.87), -- humane labs
    vector3(1642.49, 4845.72, 44.48), -- grapeseed
    vector3(714.15, 4101.85, 34.79), -- dock north califia
    vector3(1509.34, 6326.72, 23.61), -- 713 hippie camp
    vector3(-1131.35, 2695.3, 17.8), -- 835 store
    vector3(-2571.15, 1866.56, 162.72), -- 834 mansion
    vector3(663.83, 1281.69, 359.3), -- 604 radio tower
    vector3(793.28, 2162.12, 53.09), -- 844 ranch house
    vector3(-24.08, 6481.96, 33.64), -- 707 rooftop
    vector3(6.08, 6508.43, 31.88), -- 708 clothing shop
    vector3(-419.7, 6325.13, 25.49), -- 706 portch
    vector3(425.35, 6472.46, 35.87), -- 712 barn
  },
  [2]  = {
    vector3(425.35, 6472.46, 35.87), -- temp
  },
}

local aopWeedTurnIns = weedTurnIns[GlobalState.aop]
local weedTurnInIndex = math.random(1, #aopWeedTurnIns)
local prevWeedTurnInIndex = moneyWeedInIndex
local currentWeedTurnIn = aopWeedTurnIns[weedTurnInIndex]-- pick random starting turn in

print(currentWeedTurnIn)
RegisterNetEvent('weed:updateTurnIn')
AddEventHandler('weed:updateTurnIn', function()
  CreateThread( function()
    weedTurnInIndex = math.random(1, #aopWeedTurnIns)
    if weedTurnInIndex ~= prevWeedTurnInIndex then
      prevWeedTurnInIndex = weedTurnInIndex
      currentWeedTurnIn = aopWeedTurnIns[weedTurnInIndex]
    end
    GlobalState.weedTurnIn = currentWeedTurnIn
    print(GlobalState.weedTurnIn)

    Wait(1000)

    TriggerClientEvent('weed:updateTurnInBlip', -1, true)
    nextUpdateTime = os.time() + 900
    print("Next Update Time: " .. nextUpdateTime)
  end)
end)

CreateThread( function()
  TriggerEvent('weed:updateTurnIn')
  Wait(2000)
  while true do
    Wait(1000)
    --print(os.time())
    --print(nextUpdateTime)
    if os.time() == nextUpdateTime then
      TriggerEvent('weed:updateTurnIn')
    end
  end
end)
