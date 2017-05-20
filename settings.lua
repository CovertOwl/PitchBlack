data:extend{
  {
    --Desc: Number of real seconds in a game day
    --Default: 600 (10 minutes)
    --Note: A single day is not necessarily the cycle of the sun... E.G there could be multiple days with the sun up.
    type = "int-setting",
    name = "pitch-DayLength",
    setting_type = "runtime-global",
    default_value = 600,
    minimum_value = 1,
    order = "pitch-a[DayLength]-a"
  },
  {
    --Desc: Number of "days" making up the first phase of daylight.
    --Default: 12 (120 minutes if DayLength = 600)
    --Note: A single day is not necessarily the cycle of the sun... E.G there could be multiple days with the sun up.
    --ValType: Integer
    type = "int-setting",
    name = "pitch-FirstDayPhaseLength",
    setting_type = "runtime-global",
    default_value = 12,
    minimum_value = 1,
    order = "pitch-a[DayLength]-b"
  --default factorio 2
  },
  {
    --Desc: Scalar value for how much the enemy evolves, must be greater than 0.
    --Default: 1 (100%)
    --Note: To make the enemies easier, use a smaller value. To make them harder, use a higher value.
    --ValType: Floating point
    type = "double-setting",
    name = "pitch-ScaleEvolutionRate",
    setting_type = "runtime-global",
    default_value = 1,
    minimum_value = 0.0001,
    order = "pitch-a[ScaleEvolutionRate]-c"
  },
  {
    --Desc: Debug mode, affects things like how verbose logging is to file.
    --Default: false
    type = "bool-setting",
    name = "pitch-DebugMode",
    setting_type = "runtime-global",
    default_value = false,
    order = "pitch-z[Debug]-a"
  },
  {

    --Desc: Scalar value for enemy health, must be greater than 0.
    --Default: 1 (100%)
    --Note: To make the enemies weaker, use a smaller value. To make them tougher, use a higher value.
    type = "double-setting",
    name = "pitch-EnemyHealthScale",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.0001,
    order = "pitch-a[EnemyHealthScale]-a"
  },
  {
    --Desc: Scalar value for how much the enemy spawns, must be greater than 0.
    --Default: 1 (100%)
    --Note: To make the enemies easier, use a smaller value. To make them harder, use a higher value.
    --ValType: Floating point
    EnemySwarmScale = 1.0,
    type = "double-setting",
    name = "pitch-EnemySwarmScale",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.0001,
    order = "pitch-a[EnemySwarmScale]-b"
  }
}
