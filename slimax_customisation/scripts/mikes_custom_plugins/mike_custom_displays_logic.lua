-- MIKE CUSTOM FUNCTIONS
local fuelAtStart = 0
local lowFuelLedPattern = 64
local lowFuelLedBlinkDelay = 500
local startFuelStoredLedPattern = 248
local fuelResetDisplayTimeout = 1000

local fuelTarget = nil
local adjustedFuelTarget = nil
local maxYellowFlagPercentageForValidFuelLap = 0
local fuelUsedLastLap = nil

local fuelLaps = {}
local lastFuelLapCompleted = -1
local maxNonStandardFuelLapsToStore = 3
local fuelLapBeginLedPattern = 192 -- 4, 5  = 11000000
local currentFuelLap = nil

local dataDisplayDelay = 1000
local currentDataItemIndex = 1
local currentDataTypeIndex = 1
local dataTypes = {}
dataTypes[1] = {}
dataTypes[1].display = "LAP "
dataTypes[1].key = "lap"
dataTypes[2] = {}
dataTypes[2].display = "USED"
dataTypes[2].key = "fuelUsed"
dataTypes[3] = {}
dataTypes[3].display = "AJST"
dataTypes[3].key = "adjustedFuelUsed"
dataTypes[4] = {}
dataTypes[4].display = "OFST"
dataTypes[4].key = "offset"
dataTypes[5] = {}
dataTypes[5].display = "#ALL"
dataTypes[5].key = "numMixEvents"
dataTypes[6] = {}
dataTypes[6].display = "#STD"
dataTypes[6].key = "numStandardMixEvents"
dataTypes[7] = {}
dataTypes[7].display = "YELW"
dataTypes[7].key = "yellowFlagLapPrecentage"
dataTypes[8].display = "ACRY"
dataTypes[8].key = "accuracy"

local function displayFuelData()
	local left = dataTypes[currentDataTypeIndex].display
	local right = fuelLaps[currentDataItemIndex][dataTypes[currentDataTypeIndex].key]
	if right == nil then
		right = "NREF"
	else
		right = tostring(right)
	end
	display(left, right, dataDisplayDelay)
end

function processFuelDataButtonEvent(button)
	if button == confirmButton then
		displayFuelData()
	elseif button == upButton then
		if fuelLaps[currentDataItemIndex + 1] ~= nil then
			currentDataItemIndex = currentDataItemIndex + 1
			displayFuelData()
		end
	elseif button == downButton then
		if fuelLaps[currentDataItemIndex - 1] ~= nil then
			currentDataItemIndex = currentDataItemIndex - 1
			displayFuelData()
		end
	elseif button == upEncoder then
		if dataTypes[currentDataTypeIndex + 1] ~= nil then
			currentDataTypeIndex = currentDataTypeIndex + 1
		else
			currentDataTypeIndex = 1
		end
		displayFuelData()
	elseif button == downEncoder then
		if dataTypes[currentDataTypeIndex - 1] ~= nil then
			currentDataTypeIndex = currentDataTypeIndex - 1
		else
			currentDataTypeIndex = tablelength(dataTypes)
		end
		displayFuelData()
	end
end

local function getPercentageLapComplete()
	-- percentage of current lap completed
	local dist = GetContextInfo("lap_distance")		
	local trcksz = GetContextInfo("track_size")
	return dist / (trcksz / 100)
end

function getLapsCompleteIncludingCurrent()
	local lapsCompleted = GetContextInfo("laps") - 1 -- F1 2015 reports current lap as completed, so subtract 1					
	local percentLapComplete = getPercentageLapComplete() / 100
	return lapsCompleted + percentLapComplete -- Add on % current lap complete
end

function firstLapCompleted()
	-- Returns true once the first lap has been completed.
	local lapsCompleted = GetContextInfo("laps") - 1
	if lapsCompleted ~= nil and lapsCompleted > 0 then
		return true
	else
		return false
	end
end

function getLapsRemaining()
	-- Returns remaining laps including current (decimal format)
	local lapsCompleted = GetContextInfo("laps")
	local totalLaps = GetContextInfo("laps_count")
	local lapsRemaining = totalLaps - lapsCompleted

	local percentLapComplete = getPercentageLapComplete()
	local percentLapRemaining = (100 - percentLapComplete) / 100
	
	lapsRemaining = lapsRemaining + percentLapRemaining
	return lapsRemaining
end

function getRemainingLapsInTank(fuelRemaining)
	-- Mike custom: fuel laps remaining.
	-- Discounts 2.6 litres as car stutters when down to that level
	local remainingLapsInTank = 0
	local fuelPerLap = getAverageFuelPerLap()
	if fuelPerLap ~= nil and fuelRemaining > 0 then		
		remainingLapsInTank = (fuelRemaining - minFuel) / fuelPerLap
	end
	return remainingLapsInTank	
end

function getFuelUsedLastLap()
	return fuelUsedLastLap
end

function getAverageFuelPerLap()
	local totalFuelUsed = 0
	local count = 0
	for key, fuelLap in pairs(fuelLaps) do
		if fuelLap.fuelUsed ~= nil then
			totalFuelUsed = totalFuelUsed + fuelLap.fuelUsed
			count = count + 1
		end
	end
	
	if count > 0 then
		return totalFuelUsed / count
	else
		return nil
	end
end

function getFuelTarget()
	return fuelTarget
end

function getAdjustedFuelTarget()
	return adjustedFuelTarget
end

local function assessFuelLapData(functionToRunEachLap)
	local lapComparator = function(a, b) return a.accuracy > b.accuracy end	
	local sortedKeys = getKeysSortedByValue(fuelLaps, lapComparator)
	
	local count = 0
	for _, key in ipairs(sortedKeys) do
		count = count + 1
		functionToRunEachLap()
	end
end

local function filterMixAdjustedLaps()
	local count = getLocal("count")
	local key = getLocal("key")
	local fuelLap = fuelLaps[key]
	if fuelLap.accuracy < 100 and count > maxNonStandardFuelLapsToStore then
		fuelLap.adjustedFuelUsed = nil
	end
end

local function calculateMixAdjustedFuelLap(fuelLap)
	fuelUsedLastLap = fuelLap.startFuel - fuelLap.endFuel
	local fuelMixes = {}
	local numMixEvents = 0
	local numStandardMixEvents = 0
	local numYellow = 0
	for distance, mixData in pairs(fuelLap.mixdata) do
		local fuelMode = mixData.mix
		if fuelMixes[fuelMode] == nil then
			fuelMixes[fuelMode] = 1
		else
			fuelMixes[fuelMode] = fuelMixes[fuelMode] + 1
		end
		
		if fuelMode == fuelMultiFunction.defaultUpDnMode then
			numStandardMixEvents = numStandardMixEvents + 1
		end
		if mixData.yellow then
			numYellow = numYellow + 1
		end
		numMixEvents = numMixEvents + 1
	end

	local yellowFlagLapPrecentage = ((numYellow / numMixEvents) * 100)
	if yellowFlagLapPrecentage <= maxYellowFlagPercentageForValidFuelLap then
		local fuelOffset = 0
		if fuelMultiFunction.fuelUsageOffset ~= nil then
			for mix, total in pairs(fuelMixes) do
				local distPercentage = total / numMixEvents
				local offset = fuelMultiFunction.fuelUsageOffset[mix]
				fuelOffset = fuelOffset + (offset * distPercentage)
			end
		end
		
		if fuelUsedLastLap > 0 then
			fuelLap.fuelUsed = fuelUsedLastLap
			fuelLap.offset = fuelOffset
			fuelLap.numMixEvents = numMixEvents
			fuelLap.numStandardMixEvents = numStandardMixEvents
			fuelLap.yellowFlagLapPrecentage = yellowFlagLapPrecentage
			fuelLap.adjustedFuelUsed = fuelUsedLastLap / fuelOffset
			fuelLap.accuracy = ((numStandardMixEvents / numMixEvents) * 100) - (yellowFlagLapPrecentage * 3)			
			display("DATA", tostring(fuelLap.accuracy), mDisplay_Info_Delay)
			assessFuelLapData(filterMixAdjustedLaps)
		end
	end
end

local function trackFuelLapData()
	local lapsCompleted = GetContextInfo("laps")
	if lapsCompleted ~= nil then
		local distance = round(GetContextInfo("lap_distance"), 0)
		if lapsCompleted > lastFuelLapCompleted then
			local fuel = GetCarInfo("fuel")
			if fuelLaps[lastFuelLapCompleted] ~= nil and fuelLaps[lastFuelLapCompleted].endFuel == nil then				
				fuelLaps[lastFuelLapCompleted].endFuel = fuel
				fuelLaps[lastFuelLapCompleted].accuracy = 0
				calculateMixAdjustedFuelLap(fuelLaps[lastFuelLapCompleted])
			end
			
			if distance <= 1 then
				local fuelLap = {}
				fuelLap.lap = lapsCompleted
				fuelLap.startFuel = fuel
				fuelLap.mixdata = {}
				table.insert(fuelLaps, fuelLap)
				currentFuelLap = fuelLap
				lastFuelLapCompleted = lapsCompleted
				activateBlinkingLed(fuelLapBeginLedPattern, 100, 250, false)
			end
		elseif lapsCompleted == lastFuelLapCompleted then
			if currentFuelLap.mixdata[distance] == nil then
				currentFuelLap.mixdata[distance] = {}
				currentFuelLap.mixdata[distance].mix = getActiveFuelMix()
				currentFuelLap.mixdata[distance].yellow = GetContextInfo("yellow_flag")
			end			
		end
	end
end

local function calcFuelTarget(totalFuelUsed, fuelLapsCompleted)
	local fuelPerLap = totalFuelUsed / fuelLapsCompleted
	local fuelRemaining = GetCarInfo("fuel") - minFuel
	local fuelLapsRemaining = fuelRemaining / fuelPerLap
	local lapsRemaining = getLapsRemaining()
	return fuelLapsRemaining - lapsRemaining
end

local function calculateFuelTargets()	
	trackFuelLapData()
	
	local totalFuelUsed = 0
	local totalAdjustedFuelUsed = 0
	local fuelLapsCompleted = 0
	local adjustedFuelLapsCompleted = 0
	
	for lapId, fuelLap in pairs(fuelLaps) do
		if fuelLap.fuelUsed ~= nil then
			totalFuelUsed = totalFuelUsed + fuelLap.fuelUsed
			if fuelLap.adjustedFuelUsed ~= nil then
				totalAdjustedFuelUsed = totalAdjustedFuelUsed + fuelLap.adjustedFuelUsed
				adjustedFuelLapsCompleted = adjustedFuelLapsCompleted + 1
			end
			fuelLapsCompleted = fuelLapsCompleted + 1
		end			
	end
	
	if fuelLapsCompleted > 0 then
		fuelTarget = calcFuelTarget(totalFuelUsed, fuelLapsCompleted)
		adjustedFuelTarget = calcFuelTarget(totalAdjustedFuelUsed, adjustedFuelLapsCompleted)
		
		if fuelTarget < 0 then
			activateBlinkingLed(lowFuelLedPattern, lowFuelLedBlinkDelay, 0, false)
		else
			deactivateBlinkingLed(lowFuelLedPattern)
		end
	else
		fuelTarget = nil
		adjustedFuelTarget = nil
		deactivateBlinkingLed(lowFuelLedPattern)
	end
end

function performRegularCustomDisplayProcessing()
	if mSessionEnter == 1 and not(m_is_sim_idle) then
		-- Calculate fuel targets
		calculateFuelTargets()
	end
end

function storeStartFuel()	
	fuelAtStart = GetCarInfo("fuel_total")
end

function resetFuelData()
	if mSessionEnter ~= 1 and m_is_sim_idle then
		fuelAtStart = nil
	end
	fuelLaps = {}
	lastFuelLapCompleted = -1
	fuelTarget = nil
	adjustedFuelTarget = nil
	fuelUsedLastLap = nil
	currentFuelLap = nil
	currentDataItemIndex = 1
end

function getFuelAtStart()
	return fuelAtStart
end