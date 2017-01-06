require "scripts/mikes_custom_plugins/mike_led_utils"

startMultifunctionName = "STRT"
local raceStartModeActive = false
local lastMode = ""
local raceStartLedId = "racestart"
local raceStartLedPatterns = {}
raceStartLedPatterns[0] = 80	-- 2, 4  = 1010000
raceStartLedPatterns[1] = 160	-- 3, 5  = 10100000
local raceStartPermLedPattern = 8		-- 1     = 1000
local raceGoLedPattern = 56           -- 1,2,3 = 111000

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
	display(left, right, 2000)	
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
				resetAutoMixData()
				activateBlinkingLed(raceGoLedPattern, 50, 2000, false)
				display(startMultifunctionName, " GO ", 2000)				
				performRaceStart()
				storeStartFuel()
			end
		else
			if raceStartModeActive then
				exitRaceStart()
				raceStartModeActive = false
				display(startMultifunctionName, " END", 2000)
			end
			deactivateAlternateBlinkingLeds(raceStartLedId)
			deactivatePermanentLed(raceStartPermLedPattern)
		end
		
		lastMode = modeName
	end
end
