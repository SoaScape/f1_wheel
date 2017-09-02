local mOneSW_Backup = -1

function oneSwitchControlEvent(ctrlType, ctrlPos, value)
	if ctrlType == switch and ctrlPos == oneSwCtrlPos and oneSWActivated then	
		if customFunctionNamesTable ~= nil and customFunctionNamesTable[value] ~= nil and (mOneSW_Backup == nil or mOneSW_Backup ~= value) then
			display(customFunctionNamesTable[value][0], customFunctionNamesTable[value][1], mDisplay_Info_Delay)
		end
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