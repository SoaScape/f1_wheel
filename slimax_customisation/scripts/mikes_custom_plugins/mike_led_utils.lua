require "scripts/mikes_custom_plugins/mike_utils"

activeBlinkingLeds = {}
activeAlternateBlinkingLeds = {}
activePermanentLeds = {}
defaultBlinkDelay = 500
alternateLedBlinkDelay = 500
ledOn = 1
ledOff = 0

function updateLeds()
	if mSessionEnter == 1 and not(m_is_sim_idle) then
		updateBlinkingLeds()
		updateActivePermanentLeds()
		updateAlternateBlinkingLeds()
	end
end

function updateBlinkingLeds()
	for key, value in pairs(activeBlinkingLeds) do
		if mSessionEnter == 1 and not(m_is_sim_idle) then
			updateBlinkingLed(value, key)
		else
			SetPatternLed(key, ledOff)
		end
	end	
end

function updateAlternateBlinkingLeds()
	for key, value in pairs(activeAlternateBlinkingLeds) do
		if mSessionEnter == 1 and not(m_is_sim_idle) then
			updateAlternateBlinkingLed(value)
		else
			for key, value in pairs(value["patterns"]) do
				SetPatternLed(value, ledOff)
			end
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

function updateAlternateBlinkingLed(ledInfo) 
	if getTks() >= ledInfo["nextChange"] then
		ledInfo["nextChange"] = getTks() + ledInfo["delay"]
		
		if ledInfo["currentPatternIndex"] < tablelength(ledInfo["patterns"])-1 then
			ledInfo["currentPatternIndex"] = ledInfo["currentPatternIndex"] + 1
		else
			ledInfo["currentPatternIndex"] = 0
		end
	end
	
	for key, value in pairs(ledInfo["patterns"]) do
		local ledState = ledOff
		if key == ledInfo["currentPatternIndex"] then
			ledState = ledOn
		end
		SetPatternLed(value, ledState)
	end
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

function activateAlternateBlinkingLeds(id, patterns, delay)
	if activeAlternateBlinkingLeds[id] == nil then
		if delay == nil then
			delay = alternateLedBlinkDelay
		end
		activeAlternateBlinkingLeds[id] = {}
		activeAlternateBlinkingLeds[id]["delay"] = delay
		activeAlternateBlinkingLeds[id]["nextChange"] = getTks() + delay
		activeAlternateBlinkingLeds[id]["currentPatternIndex"] = 0
		activeAlternateBlinkingLeds[id]["patterns"] = patterns
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
	if activePermanentLeds[pattern] ~= nil then
		activePermanentLeds[pattern] = nil
		SetPatternLed(pattern, ledOff)
	end
end

function deactivateBlinkingLed(pattern)
	if activeBlinkingLeds[pattern] ~= nil then
		activeBlinkingLeds[pattern] = nil
		SetPatternLed(pattern, ledOff)
	end
end

function deactivateAlternateBlinkingLeds(id)
	if activeAlternateBlinkingLeds[id] ~= nil then
		for key, value in pairs(activeAlternateBlinkingLeds[id]["patterns"]) do
			SetPatternLed(value, ledOff)
		end
		activeAlternateBlinkingLeds[id] = nil
	end
end
