require "scripts/mikes_custom_plugins/mike_utils"
require "scripts/mikes_custom_plugins/mike_led_utils"

startMultifunctionName = "STRT"
awaitingRaceStart = false
raceStartModeActive = false

function raceStartModeSelected()
	if not(awaitingRaceStart) and not(raceStartModeActive) then					
		if mSessionEnter ~= 1 and m_is_sim_idle then
			awaitingRaceStart = true
			raceStartModeActive = false
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
	if(awaitingRaceStart and mSessionEnter == 1 and not(m_is_sim_idle)) then
		awaitingRaceStart = false
		raceStartModeActive = true
		storeStartFuel()
		performRaceStart()
		display("RACE", startMultifunctionName, myDevice, 2000)
	elseif(raceStartModeActive and currentMultifunction["name"] ~= startMultifunctionName and mSessionEnter == 1 and not(m_is_sim_idle)) then		
		exitRaceStart()
		awaitingRaceStart = false
		raceStartModeActive = false
		display(startMultifunctionName, " END", myDevice, 2000)
	end
end
