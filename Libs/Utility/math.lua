Math = {}

function Math.Lerp(startVal, endVal, t)
	return (((endVal - startVal) * t) + startVal)
end

function Math.RandomFloat(startVal, EndVal)
	return (math.random() * (EndVal - startVal)) + startVal
end