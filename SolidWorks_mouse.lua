scriptId = 'com.thalmic.solidworks'

--Commands
--"waveIn" hold to zoom while moving arm
--"waveOut" hold to move while moving arm
--"fingersSpread" hold to rotate
--"thumbToPinky" toggle unlock
--"fist" hold or mak to left click
--Minimum SDK of Beta5 Required.

PITCH_MOTION_THRESHOLD = 7 -- degrees
YAW_MOTION_THRESHOLD = 6 -- degrees
ROLL_MOTION_THRESHOLD = 7 -- degrees
SLOW_MOVE_PERIOD = 50

--Helper Functions
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

--Toggle Unlock Functions
function lock()
    enabled = false
    myo.vibrate("short")
    myo.controlMouse(false)
   -- myo.centerMousePosition()
end

function unlock()
    enabled = true

    myo.controlMouse(true)
    myo.vibrate("short")
    myo.vibrate("short")
end

function onPoseEdge(pose, edge)
    pose=conditionallySwapWave(pose)
    local now = myo.getTimeMilliseconds()
    if edge == "on" then
        if pose == "fist" and enabled then
            myo.mouse("left","down")
        elseif pose == "waveIn" and enabled then
            --zoom 
            myo.mouse("center","down","shift")
        elseif pose == "waveOut" and enabled then
            --move
            myo.mouse("center","down","control")
        elseif pose == "fingersSpread" and enabled  then
            myo.mouse("center","down")
        elseif pose == "thumbToPinky" then
            if enabled then
                lock()
            else
                unlock()
            end
        end
    elseif edge == "off" then
        --This releases any held buttons
        myo.mouse("center","up")
        myo.mouse("left","up")
        myo.mouse("center","up","shift")
        myo.mouse("center","up","control")
    end
end

-- onPeriodic runs every ~10ms
function onPeriodic()
    --empty
end
--When window becomes and releases activation
function onActiveChange(isActive)
    if isActive then
        enabled = true
        myo.controlMouse(true)
    else
        enabled = false
        myo.controlMouse(false)
    end 
end
-- Only activate when using SolidWorks
function onForegroundWindowChange(app, title)
    if string.match(title, "SolidWorks") then
        return true
    end
end
