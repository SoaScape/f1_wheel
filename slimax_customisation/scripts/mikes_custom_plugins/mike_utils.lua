myDevice = 3 -- 3 = SIMR-F1
switch = 0
pushbutton = 1
confirmButton = 14
upButton = 26
downButton = 27
upEncoder = 23
downEncoder = 24
buttonReleaseValue = 0

confirmDelay = 1000

local customDisplayActive = false
local customDisplayTicksTimeout = 0

local keystrokeDelay = 200
local keyHoldDelay = 30

local keyQueueActive = false
local keyQueue = {}

local activeFuelMix = nil
local nextActiveFuelMix = nil

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

local function processKeyPressQueue()
	if keyQueue ~= nil and keyQueue[1] ~= nil then
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
	else
		keyQueueActive = false
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
	keyQueueActive = true
	local keyPress = {}
	keyPress["key"] = key
	keyPress["holdDelay"] = holdDelay
	keyPress["delayTime"] = delayTime
	table.insert(keyQueue, keyPress)	
end

function confirmSelection(leftDisp, rightDisplay, buttonMap, showDisplay)
	local startTicks = getTks()
	if mSessionEnter == 1 and not(m_is_sim_idle) and not(keyQueueActive) then
		if currentMultifunction["name"] == fuelMultiFunction["name"] then
			nextActiveFuelMix = currentMultifunction["currentUpDnMode"]
		end
		
		for i = 0, tablelength(buttonMap) - 1 do
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

function round(num, idp)
  local mult = 10^(idp or 0)
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
	nextActiveFuelMix = nil
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