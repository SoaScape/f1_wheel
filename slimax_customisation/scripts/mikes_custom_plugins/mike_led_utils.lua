require "scripts/mikes_custom_plugins/mike_utils"

local activeBlinkingLeds = {}
local activeAlternateBlinkingLeds = {}
local activePermanentLeds = {}
local defaultBlinkDelay = 500
local alternateLedBlinkDelay = 500
local ledOn = 1
local ledOff = 0

-- LED Patterns Calculated As Follows
--
-- LED ID:		54321---
-- Binary Bit:	XXXXX000

local function updateBlinkingLed(ledInfo, pattern)
	local ticks = getTks()
	if ledInfo["endTime"] > 0 and ticks >= ledInfo["endTime"] then
		deactivateBlinkingLed(pattern)
	else
		if ticks >= ledInfo["nextChange"] then
			ledInfo["nextChange"] = ticks + ledInfo["delay"]
			if ledInfo["state"] == ledOn then
				ledInfo["state"] = ledOff
			else
				ledInfo["state"] = ledOn
			end
		end

		local state = ledOff
		if not(not(ledInfo["enabledWhenIdle"]) and mSessionEnter ~= 1 and m_is_sim_idle) then
			state = ledInfo["state"]
		end
		SetPatternLed(pattern, state)
	end
end

local function updateAlternateBlinkingLed(id, ledInfo)
	local ticks = getTks()
	if ledInfo["endTime"] > 0 and ticks >= ledInfo["endTime"] and ledInfo["currentPatternIndex"] == tablelength(ledInfo["patterns"]) - 1 then
		deactivateAlternateBlinkingLeds(id)
	else
		if ticks >= ledInfo["nextChange"] then
			ledInfo["nextChange"] = ticks + ledInfo["delay"]
			
			if ledInfo["currentPatternIndex"] < tablelength(ledInfo["patterns"]) - 1 then
				ledInfo["currentPatternIndex"] = ledInfo["currentPatternIndex"] + 1
			else
				ledInfo["currentPatternIndex"] = 0
			end
		end
		
		for key, value in pairs(ledInfo["patterns"]) do
			local ledState = ledOff
			if key == ledInfo["currentPatternIndex"] and not(not(ledInfo["enabledWhenIdle"]) and mSessionEnter ~= 1 and m_is_sim_idle) then
				ledState = ledOn
				SetPatternLed(value, ledState)
			end			
		end
	end
end

local function updatePermLed(pattern, ledInfo)
	if not(ledInfo["enabledWhenIdle"]) and mSessionEnter ~= 1 and m_is_sim_idle then
		SetPatternLed(pattern, ledOff)
	elseif ledInfo["nextChange"] == 0 or getTks() <= ledInfo["nextChange"] then
		SetPatternLed(pattern, ledOn)
	else
		deactivatePermanentLed(pattern)
	end
end

local function updateBlinkingLeds()
	for key, value in pairs(activeBlinkingLeds) do
		if mSessionEnter == 1 and not(m_is_sim_idle) then
			updateBlinkingLed(value, key)
		else
			SetPatternLed(key, ledOff)
		end
	end	
end

local function updateAlternateBlinkingLeds()
	for key, value in pairs(activeAlternateBlinkingLeds) do		
		updateAlternateBlinkingLed(key, value)
	end	
end

local function updateActivePermanentLeds()
	for key, value in pairs(activePermanentLeds) do
		updatePermLed(key, value)
	end	
end

function updateLeds()
	updateActivePermanentLeds()
	updateAlternateBlinkingLeds()
	updateBlinkingLeds()
end

function activateBlinkingLed(pattern, delay, duration, enabledWhenIdle)
	if activeBlinkingLeds[pattern] == nil then
		if delay == nil then
			delay = defaultBlinkDelay
		end
		activeBlinkingLeds[pattern] = {}
		activeBlinkingLeds[pattern]["delay"] = delay
		
		local endTime = 0
		if duration > 0 then
			endTime = getTks() + duration
		end
		
		activeBlinkingLeds[pattern]["endTime"] = endTime
		activeBlinkingLeds[pattern]["state"] = ledOff
		activeBlinkingLeds[pattern]["nextChange"] = 0
		activeBlinkingLeds[pattern]["enabledWhenIdle"] = enabledWhenIdle
	end
end

function activateAlternateBlinkingLeds(id, patterns, delay, enabledWhenIdle, duration)
	if activeAlternateBlinkingLeds[id] == nil then
		if delay == nil then
			delay = alternateLedBlinkDelay
		end
		
		local endTime = 0
		if duration > 0 then
			endTime = getTks() + duration
		end
		
		activeAlternateBlinkingLeds[id] = {}
		activeAlternateBlinkingLeds[id]["delay"] = delay
		activeAlternateBlinkingLeds[id]["nextChange"] = getTks() + delay
		activeAlternateBlinkingLeds[id]["currentPatternIndex"] = 0
		activeAlternateBlinkingLeds[id]["patterns"] = patterns
		activeAlternateBlinkingLeds[id]["enabledWhenIdle"] = enabledWhenIdle
		activeAlternateBlinkingLeds[id]["endTime"] = endTime
	end
end

function activatePermanentLed(pattern, delay, enabledWhenIdle)
	if activePermanentLeds[pattern] == nil then
		local nextChange = 0
		if delay > 0 then
			nextChange = getTks() + delay
		end
		
		activePermanentLeds[pattern] = {}
		activePermanentLeds[pattern]["nextChange"] = nextChange
		activePermanentLeds[pattern]["enabledWhenIdle"] = enabledWhenIdle
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
