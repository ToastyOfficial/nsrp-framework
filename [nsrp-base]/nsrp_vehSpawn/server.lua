
RegisterNetEvent('requestVehicle')
AddEventHandler('requestVehicle', function(source, name, levelNeeded, coords, heading)
  CreateThread( function()

    print(source)
    local level = exports.nsrp_xp:getPlayerLevel(source, function(level)
      level = level
    end)

    Wait(200)

    print("^3[requestVehicle] Player level : " ..level)
    --print("Vehicle: " .. name)
    print("^3[requestVehicle] Vehicle Level: " .. levelNeeded)

    if level >= levelNeeded then
      --print('hi')
      TriggerClientEvent('v:spawnVehicle', source, name, coords, heading)
    else
      --print('bye')
      TriggerClientEvent('levelWarn', source, levelNeeded)
    end
  end)

end)


function getSteam(target) -- target is player server ID
  --print("Evaluating ID: ".. target)
  -- get identifiers
  local identifiers = GetPlayerIdentifiers(target)
  steam = nil
  --print("Found an identifier: " .. identifiers[1])

  -- sort through identifiers to find steam
  for k, v in ipairs(GetPlayerIdentifiers(target)) do
      if string.match(v, "steam:") then
        -- set steam var as steam
         steam = v
         break
      end
    end
    print('^2[getSteam] Found Steam ID: ' .. steam .. ' for player: ' .. target)
  return steam
end


-- VEHICLE SAVING

RegisterNetEvent('saveVehicle')
AddEventHandler('saveVehicle', function(source, plate, name, vehicleData)

  -- print("VEHICLE MODEL: " .. vehicleData.model)
  -- print("VEHICLE COLOR: " .. vehicleData.color1)
  -- print("VEHICLE COLOR2: " .. vehicleData.color2)
  -- print("VEHICLE WHEEL TYPE: " .. vehicleData.wheels)
  -- print("VEHICLE XENON COLOR: " .. vehicleData.xenonColor)
  -- print(vehicleData.modXenon)
  -- print("VEHICLE FRONT WHEELS: " .. vehicleData.modFrontWheels)
  -- print("VEHICLE LIVERY: " .. vehicleData.modLivery)
  -- print(vehicleData.extra1)
  -- print(vehicleData.extra2)
  -- print(vehicleData.extra3)
  -- print(vehicleData.extra4)
  -- print(vehicleData.extra5)
  -- print(vehicleData.extra6)
  -- print(vehicleData.extra7)
  -- print(vehicleData.extra8)
  -- print(vehicleData.extra9)
  -- print(vehicleData.extra10)
  -- print(vehicleData.extra11)
  -- print(vehicleData.extra12)

  			print(vehicleData.spoiler)
  			print(vehicleData.bumperF)
  			print(vehicleData.bumperR)
  			print(vehicleData.exhaust)
  			print(vehicleData.grille)
  			print(vehicleData.hood)
  			print(vehicleData.roof)



  local foundPlate = MySQL.Sync.fetchAll("SELECT plate FROM vehicles WHERE plate = @plate",
  {['@plate'] = plate},
  function(result)
  end)

  -- print('Found Plate: ' .. foundPlate[1].plate)

  if foundPlate[1] and foundPlate[1].plate ~= nil then
    print('^3[saveVehicle] Plate ' .. foundPlate[1].plate .. ' already in DB')
    TriggerClientEvent('c:notification', source, 'That vehicle is already saved.', 'error')
  else
    print('^2[saveVehicle] Plate ' .. plate .. ' not found in DB. Adding vehicle.')
    local owner = getSteam(source)
    saveVehicleTo_DB(plate, owner, name, vehicleData)
    TriggerClientEvent('c:notification', source, 'Vehicle "' .. name .. '" saved!', 'success')
  end
end)

function saveVehicleTo_DB(plate, owner, name, vehicleData)


  MySQL.Sync.execute("INSERT INTO `nsrp`.`vehicles` (`plate`, `owner`, `name`, `model`, `color1`, `color2`, `livery`, `wheel_type`, `wheels_f`, `e_1`, `e_2`, `e_3`, `e_4`, `e_5`, `e_6`, `e_7`, `e_8`, `e_9`, `e_10`, `e_11`, `e_12`, `spoiler`, `bumper_f`, `bumper_r`, `exhaust`, `grille`, `hood`, `roof`) VALUES (@plate, @owner, @name, @model, @color1, @color2, @livery, @wheel_type, @wheels_f, @e_1, @e_2, @e_3, @e_4, @e_5, @e_6, @e_7, @e_8, @e_9, @e_10, @e_11, @e_12, @spoiler, @bumper_f, @bumper_r, @exhaust, @grille, @hood, @roof)",
  {['@plate'] = plate,
  ['@owner'] = owner,
  ['@name'] = name,
  ['@model'] = vehicleData.model,
  ['@color1'] = vehicleData.color1,
  ['@color2'] = vehicleData.color2,
  ['@livery'] = vehicleData.modLivery,
  ['@wheel_type'] = vehicleData.wheels,
  ['@wheels_f'] = vehicleData.modFrontWheels,
  ['@e_1'] = vehicleData.extra1,
  ['@e_2'] = vehicleData.extra2,
  ['@e_3'] = vehicleData.extra3,
  ['@e_4'] = vehicleData.extra4,
  ['@e_5'] = vehicleData.extra5,
  ['@e_6'] = vehicleData.extra6,
  ['@e_7'] = vehicleData.extra7,
  ['@e_8'] = vehicleData.extra8,
  ['@e_9'] = vehicleData.extra9,
  ['@e_10'] = vehicleData.extra10,
  ['@e_11'] = vehicleData.extra11,
  ['@e_12'] = vehicleData.extra12,

  ['@spoiler'] = vehicleData.spoiler,
  ['@bumper_f'] = vehicleData.bumperF,
  ['@bumper_r'] = vehicleData.bumperR,
  ['@exhaust'] = vehicleData.exhaust,
  ['@grille'] = vehicleData.grille,
  ['@hood'] = vehicleData.hood,
  ['@roof'] = vehicleData.roof,
  }
  )
end

function checkForPlateIn_DB(plate)
  local foundPlate = MySQL.Sync.fetchAll("SELECT plate FROM vehicles WHERE plate = @plate",
  {['@plate'] = plate},
  function(result)
    --print('Fetch from table returned: ' .. json.encode(result))
    foundPlate = result[1].plate
  end)
  print(foundPlate[1])
end


-- function getSteam(target) -- target is player server ID
--   print("Evaluating ID: ".. target)
--   -- get identifiers
--   local identifiers = GetPlayerIdentifiers(target)
--   steam = nil
--   --print("Found an identifier: " .. identifiers[1])
--
--   -- sort through identifiers to find steam
--   for k, v in ipairs(GetPlayerIdentifiers(target)) do
--       if string.match(v, "steam:") then
--         -- set steam var as steam
--          steam = v
--          break
--       end
--     end
--     print('Found Steam ID: ' .. steam)
--   return steam
-- end


-- VEHICLE LOADING

-- get all saved vehicles that belong to player for populating menu
RegisterNetEvent('GetSaves')
AddEventHandler('GetSaves', function(source)

  local targetSteam = getSteam(source)

  local savedNames = MySQL.Sync.fetchAll("SELECT name FROM vehicles WHERE owner = @targetSteam",
  {['@targetSteam'] = targetSteam},
  function(result)
  end)
  print('Get saved vehicles returned: ' .. json.encode(savedNames))
  TriggerClientEvent('receiveSaves', source, savedNames)
end)

--[[ recieves name from client based on name in menu, then finds vehicle with
 that name belonging to source player ]]
RegisterNetEvent('getVehicleFromData')
AddEventHandler('getVehicleFromData', function(source, name)
  local vehicleData = {}
  local targetSteam = getSteam(source)

  local model = MySQL.Sync.fetchAll("SELECT model FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  print(model[1].model)
  local model = model[1].model

  local plate = MySQL.Sync.fetchAll("SELECT plate FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  print(plate[1].plate)
  local plate = plate[1].plate

  local color1 = MySQL.Sync.fetchAll("SELECT color1 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  -- print(color1[1].color1)
  local color1 = color1[1].color1

  local color2 = MySQL.Sync.fetchAll("SELECT color2 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  -- print(color2[1].color2)
  local color2 = color2[1].color2

  local livery = MySQL.Sync.fetchAll("SELECT livery FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  -- print(livery[1].livery)
  local livery = livery[1].livery

  local wheel_type = MySQL.Sync.fetchAll("SELECT wheel_type FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  -- print(wheel_type[1].wheel_type)
  local wheel_type = wheel_type[1].wheel_type

  local wheels_f = MySQL.Sync.fetchAll("SELECT wheels_f FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  -- print(wheels_f[1].wheels_f)
  local wheels_f = wheels_f[1].wheels_f

  local e_1 = MySQL.Sync.fetchAll("SELECT e_1 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  -- print(e_1[1].e_1)
  local e_1 = e_1[1].e_1

  local e_2 = MySQL.Sync.fetchAll("SELECT e_2 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
  -- print(e_2[1].e_2)
  local e_2 = e_2[1].e_2

  local e_3 = MySQL.Sync.fetchAll("SELECT e_3 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_3[1].e_3)
  local e_3 = e_3[1].e_3

  local e_4 = MySQL.Sync.fetchAll("SELECT e_4 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_4[1].e_4)
  local e_4 = e_4[1].e_4

  local e_5 = MySQL.Sync.fetchAll("SELECT e_5 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_5[1].e_5)
  local e_5 = e_5[1].e_5

  local e_6 = MySQL.Sync.fetchAll("SELECT e_6 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_6[1].e_6)
  local e_6 = e_6[1].e_6

  local e_7 = MySQL.Sync.fetchAll("SELECT e_7 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_7[1].e_7)
  local e_7 = e_7[1].e_7

  local e_8 = MySQL.Sync.fetchAll("SELECT e_8 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_8[1].e_8)
  local e_8 = e_8[1].e_8

  local e_9 = MySQL.Sync.fetchAll("SELECT e_9 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_9[1].e_9)
  local e_9 = e_9[1].e_9

  local e_10 = MySQL.Sync.fetchAll("SELECT e_10 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_10[1].e_10)
  local e_10 = e_10[1].e_10

  local e_11 = MySQL.Sync.fetchAll("SELECT e_11 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_11[1].e_11)
  local e_11 = e_11[1].e_11

  local e_12 = MySQL.Sync.fetchAll("SELECT e_12 FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(e_12[1].e_12)
  local e_12 = e_12[1].e_12

  local spoiler = MySQL.Sync.fetchAll("SELECT spoiler FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(spoiler)
  local spoiler = spoiler[1].spoiler

  local bumper_f = MySQL.Sync.fetchAll("SELECT bumper_f FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(bumper_f[1].bumper_f)
  local bumper_f = bumper_f[1].bumper_f

  local bumper_r = MySQL.Sync.fetchAll("SELECT bumper_r FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(bumper_r[1].bumper_r)
  local bumper_r = bumper_r[1].bumper_r

  local exhaust = MySQL.Sync.fetchAll("SELECT exhaust FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(exhaust[1].exhaust)
  local exhaust = exhaust[1].exhaust

  local grille = MySQL.Sync.fetchAll("SELECT grille FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(grille[1].grille)
  local grille = grille[1].grille

  local hood = MySQL.Sync.fetchAll("SELECT hood FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(hood[1].hood)
  local hood = hood[1].hood

  local roof = MySQL.Sync.fetchAll("SELECT roof FROM vehicles WHERE name = @name AND owner = @targetSteam",
  {['@name'] = name,
  ['@targetSteam'] = targetSteam},
  function(result)
  end)
--  print(roof[1].roof)
  local roof = roof[1].roof


    TriggerClientEvent('spawnFromSave', source, model, plate, color1, color2, livery, wheel_type, wheels_f, e_1, e_2, e_3, e_4, e_5, e_6, e_7, e_8, e_9, e_10, e_11, e_12, spoiler, bumper_f, bumper_r, exhaust, grille, hood, roof)
end)


--[[ DELETE SAVE COMMAND

THIS WILL BE SHOWN TO PLAYER IF THEY CLICK DELETE BUTTON]]

RegisterCommand('deleteSave', function(source, args)
  local vehName = ''

  for k, v in pairs(args) do
    vehName = vehName .. v .. ' '
  end

  print(vehName)

  local targetSteam = getSteam(source)
  MySQL.Sync.execute("DELETE FROM `nsrp`.`vehicles` WHERE owner = @owner AND name = @name",
  {['@owner'] = targetSteam,
  ['@name'] = vehName,})
end, false)
