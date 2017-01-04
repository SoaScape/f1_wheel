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

local confirmTimeout = 0
local keystrokeDelay = 200
local keyHoldDelay = 30

function customDisplayIsActive()
	if customDisplayActive and getTks() > customDisplayTicksTimeout then		
		customDisplayActive = false
	end
	return customDisplayActive
end

function display(leftStr, rightStr, deviceType, timeout)
	if leftStr ~= nul and rightStr ~= nil then
		local dev = GetDeviceType(deviceType)
		UpdateDigits(leftStr, rightStr, dev)
		SLISendReport(0)
		setDisplayTimeout(timeout)
	end
end

function setDisplayTimeout(timeout)		
	customDisplayTicksTimeout = getTks() + timeout
	customDisplayActive = true	
end

local function processKeyPress(key, holdDelay, delayTime)
	SetKeystroke(key, holdDelay, "")
	SLISleep(delayTime)
end

function confirmSelection(leftDisp, rightDisplay, deviceType, buttonMap, showDisplay)
	local startTicks = getTks()
	if mSessionEnter == 1 and not(m_is_sim_idle) and startTicks > confirmTimeout then
		if showDisplay then
			display(leftDisp, rightDisplay, deviceType, 0)
		end
--print("===Keypresses Start===")
		for i=0, tablelength(buttonMap) - 1 do
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
--print("Key: " .. buttonMap[i] .. ", Delay: " .. delay)
			-- params: key, delay, modifier
			processKeyPress(buttonMap[i], holdDelay, delay)			
		end
		delayMap = nil
		
		local runningTime = getTks() - startTicks
		if showDisplay and runningTime < confirmDelay then
			setDisplayTimeout(confirmDelay - runningTime)
		end
--print("===Keypresses End===")
		if currentMultifunction["confirmDelay"] ~= nil then
			confirmTimeout = getTks() + currentMultifunction["confirmDelay"]
		end
	end
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
  for _ in pairs(T) do count = count + 1 end
  return count
end