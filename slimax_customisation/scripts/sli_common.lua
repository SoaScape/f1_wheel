require "scripts/mike_custom_displays"

-- SLIMax Mgr Lua Script v3.7.2
-- Copyright (c)2012-2015 by Zappadoc - All Rights Reserved.
-- this script builds all shiftlights methods
-- last change by Zappadoc - 2015-11-12

function sliDigitsEvent(swFunction, side, devName)
	swValue = swFunction + 1
	if devName == "SLI-EMU" then devName = "SLI-PRO" end
	if devName == "SRF1-EMU" then devName = "SIMRACEF1" end
	-- call custom script
	if side == 0 then
		local result = custom_left_Display_Event(swValue)
		-- if result = 0 bypass the script below and return 0
		-- if result = 1 bypass the script below and return 1
		if result <= 1 then return result end
		-- if result >= 2 continue
		
		-- call global custom script
		result = global_custom_left_Display_Event(swValue)
		-- if result = 0 bypass the script below and return 0
		-- if result = 1 bypass the script below and return 1
		if result <= 1 then return result end
		-- if result >= 2 continue
    else
		local result = custom_right_Display_Event(swValue)
		-- if result = 0 bypass the script below and return 0
		-- if result = 1 bypass the script below and return 1
		if result <= 1 then return result end
		-- if result >= 2 continue
		
		-- call global custom script
		result = global_custom_right_Display_Event(swValue)
		-- if result = 0 bypass the script below and return 0
		-- if result = 1 bypass the script below and return 1
		if result <= 1 then return result end
		-- if result >= 2 continue	
	end
		-- init
	InitGlobals()

	local hr = 0
	local mn = 0
	local sc = 0
	local ms = 0
	local hd = 0
	local lpt = 0.0
	local diffTimeFlag = false
	local timeFlag = false
	local systemFlag = false
	local unit = false
    local inf = ""
    local spd = 0.0
	local isSlowUpdate = false
	local sliPanel = ""
	if vside == nil then vside = side end
	
	if devName == "SIMRACE-GT" then
		if GetTicks() > mOldIgnition_Ticks then
			mOld_side_ticks = mOld_side_ticks + 1
		end

		if mOld_side_ticks >= (mBlinkTime * 2) then
			mOld_side_ticks = 0
		end

		if mOld_side_ticks <= mBlinkTime then
			vside = 1
		end

		if mOld_side_ticks > mBlinkTime then
			vside = 0
		end
		
		if GetTicks() > mOldIgnition_Ticks then
			mOldIgnition_Ticks = GetTicks() + 20
		end
	else
		vside = -1
	end
   	-- BEGIN ===============================================
	-- ignition
		local is_ignition_on = false
	local meth = GetContextInfo("ignition_method")
	if meth == nil then  meth = 0 end
	if meth ~= 0 then
		local ign = GetIgnition() 
		if ign == 0 then
			if meth == 1 then
				if side == 0 then
					swValue = 69
					if vside == 1 then swValue = 70 end
				else
					swValue = 70	
				end		
			else
				-- out of range value to empty panel
				swValue = 200	
			end
			is_ignition_on = true
			
		elseif ign == 1 then
			if meth == 1 then
				if side == 0 then
					swValue = 7
					if vside == 1 then swValue = 8 end
				else
					swValue = 8		
				end			
			else
				-- out of range value to empty panel
				swValue = 200	
			end
			
			is_ignition_on = true
			
		elseif ign == 2 then	
			-- out of range value to empty panel
			swValue = 200	
			is_ignition_on = true
			
		elseif ign == -2 then
		-- out of range value to empty panel
			if meth == 1 then
				if side == 0 then
					swValue = 69
					if vside == 1 then swValue = 70 end
				else
					swValue = 70	
				end		
			else
				swValue = 200	
			end
			is_ignition_on = true
			
		elseif ign == -1 then
			-- in pit but ignition OFF and method ENG/STOP activated
			local inpit = GetInPitsState()
			if meth == 1 and inpit > 1 then
				if side == 0 then
					swValue = 7
					if vside == 1 then swValue = 8 end
				else
					swValue = 8		
				end			
			end
		end
	end
	 -- END ================================================== 

	-- get speed in kph or mph (use "raw_speed" to get value in meter/sec)
	local spdmt = GetCarInfo("raw_speed")
	-- get current display unit metric or imperial
	unit = GetContextInfo("is_imperial")
	
	local spd = GetCarInfo("speed")
	--speed(spdmt, unit)

  
   	-- BEGIN ===============================================			
	-- lap finished, display lap time a few seconds
	local dlt = false
	dlt = GetContextInfo("display_lap_time_allowed")
	if dlt == nil then dlt = false end
	if devName == "SIMRACE-GT" or devName == "Fanatec" or side == 1 then
		if dlt and swValue ~= 47 and swValue ~= 48 and not is_ignition_on then
			swValue = 11
		end
	end
   -- END ==================================================  
   
   	-- BEGIN ===============================================	
	-- check if PIT Feedback ON
	local pf = GetContextInfo("pit_speed_function_allowed")
	local sl = GetCarInfo("pitlimiter")

	if pf and sl >0 and not is_ignition_on then
		-- force position to PIT/SPEED function if car pits
		local pit = GetInPitsState()
		if pit > 1 then
			if side == 0 then
				swValue = 45
				if vside == 1 then swValue = 1 end
			else
				swValue = 1			
			end		
		end	
	end
   -- END ==================================================  
   
   	-- BEGIN ===============================================			
	-- check if CLUTCH Feedback
    local crf = GetContextInfo("display_clutch_rpm_state")
    if crf then
		local result, cr_bool = GetSMXGlobal("mctrl_clutch_rpm")
		if cr_bool == "down" then
			if mctrl_clutch_delay == nil or mctrl_clutch_delay == 0 then mctrl_clutch_delay = GetTicks() + mDisplay_Info_Delay end  
		end
		if cr_bool == "down"  and mctrl_clutch_delay < GetTicks() then
			-- reset
			 mctrl_clutch_delay = 0
			mctrl_clutch_rpm = false
			 SetSMXGlobal("mctrl_clutch_rpm", "up")
			 cr_bool = "up"
		end
        if cr_bool == "down" then
            if not is_ignition_on then 
              -- force position to ENG/XX.X function if car pits
                --local clt = GetCarInfo("clutch")
				if side == 0 then
					swValue = 69
					if vside == 1 then swValue = 22 end
				else
					swValue = 22		
				end		
            end
        end
    end
   -- END ==================================================  
   
   	-- BEGIN ===============================================	
	-- check if bias Feedback
	local bbf = GetContextInfo("display_brake_bias_state")
	if bbf then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, bbup = GetSMXGlobal("brake_bias_button_up_sate")
		-- local result, bbdown = GetSMXGlobal("brake_bias_button_down_sate")
		local bb_bias = GetBrakeBiasState()

		-- if bbup == "down" or  bbdown == "down" or bb_bias ~= old_bb_bias then isActivated = true end
		-- if isActivated then
		if bb_bias ~= old_bb_bias then
			old_bb_bias = bb_bias
			bb_bias = math.abs(bb_bias)
			if bb_bias >= 0 then
			   
				-- if mOldBrakeBias_Ticks == nil or mOldBrakeBias_Ticks == 0 then 
				mOldBrakeBias_Ticks = GetTicks() + mDisplay_Info_Delay 
				--end        
			
			end
		end
		
		 if mOldBrakeBias_Ticks ~= nil and GetTicks() < mOldBrakeBias_Ticks then
			 -- force position to BBAL/bb_bias function if car pits
			if side == 0 then
				swValue = 75
				if vside == 1 then swValue = 76 end
			else
				swValue = 76
			end	 
		else
		   mOldBrakeBias_Ticks = 0
		end	
	end
   -- END ==================================================  
     	-- BEGIN ===============================================	
	-- check if diff_entry Feedback is allowed
	local diff_entry = GetContextInfo("display_diff_entry_state")
	if diff_entry then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("diff_entry_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("diff_entry_button_down_sate")
		local diff_entry = GetCarInfo("diff_entry")
		--if mOld_diff_entry_Ticks == nil then mOld_diff_entry_Ticks = 0 end 
		
		--if btn_up == "down" or  btn_down == "down" or diff_entry ~= old_diff_entry then isActivated = true end
		--if isActivated then and mOld_diff_entry_Ticks == 0 
		if diff_entry ~= old_diff_entry then
			old_diff_entry = diff_entry 

			--if mOld_diff_entry_Ticks == nil or mOld_diff_entry_Ticks == 0 then 
			mOld_diff_entry_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
		end
		
		 if mOld_diff_entry_Ticks ~= nil and GetTicks() < mOld_diff_entry_Ticks then
			 -- force position to diff_entry function
			if side == 0 then
				swValue = 85
				if vside == 1 then swValue = 84 end
			else
				swValue = 84
			end	 
		else
		   mOld_diff_entry_Ticks = 0
		end	
	end
   -- END ==================================================  
     	-- BEGIN ===============================================	
	-- check if diff_middle Feedback is allowed
	local diff_middle = GetContextInfo("display_diff_middle_state")
	if diff_middle then
		-- check if diff_middle BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("diff_middle_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("diff_middle_button_down_sate")
		local diff_middle = GetCarInfo("diff_middle")

		--if btn_up == "down" or  btn_down == "down" or diff_middle ~= old_diff_middle then isActivated = true end
		--if isActivated then
		if diff_middle ~= old_diff_middle then
			old_diff_middle = diff_middle
			--diff_middle = math.abs(diff_middle * 100)
			--if diff_middle > 0 then
			--if mOld_diff_middle_Ticks == nil or mOld_diff_middle_Ticks == 0 then 
			mOld_diff_middle_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_diff_middle_Ticks ~= nil and GetTicks() < mOld_diff_middle_Ticks then
			 -- force position to diff_middle function
			if side == 0 then
				swValue = 87
				if vside == 1 then swValue = 86 end
			else
				swValue = 86
			end	 
		else
		   mOld_diff_middle_Ticks = 0
		end	
	end
   -- END ==================================================   
	-- BEGIN ===============================================	
	-- check if diff_exit Feedback is allowed
	local diff_exit = GetContextInfo("display_diff_exit_state")
	if diff_exit then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("diff_exit_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("diff_exit_button_down_sate")
		local diff_exit = GetCarInfo("diff_exit")

		--if btn_up == "down" or  btn_down == "down" or diff_exit ~= old_diff_exit then isActivated = true end
		--if isActivated then
		if diff_exit ~= old_diff_exit then
			old_diff_exit = diff_exit
			--diff_exit = math.abs(diff_exit * 100)
			--if diff_exit > 0 then
			--if mOld_diff_exit_Ticks == nil or mOld_diff_exit_Ticks == 0 then 
			mOld_diff_exit_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_diff_exit_Ticks ~= nil and GetTicks() < mOld_diff_exit_Ticks then
			 -- force position to diff_exit function
			if side == 0 then
				swValue = 89
				if vside == 1 then swValue = 88 end
			else
				swValue = 88
			end	 
		else
		   mOld_diff_exit_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if bpf Feedback is allowed
	local bpf = GetContextInfo("display_clutch_biting_point_state")
	if bpf then
		
		local bpf = GetCarInfo("bpf")

		if bpf ~= old_bpf then
			old_bpf = bpf
			mOld_bpf_Ticks = GetTicks() + mDisplay_Info_Delay 
			
		end
		
		 if mOld_bpf_Ticks ~= nil and GetTicks() < mOld_bpf_Ticks then
			 -- force position to bpf function
			if side == 0 then
				swValue = 134
				if vside == 1 then swValue = 133 end
			else
				swValue = 133
			end	 
		else
		   mOld_bpf_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if engine_braking Feedback is allowed
	local engine_braking = GetContextInfo("display_engine_braking_state")
	if engine_braking then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("engine_braking_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("engine_braking_button_down_sate")
		local engine_braking = GetCarInfo("engine_braking")

		--if btn_up == "down" or  btn_down == "down" or engine_braking ~= old_engine_braking then isActivated = true end
		--if isActivated then
		if engine_braking ~= old_engine_braking then
			old_engine_braking = engine_braking
			--if engine_braking > 0 then
			--if mOld_engine_braking_Ticks == nil or mOld_engine_braking_Ticks == 0 then 
			mOld_engine_braking_Ticks = GetTicks() + mDisplay_Info_Delay
			--end        
			--end
		end
		
		 if mOld_engine_braking_Ticks ~= nil and GetTicks() < mOld_engine_braking_Ticks then
			 -- force position to engine_braking function
			if side == 0 then
				swValue = 91
				if vside == 1 then swValue = 90 end
			else
				swValue = 90
			end	 
		else
		   mOld_engine_braking_Ticks = 0
		end	
	end
   -- END ==================================================   
 	-- BEGIN ===============================================	
	-- check if engine_power Feedback is allowed
	local engine_power = GetContextInfo("display_engine_power_state")
	if engine_power then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("engine_power_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("engine_power_button_down_sate")
		local engine_power = GetCarInfo("engine_power")

		--if btn_up == "down" or  btn_down == "down" or engine_power ~= old_engine_power then isActivated = true end
		--if isActivated then
		if engine_power ~= old_engine_power then
			old_engine_power = engine_power
			--if engine_power > 0 then
			--if mOld_engine_power_Ticks == nil or mOld_engine_power_Ticks == 0 then 
			mOld_engine_power_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_engine_power_Ticks ~= nil and GetTicks() < mOld_engine_power_Ticks then
			 -- force position to engine_power function
			if side == 0 then
				swValue = 93
				if vside == 1 then swValue = 92 end
			else
				swValue = 92
			end	 
		else
		   mOld_engine_power_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if fuel_mix Feedback is allowed
	local fuel_mix = GetContextInfo("display_fuel_mix_state")
	if fuel_mix then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("fuel_mix_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("fuel_mix_button_down_sate")
		local fuel_mix = GetCarInfo("fuel_mix")

		--if btn_up == "down" or  btn_down == "down" or fuel_mix ~= old_fuel_mix then isActivated = true end
		--if isActivated then
		if fuel_mix ~= old_fuel_mix then 
			old_fuel_mix = fuel_mix
			--if fuel_mix > 0 then
			--if mOld_fuel_mix_Ticks == nil or mOld_fuel_mix_Ticks == 0 then 
			mOld_fuel_mix_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_fuel_mix_Ticks ~= nil and GetTicks() < mOld_fuel_mix_Ticks then
			 -- force position to fuel_mix function
			if side == 0 then
				swValue = 95
				if vside == 1 then swValue = 94 end
			else
				swValue = 94
			end	 
		else
		   mOld_fuel_mix_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if throttle_shaping Feedback is allowed
	local throttle_shaping = GetContextInfo("display_throttle_shaping_state")
	if throttle_shaping then
		-- check if Bthrottle_shapingAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("throttle_shaping_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("throttle_shaping_button_down_sate")
		local throttle_shaping = GetCarInfo("throttle_shaping")

		--if btn_up == "down" or  btn_down == "down" or throttle_shaping ~= old_throttle_shaping then isActivated = true end
		--if isActivated then
		if throttle_shaping ~= old_throttle_shaping then 
			old_throttle_shaping = throttle_shaping
			--if throttle_shaping > 0 then
			--if mOld_throttle_shaping_Ticks == nil or mOld_throttle_shaping_Ticks == 0 then 
			mOld_throttle_shaping_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_throttle_shaping_Ticks ~= nil and GetTicks() < mOld_throttle_shaping_Ticks then
			 -- force position to throttle_shaping function
			if side == 0 then
				swValue = 97
				if vside == 1 then swValue = 96 end
			else
				swValue = 96
			end	 
		else
		   mOld_throttle_shaping_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if front_antiroll_bar Feedback is allowed
	local front_antiroll_bar = GetContextInfo("display_front_antiroll_bar_state")
	if front_antiroll_bar then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("front_antiroll_bar_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("front_antiroll_bar_button_down_sate")
		local front_antiroll_bar = GetCarInfo("front_antiroll_bar")

		-- if btn_up == "down" or  btn_down == "down" or front_antiroll_bar ~= old_front_antiroll_bar then isActivated = true end
		-- if isActivated then
		if front_antiroll_bar ~= old_front_antiroll_bar then 
			old_front_antiroll_bar = front_antiroll_bar
			--if front_antiroll_bar > 0 then
			--if mOld_front_antiroll_bar_Ticks == nil or mOld_front_antiroll_bar_Ticks == 0 then
			mOld_front_antiroll_bar_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_front_antiroll_bar_Ticks ~= nil and GetTicks() < mOld_front_antiroll_bar_Ticks then
			 -- force position to front_antiroll_bar function
			if side == 0 then
				swValue = 99
				if vside == 1 then swValue = 98 end
			else
				swValue = 98
			end	 
		else
		   mOld_front_antiroll_bar_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if rear_antiroll_bar Feedback is allowed
	local rear_antiroll_bar = GetContextInfo("display_rear_antiroll_bar_state")
	if rear_antiroll_bar then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("rear_antiroll_bar_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("rear_antiroll_bar_button_down_sate")
		local rear_antiroll_bar = GetCarInfo("rear_antiroll_bar")

		-- if btn_up == "down" or  btn_down == "down" or rear_antiroll_bar ~= old_rear_antiroll_bar then isActivated = true end
		-- if isActivated then
		if rear_antiroll_bar ~= old_rear_antiroll_bar then
			old_rear_antiroll_bar = rear_antiroll_bar
			--if rear_antiroll_bar > 0 then
			--if mOld_rear_antiroll_bar_Ticks == nil or mOld_rear_antiroll_bar_Ticks == 0 then 
			mOld_rear_antiroll_bar_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_rear_antiroll_bar_Ticks ~= nil and GetTicks() < mOld_rear_antiroll_bar_Ticks then
			 -- force position to rear_antiroll_bar function
			if side == 0 then
				swValue = 101
				if vside == 1 then swValue = 100 end
			else
				swValue = 100
			end	 
		else
		   mOld_rear_antiroll_bar_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if left_weight_jacker Feedback is allowed
	local left_weight_jacker = GetContextInfo("display_left_weight_jacker_state")
	if left_weight_jacker then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("left_weight_jacker_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("left_weight_jacker_button_down_sate")
		local left_weight_jacker = GetCarInfo("left_weight_jacker")

		-- if btn_up == "down" or  btn_down == "down" or left_weight_jacker ~= old_left_weight_jacker then isActivated = true end
		-- if isActivated then
		if left_weight_jacker ~= old_left_weight_jacker then
			old_left_weight_jacker = left_weight_jacker
			--if left_weight_jacker > 0 then
			--if mOld_left_weight_jacker_Ticks == nil or mOld_left_weight_jacker_Ticks == 0 then 
			mOld_left_weight_jacker_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_left_weight_jacker_Ticks ~= nil and GetTicks() < mOld_left_weight_jacker_Ticks then
			 -- force position to left_weight_jacker function
			if side == 0 then
				swValue = 103
				if vside == 1 then swValue = 102 end
			else
				swValue = 102
			end	 
		else
		   mOld_left_weight_jacker_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if right_weight_jacker Feedback is allowed
	local right_weight_jacker = GetContextInfo("display_right_weight_jacker_state")
	if right_weight_jacker then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("right_weight_jacker_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("right_weight_jacker_button_down_sate")
		local right_weight_jacker = GetCarInfo("right_weight_jacker")

		-- if btn_up == "down" or  btn_down == "down" or right_weight_jacker ~= old_right_weight_jacker then isActivated = true end
		-- if isActivated then
		if right_weight_jacker ~= old_right_weight_jacker then
			old_right_weight_jacker = right_weight_jacker
			--if right_weight_jacker > 0 then
			--if mOld_right_weight_jacker_Ticks == nil or mOld_right_weight_jacker_Ticks == 0 then 
			mOld_right_weight_jacker_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_right_weight_jacker_Ticks ~= nil and GetTicks() < mOld_right_weight_jacker_Ticks then
			 -- force position to right_weight_jacker function
			if side == 0 then
				swValue = 105
				if vside == 1 then swValue = 104 end
			else
				swValue = 104
			end	 
		else
		   mOld_right_weight_jacker_Ticks = 0
		end	
	end
	-- END ==================================================   
   	-- BEGIN ===============================================	
	-- check if engine_boost Feedback is allowed
	local engine_boost = GetContextInfo("display_engine_boost_state")
	if engine_boost then
		-- check if BRAKE BIAS BUTTONS Feedback
		local isActivated = false
		local result, btn_up = GetSMXGlobal("engine_boost_button_up_sate")
		local result, btn_down = GetSMXGlobal("engine_boost_button_down_sate")
		local engine_boost = GetCarInfo("red_zone")
		--local engine_boost = GetCarInfo("engine_boost")

		if btn_up == "down" or  btn_down == "down" then isActivated = true end
		if isActivated then
		--and engine_boost ~= old_engine_boost then
			old_engine_boost = engine_boost
			--if engine_boost > 0 then
			--if mOld_engine_boost_Ticks == nil or mOld_engine_boost_Ticks == 0 then 
			mOld_engine_boost_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_engine_boost_Ticks ~= nil and GetTicks() < mOld_engine_boost_Ticks then
			 -- force position to engine_boost function
			if side == 0 then
				swValue = 80
				if vside == 1 then swValue = 22 end
			else
				swValue = 22
			end	 
		else
		   mOld_engine_boost_Ticks = 0
		end	
	end
   -- END ==================================================    
  	-- BEGIN ===============================================	
	-- check if front_flap Feedback is allowed
	local front_flap = GetContextInfo("display_front_flap_state")
	if front_flap then
		-- check if BRAKE BIAS BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("front_flap_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("front_flap_button_down_sate")
		local front_flap = GetCarInfo("front_flap")

		-- if btn_up == "down" or  btn_down == "down" or front_flap ~= old_front_flap then isActivated = true end
		-- if isActivated then
		if front_flap ~= old_front_flap then
			old_front_flap = front_flap
			--if front_flap > 0 then
			--if mOld_front_flap_Ticks == nil or mOld_front_flap_Ticks == 0 then
			mOld_front_flap_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_front_flap_Ticks ~= nil and GetTicks() < mOld_front_flap_Ticks then
			 -- force position to front_flap function
			if side == 0 then
				swValue = 107
				if vside == 1 then swValue = 106 end
			else
				swValue = 106
			end	 
		else
		   mOld_front_flap_Ticks = 0
		end	
	end
	-- END ==================================================   
	-- BEGIN ===============================================	
	-- check if rear_flap Feedback is allowed
	local rear_flap = GetContextInfo("display_rear_flap_state")
	if rear_flap then
		-- check if rear_flap  BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("rear_flap_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("rear_flap_button_down_sate")
		local rear_flap = GetCarInfo("rear_flap")

		-- if btn_up == "down" or  btn_down == "down" or rear_flap ~= old_rear_flap then isActivated = true end
		-- if isActivated then
		if rear_flap ~= old_rear_flap then
			old_rear_flap = rear_flap
			--if rear_flap > 0 then
			-- if mOld_rear_flap_Ticks == nil or mOld_rear_flap_Ticks == 0 then 
			mOld_rear_flap_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_rear_flap_Ticks ~= nil and GetTicks() < mOld_rear_flap_Ticks then
			 -- force position to rear_flap function
			if side == 0 then
				swValue = 109
				if vside == 1 then swValue = 108 end
			else
				swValue = 108
			end	 
		else
		   mOld_rear_flap_Ticks = 0
		end	
	end
	-- END ==================================================   
   	-- BEGIN ===============================================
	-- kest boost behavior	
	-- check if KERS is supported
local isKBActivated = GetContextInfo("kers_boost_btn")
if isKBActivated ~= nil and isKBActivated > 0 then
	local kbst = GetCarInfo("kers_max")
	if kbst > 0 and side == 0 then
		-- check if button state is down or up
		local result, stringValue = GetSMXGlobal("kers_boost_button_sate")
		
		if stringValue == "down" then 
		    swValue = 28	
		    if mDisplay_KERSBOOST == nil or mDisplay_KERSBOOST == 0 then
		         mDisplay_KERSBOOST = 1
			    if mOldKersBoost_Ticks == nil or mOldKersBoost_Ticks == 0 then mOldKersBoost_Ticks = GetTicks() + mDisplay_Info_Delay end
			end
		end	
		
		if stringValue == "up" and mDisplay_KERSBOOST == 1  then 
		     mDisplay_KERSBOOST = 0
			if mOldKersBoost_Ticks ~= nil or mOldKersBoost_Ticks == 0 then  mOldKersBoost_Ticks = GetTicks() + mDisplay_Info_Delay  end
		end	

         if mOldKersBoost_Ticks ~= nil and GetTicks() < mOldKersBoost_Ticks then
             -- force position to kers function
             swValue = 80
        else
           
           mOldKersBoost_Ticks = 0
           -- reset state
          
        end	
	end
end
   -- END ==================================================  
 	-- BEGIN ===============================================
	-- BPF behavior	
		-- check if BPF is supported
	  -- check if BPF button is down
	local isBPFActivated = GetContextInfo("clutch_biting_point_finder_btn")

		if isBPFBtnHasBeenDown ~= nil and isBPFBtnHasBeenDown == true and not is_ignition_on then
			
			if side == 0 then
				swValue = 69
				if vside == 1 then swValue = 22 end
			else
				swValue = 22		
			end		
			
			local cltch = GetCarInfo("clutch")
			local g = GetCarInfo("gear")	
			if g == 1 and spdmt <= 1 then
				last_bpf_value  = math.abs(cltch + 0.04)*100
				if last_bpf_value > 99 then last_bpf_value = 99 end
				
			else
				isBPFActivated = 1
				mOld_btpt_finder_button_sate = -1 
				isBPFBtnHasBeenDown = false
				if last_bpf_value ~= nil and last_bpf_value > 0 and last_bpf_value <= 100 then SetBitingPoint(last_bpf_value) end
				--  mDisplay_BTPTFINDER = 0
			    if mOldBtPtFinder_Ticks == nil or mOldBtPtFinder_Ticks == 0 then mOldBtPtFinder_Ticks = GetTicks() + ( mDisplay_Info_Delay  * 2) end
			end
		end
	if isBPFActivated ~= nil and isBPFActivated > 0 then
	
		-- check if button state is down or up
		local result, stringValue = GetSMXGlobal("btpt_finder_button_sate")
				
		if stringValue == "down" then 
		    swValue = 134	
		    if mDisplay_BTPTFINDER == nil or mDisplay_BTPTFINDER == 0 then
			  
		         mDisplay_BTPTFINDER = 1
			    if mOldBtPtFinder_Ticks == nil or mOldBtPtFinder_Ticks == 0 then mOldBtPtFinder_Ticks = GetTicks() + mDisplay_Info_Delay end
			end
		end	
		
		if stringValue == "up" and mDisplay_BTPTFINDER == 1  then 
			if isBPFBtnHasBeenDown == nil then isBPFBtnHasBeenDown = false end
			isBPFBtnHasBeenDown = not isBPFBtnHasBeenDown;
		     mDisplay_BTPTFINDER = 0
			if mOldBtPtFinder_Ticks ~= nil or mOldBtPtFinder_Ticks == 0 then  mOldBtPtFinder_Ticks = GetTicks() + mDisplay_Info_Delay  end
		end	

         if mOldBtPtFinder_Ticks ~= nil and GetTicks() < mOldBtPtFinder_Ticks then
             -- force position to BPF function
			if last_bpf_value ~= nil and last_bpf_value > 0 then
				if side == 0 then
					swValue = 134
					if vside == 1 then swValue = 133 end
				else
					swValue = 133
				end
			else
				if side == 0 then
					swValue = 134
					if vside == 1 then swValue = 135 end
				else
					swValue = 135
				end
			end			
        else
           
           mOldBtPtFinder_Ticks = 0
           -- reset state
          
        end	
	
	end

 
   -- END ==================================================  
   	-- BEGIN ===============================================
  -- check if brake rpm Feedback
	local brf = GetContextInfo("brake_rpm_function_allowed")
	if brf then 
		local bb_bias = GetBrakeBiasState()
	    bb_bias = math.abs(bb_bias)
        if bb_bias >= 0 then
            local bb_pedal = GetCarInfo("brake")
            if mOld_brake_pedal1 == nil then mOld_brake_pedal1 = 0 end
            local inpits = GetInPitsState()

            if bb_pedal ~= mOld_brake_pedal1 and inpits > 1 then
                   
                if mOldBrake_Ticks == nil or mOldBrake_Ticks == 0 then mOldBrake_Ticks = GetTicks() + mDisplay_Info_Delay end        
                
             end
            
             if mOldBrake_Ticks ~= nil and GetTicks() < mOldBrake_Ticks then
                 -- force position to BBAL/bb_bias function if car pits
                if side == 0 then
                    swValue = 75
				if vside == 1 then swValue = 76 end
                else
                    swValue = 76
                end	 
            else
                mOld_brake_pedal1 = bb_pedal
                mOldBrake_Ticks = 0
            end	
        end
	end
  -- END ==================================================  
 
    -- BEGIN ===============================================	
	-- check if quick info button is down
	local qi = false
	qi = GetContextInfo("quick_info_button")
	if qi == nil or qi == 0 then qi = false end
	if qi and not is_ignition_on then
		-- get index for left and right panel
		local qiInf = 1
		if side == 0 then
			qiInf = GetContextInfo("quick_info_left")
		else
			qiInf = GetContextInfo("quick_info_right")
		end
		if qiInf == nil then qiInf = 1 end
		-- force position to match QI preference
		swValue = qiInf
	end
   -- END ==================================================  
  -- BEGIN ==================================================  
	-- OVERDRIVE OSP
	if mOldOSPOverdrive_Btn == nil then mOldOSPOverdrive_Btn = -1 end
	local ospov = GetContextInfo("osp_overdrive_btn")
	if ospov ~= mOldOSPOverdrive_Btn then
		if mOldOSPOverdrive_Ticks == nil then mOldOSPOverdrive_Ticks = 0 end 
		if mOldOSPOverdrive_Ticks == 0 then
			mOldOSPOverdrive_Btn = ospov
			mOldOSPOverdrive_Ticks = GetTicks() + mDisplay_Info_Delay 
		end 
	end
	 if mOldOSPOverdrive_Ticks ~= nil and GetTicks() < mOldOSPOverdrive_Ticks then
		 -- force position to OSP/Factor function if car pits
		if side == 0 then
			swValue = 81
			if vside == 1 then swValue = 82 end
		else
			swValue = 82		
		end	 
	else
	    mOldOSPOverdrive_Ticks = 0
	end	
	
 -- END ==================================================  
 
        -- BEGIN ===============================================	
	-- check if Black flag flash allowed
	local bkff = false
	bkff = GetContextInfo("black_flag_flash_allowed")
	if bkff == nil then bkff = false end
	if bkff and not is_ignition_on then
		local bkf = GetContextInfo("black_flag")
		if mOldBlackFlagFlash_Ticks == nil then mOldBlackFlagFlash_Ticks = 0 end 
		if bkf==true and bkf ~= mOldBlackFlagState and mOldBlackFlagFlash_Ticks==0 then
			mOldBlackFlagState = bkf
			mOldBlackFlagFlash_Ticks = GetTicks() + mDisplay_Info_Delay 
		end 
		if bkf==false and mOldBlackFlagState == true and mOldBlackFlagFlash_Ticks==0 then
		     mOldBlackFlagState = false 
		     mOldBlackFlagFlashCount = 6
		 end
		
		 if mOldBlackFlagFlash_Ticks ~= nil and GetTicks() < mOldBlackFlagFlash_Ticks then
			 -- force position to FLAG display
			 if mOldBlackFlagFlashCount == nil then mOldBlackFlagFlashCount = 6 end
			  if side == 1 and mOldBlackFlagFlashCount>0 and GetTicks() > ( mOldBlackFlagFlash_Ticks - (100 * mOldBlackFlagFlashCount)  ) then
              
                mOldBlackFlagFlashCount = mOldBlackFlagFlashCount - 1 
                
			end
            if math.mod(mOldBlackFlagFlashCount, 2) == 0 then
                 swValue = 83
             else
                swValue = 200
             end
		else
			mOldBlackFlagFlash_Ticks = 0
		end	
	end
   -- END ==================================================  
   -- BEGIN ===============================================	
	-- check if yellow flag flash allowed
	local yff = false
	yff = GetContextInfo("yellow_flag_flash_allowed")
	if yff == nil then yff = false end
	if yff and not is_ignition_on then
		local yf = GetContextInfo("yellow_flag")
		if mOldYellowFlagFlash_Ticks == nil then mOldYellowFlagFlash_Ticks = 0 end 
		if yf==true and yf ~= mOldYellowFlagState and mOldYellowFlagFlash_Ticks==0 then
			mOldYellowFlagState = yf
			mOldYellowFlagFlash_Ticks = GetTicks() + mDisplay_Info_Delay 
		end 
		if yf==false and mOldYellowFlagState == true and mOldYellowFlagFlash_Ticks==0 then
		     mOldYellowFlagState = false 
		     mOldYellowFlagFlashCount = 6
		 end
		
		 if mOldYellowFlagFlash_Ticks ~= nil and GetTicks() < mOldYellowFlagFlash_Ticks then
			 -- force position to FLAG display
			 if mOldYellowFlagFlashCount == nil then mOldYellowFlagFlashCount = 6 end
			  if side == 1 and mOldYellowFlagFlashCount>0 and GetTicks() > ( mOldYellowFlagFlash_Ticks - (100 * mOldYellowFlagFlashCount)  ) then
              
                mOldYellowFlagFlashCount = mOldYellowFlagFlashCount - 1 
                
			end
            if math.mod(mOldYellowFlagFlashCount, 2) == 0 then
                 swValue = 83
             else
                swValue = 200
             end
		else
			mOldYellowFlagFlash_Ticks = 0
		end	
	end
   -- END ==================================================  
   
      -- BEGIN ===============================================	
	-- check if Blue flag flash allowed
	local bff = false
	bff = GetContextInfo("blue_flag_flash_allowed")
	if bff == nil then bff = false end
	if bff and not is_ignition_on then
		local bf = GetContextInfo("blue_flag")
		if mOldBlueFlagFlash_Ticks == nil then mOldBlueFlagFlash_Ticks = 0 end 
		if bf==true and bf ~= mOldBlueFlagState and mOldBlueFlagFlash_Ticks==0 then
			mOldBlueFlagState = bf
			mOldBlueFlagFlash_Ticks = GetTicks() + mDisplay_Info_Delay 
		end 
		if bf==false and mOldBlueFlagState == true and mOldBlueFlagFlash_Ticks==0 then
		     mOldBlueFlagState = false 
		     mOldBlueFlagFlashCount = 6
		 end
		
		 if mOldBlueFlagFlash_Ticks ~= nil and GetTicks() < mOldBlueFlagFlash_Ticks then
			 -- force position to FLAG display
			 if mOldBlueFlagFlashCount == nil then mOldBlueFlagFlashCount = 6 end
			  if side == 1 and mOldBlueFlagFlashCount>0 and GetTicks() > ( mOldBlueFlagFlash_Ticks - (100 * mOldBlueFlagFlashCount)  ) then
              
                mOldBlueFlagFlashCount = mOldBlueFlagFlashCount - 1 
                
			end
            if math.mod(mOldBlueFlagFlashCount, 2) == 0 then
                 swValue = 83
             else
                swValue = 200
             end
		else
			mOldBlueFlagFlash_Ticks = 0
		end	
	end
   -- END ==================================================  
   
     -- BEGIN ===============================================	
	-- check if SC flag flash allowed
	local scff = false
	scff = GetContextInfo("safety_car_flag_flash_allowed")
	if scff == nil then scff = false end
	if scff and not is_ignition_on then
		local sc = GetContextInfo("safety_car_flag")
		if mOldSCFlagFlash_Ticks == nil then mOldSCFlagFlash_Ticks = 0 end 
		if sc==true and sc ~= mOldSCFlagState and mOldSCFlagFlash_Ticks==0 then
			mOldSCFlagState = sc
			mOldSCFlagFlash_Ticks = GetTicks() + mDisplay_Info_Delay 
		end 
		if sc==false and mOldSCFlagState == true and mOldSCFlagFlash_Ticks==0 then
		     mOldSCFlagState = false 
		     mOldSCFlagFlashCount = 6
		 end
		
		 if mOldSCFlagFlash_Ticks ~= nil and GetTicks() < mOldSCFlagFlash_Ticks then
			 -- force position to FLAG display
			 if mOldSCFlagFlashCount == nil then mOldSCFlagFlashCount = 6 end
			  if side == 1 and mOldSCFlagFlashCount>0 and GetTicks() > ( mOldSCFlagFlash_Ticks - (100 * mOldSCFlagFlashCount)  ) then
              
                mOldSCFlagFlashCount = mOldSCFlagFlashCount - 1 
                
			end
            if math.mod(mOldSCFlagFlashCount, 2) == 0 then
                 swValue = 83
             else
                swValue = 200
             end
		else
			mOldSCFlagFlash_Ticks = 0
		end	
	end
   -- END ==================================================  
          -- BEGIN ===============================================	
	-- check if Red flag flash allowed
	local rff = false
	rff = GetContextInfo("red_flag_flash_allowed")
	if rff == nil then rff = false end
	if rff and not is_ignition_on then
		local rf = GetContextInfo("red_flag")
		if mOldRedFlagFlash_Ticks == nil then mOldRedFlagFlash_Ticks = 0 end 
		if rf==true and rf ~= mOldRedFlagState and mOldRedFlagFlash_Ticks==0 then
			mOldRedFlagState = rf
			mOldRedFlagFlash_Ticks = GetTicks() + mDisplay_Info_Delay 
		end 
		if rf==false and mOldRedFlagState == true and mOldRedFlagFlash_Ticks==0 then
		     mOldRedFlagState = false 
		     mOldRedFlagFlashCount = 6
		 end
		
		 if mOldRedFlagFlash_Ticks ~= nil and GetTicks() < mOldRedFlagFlash_Ticks then
			 -- force position to FLAG display
			 if mOldRedFlagFlashCount == nil then mOldRedFlagFlashCount = 6 end
			  if side == 1 and mOldRedFlagFlashCount>0 and GetTicks() > ( mOldRedFlagFlash_Ticks - (100 * mOldRedFlagFlashCount)  ) then
              
                mOldRedFlagFlashCount = mOldRedFlagFlashCount - 1 
                
			end
            if math.mod(mOldRedFlagFlashCount, 2) == 0 then
                 swValue = 83
             else
                swValue = 200
             end
		else
			mOldRedFlagFlash_Ticks = 0
		end	
	end
   -- END ==================================================  
-- BEGIN ===============================================	
	-- check if antilock_brake Feedback is allowed
	local antilock_brake = GetContextInfo("display_antilock_brake_state")
	if antilock_brake then
		-- check if antilock_brake  BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("antilock_brake_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("antilock_brake_button_down_sate")
		local antilock_brake = GetCarInfo("abs")

		-- if btn_up == "down" or  btn_down == "down" or antilock_brake ~= old_antilock_brake then isActivated = true end
		-- if isActivated then
		if antilock_brake ~= old_antilock_brake then
			old_antilock_brake = antilock_brake
			--if antilock_brake > 0 then
			--if mOld_antilock_brake_Ticks == nil or mOld_antilock_brake_Ticks == 0 then 
			mOld_antilock_brake_Ticks = GetTicks() + mDisplay_Info_Delay
			--end        
			--end
		end
		
		 if mOld_antilock_brake_Ticks ~= nil and GetTicks() < mOld_antilock_brake_Ticks then
			 -- force position to antilock_brake function
			if side == 0 then
				swValue = 118
				if vside == 1 then swValue = 117 end
			else
				swValue = 117
			end	 
		else
		   mOld_antilock_brake_Ticks = 0
		end	
	end
   -- END ==================================================    
   	-- BEGIN ===============================================	
	-- check if traction_control Feedback is allowed
	local traction_control = GetContextInfo("display_traction_control_state")
	if traction_control then
		-- check if traction_control BUTTONS Feedback
		-- local isActivated = false
		-- local result, btn_up = GetSMXGlobal("traction_control_button_up_sate")
		-- local result, btn_down = GetSMXGlobal("traction_control_button_down_sate")
		local traction_control = GetCarInfo("traction_control")

		-- if btn_up == "down" or  btn_down == "down" or traction_control ~= old_traction_control then isActivated = true end
		-- if isActivated then
		if traction_control ~= old_traction_control then 
			old_traction_control = traction_control
			--if traction_control > 0 then
			--if mOld_traction_control_Ticks == nil or mOld_traction_control_Ticks == 0 then 
			mOld_traction_control_Ticks = GetTicks() + mDisplay_Info_Delay 
			--end        
			--end
		end
		
		 if mOld_traction_control_Ticks ~= nil and GetTicks() < mOld_traction_control_Ticks then
			 -- force position to traction_control function
			if side == 0 then
				swValue = 120
				if vside == 1 then swValue = 119 end
			else
				swValue = 119
			end	 
		else
		   mOld_traction_control_Ticks = 0
		end	
	end
   -- END ==================================================    
   	-- BEGIN ===============================================	
	-- idle behavior
	if mSessionEnter == 1 then m_is_sim_idle = false end
	if m_is_sim_idle == true then 
		if side == 0 then
			swValue = m_idle_left_function
		else
			swValue = m_idle_right_function
		end	 
	end
	-- END ==================================================    
	
	-- get current simulation name
	local sim = GetContextInfo("simulation")

	-- check postion and compute left panel string
	if swValue == 1 then
		-- speed only
		if devName == "SLI-PRO" then
			sliPanel = string.format("  %3.0f ", spd )
		else
			sliPanel = string.format(" %3.0f", spd )
		end
		
	elseif swValue == 2 then
		-- fuel
		local fuel = GetCarInfo("fuel")
		if fuel ~= nil then
			fuel = GetFuel(fuel, unit)
			
			if devName == "SLI-PRO" then
				if fuel >= 100 then
					sliPanel = string.format(" F%3d  ", round(fuel))
				elseif fuel >= 10 then
					sliPanel = string.format(" F%2d   ", round(fuel))
				else
					sliPanel = string.format(" F%1.1f  ", fuel)
				end
			else
				if fuel >= 100 then
					sliPanel = string.format("F%3d", round(fuel))
				elseif fuel >= 10 then
					sliPanel = string.format(" F%2d", round(fuel))
				else
					sliPanel = string.format(" F%1.1f", fuel)
				end
			end
		end
    elseif swValue == 3 then
		-- position
		inf = GetContextInfo("position")
		if inf ~= nil then
			
			if devName == "SLI-PRO" then
				if inf >= 100 then
					 sliPanel = string.format(" P%3d  ", inf)
				elseif inf >= 10 then
					 sliPanel = string.format(" P%2d   ", inf)
				else
					sliPanel = string.format(" P%1d    ", inf)
				end	   
			else
				if inf >= 100 then
					sliPanel = string.format("P%3d", inf)
				elseif inf >= 10 then
					 sliPanel = string.format(" P%2d", inf)
				else
					sliPanel = string.format(" P%1d ", inf)
				end	   
			end
  		end
   elseif swValue == 4 then
		-- laps completed
		inf = GetContextInfo("laps")
		if inf ~= nil then
			-- if more then 99 laps
			
			
			if devName == "SLI-PRO" then
				if inf >= 100 then
					sliPanel = string.format(" L%3d  ", inf)
				elseif inf >= 10 then
					sliPanel = string.format(" L%2d   ", inf)
				else
					sliPanel = string.format(" L%1d    ", inf)
				end
			else
				if inf >= 100 then
					sliPanel = string.format("L%3d", inf)
				elseif inf >= 10 then
					sliPanel = string.format(" L%2d", inf)
				else
					sliPanel = string.format(" L%1d ", inf)
				end
			end
 		end
    elseif swValue == 5 then
		-- sector
		inf = GetCarInfo("sector")
		if inf ~= nil then
			-- check if sector > 9
			if devName == "SLI-PRO" then
				if inf >9 then
					sliPanel = string.format(" S%2d   ", inf)
				else
					sliPanel = string.format(" S%1d   ", inf)
				end
			else
				if inf >9 then
					sliPanel = string.format(" S%2d", inf)
				else
					sliPanel = string.format(" S%1d ", inf)
				end
			end
 		end
   elseif swValue == 6 then
		-- total laps if available
		local tl = GetContextInfo("laps_count")
		if tl < 1 then  tl = 0 end
		-- if more then 99 laps
		
		if devName == "SLI-PRO" then
			if tl >= 100 then
				sliPanel = string.format(" t%3d  ", tl)
			elseif tl >= 10 then
				sliPanel = string.format(" t%2d   ", tl)
			else
				sliPanel = string.format(" t%1d    ", tl)
			end	   
		else
			if tl >= 100 then
				sliPanel = string.format("t%3d", tl)
			elseif tl >= 10 then
				sliPanel = string.format("t%2d ", tl)
			else
				sliPanel = string.format("t%1d  ", tl)
			end	   
		end
		
    elseif swValue == 7 then
		-- water temp
		inf = GetCarInfo("water_temp")
		if inf ~= nil then
			inf = GetTemp(inf, unit)
		    
			if devName == "SLI-PRO" then
				sliPanel = string.format(" t%3.0f  ", inf)
			else
				sliPanel = string.format("t%3.0f", inf)
			end
 		end
    elseif swValue == 8 then
		-- oil temp
		inf = GetCarInfo("oil_temp")
		if inf ~= nil then
			inf = GetTemp(inf, unit)
		    
			if devName == "SLI-PRO" then
				sliPanel = string.format(" o%3.0f  ", inf)
			else
				sliPanel = string.format("o%3.0f", inf)
			end
		end
		
    elseif swValue == 9 then
			-- best lap time 
		timeFlag = true
		lpt = GetTimeInfo("lap_time")

	elseif swValue == 10 then
			-- best lap time 
		timeFlag = true
		lpt = GetTimeInfo("best_lap_time")

	elseif swValue == 11 then
		-- last lap time
		timeFlag = true
		lpt = GetTimeInfo("last_lap_time")
	
	elseif swValue >= 12 and swValue <= 18 then
		timeFlag = true
		diffTimeFlag = true
		-- iRacing partials
		if isAppIRacing(sim) then
			-- local sector = GetCarInfo("sector")
			-- if sector == nil then sector = 0 end
			-- if ts ~= nil and ts > 0 then
			if swValue == 12 then
			   lpt = GetPartialTimeInfo("ir_current_partial", 1)
			elseif swValue == 13 then
				lpt = GetPartialTimeInfo("ir_vs_best_lap", 1)
			elseif swValue == 14 then
				lpt = GetPartialTimeInfo("ir_vs_optimal_lap", 1)
			elseif swValue == 15 then
				lpt = GetPartialTimeInfo("ir_vs_optimal_sector", 1)
			elseif swValue == 16 then
				lpt = GetPartialTimeInfo("ir_vs_session_best_lap", 1)
			elseif swValue == 17 then
				lpt = GetPartialTimeInfo("ir_vs_session_optimal_lap", 1)
			elseif swValue == 18 then
				lpt = GetPartialTimeInfo("ir_vs_session_optimal_sector", 1)
			else
				lpt = 0.0
			end
		else
			lpt = 0.0
		end
		
	elseif swValue == 19 then
		-- real time diff vs your best
		diffTimeFlag = true
		timeFlag = true
		lpt = GetTimeInfo("delta_time_vs_best_records")

	elseif swValue == 20 then
		-- real time diff vs your last
		diffTimeFlag = true
		timeFlag = true
		lpt = GetTimeInfo("delta_time_vs_last_lap_records")

	elseif swValue == 21 then
		-- get an average consumption of fuel per lap and gives the remaining laps
		local remainintank = GetCarInfo("remain_laps_in_tank")
		if devName == "SLI-PRO" then
			sliPanel = string.format(" L%3.0f  ",  math.floor(remainintank) )
		else
			sliPanel = "L" .. remainintank			
		end
		
	elseif swValue == 22 then
		-- rpm
		isSlowUpdate = true
		--timeFlag = true
		local rpm = GetCarInfo("rpm")
	
		if devName == "SLI-PRO" then
			sliPanel =  string.format(" %5d", rpm)
		else
			local r = rpm / 1000.0
			if r < 10.0 then
				sliPanel =  string.format("  %1.1f", r)	
			else
				sliPanel =  string.format(" %2.1f", r)	
			end
		end

	elseif swValue == 23 then
		-- track size
		isSlowUpdate = true
		--timeFlag = true
		local trcksz = GetContextInfo("track_size")
		
		if devName == "SLI-PRO" then
			sliPanel =  string.format(" %5d    ", trcksz)
		else
			if trcksz < 10000 then
				sliPanel =  string.format("%4d", trcksz)	
			else
				local r = trcksz / 1000.0
				sliPanel =  string.format(" %2.1f", r)			
			end
		end	
				
	elseif swValue == 24 then
		-- distance percent
		local dist = GetContextInfo("lap_distance")
		-- track size
		local trcksz = GetContextInfo("track_size")
		local p = round(dist / (trcksz / 100))
		
		if devName == "SLI-PRO" then
			sliPanel = string.format(" D%3d   ", p )
		else
			sliPanel = string.format("D%3d", p )
		end		
		
	elseif swValue == 25 then
		-- kers
		local kers = GetCarInfo("kers")
		if devName == "SLI-PRO" then
			sliPanel = string.format("  %3d   ", round(kers/1000))
		else
			sliPanel = string.format(" %3d", round(kers/1000))
		end		
		
	elseif swValue == 26 then
		-- kers max 
		local kmx = GetCarInfo("kers_max")
		
	if devName == "SLI-PRO" then
			sliPanel = string.format("  %3d   ", round(kmx/1000))
		else
			sliPanel = string.format(" %3d", round(kmx/1000))
		end			
	elseif swValue == 27 then
		-- drs
		local drs = GetCarInfo("drs")
		if devName == "SLI-PRO" then
			if drs == 1 then
				sliPanel = " ON   " 
			else
				sliPanel = " OFF  "
			end
		else
			if drs == 1 then
				sliPanel = " ON " 
			else
				sliPanel = " OFF"
			end

		end
		
	elseif swValue == 28 then
		-- kers percent
		local kers = GetCarInfo("kers")
		
		if devName == "SLI-PRO" then
			sliPanel = string.format(" %3d    ", round((kers/1000)/4) )
		else
			sliPanel = string.format(" %3d", round((kers/1000)/4) )
		end	
    elseif swValue == 29 then
		-- wheels temp if available
		inf = GetCarInfo("wheel_temp_front_left")
		if inf ~= nil then
			-- if rFactor convert Kelvin to Celsius (see global.lua)
			--if isAppRFactor(sim) then  inf = KtoC(inf) end
		   if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end	
 		end
		
    elseif swValue == 30 then
		inf = GetCarInfo("wheel_temp_front_right")
		if inf ~= nil then
			--if isAppRFactor(sim) then  inf = KtoC(inf) end
		   if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end	
 		end
		
    elseif swValue == 31 then
		inf = GetCarInfo("wheel_temp_rear_left")
		if inf ~= nil then
			--if isAppRFactor(sim) then  inf = KtoC(inf) end
		   if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end	
 		end
		
    elseif swValue == 32 then
		inf = GetCarInfo("wheel_temp_rear_right")
		if inf ~= nil then
			--if isAppRFactor(sim) then  inf = KtoC(inf) end
		   if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end	
 		end
	
  elseif swValue == 33 then
		-- wheels pressure if available
		inf = GetCarInfo("wheel_press_front_left")
		if inf ~= nil then
			-- convert to psi
			if devName == "SLI-PRO" then
				sliPanel = string.format("  %2.1f   ", inf / 6.88)
			else
				sliPanel = string.format(" %2.1f", inf / 6.88)
			end	
 		end
		
    elseif swValue == 34 then
		inf = GetCarInfo("wheel_press_front_right")
		if inf ~= nil then
		    if devName == "SLI-PRO" then
				sliPanel = string.format("  %2.1f   ", inf / 6.88)
			else
				sliPanel = string.format(" %2.1f", inf / 6.88)
			end	
 		end
		
    elseif swValue == 35 then
		inf = GetCarInfo("wheel_press_rear_left")
		if inf ~= nil then
		    if devName == "SLI-PRO" then
				sliPanel = string.format("  %2.1f   ", inf / 6.88)
			else
				sliPanel = string.format(" %2.1f", inf / 6.88)
			end	
 		end
		
    elseif swValue == 36 then
		inf = GetCarInfo("wheel_press_rear_right")
		if inf ~= nil then
		    
			if devName == "SLI-PRO" then
				sliPanel = string.format("  %2.1f   ", inf / 6.88)
			else
				sliPanel = string.format(" %2.1f", inf / 6.88)
			end	
 		end
		
   elseif swValue == 37 then
		-- brakes temp if available
		inf = GetCarInfo("brake_temp_front_left")
		if inf ~= nil then
			--if isAppRFactor(sim) or sim == "GTR2.exe" then  inf = KtoC(inf) end
		    if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end	
 		end
		
    elseif swValue == 38 then
		inf = GetCarInfo("brake_temp_front_right")
		if inf ~= nil then
			--if isAppRFactor(sim) or sim == "GTR2.exe" then  inf = KtoC(inf) end
		    if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end	
 		end
		
    elseif swValue == 39 then
		inf = GetCarInfo("brake_temp_rear_left")
		if inf ~= nil then
			--if isAppRFactor(sim) or sim == "GTR2.exe" then  inf = KtoC(inf) end
		    if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end	
 		end
		
    elseif swValue == 40 then
		inf = GetCarInfo("brake_temp_rear_right")
		if inf ~= nil then
			--if isAppRFactor(sim) or sim == "GTR2.exe" then  inf = KtoC(inf) end
			
			if devName == "SLI-PRO" then
				sliPanel = string.format("  %3.0f   ", inf)
			else
				sliPanel = string.format(" %3.0f", inf)
			end					
		
 		end
		
	elseif swValue == 41 then
		-- time remaining if available
		lpt = GetTimeInfo("time_remaining")
		timeFlag = true
	
	elseif swValue == 42 then
		-- PC system time
		systemFlag = true
		lpt = GetTimeInfo("system_time")
		timeFlag = true
		--diffTimeFlag = true
	elseif swValue == 43 then
		-- time elapsed if available
		lpt = GetTimeInfo("time_total_elapsed")
		timeFlag = true

	elseif swValue == 44 then
		-- last sector 1, 2 and 3
		local sector = GetCarInfo("sector")
		timeFlag = true
		if sector == 1 then
			-- sector 3
			local ls3 = GetTimeInfo("last_sector3")
			lpt = ls3
		elseif sector == 2 then
			local ls1 = GetTimeInfo("last_sector1")
			lpt = ls1
		else
			-- sector 3
			local ls2 = GetTimeInfo("last_sector2") 
			lpt = ls2
		end		

	elseif swValue == 45 then
		-- PIT
		if devName == "SLI-PRO" then
			sliPanel = "  PIt "
		elseif devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1" then
			sliPanel = " P|T"
		else
			sliPanel = " PIt"
		end					
		
	elseif swValue == 46 then
		-- sc
		local sc = GetContextInfo("safety_car_flag")
		if sc then
			if devName == "SLI-PRO" then
				sliPanel = "  SC  "
			else
				sliPanel = " SC "
			end
		else
			sliPanel = "      "
		end
		
	elseif swValue == 47 then
		-- real time delta vs last + last sector diff 1, 2 and 3
		timeFlag = true
		diffTimeFlag = true
		
		lpt = GetDeltaLastTime(false)
		
	elseif swValue == 48 then
		-- real time delta vs best + last sector diff 1, 2 and 3
		
		-- set flags
		timeFlag = true
		diffTimeFlag = true

		lpt = GetDeltaBestTime(false)
			
	elseif swValue == 49 then
		timeFlag = true
		-- current sector
		local sector = GetCarInfo("sector")
		if sector == 1 then
			lpt = GetTimeInfo("sector1")
		elseif sector == 2 then
			lpt = GetTimeInfo("sector2")
		else
			-- sector 3
			lpt = GetTimeInfo("sector3")
		end
		
	elseif swValue == 50 then
		timeFlag = true
		-- best sector 1
		lpt = GetTimeInfo("best_sector1")
		
	elseif swValue == 51 then
		timeFlag = true
		-- best sector 2
		lpt = GetTimeInfo("best_sector2")
		
	elseif swValue == 52 then
		timeFlag = true
		-- last sector 1
		lpt = GetTimeInfo("last_sector1")
		
	elseif swValue == 53 then
		timeFlag = true
		-- last sector 2
		lpt = GetTimeInfo("last_sector2")	
		
	elseif swValue == 54 then
		timeFlag = true
		-- last sector 3
		lpt = GetTimeInfo("last_sector3")	
		
	elseif swValue == 55 then
		timeFlag = true
		-- last sector 3
		lpt = GetTimeInfo("best_sector3")	
		
	elseif swValue == 56 then
		timeFlag = true
		-- current sector 1 (rFactor)
		lpt = GetTimeInfo("sector1")
		
	elseif swValue == 57 then
		timeFlag = true
		-- current sector 2 (rFactor)
		lpt = GetTimeInfo("sector2")	
		
	elseif swValue == 58 then
		timeFlag = true
		-- current sector 3 (rFactor)
		lpt = GetTimeInfo("sector3")	
		
	elseif swValue == 59 then
		-- rfactor real time delta vs last + last sector diff 1, 2 and 3
		timeFlag = true
		diffTimeFlag = true
		lpt = GetDeltaLastTime(true)
		
	elseif swValue == 60 then
		-- rfactor real time delta vs best + last sector diff 1, 2 and 3
		
		-- set flags
		timeFlag = true
		diffTimeFlag = true
			
		lpt = GetDeltaBestTime(true)

	elseif swValue == 61 then
		timeFlag = true
		-- sector (zero based, 0 = sector 1, 1 = sector 2, 2 = sector 3)
		local sector = GetCarInfo("sector")
		if sector == 1 then
			lpt = GetTimeInfo("sector1")
		elseif sector == 2 then
			lpt = GetTimeInfo("sector1") + GetTimeInfo("sector2")
		else
			-- sector 3
			lpt = GetTimeInfo("last_lap_time")
		end
	elseif swValue == 62 then
		timeFlag = true
		-- sector (zero based, 0 = sector 1, 1 = sector 2, 2 = sector 3)
		local sector = GetCarInfo("sector")
		if sector == 1 then
			lpt = GetTimeInfo("last_sector1")
		elseif sector == 2 then
			lpt = GetTimeInfo("last_sector1") + GetTimeInfo("last_sector2")
		else
			-- sector 3
			lpt = GetTimeInfo("last_lap_time")
		end
		
	elseif swValue == 63 then
		-- ultimate best lap time
		timeFlag =  true
		local bs1 = GetTimeInfo("best_sector1")
		local ls1 = GetTimeInfo("last_sector1")
		if ls1 < bs1 then s1 = ls1 else s1 = bs1 end

		local bs2 = GetTimeInfo("best_sector2")
		local ls2 = GetTimeInfo("last_sector2")
		if ls2 < bs2 then s2 = ls2 else s2 = bs2 end

		local bs3 = GetTimeInfo("best_sector3")
		local ls3 = GetTimeInfo("last_sector3")
		if ls3 < bs3 then s3 = ls3 else s3 = bs3 end
		lpt = s1 + s2 + s3
		
	elseif swValue == 64 then
		-- utimate best sector 1
		timeFlag = true
		local bs = GetTimeInfo("sector1")
		if mUltimate_best_sector1 == nil or bs <  mUltimate_best_sector1 then mUltimate_best_sector1 = bs end
		lpt = mUltimate_best_sector1
		
	elseif swValue == 65 then
		-- utimate best sector 2
		timeFlag = true
		local bs = GetTimeInfo("sector2")
		if mUltimate_best_sector2 == nil or bs <  mUltimate_best_sector2 then mUltimate_best_sector2 = bs end
		lpt = mUltimate_best_sector2
		
	elseif swValue == 66 then
		-- utimate best sector 3
		timeFlag = true
		local bs = GetTimeInfo("sector3")
		if mUltimate_best_sector3 == nil or bs <  mUltimate_best_sector3 then mUltimate_best_sector3 = bs end
		lpt = mUltimate_best_sector3
		
	elseif swValue == 67 then
		-- clear
		if devName == "SLI-PRO" then
			sliPanel = " CLEAR"
		else
			sliPanel = " CLR"
		end				
		
	elseif swValue == 68 then
		-- engine map
		if devName == "SLI-PRO" then
			sliPanel = "  MAP "
		else
			sliPanel = " MAP"
		end			
		
	elseif swValue == 69 then
		-- engine
		if devName == "SLI-PRO" then
			sliPanel = "  ENG "
		else
			sliPanel = " ENG"
		end	
		
	elseif swValue == 70 then
		-- engine stop
		if devName == "SLI-PRO" then
			sliPanel = " StOP "
		elseif devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1" then
			sliPanel = "STOP"
		else
			sliPanel = "StOP"
		end	
		
	elseif swValue == 71 then
		-- loading
		if devName == "SLI-PRO" then
			sliPanel = " BOOt "
		elseif devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1"  then
			sliPanel = "BOOT"
		else
			sliPanel = "BOOt"
		end	

	elseif swValue == 72 then
		-- loading
		if devName == "SLI-PRO"  then
			sliPanel = "  IN  "
		else
			sliPanel = " IN "
		end	
	elseif swValue == 73 then
		-- engine start
		if devName == "SLI-PRO"  then
			sliPanel = "  ING "
		else
			sliPanel = " ING"
		end				
		
	elseif swValue == 74 then
		-- engine start
		if devName == "SLI-PRO"  then
			sliPanel = "  ONE "
		else
			sliPanel = " ONE"
		end		
		
	elseif swValue == 75 then
		-- Brake bias
		if devName == "SLI-PRO"  then
			sliPanel = " BBAL "
		else
			sliPanel = "BBAL"
		end	
		
	elseif swValue == 76 then
		-- brake bias
		local bb = GetBrakeBiasState()
		if bb == nil then bb = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %2.1f   ", bb)	
		else
			sliPanel = string.format(" %2.1f", bb)	
		end		

	elseif swValue == 77 then
		-- clutch 
		local ct = GetCarInfo("clutch")
		if ct == nil then ct = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %2.1f   ", ct)	
		else
			sliPanel = string.format(" %2.1f", ct)	
		end		
		
	elseif swValue == 78 then
		-- brake 
		local bb = GetCarInfo("brake")
		if bb == nil then bb = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %2.1f   ", bb)	
		else
			sliPanel = string.format(" %2.1f", bb)	
		end		
		
	elseif swValue == 79 then
		-- throttle 
		local tt = GetCarInfo("throttle")
		if tt == nil then tt = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %2.1f   ", tt)	
		else
			sliPanel = string.format(" %2.1f", tt)	
		end	
	
    elseif swValue == 80 then
		-- KERS BOOST
		if devName == "SLI-PRO"  then
			sliPanel = " BOOSt"
		elseif devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1" then
			sliPanel = "BOST"
		else
			sliPanel = "BOSt"
		end			
    
	elseif swValue == 81 then
		-- KERS BOOST	
		if devName == "SLI-PRO"  then
			sliPanel = "  OSP "
		else		
			sliPanel = " OSP"
		end		
		
	elseif swValue == 82 then
		-- OSP Factor
		local inf = GetContextInfo("osp_factor")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f   ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 83 then
		-- OSP
		if devName == "SLI-PRO"  then
			sliPanel = " FLAG "
		else		
			sliPanel = "FLAG"
		end			
		
	elseif swValue == 84 then
		-- diff_entry
		local inf = GetCarInfo("diff_entry")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f   ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 85 then
		-- diff_entry
		if devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1"  then
			sliPanel = " ENT"
		else		
			sliPanel = " Ent  "
		end
		
	elseif swValue == 86 then
		-- diff_middle
		local inf = GetCarInfo("diff_middle")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 87 then
		-- diff_middle
		if devName == "SLI-PRO"  then
			sliPanel = "  MID "
		else		
			sliPanel = " MID"
		end			
	elseif swValue == 88 then
		-- diff_exit
		local inf = GetCarInfo("diff_exit")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 89 then
		-- diff_exit
		if devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1"  then
			sliPanel = " EXT"
		else		
			sliPanel = " EXt  "
		end	
		
	elseif swValue == 90 then
		-- engine_braking
		local inf = GetCarInfo("engine_braking")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 91 then
		-- engine_braking
		if devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1"  then
			sliPanel = " TRQ"
		else		
			sliPanel = " trQ  "
		end	
		
	elseif swValue == 92 then
		-- engine_power
		local inf = GetCarInfo("engine_power")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 93 then
		-- engine_power
		if devName == "SLI-PRO"  then
			sliPanel = " MODE "
		else		
			sliPanel = "MODE"
		end		
		
	elseif swValue == 94 then
		-- fuel mix
		local inf = GetCarInfo("fuel_mix")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 95 then
		-- fuel mix
		if devName == "SLI-PRO"  then
			sliPanel = "  MIX "
		else		
			sliPanel = " MIX"
		end		
		
	elseif swValue == 96 then
		-- throttle_shaping
		
		local inf = GetCarInfo("throttle_shaping")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			
		

	elseif swValue == 97 then
		-- throttle_shaping
		if devName == "SLI-PRO"  then
			sliPanel = "  PED "
		else
			sliPanel = " PED"
		end		
	
	elseif swValue == 98 then
		-- Antiroll Bar Front
		local inf = GetCarInfo("front_antiroll_bar")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 99 then
		-- Antiroll Bar Front
		if devName == "SLI-PRO"  then
			sliPanel = " ARBF "
		else
			sliPanel = "ARBF"
		end			
	elseif swValue == 100 then
		-- Antiroll Bar Rear
		local inf = GetCarInfo("rear_antiroll_bar")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 101 then
		-- Antiroll Bar Rear
		if devName == "SLI-PRO"  then
			sliPanel = " ARBR "
		else
			sliPanel = "ARBR"
		end		
		
	elseif swValue == 102 then
		-- Left WJ
		local inf = GetCarInfo("left_weight_jacker")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			
	elseif swValue == 103 then
		-- Left WJ
		if devName == "SLI-PRO"  then
			sliPanel = "  WJL "
		else
			sliPanel = " WJL"
		end		
	elseif swValue == 104 then
		-- Right WJ
		local inf = GetCarInfo("right_weight_jacker")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			

	elseif swValue == 105 then
		-- Right WJ
		if devName == "SLI-PRO"  then
			sliPanel = "  WJR "
		else
			sliPanel = " WJR"
		end				
	elseif swValue == 106 then
		-- front flap
		local inf = GetCarInfo("front_flap")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end			
		
	elseif swValue == 107 then
		-- Front flap
		if devName == "SLI-PRO"  then
			sliPanel = " FFLAP"
		else
			sliPanel = "FFLP"
		end			
		
	elseif swValue == 108 then
		-- rear flap
		local inf = GetCarInfo("rear_flap")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f  ", inf)
		else
			sliPanel = string.format(" %3.0f", inf)
		end	
		
	elseif swValue == 109 then
		-- rear flap
		if devName == "SLI-PRO"  then
			sliPanel = " RFLAP"
		else
			sliPanel = "RFLP"
		end
		
	elseif swValue == 110 then
		-- fuel:speed
		if side == 0 and devName == "SLI-PRO" then
			local fuel = GetCarInfo("fuel")
			if fuel ~= nil then
				fuel = GetFuel(fuel, unit)
				if fuel >= 100 then
					sliPanel = string.format("%03d:%3d", round(fuel), spd)
				elseif fuel >= 10 then
					sliPanel = string.format("F%02d:%3d", round(fuel), spd)
				else
					sliPanel = string.format("F%1.1f:%3d", fuel, spd)
				end
			end
		else
			sliPanel = "      "
		end
    elseif swValue == 111 then
		-- position:speed
		if side == 0 and devName == "SLI-PRO" then
			inf = GetContextInfo("position")
			if inf ~= nil then
				if inf >= 100 then
					 sliPanel = string.format("%03d:%3.0f", inf, spd)
				else
					 sliPanel = string.format("P%02d:%3.0f", inf, spd)
				end		   
			end
		else
			sliPanel = "      "
		end
   elseif swValue == 112 then
		-- laps completed:speed
		if side == 0 and devName == "SLI-PRO" then
			inf = GetContextInfo("laps")
			if inf ~= nil then
				-- if more then 99 laps
				if inf >= 100 then
					sliPanel = string.format("%03d:%3.0f", inf, spd)
				else
					sliPanel = string.format("L%02d:%3.0f", inf, spd)
				end
			end
		else
			sliPanel = "      "
		end
    elseif swValue == 113 then
		-- sector:speed
		if side == 0 and devName == "SLI-PRO" then
			inf = GetCarInfo("sector")
			if inf ~= nil then
				-- check if sector > 9
				if inf >9 then
					sliPanel = string.format("S%02d:%3.0f", inf, spd)
				else
					sliPanel = string.format("S%01d :%3.0f", inf, spd)
				end
			end
		else
			sliPanel = "      "
		end
   elseif swValue == 114 then
		-- laps completed:total laps if available
		if side == 0 and devName == "SLI-PRO" then
			inf = GetContextInfo("laps")
			if inf ~= nil then
				local tl = GetContextInfo("laps_count")
				if tl < 1 then  tl = 0 end
				-- if more then 99 laps
				if inf >= 100 or tl >= 100 then
					sliPanel = string.format("%03d:%03d", inf, tl)
				else
					sliPanel = string.format("L%02d:t%02d", inf, tl)
				end
			end
		else
			sliPanel = "      "
		end
	elseif swValue == 115 then
		-- rpm:gear
		if side == 1 and devName == "SLI-PRO" then
			local rpm = GetCarInfo("rpm")
			if rpm == nil then rpm = 0 end
			local gear = GetCarInfo("gear")
			if gear == nil then gear = 0 end
			sliPanel =  string.format("%5d:%d", rpm, gear)
		else
			sliPanel = "      "
		end			
		
	elseif swValue == 116 then
		-- gear
		local inf = GetCarInfo("gear")
		if inf == nil then inf = 0 end
		local v, dot = pre_translated_gear(inf)
		if devName == "SLI-PRO"  then
			sliPanel = string.format(" %2.0d   ", v)
		else
			sliPanel = string.format(" %2.0d ", v)
		end			
	elseif swValue == 117 then
		-- aBS
		local inf = GetCarInfo("abs")
		if inf == nil then inf = 0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format(" %2.0d   ", inf)
		else
			sliPanel = string.format(" %2.0d ", inf)
		end			
	elseif swValue == 118 then
		-- abs
		if devName == "SLI-PRO"  then
			sliPanel = "  ABS "
		else
			sliPanel = " ABS"
		end			
		
	elseif swValue == 119 then
		-- TC
		local inf = GetCarInfo("traction_control")
		if inf == nil then inf = 0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format(" %2.0d   ", inf)
		else
			sliPanel = string.format(" %2.0d ", inf)
		end
		
	elseif swValue == 120 then
		-- TC
		if devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1"  then
			sliPanel = " TC "
		else
			sliPanel = " tc   "
		end			
		
	elseif swValue == 121 then
		-- fuel in kilogram
		local fuel = GetCarInfo("fuel")
		if fuel ~= nil then
			fuel = GetFuelKilogram(fuel)
			
			if devName == "SLI-PRO" then
				if fuel >= 100 then
					sliPanel = string.format(" F%3d  ", round(fuel))
				elseif fuel >= 10 then
					sliPanel = string.format(" F%2d   ", round(fuel))
				else
					sliPanel = string.format(" F%1.1f  ", fuel)
				end
			else
				if fuel >= 100 then
					sliPanel = string.format("F%3d", round(fuel))
				elseif fuel >= 10 then
					sliPanel = string.format(" F%2d", round(fuel))
				else
					sliPanel = string.format(" F%1.1f", fuel)
				end
			end
		end
		
	elseif swValue == 122 then
		-- fuel (Kg):speed
		if side == 0 and devName == "SLI-PRO" then
			local fuel = GetCarInfo("fuel")
			if fuel ~= nil then
				fuel = GetFuelKilogram(fuel)
				if fuel >= 100 then
					sliPanel = string.format("%03d:%3d", round(fuel), spd)
				elseif fuel >= 10 then
					sliPanel = string.format("F%02d:%3d", round(fuel), spd)
				else
					sliPanel = string.format("F%1.1f:%3d", fuel, spd)
				end
			end
		else
			sliPanel = "      "
		end
		
	elseif swValue == 123 then
		-- turbo or boost
		local inf = GetCarInfo("turbo")
		if inf == nil then inf = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %2.2f  ", round(inf/1000))
		else
			sliPanel = string.format("%2.2f", round(inf/1000))
		end			
		
	elseif swValue == 124 then
		-- red zone
		local inf = GetCarInfo("red_zone")
		if devName == "SLI-PRO" then
			sliPanel =  string.format(" %5d", inf)
		else
			local r = inf / 1000.0
			if r < 10.0 then
				sliPanel =  string.format("  %1.1f", r)	
			else
				sliPanel =  string.format(" %2.1f", r)	
			end
		end	
		
	elseif swValue == 125 then
		-- clutch percentage
		local ct = GetCarInfo("clutch")
		if ct == nil then ct = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f   ", round(ct * 100))
		else
			sliPanel = string.format(" %3.0f", round(ct * 100))
		end		
		
	elseif swValue == 126 then
		-- brake percentage
		local bb = GetCarInfo("brake")
		if bb == nil then bb = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f   ", round(bb * 100))	
		else
			sliPanel = string.format(" %3.0f", round(bb * 100))	
		end		
		
	elseif swValue == 127 then
		-- throttle percentage
		local tt = GetCarInfo("throttle")
		if tt == nil then tt = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %3.0f   ", round(tt * 100))	
		else
			sliPanel = string.format(" %3.0f", round(tt * 100))	
		end
		
	elseif swValue == 128 then
		-- fuel per lap
		local lastlapfuel = GetCarInfo("fuel_per_lap")
		if lastlapfuel == nil then lastlapfuel = 0.0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %2.2f  ", lastlapfuel)
		else
			sliPanel = string.format("%2.2f", lastlapfuel)
		end			
		
	elseif swValue == 129 then
		
		-- display delta by default
		timeFlag = true
		diffTimeFlag = true
		lpt = GetTimeInfo("delta_time_vs_last_lap_records")
			
	elseif swValue == 130 then
		
		-- display delta by default
		timeFlag = true
		diffTimeFlag = true
		lpt = GetTimeInfo("delta_time_vs_best_records")

	elseif swValue == 131 then
		-- fuel laps consumption
		local fuel = GetCarInfo("fuel")
		local fueltank = GetCarInfo("fuel_total")
		if fuel ~= nil and fueltank ~= nil then 
			local f = GetFuel(fuel, unit)
			local ft = GetFuel(fueltank, unit)
			local t = fueltank - fuel
			if devName == "SLI-PRO" then
				if t >= 100 then
					sliPanel = string.format(" F%3d  ", round(t))
				elseif t >= 10 then
					sliPanel = string.format(" F%2d   ", round(t))
				else
					sliPanel = string.format(" F%1.1f  ", t)
				end
			else
				if t >= 100 then
					sliPanel = string.format("F%3d", round(t))
				elseif t >= 10 then
					sliPanel = string.format(" F%2d", round(t))
				else
					sliPanel = string.format(" F%1.1f", t)
				end
			end
		end

	elseif swValue == 132 then
		-- total fuel in tank
		local fueltank = GetCarInfo("fuel_total")
		if fueltank ~= nil then 
			local ft = GetFuel(fueltank, unit)
			if devName == "SLI-PRO" then
				if ft >= 100 then
					sliPanel = string.format(" F%3d  ", round(ft))
				elseif ft >= 10 then
					sliPanel = string.format(" F%2d   ", round(ft))
				else
					sliPanel = string.format(" F%1.1f  ", ft)
				end
			else
				if ft >= 100 then
					sliPanel = string.format("F%3d", round(ft))
				elseif ft >= 10 then
					sliPanel = string.format(" F%2d", round(ft))
				else
					sliPanel = string.format(" F%1.1f", ft)
				end
			end
		end

	elseif swValue == 133 then
		-- bpf
		local inf = GetCarInfo("bpf")
		if inf == nil then inf = 0 end
		if inf > 100 then inf = 100 end
		if inf < 0 then inf = 0 end
		if devName == "SLI-PRO"  then
			sliPanel = string.format("  %2.0f   ", inf)
		else
			sliPanel = string.format(" %2.0f ", inf)
		end				
		
	elseif swValue == 134 then
		-- abs
		if devName == "SLI-PRO"  then
			sliPanel = " BtPt "
		else
			sliPanel = "BtPt"
		end

	elseif swValue == 135 then
		-- abs
		if devName == "SLI-PRO"  then
			sliPanel = " Find "
		else
			sliPanel = "Find"
		end
		
	elseif swValue == 193 then
		-- Mike custom: LAPS COMPLETED SCRIPT INCLUDING CURRENT DECIMAL PLACE LAP
		local lapsCompleted = getLapsCompleteIncludingCurrent()
		
		if lapsCompleted ~= nil then
			sliPanel = string.format("L%2.2f",  round(lapsCompleted, 2))
		end
	
	elseif swValue == 194 then
		-- Mike custom: fuel target.		
		if fuelTarget ~= nil then
			local fuelRemaining = GetCarInfo("fuel")
			local c = ""
			if(fuelTarget >= 0) then
				c = "+"
			end
		
			if firstLapCompleted() and remainingLapsInTank ~= 0 then
				if(fuelTarget >= 10 or fuelTarget <= -10) then
					sliPanel = string.format("%s%2.1f",  c, fuelTarget, 1)
				else
					sliPanel = string.format("T%s%1.1f",  c, fuelTarget, 1)
				end
				isSlowUpdate = true
			else
				if(fuelRemaining <= minFuel) then
					sliPanel = "OUT "
				else
					sliPanel = "NREF"
				end
			end
		else
			sliPanel = "NREF"
		end

	elseif swValue == 195 then
		-- Mike custom: total fuel in tank at start(doesn't reset with flashback in F1)				
		if fuelAtStart ~= nil then 
			local ft = GetFuelKilogram(fuelAtStart)
			if devName == "SLI-PRO" then
				if ft >= 100 then
					sliPanel = string.format(" F%3d  ", round(ft))
				elseif ft >= 10 then
					sliPanel = string.format(" F%2d   ", round(ft))
				else
					sliPanel = string.format(" F%1.1f  ", ft)
				end
			else
				if ft >= 100 then
					sliPanel = string.format("F%3d", round(ft))
				elseif ft >= 10 then
					sliPanel = string.format(" F%2d", round(ft))
				else
					sliPanel = string.format(" F%1.1f", ft)
				end
			end
		else
			sliPanel = "NREF"
		end

	elseif swValue == 196 then
		-- Mike custom: real time diff vs next
		diffTimeFlag = true
		timeFlag = true
		lpt = GetTimeInfo("diff_time_behind_next")
	
	elseif swValue == 197 then
		-- Mike custom: real time diff vs leader
		diffTimeFlag = true
		timeFlag = true
		lpt = GetTimeInfo("diff_time_behind_leader")
		
	elseif swValue == 198 then
		-- Mike custom: fuel laps remaining.		
		local fuelRemaining = GetCarInfo("fuel")
		local remainingLapsInTank = getRemainingLapsInTank(fuelRemaining)

		if remainingLapsInTank > 0 then
			sliPanel = string.format("F%2.2f",  round(remainingLapsInTank, 2))
			isSlowUpdate = true
		elseif remainingLapsInTank == 0 then
			if(fuelRemaining <= minFuel) then
				sliPanel = "OUT "
			else
				sliPanel = "NREF"
			end
		end

	elseif swValue == 199 then
		-- Mike custom: Laps remaining including current (using decimal)
		lapsRemaining = getLapsRemaining()
		
		if lapsRemaining ~= nil then
			sliPanel = string.format("L%2.2f",  round(lapsRemaining, 2))
		end
		
	elseif swValue == 200 then
		-- empty
		sliPanel = "      "	
				
	else
		sliPanel = "      "
	end
	-- check if diff time is ready
	local diffOK = GetTimeInfo("delta_time_enough_records") 
	local isNREF = GetContextInfo("display_nref_allowed") 
	if isNREF and diffTimeFlag and diffOK == false and dlt == false then
		diffTimeFlag = false
		timeFlag = false
		if devName == "SIMRACE-F1" or devName == "SIMRACE-GT" or devName == "SLI-F1" then
			sliPanel = "NREF"
		elseif devName == "SLI-PRO" then
			sliPanel = " nrEF "
		else
			sliPanel = "nrEF"
		end
			
	end

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
			if GetTicks() > ( refreshRate  + mDeltaTimeOldTicks ) then
				mDeltaTimeOldTicks = GetTicks()
				mSRF1LeftText = sliPanel
			end
		else
			if GetTicks() > ( refreshRate  + mDeltaTimeAlternateOldTicks ) then
				mDeltaTimeAlternateOldTicks  = GetTicks()
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

	return 1
end