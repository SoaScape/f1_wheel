require "scripts/mikes_custom_plugins/mike_led_utils"

startMultifunctionName = "STRT"
local raceStartModeActive = false
local lastMode = ""
local raceStartLedId = "racestart"
local raceGoLedId = "racego"
local raceStartLedPatterns = {}
raceStartLedPatterns[0] = 0x50		-- 2, 4  = 1010000
raceStartLedPatterns[1] = 0xA0		-- 3, 5  = 10100000
local raceStartPermLedPattern = 0x8	-- 1     = 1000
local raceGoLedPatterns = {}		-- 1,2,3 = 111000
raceGoLedPatterns[0] = 0x10			-- 2 = 10000
raceGoLedPatterns[1] = 0x8			-- 1 = 1000
raceGoLedPatterns[2] = 0x20			-- 3 = 100000
raceGoLedPatterns[3] = 0x8			-- 1 = 1000
raceGoLedPatterns[4] = 0x10			-- 2 = 10000

local function raceStartModeSelected()	
	if mSessionEnter ~= 1 and m_is_sim_idle then
		activateAlternateBlinkingLeds(raceStartLedId, raceStartLedPatterns, nil, true, 0)
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
	if raceStartModeEnabled and currentMultifunction ~= nil then
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
				resetUtilsData()
				activateAlternateBlinkingLeds(raceGoLedId, raceGoLedPatterns, 50, true, 500)
				display(startMultifunctionName, " GO ", 2000)				
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
			deactivatePermanentLed(raceStartPermLedPattern)
		end
		
		lastMode = modeName
	end
end
