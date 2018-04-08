data:extend{
	{
        --Desc: Max evolution value
        --Default: 100 (100%)
        type = "int-setting",
        name = "pitch-MaxEvolution",
        setting_type = "runtime-global",
        default_value = 100,
        minimum_value = 0,
        order = "pitch-a[MaxEvolution]-a"
    },
	{
        --Desc: Biter expansion scale
        --Default: 100 (100%)
        type = "int-setting",
        name = "pitch-ExpansionScale",
        setting_type = "runtime-global",
        default_value = 100,
        minimum_value = 0,
        maximum_value = 100,
        order = "pitch-a[ExpansionScale]-a"
    },
	{
        --Desc: Biter expansion scale
        --Default: 100 (100%)
        type = "double-setting",
        name = "pitch-ScalePollutionDamage",
        setting_type = "runtime-global",
        default_value = 1.0,
        minimum_value = 0.0,
        maximum_value = 1.0,
        order = "pitch-a[ScalePollutionDamage]-a"
    },
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
        type = "double-setting",
        name = "pitch-BiterDamageModifier",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = -0.9,
        order = "pitch-a[ScaleEvolutionRate]-d"
    },
    {
        type = "double-setting",
        name = "pitch-SpitterDamageModifier",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = -0.9,
        order = "pitch-a[ScaleEvolutionRate]-d"
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
        default_value = 2.75,
        minimum_value = 0.0001,
        order = "pitch-a[EnemyHealthScale]-a"
    },
    {
        --Desc: Scalar value for how much the enemy spawns, must be greater than 0.
        --Default: 1 (100%)
        --Note: To make the enemies easier, use a smaller value. To make them harder, use a higher value.
        --ValType: Floating point
        --EnemySwarmScale = 1.0,
        type = "double-setting",
        name = "pitch-EnemySwarmScale",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 0.0001,
        order = "pitch-a[EnemySwarmScale]-b"
    },
    {
        type = "double-setting",
        name = "pitch-BiterDamageScale",
        setting_type = "startup",
        default_value = 2.5,
        minimum_value = 0.0001,
        order = "pitch-b[BiterDamage]-a"
    },
    {
        type = "double-setting",
        name = "pitch-SpitterDamageScale",
        setting_type = "startup",
        default_value = 2,
        minimum_value = 0.0001,
        order = "pitch-b[SpitterDamage]-b"
    },
    {
        type = "double-setting",
        name = "pitch-EnemyMovementScale",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 0.0001,
        order = "pitch-c[EnemyMovementScale]-c"
    },
    {
        type = "bool-setting",
        name = "pitch-addResistances",
        setting_type = "startup",
        default_value = true,
        order = "pitch-d[addResistances]-a"
    },
    {
        type = "bool-setting",
        name = "pitch-disableSmoke",
        setting_type = "startup",
        default_value = true,
        order = "pitch-z[disableSmoke]-a"
    }
}

local biters = {'small-biter', 'medium-biter', 'big-biter', 'behemoth-biter'}
local spitters = {'small-spitter', 'medium-spitter', 'big-spitter', 'behemoth-spitter'}

for i, name in pairs(biters) do
    data:extend({
        {
            type = "double-setting",
            name = "pitch-" .. name .. "-resistance",
            setting_type = "startup",
            default_value = 10*(i-1) + 5,
            minimum_value = 0,
            order = "pitch-d[addResistances]-a-" .. i
        },
    })
end

for i, name in pairs(spitters) do
    data:extend({
        {
            type = "double-setting",
            name = "pitch-" .. name .. "-resistance",
            setting_type = "startup",
            default_value = 10*(i-1) + 5,
            minimum_value = 0,
            order = "pitch-d[addResistances]-b-" .. i
        },
    })
end
