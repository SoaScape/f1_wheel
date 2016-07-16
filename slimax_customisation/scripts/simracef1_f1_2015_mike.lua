require "scripts/one_switch_to_rule_them_all"

function custom_init_Event(scriptfile)	
end

oneSWActivated = true
displaySwitchId = 2
settingSwitchId = 1

simrF1DeviceType = 3
switch = 0
pushbutton = 1
multiFunctionSwitch = 3

confirmButton = 14
upButton = 26
downButton = 27
buttonReleaseValue = 0
overtakeButton = 10
overtakePressValue = 2

keystrokeDelay = 200
selectDelay = 170
multiSelectDelay = 300
overtakeAdditionalDelay = 600

defaultMultiFunction = "DFLT"
multiFunction = defaultMultiFunction

upDnModeButtonMap = {}
upDnModeSelected = false
upDnConfirmRequied = false
upDnModes = {}
minUpDnMode = 0
maxUpDnMode = 2
currentUpDnMode = {} -- use array / table for this to pass by ref (so we don't lose mode when changing multifunctions)

currentFuelMode = {}
minFuelMode = 0
maxFuelMode = 2
fuelModes = {}
fuelModes[0] = "LEAN"
fuelModes[1] = "NORM"
fuelModes[2] = "RICH"
fuelModeButtonMap = {}
fuelModeButtonMap[0] = {}
fuelModeButtonMap[1] = {}
fuelModeButtonMap[2] = {}
fuelModeButtonMap[0][0] = "NUMPAD8"
fuelModeButtonMap[0][1] = "NUMPAD8"
fuelModeButtonMap[0][2] = "NUMPAD2"
fuelModeButtonMap[1][0] = "NUMPAD8"
fuelModeButtonMap[1][1] = "NUMPAD8"
fuelModeButtonMap[1][2] = "NUMPAD6"
fuelModeButtonMap[2][0] = "NUMPAD8"
fuelModeButtonMap[2][1] = "NUMPAD8"
fuelModeButtonMap[2][2] = "NUMPAD8"

currentWingMode = {}
minWingMode = 0
maxWingMode = 2
wingModes = {}
wingModes[0] = "DOWN"
wingModes[1] = "MIDL"
wingModes[2] = " UP "
wingModeButtonMap = {}
wingModeButtonMap[0] = {}
wingModeButtonMap[1] = {}
wingModeButtonMap[2] = {}
wingModeButtonMap[0][0] = "NUMPAD4"
wingModeButtonMap[0][1] = "NUMPAD4"
wingModeButtonMap[0][2] = "NUMPAD2"
wingModeButtonMap[1][0] = "NUMPAD4"
wingModeButtonMap[1][1] = "NUMPAD4"
wingModeButtonMap[1][2] = "NUMPAD6"
wingModeButtonMap[2][0] = "NUMPAD4"
wingModeButtonMap[2][1] = "NUMPAD4"
wingModeButtonMap[2][2] = "NUMPAD8"

currentBiasMode = {}
minBiasMode = 0
maxBiasMode = 2
biasModes = {}
biasModes[0] = "BACK"
biasModes[1] = "MIDL"
biasModes[2] = "FORW"
biasModeButtonMap = {}
biasModeButtonMap[0] = {}
biasModeButtonMap[1] = {}
biasModeButtonMap[2] = {}
biasModeButtonMap[0][0] = "NUMPAD2"
biasModeButtonMap[0][1] = "NUMPAD2"
biasModeButtonMap[0][2] = "NUMPAD2"
biasModeButtonMap[1][0] = "NUMPAD2"
biasModeButtonMap[1][1] = "NUMPAD2"
biasModeButtonMap[1][2] = "NUMPAD6"
biasModeButtonMap[2][0] = "NUMPAD2"
biasModeButtonMap[2][1] = "NUMPAD2"
biasModeButtonMap[2][2] = "NUMPAD8"

wets = "WETS"
inters = "INTR"
primes = "PRIM"
options = "OPTN"
ultras = "ULTR"
wetTyreMode = 0
interTyreMode = 1
primeTyreMode = 2
optionTyreMode = 3

currentTyreMode = {}
minTyreMode = 0
maxTyreMode = 3
tyreModes = {}
tyreModes[wetTyreMode] = wets
tyreModes[interTyreMode] = inters
tyreModes[primeTyreMode] = primes
tyreModes[optionTyreMode] = options

tyreTypeButtonMap = {}
tyreTypeButtonMap[wetTyreMode] = {}
tyreTypeButtonMap[interTyreMode] = {}
tyreTypeButtonMap[primeTyreMode] = {}
tyreTypeButtonMap[optionTyreMode] = {}
tyreTypeButtonMap[optionTyreMode][0] = "NUMPAD6"
tyreTypeButtonMap[optionTyreMode][1] = "NUMPAD6"
tyreTypeButtonMap[optionTyreMode][2] = "NUMPAD8"
tyreTypeButtonMap[primeTyreMode][0] = "NUMPAD6"
tyreTypeButtonMap[primeTyreMode][1] = "NUMPAD6"
tyreTypeButtonMap[primeTyreMode][2] = "NUMPAD6"
tyreTypeButtonMap[interTyreMode][0] = "NUMPAD6"
tyreTypeButtonMap[interTyreMode][1] = "NUMPAD6"
tyreTypeButtonMap[interTyreMode][2] = "NUMPAD2"
tyreTypeButtonMap[wetTyreMode][0] = "NUMPAD6"
tyreTypeButtonMap[wetTyreMode][1] = "NUMPAD6"
tyreTypeButtonMap[wetTyreMode][2] = "NUMPAD4"

currentFuelMode[0] = 1
currentWingMode[0] = 1
currentBiasMode[0] = 1
currentTyreMode[0] = primeTyreMode -- default to primes ready for selection
overtakeEngaged = false
fuelAtStart = -1

function custom_controls_Event(deviceType, ctrlType, ctrlPos, value, funcIndex, targetDevice)	
	if deviceType == simrF1DeviceType then	
		--print("ctrlType: " .. ctrlType .. ", ctrlPos: " .. ctrlPos .. ", value: " .. value .. "\n")
		if ctrlType == switch and ctrlPos == multiFunctionSwitch then
			confirmFunctionKeys = {}
			upFunctionKeys = {}
			downFunctionKeys = {}			
			multiFunction = nil
			multiFunctionConfirmValue = nil			
			leftDisplay = "MULT"
			rightDisplay = nul			
			upDnModeSelected = false
			upDnConfirmRequied = false
			
			if value == 1 then
				upDnModeSelected = true
				upDnConfirmRequied = true
				multiFunction = "FUEL"
				rightDisplay = "FUEL"				
				upDnModeButtonMap = fuelModeButtonMap
				upDnModes = fuelModes
				minUpDnMode = minFuelMode
				maxUpDnMode = maxFuelMode
				currentUpDnMode = currentFuelMode
			elseif value == 2 then
				upDnModeSelected = true
				upDnConfirmRequied = true
				multiFunction = "TYRE"
				rightDisplay = "TYRE"				
				upDnModeButtonMap = tyreTypeButtonMap
				upDnModes = tyreModes
				minUpDnMode = minTyreMode
				maxUpDnMode = maxTyreMode
				currentUpDnMode = currentTyreMode
			elseif value == 3 then
				upDnModeSelected = true
				upDnConfirmRequied = true
				multiFunction = "BIAS"
				rightDisplay = "BIAS"				
				upDnModeButtonMap = biasModeButtonMap
				upDnModes = biasModes
				minUpDnMode = minBiasMode
				maxUpDnMode = maxBiasMode
				currentUpDnMode = currentBiasMode
			elseif value == 4 then
				upDnModeSelected = true
				upDnConfirmRequied = true
				multiFunction = "WING"
				rightDisplay = "WING"				
				upDnModeButtonMap = wingModeButtonMap
				upDnModes = wingModes
				minUpDnMode = minWingMode
				maxUpDnMode = maxWingMode
				currentUpDnMode = currentWingMode
			elseif value == 5 then
				rightDisplay = " DX  "
			elseif value == 6 then
				rightDisplay = " L  "
			elseif value == 7 then
				rightDisplay = " D  "
			elseif value == 8 then
				rightDisplay = wets
			elseif value == 9 then
				rightDisplay = inters
			elseif value == 10 then
				rightDisplay = primes
			elseif value == 11 then
				rightDisplay = options
			elseif value == 12 then
				rightDisplay = defaultMultiFunction
				multiFunction = defaultMultiFunction
			end
			
			if upDnModeSelected then
				display(multiFunction, upDnModes[currentUpDnMode[0]], deviceType)
			else
				display(leftDisplay, rightDisplay, deviceType)
			end
			SLISleep(multiSelectDelay)
			return 1
		
		elseif ctrlType == pushbutton and ctrlPos == overtakeButton and value == buttonReleaseValue and multiFunction ~= defaultMultiFunction then
			if overtakeEngaged then
				overtakeEngaged = false				
				confirmSelection("OVTK", " END", deviceType, fuelModeButtonMap[currentFuelMode[0]])
			else
				overtakeEngaged = true
				confirmSelection("OVER", "TAKE", deviceType, fuelModeButtonMap[maxFuelMode])
				SLISleep(overtakeAdditionalDelay)
			end		
		elseif ctrlType == pushbutton and value == buttonReleaseValue and multiFunction ~= defaultMultiFunction then
			-- MULTIFUNCTION UP/DOWN
			if upDnModeSelected then
				if ctrlPos == upButton then
					if currentUpDnMode[0] < maxUpDnMode then
						currentUpDnMode[0] = currentUpDnMode[0] + 1
						if upDnConfirmRequied then
							display(multiFunction, upDnModes[currentUpDnMode[0]], deviceType)
							SLISleep(selectDelay)
						else
							confirmSelection(multiFunction, upDnModes[currentUpDnMode[0]], deviceType, upDnModeButtonMap[currentUpDnMode[0]])
						end
					else
						if upDnConfirmRequied then
							display(multiFunction, upDnModes[currentUpDnMode[0]], deviceType)
							SLISleep(selectDelay)							
						else
							confirmSelection(multiFunction, "MAX ", deviceType, upDnModeButtonMap[currentUpDnMode[0]])
						end
					end
					return 1
				elseif ctrlPos == downButton then
					if currentUpDnMode[0] > minUpDnMode then
						currentUpDnMode[0] = currentUpDnMode[0] - 1
						if upDnConfirmRequied then
							display(multiFunction, upDnModes[currentUpDnMode[0]], deviceType)
							SLISleep(selectDelay)
						else
							confirmSelection(multiFunction, upDnModes[currentUpDnMode[0]], deviceType, upDnModeButtonMap[currentUpDnMode[0]])
						end
					else
						if upDnConfirmRequied then
							display(multiFunction, upDnModes[currentUpDnMode[0]], deviceType)
							SLISleep(selectDelay)
						else
							confirmSelection(multiFunction, "MIN ", deviceType, upDnModeButtonMap[currentUpDnMode[0]])							
						end
					end
					return 1				
				elseif ctrlPos == confirmButton then
					confirmSelection("CONF", upDnModes[currentUpDnMode[0]], deviceType, upDnModeButtonMap[currentUpDnMode[0]])
					return 1
				end
			
			-- Multifunction Single Confirm (For non Up-Dn Modes)
			elseif ctrlPos == confirmButton and multiFunctionConfirmValue ~= nil then		
				confirmSelection(multiFunction, multiFunctionConfirmValue, deviceType, buttonMap, confirmFunctionKeys)				
				return 1
			end
		elseif multiFunction == defaultMultiFunction and ctrlPos == confirmButton and value == buttonReleaseValue then
			setDefaultModes()
		
		elseif ctrlType == switch and ctrlPos == settingSwitchId and upDnModeSelected then
			upDnValue = value - 1
			if upDnValue >= minUpDnMode and upDnValue <= maxUpDnMode then
				currentUpDnMode[0] = upDnValue
				display(multiFunction, upDnModes[currentUpDnMode[0]], deviceType)
				SLISleep(selectDelay)
			end
			return 1

		-- Control both displays with one switch
		elseif ctrlType == switch and ctrlPos == displaySwitchId and oneSWActivated then			
			mOneSW_Backup  = value
			return 1				
		end
	end
	
	return 2
end

function confirmSelection(leftDisp, rightDisplay, deviceType, buttonMap)	
	display(leftDisp, rightDisplay, deviceType)
	for i=0,tablelength(buttonMap)-1 do
		-- params: key, delay, modifier
		SetKeystroke(buttonMap[i], keystrokeDelay, "")					
		SLISleep(keystrokeDelay)
	end
	SetDigitsAllowed(true)
end

function display(leftStr, rightStr, deviceType)
	if leftStr ~= nul and rightStr ~= nil then			
		local dev = GetDeviceType(deviceType)
		UpdateDigits(leftStr, rightStr, dev)
		SLISendReport(0)
	end
end

function setDefaultModes()
	currentFuelMode[0] = 1
	currentWingMode[0] = 1
	currentBiasMode[0] = 1
	currentTyreMode[0] = primeTyreMode -- default to primes ready for selection
	overtakeEngaged = false
	fuelAtStart = -1
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
