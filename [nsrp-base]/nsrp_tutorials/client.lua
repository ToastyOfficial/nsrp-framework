local player = Entity(PlayerPedId())

AddEventHandler('playerSpawned', function()
  player = Entity(PlayerPedId())

  print("Player Level: " .. player.state.level)
  if player.state.level == 1 then
    TriggerEvent('tutorial', 'new')
  end

end)


-------------------------
-------------------------
---- TUTORIAL EVENTS ----
-------------------------
-------------------------


AddEventHandler('hideTutorials', function()
  SendNUIMessage({
    type = 'hideTutorials',
  })
  -- do blur stuff 
end)

AddEventHandler('tutorial', function(name)
  SendNUIMessage({
    type = 'showTutorial',
    tutorial = name,
  })
  -- do blur stuff
  -- disable controls
end)
