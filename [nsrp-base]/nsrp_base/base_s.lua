-- Server command to send message to all players from console
RegisterCommand('ssay', function(source, args)
  local str = ''
  for i=1, #args, 1 do
    -- if i > 1 then
      str = str .. ' '
      str = str .. args[i]
    -- end
  end
  TriggerClientEvent('serverMessage', -1, str)
end, true)

-- Chat notes

local notes = {
  "Join our Discord for Rules & Additional Information Discord.gg/k2wBYZN",
  "Type /report [ID] [Message] to make a report. (If you don't know their ID use your own.)",
  "Join our CAD for better RP! Link in Discord.",
  "Type /tp to teleport to a random vehicle garage in AOP",
  "Press M to open up the menu",
  "Join our Discord and type 'visualpack' to download our visual pack for brighter police lights and more!",
  "Type /report [ID] [Message] to make a report. (If you don't know their ID use your own.)",
  "Type /tp to teleport to a random vehicle garage in AOP",
  "Press M to open up the menu",
  "Type /hidenotes to hide these messages!",
}

local timer = 5
local index = math.random(1,#notes)

CreateThread( function()
  while true do Wait(1000)
    if timer == 1 then
      print(notes[index])
      TriggerClientEvent('chatnote', -1, notes[index])
      timer = 240
      if index == #notes then
        index = 1
      else
        index = index + 1
      end
    else
      timer = timer - 1
    end
  end
end)


------------------------
------------------------
-------- REPORT --------
------------------------
------------------------


RegisterCommand('report', function(source, args)

  local reporterName = GetPlayerName(source)
  local reported = args[1]
  local reportedName = GetPlayerName(reported)
  local msg = ''

  for k, v in pairs(args) do
    if k ~= 1 then
      msg = msg .. ' ' .. v
    end
  end

  local players = GetPlayers()
  for k, v in pairs(players) do
    if IsPlayerAceAllowed(v, 'nsrp.aopcmds') then
      TriggerClientEvent('receiveReport', v, source, reporterName, reported, reportedName, msg)
    end
  end
end)
