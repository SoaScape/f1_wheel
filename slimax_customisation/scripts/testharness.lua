require "scripts/simracef1_f1_2016_mike"

local instructions = "b1, b2 etc. or s1p10 would be switch 1 position 10"

print(instructions)

-- Stubs
local throttle = 0
local pits = 0
local yellow = false

function GetDeviceType(deviceType)
	return deviceType
end
function UpdateDigits(leftStr, rightStr, dev)
	print("Display: " .. leftStr .. " : " .. rightStr)
end
function SLISendReport(val)
end
function GetAppInfo(info)
	if info == "ticks" then
		return os.time() * 1000
	end
end
function SetKeystroke(key, holdDelay, str)
	print("Key: " .. key .. " (" .. holdDelay .. "ms)")
end
function SLISleep(delay)
	local endTime = getTks() + delay
	print("Wait: " .. delay)
	while getTks() < endTime do		
	end
end
function GetCarInfo(item)
	if item == "throttle" then
		return throttle
	end
end
function GetContextInfo(item)
	if item == "yellow_flag" then
		return yellow
	end
end
function GetInPitsState()
	return pits
end

mSessionEnter = 1
m_is_sim_idle = false
-- End Stubs

local leftDisplayPos = 1
local rightDisplayPos = 1
while true do
	custom_left_Display_Event(leftDisplayPos)
	custom_right_Display_Event(rightDisplayPos)
	
	print("user input: ")
	local input = io.read("*l")
	local buttonEvent = string.find(input, "b")
	local switchEvent = string.find(input, "s")
	local sessionEvent = string.find(input, "z")
	if buttonEvent ~= nil then
		local button = string.sub(input, buttonEvent + 1)
		multiControlsEvent(3, 1, tonumber(button), 0)
	elseif switchEvent ~= nil then
		local switch = string.sub(input, switchEvent + 1, 2)
		local position = string.find(input, "p")
		local switchPos = string.sub(input, position + 1)
		multiControlsEvent(3, 0, tonumber(switch), tonumber(switchPos))
		
		if switch == 1 then
			rightDisplayPos = switchPos
		elseif switch == 2 then
			leftDisplayPos = switchPos
		end
	elseif sessionEvent ~= nil then
		if m_is_sim_idle then
			mSessionEnter = 1
			m_is_sim_idle = false
			print("Session Active")
		else
			mSessionEnter = 0
			m_is_sim_idle = true
			print("Session Idle")
		end
	end
end
