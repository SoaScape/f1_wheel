safetyCarMultifunctionName = "SAFE"
local lastMode = ""
local safetyCarModeActive = false
local safetyCarActiveMessageDelay = 10000
local lastSafetyCarMessageTime = 0

local function activateSafetyCarMode()
	safetyCarModeActive = true
	
	if isOvertakeActive() then
		toggleOvertakeMode(false, false)
	end

	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["min"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)
	autoMixOff()
	autoMixInhibitOn()
	autoDiffInhibitOn()
end

local function safetyCarEnd()
	safetyCarModeActive = false
	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["max"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)
	autoDiffInhibitOff()
	autoMixInhibitOff()
	if safetyCarLedPattern ~= nil then
		deactivatePermanentLed(safetyCarLedPattern)
	else
		display("SAFE", " END", 2000)
	end
end

local function safetyCarModeSelected()
	if safetyCarModeActive then
		display(safetyCarMultifunctionName, "ACTV", mDisplay_Info_Delay)
	elseif GetContextInfo("yellow_flag") and mSessionEnter == 1 and not(m_is_sim_idle) then
		activateSafetyCarMode()
	else
		currentMultifunction = nil
		display(safetyCarMultifunctionName, "UNAV", mDisplay_Info_Delay)
	end	
end

function processSafetyCarButtonEvent(button)
	if button == confirmButton and safetyCarModeActive and mSessionEnter == 1 and not(m_is_sim_idle) then
		safetyCarEnd()
	end
end

function safetyCarModeRegularProcessing()	
	if safetyCarModeActive and mSessionEnter == 1 and not(m_is_sim_idle) then
		if GetContextInfo("yellow_flag") or inPits() then
			if safetyCarLedPattern ~= nil then
				activatePermanentLed(safetyCarLedPattern, 0, false)
			elseif getTks() - lastSafetyCarMessageTime >= safetyCarActiveMessageDelay then
				lastSafetyCarMessageTime = getTks()
				display("SAFE", " CAR", 1000)
			end
		else
			safetyCarEnd()
		end
	end

	if safetyCarModeEnabled and currentMultifunction ~= nil then
		currentMode = currentMultifunction["name"]
		if currentMode == safetyCarMultifunctionName then
			if currentMode ~= lastMode then
				safetyCarModeSelected()
			end
		end
		lastMode = currentMode
	end
end

function resetSafetyCarMode()
	safetyCarModeActive = false
	lastSafetyCarMessageTime = 0
end
