require "scripts/mikes_custom_plugins/mike_led_utils"
require "scripts/mikes_custom_plugins/mike_utils"

-- MIKE CUSTOM FUNCTIONS
local fuelAtStart = 0
local lowFuelLedPattern = 64
local startFuelStoredLedPattern = 248
local fuelResetDisplayTimeout = 1000

local fuelTarget = nil
local adjustedFuelTarget = nil
local maxYellowFlagPercentageForValidFuelLap = 2

local fuelLaps = {}
local lastLapCompleted = -1
local maxNonStandardFuelLapsToStore = 3

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
	local lapsCompleted = getLapsCompleteIncludingCurrent()

	local remainingLapsInTank = 0
	if fuelRemaining > 0 and fuelAtStart > 0 and lapsCompleted >= 1 then
		local fuelUsed = fuelAtStart - fuelRemaining
		local fuelPerLap = fuelUsed / lapsCompleted	
		if fuelPerLap > 0 then				
			remainingLapsInTank = (fuelRemaining - minFuel) / fuelPerLap
		end
	end
	return remainingLapsInTank	
end

function getFuelTarget()
	return fuelTarget
end

function getAdjustedFuelTarget()
	return adjustedFuelTarget
end

local function assessFuelLapData()
	local lapComparator = function(a, b) return a["accuracy"] > b["accuracy"] end
	table.sort(fuelLaps, lapComparator)
	
	local count = 0
	for id, fuelLap in pairs(fuelLaps) do		
		if fuelLap["accuracy"] < 100 and count > maxNonStandardFuelLapsToStore then
			table.remove(id, fuelLaps)
		elseif fuelLap["new"] then
			display("DATA", tostring(fuelLap["accuracy"]), mDisplay_Info_Delay)
		end
		count = count + 1
	end
end

local function calculateMixAdjustedFuelLap(fuelLap)
	local fuelUsed = fuelLap["startFuel"] - fuelLap["endFuel"]
	local fuelMixes = {}
	local numMixEvents = 0
	local numStandardMixEvents = 0
	local numYellow = 0
	for distance, mixData in pairs(fuelLap["mixdata"]) do
		local fuelMode = mixData["mix"]
		if fuelMixes[fuelMode] == nil then
			fuelMixes[fuelMode] = 1
		else
			fuelMixes[fuelMode] = fuelMixes[fuelMode] + 1
		end
		
		if fuelMode == fuelMultiFunction["defaultUpDnMode"] then
			numStandardMixEvents = numStandardMixEvents + 1
		end
		if mixData["yellow"] then
			numYellow = numYellow + 1
		end
		numMixEvents = numMixEvents + 1
	end
	
	local yellowFlagLapPrecentage = ((numYellow / numMixEvents) * 100)
	if yellowFlagLapPrecentage < maxYellowFlagPercentageForValidFuelLap then	
		local fuelOffset = 1
		for mix, total in pairs(fuelMixes) do
			local distPercentage = total / numMixEvents
			local offset = -fuelMultiFunction["fuelUsageOffset"][mix]
			fuelOffset = fuelOffset + (offset * distPercentage)
		end
		
		local adjustedFuelUsed = fuelUsed * fuelOffset
		if adjustedFuelUsed > 0 then
			fuelLap["fuelUsed"] = adjustedFuelUsed
			fuelLap["accuracy"] = ((numStandardMixEvents / numMixEvents) * 100) - (yellowFlagLapPrecentage * 3)
			fuelLap["new"] = true
			assessFuelLapData()
		end
	end
end

local function trackFuelLapData()	
	local lapsCompleted = GetContextInfo("laps")
	if lapsCompleted ~= nil then
		if lapsCompleted > lastLapCompleted then
			local fuel = GetCarInfo("fuel")
			if fuelLaps[lastLapCompleted] ~= nil then				
				fuelLaps[lastLapCompleted]["endFuel"] = fuel
				calculateMixAdjustedFuelLap(fuelLaps[lastLapCompleted])
			end
			
			local fuelLap = {}
			fuelLap["startFuel"] = fuel
			fuelLap["mixdata"] = {}
			fuelLaps[lapsCompleted] = fuelLap
			
			lastLapCompleted = lapsCompleted
		else
			local fuelLap = fuelLaps[lapsCompleted]
			local distance = round(GetContextInfo("lap_distance"), 0)
			if fuelLap["mixdata"][distance] ~= nil then
				fuelLap["mixdata"][distance] = {}
				fuelLap["mixdata"][distance]["mix"] = getActiveFuelMix()
				if GetContextInfo("yellow_flag") then
					-- Do it this way so we don't remove a previous yellow
					fuelLap["mixdata"][distance]["yellow"] = true
				end
			end			
		end
	end
end

local function calculateAdjustedFuelTarget()
	if fuelMultiFunction["fuelUsageOffset"] ~= nil then
		trackFuelLapData()
		
		local totalFuelUsed = 0
		local fuelLapsCompleted = 0
		
		for lapId, fuelLap in pairs(fuelLaps) do		
			if fuelLap["fuelUsed"] ~= nil then
				totalFuelUsed = totalFuelUsed + fuelLap["fuelUsed"]
				fuelLapsCompleted = fuelLapsCompleted + 1
			end
		end
		
		if fuelLapsCompleted > 0 then
			local fuelPerLap = totalFuelUsed / fuelLapsCompleted
			local fuelRemaining = GetCarInfo("fuel") - minFuel
			local fuelLapsRemaining = fuelRemaining / fuelPerLap
			local lapsRemaining = getLapsRemaining()
			adjustedFuelTarget = fuelLapsRemaining - lapsRemaining
		else
			adjustedFuelTarget = nil
		end
	end
end

local function calculateRawFuelTarget()	
	local fuelRemaining = GetCarInfo("fuel")
	if firstLapCompleted() and fuelAtStart > 0 and fuelRemaining > 0 then
		local remainingLapsInTank = getRemainingLapsInTank(fuelRemaining)
		local remainingLaps = getLapsRemaining()
		fuelTarget = round(remainingLapsInTank - remainingLaps, 1)

		if fuelTarget < 0 then
			activateBlinkingLed(lowFuelLedPattern, 500, 0, false)
		else
			deactivateBlinkingLed(lowFuelLedPattern)
		end
	else
		deactivateBlinkingLed(lowFuelLedPattern)
		fuelTarget = nil
	end
end

local function calculateFuelTargets()
	calculateRawFuelTarget()
	calculateAdjustedFuelTarget()
end

function performRegularCustomDisplayProcessing()
	-- Calculate fuel targets
	calculateFuelTargets()
end

function storeStartFuel()	
	fuelAtStart = GetCarInfo("fuel_total")
end

function resetFuelData()
	fuelAtStart = 0
	fuelLaps = {}
	lastLapCompleted = -1
	fuelTarget = nil
	adjustedFuelTarget = nil
end

function getFuelAtStart()
	return fuelAtStart
end