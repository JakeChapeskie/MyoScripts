scriptId = 'com.thalmic.generated'
--TEMPLATE FOR SCRIPT GENERATION, DO NOT MODIFY
--Helper functions
function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

--Control Functions
function waveInAction()
	--myo.debug("WaveIn")
	--PLACEHOLDER:WAVEIN
end
function waveOutAction()
	--myo.debug("WaveOut")
	--PLACEHOLDER:WAVEOUT
end
function fingersSpreadAction()
	--myo.debug("fingersSpread")
	--PLACEHOLDER:FINGERSSPREAD
end
function fistAction()
	--myo.debug("fist")
	--PLACEHOLDER:FIST
end
function thumbToPinkyAction()
	--PLACEHOLDER: thumbToPinky
end
--Toggle Unlock Functions
function lock()
    enabled = false
    myo.vibrate("short")
end

function unlock()
    enabled = true
    myo.vibrate("short")
    myo.vibrate("short")
end

function onPoseEdge(pose, edge)
	pose=conditionallySwapWave(pose)
	local now = myo.getTimeMilliseconds()

	
	if edge == "on" then
		if pose == "waveIn" and enabled then
			waveInAction()
		elseif pose == "waveOut" and enabled then
			waveOutAction()
		elseif pose == "fist" and enabled then
			fistAction()	
		elseif pose == "fingersSpread" and enabled  then
			fingersSpreadAction()
		elseif pose == "thumbToPinky" then
			if enabled then
                lock()
            else
                unlock()
            end
		end
	end
end

-- onPeriodic runs every ~10ms
function onPeriodic()
	
end

-- Only activate when using correct application
function onForegroundWindowChange(app, title)
	enabled = true
    if string.match(title, "PLACEHOLDER:TITLE") then
		return true
	end
end
