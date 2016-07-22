require "scripts/mike_utils"

activeLeds = {}
defaultBlinkDelay = 500
ledOn = 1
ledOff = 0

function updateBlinkingLeds()	
	for key, value in pairs(activeLeds) do
		if mSessionEnter == 1 and not(m_is_sim_idle) then
			updateLed(activeLeds[key], key)
		else
			SetPatternLed(key, ledOff)
		end
	end	
end

function updateLed(ledInfo, pattern) 
	if getTks() >= ledInfo["nextChange"] then
		ledInfo["nextChange"] = getTks() + ledInfo["delay"]
		if ledInfo["state"] == ledOn then
			ledInfo["state"] = ledOff
		else
			ledInfo["state"] = ledOn
		end
		SetPatternLed(pattern, ledInfo["state"])
	end
end

function activateLedBlink(pattern, delay)
	if activeLeds[pattern] == nil then
		if delay == nil or delay <= 0 then
			delay = defaultBlinkDelay
		end
		activeLeds[pattern] = {}
		activeLeds[pattern]["delay"] = delay
		activeLeds[pattern]["state"] = ledOn
		activeLeds[pattern]["nextChange"] = getTks() + delay
		SetPatternLed(pattern, ledOn)
	end
end

function deactivateLedBlink(pattern, delay)
	activeLeds[pattern] = nil
	SetPatternLed(pattern, ledOff)
end
