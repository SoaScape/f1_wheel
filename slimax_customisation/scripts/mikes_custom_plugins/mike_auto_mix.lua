autoMixMultifunctionName = "AUTO"
autoMixTrackId = 0

autoMixModes = {}
autoMixModes[0] = "ACTV"
autoMixModes[1] = "PROG"
autoMixModes[2] = "LERN"
autoMixModeId = 0
autoMixMode = autoMixModes[autoMixModeId]
numAutoMixModes = tablelength(autoMixModes)

autoMixFuelMode = fuelMultiFunction["currentUpDnMode"]

function autoMixRegularProcessing
	if autoMixEnabled and currentMultifunction ~= nil and currentMultifunction["name"] == autoMixMultifunctionName then
		autoMixTrack = autoMixTable[autoMixTrackId]
		if mSessionEnter == 1 and not(m_is_sim_idle) then
			if autoMixMode == "ACTV" then
				local distance = GetContextInfo("lap_distance")
				if autoMixTrack["mixEvents"][distance] ~= nil then
					local fuelMode = autoMixTrack["mixEvents"][distance]					
					multiFunctionBak = currentMultifunction
					currentMultifunction = fuelMultiFunction					
					currentMultifunction["currentUpDnMode"] = currentMultifunction[fuelMode]
					confirmSelection("AUTO", fuelMultiFunction["modes"][fuelMode], myDevice, getButtonMap(currentMultifunction), showDisplay)					
					currentMultifunction = multiFunctionBak
				end
			end
		end
	end
end

function processAutoMixFuelModeChange(mode)
	if mode >= fuelMultiFunction["min"] and mode <= fuelMultiFunction["max"] then
		autoMixFuelMode = mode
		display("AMIX", fuelMultiFunction["modes"][autoMixFuelMode], myDevice, 500)
	end
end

function processAutoMixButtonEvent(button)
	-- Up/dn buttons control automix track selection
	if button == upEncoder then
		if autoMixTrackId < tablelength(autoMixTable-1) then
			autoMixTrackId = autoMixTrackId + 1			
		else
			autoMixTrackId = 0
		end
		autoMixTrack = autoMixTable[autoMixTrackId]
		display("TRCK", autoMixTrack["track"], myDevice, 1000)
	elseif button == downEncoder then
		if autoMixTrackId > 0 then
			autoMixTrackId = autoMixTrackId - 1
		else
			autoMixTrackId = tablelength(autoMixTable-1)
		end
		autoMixTrack = autoMixTable[autoMixTrackId]
		display("TRCK", autoMixTrack["track"], myDevice, 1000)
		
	-- Up/dn encoders control automix mode
	elseif button == upButton then
		if autoMixModeId < numAutoMixModes-1 then
			autoMixModeId = autoMixModeId + 1			
		else
			autoMixModeId = 0
		end
		autoMixMode = autoMixModes[autoMixModeId]
		display("MODE", autoMixMode, myDevice, 1000)
	elseif button == downButton then
		if autoMixModeId > 0 then
			autoMixModeId = autoMixModeId - 1
		else
			autoMixModeId = numAutoMixModes - 1
		end
		autoMixMode = autoMixModes[autoMixModeId]
		display("MODE", autoMixMode, myDevice, 1000)
		
	-- OT button in autoMix prog mode indicates mix change to store
	elseif button == overtakeButton and autoMixMode = "PROG" then
		local distance = GetContextInfo("lap_distance")
		autoMixTrack["mixEvents"][distance] = autoMixFuelMode
		display(fuelMultiFunction["modes"][autoMixFuelMode], string(distance), myDevice, 1000)
	end
end