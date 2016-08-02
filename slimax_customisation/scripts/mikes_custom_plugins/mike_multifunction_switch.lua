require "scripts/mikes_custom_plugins/mike_utils"

--------------------------------------------------
-- Set These Values To The Buttons You Want To Use
multiFunctionSwitchId = 3

confirmButton = 14
upButton = 26
downButton = 27
upEncoder = 22
downEncoder = 21
setValueSwitchId = 1

overtakeButton = 10
startFuelLockButton = 3
--------------------------------------------------
selectDelay = 600
confirmDelay = 1000
multiSelectDelay = 500
kiloDivider = 0.750
encoderIncrement = 10
fuelEncoderIncrement = (10 / (kiloDivider * 10)) * encoderIncrement
fuelButtonIncrement = (10 / (kiloDivider * 10))
customDisplayTicksTimeout = 0
resetMultiFunctionName = "RSET"
currentMultifunction = nil
overtakeEngaged = false
customDisplayActive = false

function multiControlsEvent(deviceType, ctrlType, ctrlPos, value)
	if deviceType == myDevice then	
		trackButtons(ctrlType, ctrlPos, value)
		--print("ctrlType: " .. ctrlType .. ", ctrlPos: " .. ctrlPos .. ", value: " .. value .. "\n")
		if ctrlType == switch and ctrlPos == multiFunctionSwitchId then			
			if multifunctionMap[value] ~= nil then
				currentMultifunction = multifunctionMap[value]			
			
				if currentMultifunction["enabled"] and currentMultifunction["upDnSelectable"] then
					display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, multiSelectDelay)
				else
					display("MULT", currentMultifunction["name"], deviceType, multiSelectDelay)
				end
				return 1
			end
		
		elseif currentMultifunction ~= nil and currentMultifunction["enabled"] then
			-- Overtake Button
			if ctrlType == pushbutton and ctrlPos == overtakeButton and value == buttonReleaseValue and currentMultifunction["name"] ~= resetMultiFunctionName then
				if overtakeButtonEnabled then
					if overtakeEngaged then
						overtakeEngaged = false
						multiFunctionBak = currentMultifunction
						currentMultifunction = fuelMultiFunction
						confirmSelection("OVTK", " END", deviceType, getButtonMap(currentMultifunction))
						currentMultifunction = multiFunctionBak
					else
						overtakeEngaged = true
						multiFunctionBak = currentMultifunction
						currentMultifunction = fuelMultiFunction
						fuelModeBak = currentMultifunction["currentUpDnMode"]
						currentMultifunction["currentUpDnMode"] = currentMultifunction["max"]
						confirmSelection("OVER", "TAKE", deviceType, getButtonMap(currentMultifunction))
						currentMultifunction["currentUpDnMode"] = fuelModeBak
						currentMultifunction = multiFunctionBak
					end
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
								confirmSelection(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, getButtonMap(currentMultifunction))
							end
						else
							if currentMultifunction["wrap"] then
								currentMultifunction["currentUpDnMode"] = currentMultifunction["min"]
							end
							
							if currentMultifunction["upDnConfirmRequired"] then
								display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
							else
								confirmSelection(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, getButtonMap(currentMultifunction))
							end
						end
						return 1
					elseif ctrlPos == downButton or ctrlPos == downEncoder then
						if currentMultifunction["currentUpDnMode"] > currentMultifunction["min"] then
							currentMultifunction["currentUpDnMode"] = currentMultifunction["currentUpDnMode"] - 1
							if currentMultifunction["upDnConfirmRequired"] then
								display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
							else
								confirmSelection(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, getButtonMap(currentMultifunction))
							end
						else
							if currentMultifunction["wrap"] then
								currentMultifunction["currentUpDnMode"] = currentMultifunction["max"]
							end
							
							if currentMultifunction["upDnConfirmRequired"] then
								display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
							else
								confirmSelection(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, getButtonMap(currentMultifunction))
							end
						end
						return 1			
					elseif ctrlPos == confirmButton then
						confirmSelection("CONF", currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, getButtonMap(currentMultifunction))
						return 1
					end
				
				-- Multifunction Single Confirm (For non Up-Dn Modes)
				elseif ctrlPos == confirmButton then		
					confirmSelection(currentMultifunction["name"], "CONF", deviceType, getButtonMap(currentMultifunction))				
					return 1
				end
			
			elseif currentMultifunction["name"] ~= resetMultiFunctionName and ctrlType == switch and ctrlPos == setValueSwitchId and currentMultifunction["upDnSelectable"] then
				upDnValue = value - 1
				if upDnValue >= currentMultifunction["min"] and upDnValue <= currentMultifunction["max"] then
					currentMultifunction["currentUpDnMode"] = upDnValue
					display(currentMultifunction["name"], currentMultifunction["modes"][currentMultifunction["currentUpDnMode"]], deviceType, selectDelay)
				end
				return 1

			elseif currentMultifunction["name"] == resetMultiFunctionName and value == buttonReleaseValue then
				if ctrlPos == confirmButton then
					setDefaultModes()
				elseif startFuelLocked and (ctrlPos == upButton or ctrlPos == upEncoder and fuelAtStart ~= nil) then
					local inc = fuelButtonIncrement
					if ctrlPos == upEncoder then
						inc = fuelEncoderIncrement
					end
					fuelAtStart = fuelAtStart + inc
					
					display("TANK", GetFuelKilogram(fuelAtStart), myDevice, 500)
					return 1
				elseif startFuelLocked and (ctrlPos == downButton or ctrlPos == downEncoder and fuelAtStart ~= nil) then
					local inc = fuelButtonIncrement
					if ctrlPos == downEncoder then
						inc = fuelEncoderIncrement
					end
					fuelAtStart = fuelAtStart - inc
					display("TANK", GetFuelKilogram(fuelAtStart), myDevice, 500)
					return 1
				elseif ctrlPos == startFuelLockButton then
					startFuelLocked = not(startFuelLocked)
					local right
					if startFuelLocked then
						right = "LOCK"
					else
						right = "UNLK"
					end
					display("TANK", right, myDevice, 500)
					return 1
				end
			end
		end
	end
	
	return 2
end

function confirmSelection(leftDisp, rightDisplay, deviceType, buttonMap)	
	display(leftDisp, rightDisplay, deviceType, 0)
	for i=0,tablelength(buttonMap)-1 do
		local delay = keystrokeDelay
		if customKeystrokeDelays[buttonMap[i]] ~= nil then
			delay = customKeystrokeDelays[buttonMap[i]]
		end
		-- params: key, delay, modifier
		SetKeystroke(buttonMap[i], delay, "")
		SLISleep(delay)
	end
	setDisplayTimeout(confirmDelay)
end

function trackButtons(ctrlType, ctrlPos, value)
	if ctrlType == pushbutton and value == buttonReleaseValue and buttonTrackerMap[ctrlPos] ~= nil then
		buttonTrackerMap[ctrlPos] = buttonTrackerMap[ctrlPos] + 1
	end
end

function setDefaultModes()	
	for key, value in pairs(multifunctionMap) do
		if value["defaultUpDnMode"] ~= nil then
			value["currentUpDnMode"] = value["defaultUpDnMode"]
		else
			value["currentUpDnMode"] = nil
		end
		value["currentPosition"] = nil
	end
	
	if buttonTrackerMap ~= nil then
		for key, value in pairs(buttonTrackerMap) do
			buttonTrackerMap[key] = 0
		end
	end
	
	overtakeEngaged = false
	resetStartFuel = true
end