oneSWActivated = true
mOneSW_Backup = 0

function oneSwitchControlEvent(ctrlType, ctrlPos, value)
	if ctrlType == 0 and ctrlPos == 2 and oneSWActivated then			
		mOneSW_Backup = value
		return 1
	end
	return 2
end

function oneSwitchRightDisplayEvent(swPosition)
	local pos = mOneSW_Backup - 1
	if pos == nil or pos < 0 then
		pos = 0
	end
	swValue = GetDisplayFunctionIndex("right", pos )
	swValue = swValue + 1
	if swValue == nil or swValue < 0 then
		swValue = 0
	end	
	return 2
end