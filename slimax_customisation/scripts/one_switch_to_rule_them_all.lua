oneSWActivated = true

function oneSwitchEvent(deviceType, ctrlType, ctrlPos, value)
	if ctrlType == 0 and ctrlPos == 2 and oneSWActivated then			
		mOneSW_Backup  = value
		return 1				
	end
end

function oneSwitchLeftDisplayEvent(swPosition)
	-- type your custom script related to left digits panel here
	
	-- init global var if needed
	if mOneSW_Backup == nil then
		mOneSW_Backup = 0
	end
	
	return 2
end

function oneSwitchRightDisplayEvent(swPosition)
	-- type your custom script related to right SLI-PRO digits panel here
	-- init global var if needed
	if mOneSW_Backup == nil then
		mOneSW_Backup = 0
	end
	
	-- then patch right digits function for the 12 position of the switch
	-- by assigning a function number to swValue (see SLIMax Mgr API)
	-- here in this example we patched it with right function 9 (current lap time)
	-- change the 9 to the right function you want to each position of the switch from 1 to 12
	if mSMX_VERSION >= 6 then
		local pos = mOneSW_Backup - 1
		if pos == nil or pos < 0 then pos = 0 end
		swValue = GetDisplayFunctionIndex("right", pos )
		swValue = swValue + 1
		if swValue == nil or swValue < 0 then swValue = 0 end
	
	else
		if mOneSW_Backup == 1 then
			swValue = 9
		elseif mOneSW_Backup == 2 then
			swValue = 11	
		elseif mOneSW_Backup == 3 then
			swValue = 10	
		elseif mOneSW_Backup == 4 then
			swValue = 4
		elseif mOneSW_Backup == 5 then
			swValue = 22
		elseif mOneSW_Backup == 6 then
			swValue = 21
		elseif mOneSW_Backup == 7 then
			swValue = 23
		elseif mOneSW_Backup == 8 then
			swValue = 24
		elseif mOneSW_Backup == 9 then
			swValue = 6
		elseif mOneSW_Backup == 10 then
			swValue = 25
		elseif mOneSW_Backup == 11 then
			swValue = 27
		elseif mOneSW_Backup == 12 then
			swValue = 42
		end
	end
	
	-- return 2 to let SLIMax Mgr do the stuff for us with the new patched function in swValue
	return 2
end