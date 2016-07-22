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

function activateLedBlink(pattern)
	activateLedBlink(pattern, defaultBlinkDelay)
end

function activateLedBlink(pattern, delay)
	if activeLeds[pattern] == nil then
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

function getTks()
	local ticks = GetAppInfo("ticks")
	if ticks == nil then
		ticks = 0
	end
	return ticks
end