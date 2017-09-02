switch = 0
pushbutton = 1
buttonReleaseValue = 0

confirmDelay = 1000
progDisplayTimeout = 500

local progBlinkLedPatterns = {}
progBlinkLedPatterns[0] = 0xD8 -- 1,2,4,5
progBlinkLedPatterns[1] = 0xE8 -- 1,2,3,5
local progBlinkLedId = "PROG"
local progDoubleClickTime = 500
local progDataDir = "./auto-cfg/"

local customDisplayActive = false
local customDisplayTicksTimeout = 0

local keystrokeDelay = 200
local keyHoldDelay = 30

local keyQueue = {}

local activeFuelMix = nil
nextActiveFuelMix = nil

local progActive = false
local lastProgButtonPress = 0

function customDisplayIsActive()
	return customDisplayActive
end

function display(leftStr, rightStr, timeout)
	if leftStr ~= nul and rightStr ~= nil then
		local dev = GetDeviceType(myDevice)
		UpdateDigits(leftStr, rightStr, dev)
		SLISendReport(0)
		customDisplayTicksTimeout = getTks() + timeout
		customDisplayActive = true
	end
end

function inPits()
	return GetInPitsState() > 0
end

local function processKeyPressQueue()
	if keyQueue ~= nil and keyQueue[1] ~= nil then
		if inPits() then
			keyQueue = {}
			nextActiveFuelMix = nil -- Best assumption here is that the fuel mode didn't get set
		else
			local nextKey = keyQueue[1]
			if nextKey["expires"] ~= nil then
				if getTks() > nextKey["expires"] then
					table.remove(keyQueue, 1)
				end
			else
				SetKeystroke(nextKey["key"], nextKey["holdDelay"], "")
				nextKey["expires"] = getTks() + nextKey["delayTime"]
	--print("DEBUG key: " .. nextKey["key"] .. ", holdDelay, " .. nextKey["holdDelay"] .. ", delay: " .. nextKey["delayTime"])
			end
		end
	else
		if nextActiveFuelMix ~= nil then
			activeFuelMix = nextActiveFuelMix
			nextActiveFuelMix = nil
		end
	end
end

local function checkForDisplayTimeout()
	if customDisplayActive and getTks() > customDisplayTicksTimeout then		
		customDisplayActive = false
	end
end

function utilsRegularProcessing()
	checkForDisplayTimeout()
	processKeyPressQueue()
end

local function queueKeyPress(key, holdDelay, delayTime)
	local keyPress = {}
	keyPress["key"] = key
	keyPress["holdDelay"] = holdDelay
	keyPress["delayTime"] = delayTime
	table.insert(keyQueue, keyPress)	
end

function confirmSelection(leftDisp, rightDisplay, buttonMap, showDisplay)
	local startTicks = getTks()
	if mSessionEnter == 1 and not(m_is_sim_idle) and not(inPits()) then
		if buttonMap ~= nil and tablelength(buttonMap) > 0 then
--local inspect = require('inspect')
--print(inspect(buttonMap))
			for i = 1, tablelength(buttonMap) do
				local delay = keystrokeDelay
				local holdDelay = keyHoldDelay
				if delayMap ~= nil and delayMap[i] ~= nil then
					delay = delayMap[i]
				elseif customKeystrokeDelays[buttonMap[i]] ~= nil then
					delay = customKeystrokeDelays[buttonMap[i]]
				end
				
				if keyHoldMap ~= nil and keyHoldMap[i] ~= nil then
					holdDelay = keyHoldMap[i]
				end
				queueKeyPress(buttonMap[i], holdDelay, delay)			
			end
			delayMap = nil
		else
			leftDisp = "CURR"
		end
		if showDisplay then
			display(leftDisp, rightDisplay, confirmDelay)
		end
	end
end

function getActiveFuelMix()
	if activeFuelMix == nil then
		activeFuelMix = fuelMultiFunction["defaultUpDnMode"]
	end
	return activeFuelMix
end

function getTks()
	local ticks = GetAppInfo("ticks")
	if ticks == nil then
		ticks = 0
	end
	return ticks
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function getKeysSortedByValue(tbl, sortFunction)
	local keys = {}
	for key in pairs(tbl) do
		table.insert(keys, key)
	end

	table.sort(keys, function(a, b)
		return sortFunction(tbl[a], tbl[b])
	end)

	return keys
end

function resetUtilsData()
	activeFuelMix = fuelMultiFunction["defaultUpDnMode"]
	keyQueue = {}
	nextActiveFuelMix = nil
	progEvents = nil
	progActive = false
	lastProgButtonPress = 0
end

function showupvalues(f)
  assert (type (f) == "function")
  
  local i = 1
  local name, val
  
  repeat
    name, val = debug.getupvalue (f, i)
    if name then
      print ("index", i, name, "=", val)
      i = i + 1
    end
  until not name
end

function getLocal(key)
	local i = 1
	while true do
		local name, val = debug.getlocal(3, i)
		if not name then
			return nil
		elseif name == key then
			return val
		end
		i = i + 1		
	end
end

function getLapDistance()
	return round(GetContextInfo("lap_distance"), 0)
end

function loadProperties(fileName)
	local file = assert(io.open(fileName, "r"))
	local props = {}
	for line in file:lines() do
		for key, value in string.gmatch(line, "(.-)=(.*)") do 
			props[key] = value 
		end
	end
	file:close()
	return props
end

function saveTextToFile(text, fileName)
	file = io.open(fileName, "w")
	file:write(text)
	file:close()
end

function fileExists(name)
	local file = io.open(name, "r")
	if file ~= nil then
		io.close(file)
		return true
	else
		return false
	end
end

function getKeyForValue(tableToSearch, value)
	for key, val in pairs(tableToSearch) do
		if val == value then
			return key
		end
	end
	return nil
end

function buildPropertyStringFromTable(tabl, numericKeySort)
	local text = ""	
	if numericKeySort then
		local tkeys = {}
		for key in pairs(tabl) do
			table.insert(tkeys, key)
		end		
		table.sort(tkeys)
		for _, key in ipairs(tkeys) do
			text = text .. key .. "=" .. tabl[key] .. "\n"
		end
	else
		for key, val in pairs(tabl) do
			text = text .. key .. "=" .. val .. "\n"
		end
	end
	return text
end

function startProgramming()
	progEvents = {}
	activateAlternateBlinkingLeds(progBlinkLedId, progBlinkLedPatterns, nil, false, 0)
	progActive = true
	display("PROG", "STRT", progDisplayTimeout)
end

function endProgramming(fileExtension)
	local propertyText = buildPropertyStringFromTable(progEvents, true)
	local fileName = progDataDir .. trackMultiFunction["modes"][trackMultiFunction["currentUpDnMode"]] .. "." .. fileExtension
	saveTextToFile(propertyText, fileName)
	progEvents = nil
	progActive = false
	deactivateAlternateBlinkingLeds(progBlinkLedId)
	display("PROG", "DONE", progDisplayTimeout)
end

function toggleProgrammingMode(fileExtension)
	if getTks() - lastProgButtonPress < progDoubleClickTime then
		if progActive then
			endProgramming(fileExtension)
		else
			startProgramming()
		end
	else
		lastProgButtonPress = getTks()
	end
end

function loadEventsForTrack(trackId, fileExtension)
	local fileName = progDataDir .. trackId .. "." .. fileExtension
	if fileExists(fileName) then
		return loadProperties(fileName)
	else
		return nil
	end
end

function inProgrammingMode()
	return progActive
end
