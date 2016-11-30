require "scripts/mikes_custom_plugins/mike_led_utils"

startMultifunctionName = "STRT"
raceStartModeActive = false
lastMode = ""
raceStartLedId = "racestart"
raceStartLedPatterns = {}
raceStartLedPatterns[0] = 80	-- 2, 4
raceStartLedPatterns[1] = 130	-- 3, 5
raceStartPermLedPattern = 8		-- 8

function raceStartModeSelected()
	if not(raceStartModeActive) then					
		if mSessionEnter ~= 1 and m_is_sim_idle then
			activateAlternateBlinkingLeds(raceStartLedId, raceStartLedPatterns, nil, true)
			activatePermanentLed(raceStartPermLedPattern, 0, true)
			left = startMultifunctionName
			right = "MODE"
		else
			left = " IN "
			right = "PROG"
		end
		display(left, right, deviceType, multiSelectDelay)
	end
end

function raceStartRegularProcessing()
	local inStartMode = currentMultifunction["name"] == startMultifunctionName
	
	if inStartMode then
		if currentMultifunction["name"] ~= lastMode then
			raceStartModeSelected()
		elseif not(raceStartModeActive) and mSessionEnter == 1 and not(m_is_sim_idle) then				
			raceStartModeActive = true
			deactivateAlternateBlinkingLeds(raceStartLedId)
			storeStartFuel()
			performRaceStart()
			display("RACE", startMultifunctionName, myDevice, 2000)
		end
	else
		if raceStartModeActive then
			exitRaceStart()
			raceStartModeActive = false
			display(startMultifunctionName, " END", myDevice, 2000)
		end
		deactivateAlternateBlinkingLeds(raceStartLedId)
		deactivatePermanentLed(raceStartPermLedPattern)
	end
	
	lastMode = currentMultifunction["name"]
end
