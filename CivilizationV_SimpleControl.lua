scriptId = 'com.thalmic.CivilizationVCamera'
--Jake Chapeskie
--Commands
--"waveIn" reset to Next Unit
--"waveOut" reset to Previous Unit
--"fingersSpread" Do Nothing
--"thumbToPinky" toggle unlock
--hold fist and move left, right, up and down to move camera/map
--hold fist and turn cw and ccw to zoom
--LOAD SCRIPT BEFORE DOING SETUP GESTURE TO MAKE SURE XPOS WORKS

PITCH_MOTION_THRESHOLD = 5 -- degrees
YAW_MOTION_THRESHOLD = 5 -- degrees
ROLL_MOTION_THRESHOLD = 7 -- degrees
SLOW_MOVE_PERIOD = 50

--Helper Functions
function getMyoYawDegrees()
    local yawValue = math.deg(myo.getYaw())
    return yawValue
end
function getMyoPitchDegrees()
    local PitchValue = math.deg(myo.getPitch())
    return PitchValue
end
function getMyoRollDegrees()
    local RollValue = math.deg(myo.getRoll())
    return RollValue
end
function degreeDiff(value, base)
    local diff = value - base
    if diff > 180 then
        diff = diff - 360
    elseif diff < -180 then
        diff = diff + 360
    end
    return diff
end
function conditionalPitch(pitch)
    if myo.getXDirection()== "towardElbow" then
        pitch=-pitch;
    end
    return pitch
end
function conditionalRoll(roll)
    if myo.getXDirection()== "towardElbow" then
        roll=-roll;
    end
    return roll
end
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
function zoomIn()
    myo.keyboard("equal", "press")
end
function zoomOut()
    myo.keyboard("minus", "press")
end
function moveLeft()
    myo.keyboard("left_arrow", "press")
end
function moveRight()
    myo.keyboard("right_arrow", "press")
end
function moveUp()
    myo.keyboard("up_arrow", "press")
end
function moveDown()
    myo.keyboard("down_arrow", "press")
end
function nextUnit()
    myo.keyboard("period", "press")
end
function prevUnit()
    myo.keyboard("comma", "press")
end
function doNothing()
    myo.keyboard("space", "press")
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
    --Hold to move activation
    if pose == "fist" and enabled then
        moveActive = edge == "on"
        yawReference = getMyoYawDegrees()
        pitchReference = getMyoPitchDegrees()
        rollReference = getMyoRollDegrees()
        moveSince = now
       end
    --Other shortcut control
    if edge == "on" then
        if pose == "waveIn" and enabled then
            nextUnit()
        elseif pose == "waveOut" and enabled then
            prevUnit()
        elseif pose == "fingersSpread" and enabled  then
            doNothing()
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
    local now = myo.getTimeMilliseconds()
    if moveActive then
        local relativeYaw = degreeDiff(getMyoYawDegrees(), yawReference)
        if math.abs(relativeYaw)> YAW_MOTION_THRESHOLD then
            if relativeYaw>0 then
                moveLeft()
            else
                moveRight()
            end    
        end
        local relativePitch = degreeDiff(getMyoPitchDegrees(), pitchReference)
        relativePitch=conditionalPitch(relativePitch)
        if math.abs(relativePitch)> PITCH_MOTION_THRESHOLD then
            if relativePitch>0 then
                moveDown()
            else
                moveUp()
            end    
        end
        local relativeRoll = degreeDiff(getMyoRollDegrees(), rollReference)
        relativeRoll=conditionalRoll(relativeRoll)
        if math.abs(relativeRoll)> ROLL_MOTION_THRESHOLD then
            if relativeRoll>0 then
                zoomIn()
            else
                zoomOut()
            end    
        end        
    end
end

-- Only activate when using Civilization V
function onForegroundWindowChange(app, title)
    enabled = true
    if string.match(title, "Civilization V") then
        return true
    end
end
