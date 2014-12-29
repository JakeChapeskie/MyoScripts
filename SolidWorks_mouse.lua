scriptId = 'com.jakechapeskie.solidworks'
minMyoConnectVersion ='0.8.0'
scriptDetailsUrl = 'https://github.com/JakeChapeskie/MyoScripts'
scriptTitle = 'SolidWorks Connector'

--Commands
--"waveIn" hold to zoom while moving arm
--"waveOut" hold to move while moving arm
--"fingersSpread" hold to rotate
--"doubleTap" toggle unlock
--"fist" hold to left click
--Minimum SDK of Beta8 Required.

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

-- Locking Functions

-- Set how the Myo Armband handles locking
myo.setLockingPolicy("none")

function onLock()
    myo.controlMouse(false)
end

function onUnlock()
    myo.controlMouse(true)
end

function unLatch()
    myo.mouse("center","up")
    myo.mouse("left","up")
    myo.mouse("center","up","shift")
    myo.mouse("center","up","control")
end

function onPoseEdge(pose, edge)
    local now = myo.getTimeMilliseconds()
    
    pose = conditionallySwapWave(pose)
    if pose == "doubleTap" and edge == "on" then
        if myo.isUnlocked() then
            myo.lock()
        else
            myo.unlock("hold") 
        end  
    end

    if edge == "on" and  myo.isUnlocked() then
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
        unLatch()
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
        unLatch()
    end 
end
-- Only activate when using SolidWorks
function onForegroundWindowChange(app, title)
    if string.match(title, "SolidWorks") then
        return true
    end
end
