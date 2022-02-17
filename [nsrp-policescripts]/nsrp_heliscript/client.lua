heli = nil

fov = 35.0
speed_lr = 16.0 -- speed by which the camera pans left-right
speed_ud = 24.0 -- speed by which the camera pans up-down

cam = nil
camEnabled = false
camLoc =  nil
forwardVec = nil

visionMode = 1 -- 1 (default), 2 (night vision), 3 (thermal)
scaleform = nil

spotEnabled = false

-- VARIABLES FOR HANDLING NETWORK SPOTLIGHT

local serverSpotEnabled = false
refObjLoc = nil -- user object location

mySpotDir = nil
myHeli = nil
myRefObj = nil -- viewer object
myRefObjLoc = nil -- viewer object location
mySpotlightRefObj = nil
local myForVec = vector3(0, 0, 0)

---------------------------------------
------------- Keymappings -------------
---------------------------------------
---------------------------------------

-- TOGGLE CAM --
----------------
--RegisterKeyMapping('toggle_cam', 'Toggle Heli Camera', 'keyboard', 'e')
RegisterCommand('camToggle', function()
  if not camEnabled then
    camEnabled = true
    print('Cam on!')

    -- set view filter effect
    SetTimecycleModifier("heliGunCam")
    SetTimecycleModifierStrength(0.2)

    -- scaleform
    scaleform = RequestScaleformMovie("HELI_CAM")
    while not HasScaleformMovieLoaded(scaleform) do
      Citizen.Wait(0)
    end

    local ped = PlayerPedId()
    heli = GetVehiclePedIsIn(ped)

    -- create camera
    cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

    print(heli)
    print(cam)
    AttachCamToEntity(cam, heli, 0.0, 4.0, -2.0, true)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli))
    SetCamFov(cam, fov)

    RenderScriptCams(true, false, 0, 1, 0)


  else

    camEnabled = false
    print('Cam off!')

    ClearTimecycleModifier()
    RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
    SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
    DestroyCam(cam, false)
    SetNightvision(false)
    SetSeethrough(false)
	end
end, false)

-- VISION MODE --
----------------
--RegisterKeyMapping('change_display', 'Change Camera View', 'keyboard', 'q')
RegisterCommand('cycleView', function()
  print('Changing vision mode.')
  if camEnabled then
    if visionMode == 1 then
  		SetNightvision(true)
  		visionMode = 2
  	elseif visionMode == 2 then
  		SetNightvision(false)
  		SetSeethrough(true)
  		visionMode = 3
  	else
  		SetSeethrough(false)
  		visionMode = 1
  	end
  else -- if not in cam
    visionMode = 1
  end
end)

-- TOGGLE SPOTLIGHT --
----------------
--RegisterKeyMapping('toggle_spot', 'Toggle Heli Spotlight', 'keyboard', 'g')
RegisterCommand('spotToggle', function()
  CreateThread(function()
    -- if someone is already using spotlight then
    if not serverSpotEnabled then
      if not spotEnabled then
        spotEnabled = true
        print('Spot on!')
        Wait(100)
        local user = GetPlayerServerId(PlayerId())
        TriggerServerEvent('s:spotActivated', refObjLoc, user)
      else
        spotEnabled = false
        print('Spot off!')
        TriggerServerEvent('s:spotDeactivated')
      end
    end
  end)
end)


---------------------------------------
--------------- Threads ---------------
---------------------------------------
---------------------------------------

-- while cam enabled
CreateThread(function()
  while true do Wait(0)
    if camEnabled then
      -- Update cam rotation from mouse movement
      CheckInputRotation(cam, 0)
      -- Hide game HUD
      HideHUDThisFrame()
      -- Hide NSRP HUD

      -- DRAW HELI CAM SCALEFORM HUD ELEMENTS
      BeginScaleformMovieMethod(scaleform, "SET_ALT_FOV_HEADING")
      ScaleformMovieMethodAddParamFloat(GetEntityCoords(heli).z)
      PushScaleformMovieFunctionParameterFloat(0.5)
      ScaleformMovieMethodAddParamFloat(GetCamRot(cam, 2).z)
      DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
      EndScaleformMovieMethod()

      if spotEnabled then
        camLoc = GetCamCoord(cam)

        local camRot = GetCamRot(cam)
        forwardVec = rotAnglesToVec(camRot)
        --print(forwardVec)
        refObjLoc = camLoc + forwardVec * 100
        --DrawSphere(refObjLoc, 2.0, 150, 200, 255, 0.2)
        DrawSpotLightWithShadow(camLoc, forwardVec, 255, 255, 255, 700.0, 0.5, 0.1, 6.0, 40.0, 1)
      end
    end
  end
end)

-- tell other clients wher eto draw spotlight
CreateThread(function()
  while true do Wait(25)
    if spotEnabled then -- if i'm the user
      --print(forwardVec)
      TriggerServerEvent('s:updateSpotlight', forwardVec)
    end
  end
end)
-- user while spotlight enabled
-- CreateThread(function()
--   while true do
--
--   Wait(0)
--   end
-- end)

---------------------------------------
--------------- Viewer ----------------
---------------------------------------
---------------------------------------

RegisterNetEvent('c:serverSpotEnabled')
AddEventHandler('c:serverSpotEnabled', function(location, user)
  print('Recieved spotlight enable event')
  if not spotEnabled then -- if I'm not the one who enabled i
    print(user)
    local spotUser = GetPlayerFromServerId(user)
    print(spotUser)
    local userPed = GetPlayerPed(spotUser)
    print(userPed)
    myHeli = GetVehiclePedIsIn(userPed, false)
    print(myHeli)
    print(GetEntityCoords(userPed))

    RequestModel(1871573721)

  	while not HasModelLoaded(1871573721) do
  			Citizen.Wait(100)
  			print('loading')
  	end

    --mySpotlightRefObj = CreateObject(1871573721, location, false, false, true)
    --SetEntityCollision(mySpotlightRefObj, false, true)
    SetModelAsNoLongerNeeded(1871573721)

    serverSpotEnabled = true
  end
end)

RegisterNetEvent('c:serverSpotDisabled')
AddEventHandler('c:serverSpotDisabled', function()
  print('Recieved spotlight disable event')
    serverSpotEnabled = false
end)

RegisterNetEvent('c:updateSpotlight')
AddEventHandler('c:updateSpotlight', function(forVec)
  --print('Recieved spotlight update event')

  --print(forVec)
  myForVec = forVec

end)

-- move reference object and draw spotlight
CreateThread(function()
  while true do
    if serverSpotEnabled then
      if not spotEnabled then -- if im not the user
        local heliCoords = GetEntityCoords(myHeli)
        local mySpotLoc = heliCoords + vector3(0, 1, -1)

        DrawSpotLightWithShadow(mySpotLoc, myForVec, 255, 255, 255, 700.0, 0.5, 0.1, 6.0, 40.0, 1)
      end
    end
    Wait(0)
  end
end)
