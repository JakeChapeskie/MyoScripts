scriptId = 'com.thalmic.pointer'
function onForegroundWindowChange(app, title)
	return true
end
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

PITCH_MOTION_THRESHOLD = 7 -- degrees
YAW_MOTION_THRESHOLD = 7 -- degrees

function onPeriodic()

 local now = myo.getTimeMilliseconds()
		if moveActive then
        local relativeYaw = degreeDiff(getMyoYawDegrees(), yawReference)
		if math.abs(relativeYaw)> YAW_MOTION_THRESHOLD then
			if relativeYaw>0 then
				myo.debug("left")
			else
				myo.debug("right")
			end	
		end
		local relativePitch = degreeDiff(getMyoPitchDegrees(), pitchReference)
		if math.abs(relativePitch)> PITCH_MOTION_THRESHOLD then
			myo.debug("ARM dir:"..myo.getXDirection())
			relativePitch=conditionalPitch(relativePitch)
			if relativePitch>0 then
				myo.debug("DOWN")
				
			else
				myo.debug("UP")
			end	
		end
	end
    
end

function activeAppName()
    return activeApp
end

function onActiveChange(isActive)
    if not isActive then
        enabled = false
    end
end

function onPoseEdge(pose, edge)
	local now = myo.getTimeMilliseconds()
	if pose == "fist" or  pose == "thumbToPinky" then
            moveActive = edge == "on"
            yawReference = getMyoYawDegrees()
			pitchReference=getMyoPitchDegrees()
            moveSince = now
            --extendUnlock()
    end
end