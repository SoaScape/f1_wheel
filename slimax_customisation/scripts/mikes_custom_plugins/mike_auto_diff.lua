require "scripts/mikes_custom_plugins/mike_led_utils"

autoDiffMultifunctionName = "ADIF"
local autoDiffFileExtension = "diff"

local displayTimeout = 500
local progInc = 5
local displayDiffEvents = false

local autoDiffActive = false
local lastEvent = -1
local diffEvents = nil

local progOffset = 0

local tyres = {}
tyres[0] = "WETS"
tyres[1] = "INTR"
tyres[2] = "HARD"
tyres[3] = "MEDM"
tyres[4] = "SOFT"
tyres[5] = "SUPR"
tyres[6] = "ULTR"

local minTyre = 0
local maxTyre = 6
local currentTyre = 5

local baseDiffs = {}
baseDiffs["ULTR"] = 95
baseDiffs["SUPR"] = 90
baseDiffs["SOFT"] = 80
baseDiffs["MEDM"] = 70
baseDiffs["HARD"] = 60
baseDiffs["INTR"] = 55
baseDiffs["WETS"] = 50

local function loadDiffEventsForTrack(trackId)
	diffEvents = loadEventsForTrack(trackId, autoDiffFileExtension)
	lastEvent = -1
	if diffEvents ~= nil then
		return true
	end
end

function resetAutoDiff()
	autoDiffActive = false
	diffEvents = nil
	progOffset = 0
	lastEvent = -1
end

local function storeDiffEvent(offset)
	if(mSessionEnter == 1 and not(m_is_sim_idle)) then
		local distStr = tostring(getLapDistance())
		progEvents[distStr] = tostring(offset)
		display(distStr, tostring(offset), progDisplayTimeout)
	end
end

local function displayProgOffset(offset)
	local offsetStr = string.format("%3d", offset)	
	display("PROG", offsetStr, progDisplayTimeout)
end

function processAutoDiffButtonEvent(button)
	if autoDiffEnabled then
		if button == confirmButton then
			if inProgrammingMode() then
				storeDiffEvent(progOffset)
			else
				if autoDiffActive then
					autoDiffActive = false
					display(autoDiffMultifunctionName, " OFF", displayTimeout)
				else
					if loadDiffEventsForTrack(trackMultiFunction["modes"][trackMultiFunction["currentUpDnMode"]]) then
						autoDiffActive = true						
						display(autoDiffMultifunctionName, "ACTV", displayTimeout)
					else
						display(autoDiffMultifunctionName, " ERR", displayTimeout)
					end
				end
			end
		elseif button == upButton or button == upEncoder then
			if inProgrammingMode() then
				progOffset = progOffset + progInc
				displayProgOffset(progOffset)
			else
				if currentTyre < maxTyre then
					currentTyre = currentTyre + 1
				else
					currentTyre = minTyre
				end
				display(autoDiffMultifunctionName, tyres[currentTyre], displayTimeout)
			end
		elseif button == downButton or button == downEncoder then
			if inProgrammingMode() then
				progOffset = progOffset - progInc
				displayProgOffset(progOffset)
			else
				if currentTyre > minTyre then
					currentTyre = currentTyre - 1
				else
					currentTyre = maxTyre
				end
				display(autoDiffMultifunctionName, tyres[currentTyre], displayTimeout)
			end
		elseif button == progButton then
			if autoDiffActive or (mSessionEnter ~= 1 or m_is_sim_idle) then
				display("PROG", "UNAV", displayTimeout)
				return
			end
			toggleProgrammingMode("diff")
		end
	end
end

local function setDifferential(diffOffset)
	local diff = baseDiffs[tyres[currentTyre]] + diffOffset

	local key = getKeyForValue(diffMultiFunction["modes"], diff .. "%")
	
	if key == nil then
		if diff > 100 then
			key = diffMultiFunction["max"]
		else
			key = diffMultiFunction["min"]
		end
	end
	diffMultiFunction["currentUpDnMode"] = key
	confirmSelection(autoDiffMultifunctionName, diffMultiFunction["modes"][key], getButtonMap(diffMultiFunction), displayDiffEvents)
	--print("Diff: " .. diff .. "%" .. "(key: " .. key .. ", tyre: " ..  tyres[currentTyre] .. ", base: " .. baseDiffs[tyres[currentTyre]])
end

function autoDiffRegularProcessing()
	if autoDiffActive and mSessionEnter == 1 and not(m_is_sim_idle) then
		local distance = getLapDistance()
		if diffEvents[tostring(distance)] ~= nil and lastEvent ~= distance then
			lastEvent = distance
			setDifferential(diffEvents[tostring(distance)])
		end
	end
end

--The differential on throttle works like it does it real life. A more locked diff will give you more grip, but if you overload the outside tire it will break traction very quickly and spin. A more open diff will not have as much pure grip, but will break traction in a much smoother manner.
--The way you should use this is based on the amount of grip available from the track and tires. For example, in FP1 the track is very low grip. The diff should be turned down or you will get excessive wheel spin when exiting corners. The softer the tires, the more grip they give initially, so you can turn up the diff to get more performance from them. When you start to get corner exit oversteer, start going back down on the diff to match the grip level.
--That is the easy way to control power on oversteer. You can also do it corner by corner if you can keep up. Faster corners like higher diff levels, lower speed corners where you need more traction forgiveness, turn the diff back down.
--The hards like 60s, mediums 70s, softs 80s and supersofts 90s when they are brand new. Havent drove the ultras yet