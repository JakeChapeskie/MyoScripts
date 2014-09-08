scriptId = 'com.thalmic.generated'
--TEMPLATE FOR SCRIPT GENERATION, DO NOT MODIFY
--Helper functions
ENABLED_TIMEOUT = 2200
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
--Unlock Functions
function unlock()
    local now = myo.getTimeMilliseconds()

    if myo.practice then
        myo.notifyEffect("unlock")
    end

    enabled = true
    enabledSince = now
end

function extendUnlock()
    local now = myo.getTimeMilliseconds()

    if myo.practice then
        myo.notifyEffect("extendUnlock")
    end

    enabledSince = now
end


function onPoseEdge(pose, edge)
    pose=conditionallySwapWave(pose)
    local now = myo.getTimeMilliseconds()

    if pose == "thumbToPinky" then
        if edge == "off" then
            unlock()
        elseif edge == "on" and not enabled then
            -- Vibrate twice on unlock
            myo.vibrate("short")
            myo.vibrate("short")
        end
    end
    
    if edge == "on" and enabled then
        if pose == "waveIn" and enabled then
            waveInAction()
            extendUnlock()
        elseif pose == "waveOut" and enabled then
            waveOutAction()
            extendUnlock()
        elseif pose == "fist" and enabled then
            fistAction()    
            extendUnlock()
        elseif pose == "fingersSpread" and enabled  then
            fingersSpreadAction()
            extendUnlock()
        end
    end
end

-- onPeriodic runs every ~10ms
function onPeriodic()
    local now = myo.getTimeMilliseconds()
    if enabled then
        if (now - enabledSince) > ENABLED_TIMEOUT then
            enabled = false
            -- Vibrate once on lock
            myo.vibrate("short")
        end
    end
end

-- Only activate when using correct application
function onForegroundWindowChange(app, title)
    enabled = true
    if string.match(title, "PLACEHOLDER:TITLE") then
        unlock()
        return true
    end
end
