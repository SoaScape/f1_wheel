require "scripts/mike_utils"

-- This file houses non-changed code from original SliMaxManager scripts
-- =====================================================================
function commonDisplayProcessing(diffTimeFlag, lpt, sliPanel, side)
	local hr = 0
	local mn = 0
	local sc = 0
	local ms = 0
	local hd = 0
	
	local c = ""
	local refreshRate = mRefreshLapTimeRate
	if diffTimeFlag then
		if devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1" then
			c = "+"
		else
			c = " "
		end
		refreshRate = mDeltaTimeDelay
	end		
	
	if timeFlag and lpt ~= nil then	
		-- set char of negative number
		if diffTimeFlag then
			if lpt < 0 then c = "-" end
		end
		-- explod time
		hr, mn, sc, hd, tms = timeDispatcher(lpt)
		ms = tms - 100;
		if lpt == -1 or (mn + sc + ms) == 0.0000 then
			mDeltaTimeBackup =  "-:--.---" 
	
		elseif systemFlag then
			if devName == "SLI-PRO" then
				if side == 0 then
					mDeltaTimeBackup =  string.format( " %2d:%02d ", hr, mn)
				else
					mDeltaTimeBackup =  string.format( " %2d.%02d ", hr, mn)
				end
			else
				 mDeltaTimeBackup =  string.format( "%2d.%02d", hr, mn)
			end
		else
			if devName == "SLI-PRO" then
				if diffTimeFlag then
					-- 
					if lpt == -1 or (mn + sc + ms) == 0.0000 then
						mDeltaTimeBackup =  " --.---" 
					elseif mn > 0 then
						mDeltaTimeBackup =  string.format( "%s%2d.%02d.%01d", c, mn, sc, ms)
					 else
						mDeltaTimeBackup =  string.format( "%s%2d.%03d", c, sc, ms)
					 end
				
					sliPanel = mDeltaTimeBackup	
					
				else
					--
					if lpt == -1 or (mn + sc + ms) == 0.0000 then
						mDeltaTimeBackup =  "-:--.---" 
					elseif mn < 10 then
						mDeltaTimeBackup =  string.format( "%1d:%02d.%03d", mn, sc, ms)
					elseif hr > 0 then
						mDeltaTimeBackup =  string.format( " %02d.%02d ", hr, mn)   
					 else
						mDeltaTimeBackup =  string.format( " %02d.%02d.%01d", mn, sc, ms)
					 end					 
				 end	
			else
				if mn > 9 then
					-- > 9mn
					if c == "" then
						mDeltaTimeBackup =  string.format( " %2d.%2d ", mn, sc)
					else
						mDeltaTimeBackup =  string.format( "%s%2d  ", c, mn)
					end	

				elseif mn > 0 and mn < 10 then
					-- < 10mn
					if c == "" then
						mDeltaTimeBackup =  string.format( "%1d:%02d.%03d", mn, sc, ms)
					 else
						mDeltaTimeBackup =  string.format( "%s%2d.%02d.%01d", c, mn, sc, ms)
					end	
						
				else
					-- sc > 9
					if sc > 9 then
						if c == "" then
							mDeltaTimeBackup =  string.format( "0.%2d.%1d", sc, hd)
						else
							mDeltaTimeBackup =  string.format( "%s%02d.%01d", c, sc, hd)
						end	
						
					else
						-- sc < 0
						if c == "" then
							mDeltaTimeBackup =  string.format( "0.%01d.%02d", sc, hd)
						else
							mDeltaTimeBackup =  string.format( "%s%01d.%02d", c, sc, hd)
						end	
						
					end
				end												
			end
		end
			
		sliPanel = mDeltaTimeBackup
	end
	
	if isSlowUpdate or diffTimeFlag or timeFlag or systemFlag then
		if side == 0 then
			if getTks() > ( refreshRate  + mDeltaTimeOldTicks ) then
				mDeltaTimeOldTicks = getTks()
				mSRF1LeftText = sliPanel
			end
		else
			if getTks() > ( refreshRate  + mDeltaTimeAlternateOldTicks ) then
				mDeltaTimeAlternateOldTicks  = getTks()
				mSRF1RightText = sliPanel
			end
		end

	else
		if side == 0 then
			mSRF1LeftText = sliPanel
		else
			mSRF1RightText = sliPanel
		end
	end

	-- send string to sli manager
	if side == 0 then
		SetLeftDigits( mSRF1LeftText ) 
	else
		SetRightDigits( mSRF1RightText ) 
	end
end
