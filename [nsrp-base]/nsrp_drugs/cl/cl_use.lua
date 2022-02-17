local NSRPWeedDura = 60*1000


prefix = "^1[NSRP Drugs]^2 "
high = false
DisabledRun = false

Citizen.CreateThread(function()
		Citizen.Wait(0)
		if DisabledRun == true then
			DisableControlAction(0,21,true)
		end
end)


RegisterCommand("iWeed", function(source, args, rawCommand)
	if #args < 1 then

	    TriggerEvent('chat:addMessage', {
			color = { 255, 0, 0},
			multiline = true,
			args = {"NSRP Drugs", "^2Correct usage of command is ^*/iWeed <amount>"}
		})
	    return;
	end
	if high == false then
		local amount = tonumber(args[1])
		local target = args[1]
		local item = 'iWeed'
		TriggerServerEvent('i:takeItem', target, item, amount)
		TriggerEvent('chat:addMessage', {
			color = { 255, 0, 0},
			multiline = true,
			args = {"NSRP Drugs", "^2You have smoked ".. amount.." gram(s) of weed"}
		})
		ShakeGameplayCam('DRUNK_SHAKE', 0.35)
		SetPedMotionBlur(GetPlayerPed(-1), true)
		runAnim("move_m@muscle@a")
		local FadeTime = (NSRPWeedDura/10)
		high = true
		SetTimecycleModifier('BloomMid')
		Citizen.Wait(NSRPWeedDura*amount)
		high = false
		StopGameplayCamShaking(true)
		resetAnims()
		SetPedMotionBlur(GetPlayerPed(-1), false)
		SetTransitionTimecycleModifier('default', 0.35)
	else
	TriggerEvent('chat:addMessage', {
		color = { 255, 0, 0},
		multiline = true,
		args = {"NSRP Drugs", "^2^*You are already high"}
	})
	end
end)


function runAnim(anim)
	RequestAnimSet(anim)
	SetPedMovementClipset(GetPlayerPed(-1), anim, true)
end

function resetAnims()
	ResetPedMovementClipset(GetPlayerPed(-1))
	ResetPedWeaponMovementClipset(GetPlayerPed(-1))
	ResetPedStrafeClipset(GetPlayerPed(-1))
end
