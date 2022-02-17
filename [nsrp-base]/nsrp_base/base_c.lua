-- Receive message from server  console
RegisterNetEvent('serverMessage')
AddEventHandler('serverMessage', function(string)
  TriggerEvent('chat:addMessage', {
    color = {0, 255, 255},
    multiline = true,
    args = {"Server", string}
  })
end)

-- Receive chat note from server
local hideNotes = false
RegisterCommand('hidenotes', function()
  hideNotes = not hideNotes
  if hideNotes then
    TriggerEvent('chat:addMessage', {
      color = {158, 151, 206},
      multiline = true,
      args = {'Chat notes now hidden.'}
    })
  else
    TriggerEvent('chat:addMessage', {
      color = {158, 151, 206},
      multiline = true,
      args = {'Chat notes now enabled.'}
    })
  end
end)

RegisterNetEvent('chatnote')
AddEventHandler('chatnote', function(message)

  if not hideNotes then
    TriggerEvent('chat:addMessage', {
      color = {136, 198, 225},
      multiline = true,
      args = {message}
    })
  end

end)


------------------------
------------------------
-------- REPORT --------
------------------------
------------------------

RegisterNetEvent('receiveReport')
AddEventHandler('receiveReport', function(reporter, reporterName, reported, reportedName, msg)
  TriggerEvent('chat:addMessage', {
    color = {255, 90, 90},
    multiline = true,
    args = {"NEW REPORT ON: " .. reportedName .. ' [' .. reported .. [[]
    REASON: ^7]] .. msg .. [[ 
    ^4REPORTED BY: ]] .. reporterName .. ' [' .. reporter .. ']'}
  })
end)
