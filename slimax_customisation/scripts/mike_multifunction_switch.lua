require "scripts/mike_utils"
require "scripts/one_switch_to_rule_them_all"

--------------------------------------------------
-- Set These Values To The Buttons You Want To Use
confirmButton = 14
upButton = 26
downButton = 27
upEncoder = 22
downEncoder = 21
overtakeButton = 10
startFuelLockButton = 3
--------------------------------------------------
keystrokeDelay = 200
selectDelay = 600
confirmDelay = 1000
multiSelectDelay = 500

customDisplayActive = false
customDisplayTicksTimeout = 0

oneSWActivated = true
displaySwitchId = 2
settingSwitchId = 1

simrF1DeviceType = 3
switch = 0
pushbutton = 1
multiFunctionSwitch = 3
buttonReleaseValue = 0

resetMultiFunctionName = "RSET"
encoderIncrement = 10

currentMultifunction = nil
overtakeEngaged = false

function multiControlsEvent(deviceType, ctrlType, ctrlPos, value, funcIndex, targetDevice)
	if deviceType == simrF1DeviceType then	
		--print("ctrlType: " .. ctrlType .. ", ctrlPos: " .. ctrlPos .. ", value: " .. value .. "\n")
		if ctrlType == switch and ctrlPos == multiFunctionSwitch then			
			currentMultifunction = multifunctionMap[value]
			
			if currentMultifunction["upDnSelectable"] then
				display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, multiSelectDelay)
			else
				display("MULT", currentMultifunction["name"], deviceType, multiSelectDelay)
			end
			return 1
		
		elseif currentMultifunction ~= nil then
			-- Overtake Button
			if ctrlType == pushbutton and ctrlPos == overtakeButton and value == buttonReleaseValue and currentMultifunction["name"] ~= resetMultiFunctionName then
				if overtakeEngaged then
					overtakeEngaged = false
					confirmSelection("OVTK", " END", deviceType, multifunctionMap[fuelMultiFunctionMapIndex]["buttonMap"][multifunctionMap[1]["currentUpDnMode"]])
				else
					overtakeEngaged = true
					confirmSelection("OVER", "TAKE", deviceType, multifunctionMap[fuelMultiFunctionMapIndex]["buttonMap"][multifunctionMap[1]["max"]])
				end					
			elseif ctrlType == pushbutton and value == buttonReleaseValue and currentMultifunction["name"] ~= resetMultiFunctionName then			
				-- Multifunction Up/Dn
				if currentMultifunction["upDnSelectable"] then
					if ctrlPos == upButton or ctrlPos == upEncoder then
						if currentMultifunction["currentUpDnMode"] < currentMultifunction["max"] then
							currentMultifunction["currentUpDnMode"] = currentMultifunction["currentUpDnMode"] + 1
							if currentMultifunction["upDnConfirmRequired"] then
								display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
							else
								confirmSelection(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]])
							end
						else
							if currentMultifunction["upDnConfirmRequired"] then
								display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
							else
								confirmSelection(currentMultifunction["name"], "MAX ", deviceType, currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]])
							end
						end
						return 1
					elseif ctrlPos == downButton or ctrlPos == downEncoder then
						if currentMultifunction["currentUpDnMode"] > currentMultifunction["min"] then
							currentMultifunction["currentUpDnMode"] = currentMultifunction["currentUpDnMode"] - 1
							if currentMultifunction["upDnConfirmRequired"] then
								display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
							else
								confirmSelection(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]])
							end
						else
							if currentMultifunction["upDnConfirmRequired"] then
								display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
							else
								confirmSelection(currentMultifunction["name"], "MIN ", deviceType, currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]])
							end
						end
						return 1			
					elseif ctrlPos == confirmButton then
						confirmSelection("CONF", currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]])
						return 1
					end
				
				-- Multifunction Single Confirm (For non Up-Dn Modes)
				elseif ctrlPos == confirmButton then		
					confirmSelection(currentMultifunction["name"], "CONF", deviceType, currentMultifunction["buttonMap"][0], confirmFunctionKeys)				
					return 1
				end
			
			elseif currentMultifunction["name"] ~= resetMultiFunctionName and ctrlType == switch and ctrlPos == settingSwitchId and currentMultifunction["upDnSelectable"] then
				upDnValue = value - 1
				if upDnValue >= currentMultifunction["min"] and upDnValue <= currentMultifunction["max"] then
					currentMultifunction["currentUpDnMode"] = upDnValue
					display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
				end
				return 1

			elseif currentMultifunction["name"] == resetMultiFunctionName and value == buttonReleaseValue then
				if ctrlPos == confirmButton then
					setDefaultModes()
				elseif startFuelLocked and ctrlPos == upButton or ctrlPos == upEncoder then
					local inc = 1
					if ctrlPos == upEncoder then
						inc = encoderIncrement
					end
					fuelAtStart = fuelAtStart + inc
					
					display("TANK", fuelAtStart, simrF1DeviceType, 500)
				elseif startFuelLocked and ctrlPos == downButton or ctrlPos == downEncoder then
					local inc = 1
					if ctrlPos == downEncoder then
						inc = encoderIncrement
					end
					fuelAtStart = fuelAtStart - inc
					display("TANK", fuelAtStart, simrF1DeviceType, 500)
				elseif ctrlPos == startFuelLockButton then
					startFuelLocked = not(startFuelLocked)
					local right
					if startFuelLocked then
						right = "LOCK"
					else
						right = "UNLK"
					end
					display("TANK", right, simrF1DeviceType, 500)
				end

			-- Control both displays with one switch
			elseif ctrlType == switch and ctrlPos == displaySwitchId and oneSWActivated then			
				mOneSW_Backup  = value
				return 1				
			end
		end
	end
	
	return 2
end

function confirmSelection(leftDisp, rightDisplay, deviceType, buttonMap)	
	display(leftDisp, rightDisplay, deviceType, 0)
	for i=0,tablelength(buttonMap)-1 do
		-- params: key, delay, modifier
		SetKeystroke(buttonMap[i], keystrokeDelay, "")					
		SLISleep(keystrokeDelay)
	end
	setDisplayTimeout(confirmDelay)
end

function setDefaultModes()
	currentFuelMode[0] = 1
	currentWingMode[0] = 1
	currentBiasMode[0] = 1
	currentTyreMode[0] = primeTyreMode -- default to primes ready for selection
	overtakeEngaged = false
	resetStartFuel = true
end