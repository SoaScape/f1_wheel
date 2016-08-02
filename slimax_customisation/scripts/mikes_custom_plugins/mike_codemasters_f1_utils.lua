
function getOpenMenuButtons(chosenMenu)
	local buttons = {}
	local currentMenu = buttonTrackerMap[quickMenuToggleButton] % (numMenus + 1)
	if currentMenu ~= chosenMenu then
		local closeMenuClicks = 0
		if chosenMenu < currentMenu then
			closeMenuClicks = (numMenus + 1) - currentMenu
			for i = 1, closeMenuClicks + chosenMenu do
				buttons[i] = quickMenuToggleKey
				buttonTrackerMap[quickMenuToggleButton] = buttonTrackerMap[quickMenuToggleButton] + 1
			end
		else
			for i = currentMenu, (chosenMenu - 1 + closeMenuClicks) do
				buttons[i] = quickMenuToggleKey
				buttonTrackerMap[quickMenuToggleButton] = buttonTrackerMap[quickMenuToggleButton] + 1
			end
		end		
	end	
	return buttons
end