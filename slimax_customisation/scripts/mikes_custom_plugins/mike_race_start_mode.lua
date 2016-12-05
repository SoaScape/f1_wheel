require "scripts/mikes_custom_plugins/mike_led_utils"

startMultifunctionName = "STRT"
raceStartModeActive = false
lastMode = ""
raceStartLedId = "racestart"
raceStartLedPatterns = {}
raceStartLedPatterns[0] = 80	-- 2, 4
raceStartLedPatterns[1] = 160	-- 3, 5
raceStartPermLedPattern = 8		-- 1
raceGoLedPattern = 56

function raceStartModeSelected()	
	if mSessionEnter ~= 1 and m_is_sim_idle then
		activateAlternateBlinkingLeds(raceStartLedId, raceStartLedPatterns, nil, true)
		activatePermanentLed(raceStartPermLedPattern, 0, true)
		left = startMultifunctionName
		right = "WAIT"
	else
		left = startMultifunctionName
		right = "UNAV"
		currentMultifunction = nil
	end
	display(left, right, myDevice, 2000)	
end

function raceStartRegularProcessing()
	if currentMultifunction ~= nil then
		local inStartMode = currentMultifunction["name"] == startMultifunctionName
		local modeName = currentMultifunction["name"]
		
		if inStartMode then
			if currentMultifunction["name"] ~= lastMode then
				raceStartModeSelected()
			elseif not(raceStartModeActive) and mSessionEnter == 1 and not(m_is_sim_idle) then
				raceStartModeActive = true
				deactivateAlternateBlinkingLeds(raceStartLedId)
				deactivatePermanentLed(raceStartPermLedPattern)
				storeStartFuel()
				resetAutoMixData()
				activateBlinkingLed(raceGoLedPattern, 50, 2000, false)
				display(startMultifunctionName, " GO ", myDevice, 2000)				
				performRaceStart()				
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
		
		lastMode = modeName
	end
end
