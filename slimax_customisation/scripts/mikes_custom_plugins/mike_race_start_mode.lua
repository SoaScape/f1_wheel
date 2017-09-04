require "scripts/mikes_custom_plugins/mike_led_utils"

startMultifunctionName = "STRT"
local raceStartModeActive = false
local lastMode = ""

local raceStartLedId = "racestart"
local raceGoLedDelay = 75
local raceGoLedDuration = 600

local function raceStartModeSelected()	
	if mSessionEnter ~= 1 and m_is_sim_idle then
		activateAlternateBlinkingLeds(raceStartLedId, raceStartLedPatterns, nil, true, 0)
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
	if raceStartModeEnabled and currentMultifunction ~= nil then
		local inStartMode = currentMultifunction["name"] == startMultifunctionName
		local modeName = currentMultifunction["name"]
		
		if inStartMode then
			if currentMultifunction["name"] ~= lastMode then
				raceStartModeSelected()
			elseif not(raceStartModeActive) and mSessionEnter == 1 and not(m_is_sim_idle) then
				raceStartModeActive = true
				deactivateAlternateBlinkingLeds(raceStartLedId)
				resetAutoMixData()
				resetUtilsData()
				activateBlinkingLed(raceGoLedPattern, raceGoLedDelay, raceGoLedDuration, false)
				display("RACE", " GO ", 2000)				
				performRaceStart()
				storeStartFuel()
			end
		else
			if raceStartModeActive then
				exitRaceStart()
				raceStartModeActive = false
				display(startMultifunctionName, "EXIT", 2000)
			end
			deactivateAlternateBlinkingLeds(raceStartLedId)
		end
		
		lastMode = modeName
	end
end
