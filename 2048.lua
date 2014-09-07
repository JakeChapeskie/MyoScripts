scriptId = 'com.thalmic.2048'
--Jake Chapeskie
--Commands
--Move up down left and right to move
--"thumbToPinky" toggle unlock
--"fist" to reset zero/dead zone

PITCH_MOTION_THRESHOLD = 6 -- degrees
YAW_MOTION_THRESHOLD = 6-- degrees

--Helper Functions
function getMyoYawDegrees()
	local yawValue = math.deg(myo.getYaw())
	return yawValue
end
function getMyoPitchDegrees()
	local PitchValue = math.deg(myo.getPitch())
	return PitchValue
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
--Toggle Unlock Functions
function lock()
    enabled = false
    myo.vibrate("short")
end

function unlock()
	yawReference = getMyoYawDegrees()
	pitchReference = getMyoPitchDegrees()
	rollReference = getMyoRollDegrees()
    enabled = true
    myo.vibrate("short")
    myo.vibrate("short")
end

function onPoseEdge(pose, edge)
	pose=conditionallySwapWave(pose)
	local now = myo.getTimeMilliseconds()
	--Hold to move activation
	if pose == "fist" and enabled then
        --moveActive = edge == "on"
        yawReference = getMyoYawDegrees()
		pitchReference = getMyoPitchDegrees()
		rollReference = getMyoRollDegrees()
        moveSince = now
   	end
	--Other shortcut control
	if edge == "on" then
		if pose == "thumbToPinky" then
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
	if enabled then
        local relativeYaw = degreeDiff(getMyoYawDegrees(), yawReference)
		if math.abs(relativeYaw)> YAW_MOTION_THRESHOLD then
			if moveYawLatch == false then
				if relativeYaw>0 then
					moveLeft()
					moveYawLatch=true
				else
					moveRight()
					moveYawLatch=true
				end	
			end
		else
			moveYawLatch=false
		end
		local relativePitch = degreeDiff(getMyoPitchDegrees(), pitchReference)
		relativePitch=conditionalPitch(relativePitch)
		if math.abs(relativePitch)> PITCH_MOTION_THRESHOLD then
			if movePitchLatch == false then
				if relativePitch>0 then
					moveDown()
					movePitchLatch=true
				else
					moveUp()
					movePitchLatch=true
				end	
			end
		else
			movePitchLatch=false
		end
	end
end

-- Only activate when using Civilization V
function onForegroundWindowChange(app, title)
	enabled = true
	movePitchLatch=false
	movePitchLatch=false
	yawReference = getMyoYawDegrees()
	pitchReference = getMyoPitchDegrees()
	rollReference = getMyoRollDegrees()
	moveSince = now
	
    if string.match(title, "2048") then
		return true
	end
end
