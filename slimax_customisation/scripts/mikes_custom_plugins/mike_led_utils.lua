require "scripts/mikes_custom_plugins/mike_utils"

activeBlinkingLeds = {}
activePermanentLeds = {}
defaultBlinkDelay = 500
ledOn = 1
ledOff = 0

function updateLeds()
	updateBlinkingLeds()
	updateActivePermanentLeds()
end

function updateBlinkingLeds()
	for key, value in pairs(activeBlinkingLeds) do
		if mSessionEnter == 1 and not(m_is_sim_idle) then
			updateBlinkingLed(activeBlinkingLeds[key], key)
		else
			SetPatternLed(key, ledOff)
		end
	end	
end

function updateActivePermanentLeds()
	for key, value in pairs(activePermanentLeds) do
		updatePermLed(key, value)
	end	
end

function updateBlinkingLed(ledInfo, pattern) 
	if getTks() >= ledInfo["nextChange"] then
		ledInfo["nextChange"] = getTks() + ledInfo["delay"]
		if ledInfo["state"] == ledOn then
			ledInfo["state"] = ledOff
		else
			ledInfo["state"] = ledOn
		end
	end
	SetPatternLed(pattern, ledInfo["state"])
end

function updatePermLed(pattern, timeout)
	if timeout == 0 or getTks() <= timeout then
		SetPatternLed(pattern, ledOn)
	else
		deactivatePermanentLed(pattern)
	end
end

function activateBlinkingLed(pattern, delay)
	if activeBlinkingLeds[pattern] == nil then
		if delay == nil then
			delay = defaultBlinkDelay
		end
		activeBlinkingLeds[pattern] = {}
		activeBlinkingLeds[pattern]["delay"] = delay
		activeBlinkingLeds[pattern]["state"] = ledOn
		activeBlinkingLeds[pattern]["nextChange"] = getTks() + delay
		SetPatternLed(pattern, ledOn)
	end
end

function activatePermanentLed(pattern, delay)
	if activePermanentLeds[pattern] == nil then
		if delay == nil then
			delay = 0
		end
		activePermanentLeds[pattern] = getTks() + delay
		SetPatternLed(pattern, ledOn)
	end
end

function deactivatePermanentLed(pattern)
	activePermanentLeds[pattern] = nil
	SetPatternLed(pattern, ledOff)
end

function deactivateBlinkingLed(pattern)
	activeBlinkingLeds[pattern] = nil
	SetPatternLed(pattern, ledOff)
end
