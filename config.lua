Config = {
	--Desc: Debug mode, affects things like how verbose logging is to file.
	--Default: false
	--ValType: boolean
	DebugMode = false,

	--Desc: Number of real seconds in a game day
	--Default: 600 (10 minutes)
	--Note: A single day is not necessarily the cycle of the sun... E.G there could be multiple days with the sun up.
	--ValType: Integer
	DayLength = 600,
	
	--Desc: Number of "days" making up the first phase of daylight.
	--Default: 12 (120 minutes if DayLength = 600)
	--Note: A single day is not necessarily the cycle of the sun... E.G there could be multiple days with the sun up.
	--ValType: Integer
	FirstDayPhaseLength = 12,
	
	--Desc: Scalar value for enemy health, must be greater than 0.
	--Default: 1 (100%)
	--Note: To make the enemies weaker, use a smaller value. To make them tougher, use a higher value.
	--ValType: Floating point
	EnemyHealthScale = 1.0,
	
	--Desc: Scalar value for how much the enemy spawns, must be greater than 0.
	--Default: 1 (100%)
	--Note: To make the enemies easier, use a smaller value. To make them harder, use a higher value.
	--ValType: Floating point
	EnemySwarmScale = 1.0,
	
	--Desc: Scalar value for how much the enemy evolves, must be greater than 0.
	--Default: 1 (100%)
	--Note: To make the enemies easier, use a smaller value. To make them harder, use a higher value.
	--ValType: Floating point
	ScaleEvolutionRate = 1.0
}