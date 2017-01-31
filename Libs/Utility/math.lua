Math = {}

function Math.Lerp(startVal, endVal, t)
	return (((endVal - startVal) * t) + startVal)
end

function Math.Clamp(val, minVal, Max)
	local finalVal = val
	
	if val < minVal then
		val = minVal
	elseif val > maxVal then
		val = maxVal
	end

	return val
end

function Math.RandomFloat(startVal, EndVal)
	return (math.random() * (EndVal - startVal)) + startVal
end