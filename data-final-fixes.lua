--local biters = {'small-biter', 'medium-biter', 'big-biter', 'behemoth-biter'}
--local spitters = {'small-spitter', 'medium-spitter', 'big-spitter', 'behemoth-spitter'}
--
--for _, name in pairs(biters) do
--    log(name)
--    log(serpent.block(data.raw["unit"][name].attack_parameters.ammo_type.action.action_delivery.target_effects.damage.amount))
--    log(serpent.block(data.raw["unit"][name].resistances))
--end
--for _, name in pairs(spitters) do
--    log(name)
--    log(serpent.block(data.raw["unit"][name].attack_parameters.ammo_type))
--    log(serpent.block(data.raw["unit"][name].resistances))
--end
--log(serpent.block(data.raw.projectile["acid-projectile-purple"].action.action_delivery.target_effects[3]))
--log(serpent.block(data.raw.wall["stone-wall"].resistances))
local EnemyHealthScale = settings.startup["pitch-EnemyHealthScale"].value
local EnemySwarmScale = settings.startup["pitch-EnemySwarmScale"].value
local BiterDamageScale = settings.startup["pitch-BiterDamageScale"].value
local SpitterDamageScale = settings.startup["pitch-SpitterDamageScale"].value
local EnemyMovementScale = settings.startup["pitch-EnemyMovementScale"].value

--Spawners spawn more and more frequently
for _, prototype in pairs(data.raw["unit-spawner"]) do
    prototype.max_count_of_owned_units = math.ceil(6 * EnemySwarmScale)
    prototype.max_friends_around_to_spawn = math.ceil(8 * EnemySwarmScale)
end

local biters = {'small-biter', 'medium-biter', 'big-biter', 'behemoth-biter'}
local spitters = {'small-spitter', 'medium-spitter', 'big-spitter', 'behemoth-spitter'}

local resistances = {}
for _, name in pairs(biters) do
    resistances[name] = settings.startup["pitch-" .. name .. "-resistance"].value
end
for _, name in pairs(spitters) do
    resistances[name] = settings.startup["pitch-" .. name .. "-resistance"].value
end

--Biters have more HP and join the attack more rapidly if you're polluting too much
data.raw["unit"]["small-biter"].pollution_to_join_attack = math.ceil(133 * (1.0 / EnemySwarmScale))         --Default 200
data.raw["unit"]["small-biter"].max_health = math.ceil(10 * EnemyHealthScale)                               --Default 15
data.raw["unit"]["medium-biter"].pollution_to_join_attack = math.ceil(666 * (1.0 / EnemySwarmScale))            --Default 1000
data.raw["unit"]["medium-biter"].max_health = math.ceil(50 * EnemyHealthScale)                              --Default 75
data.raw["unit"]["big-biter"].pollution_to_join_attack = math.ceil(2666 * (1.0 / EnemySwarmScale))          --Default 4000
data.raw["unit"]["big-biter"].max_health = math.ceil(500 * EnemyHealthScale)                                    --Default 375
data.raw["unit"]["behemoth-biter"].pollution_to_join_attack = math.ceil(6650 * (1.0 / EnemySwarmScale))     --Default 20000
data.raw["unit"]["behemoth-biter"].max_health = math.ceil(2500 * EnemyHealthScale)                          --Default 3000
data.raw["unit"]["small-spitter"].pollution_to_join_attack = math.ceil(133 * (1.0 / EnemySwarmScale))       --Default 200
data.raw["unit"]["small-spitter"].max_health = math.ceil(8 * EnemyHealthScale)                              --Default 10
data.raw["unit"]["medium-spitter"].pollution_to_join_attack = math.ceil(665 * (1.0 / EnemySwarmScale))      --Default 600
data.raw["unit"]["medium-spitter"].max_health = math.ceil(37 * EnemyHealthScale)                                --Default 50
data.raw["unit"]["big-spitter"].pollution_to_join_attack = math.ceil(2666 * (1.0 / EnemySwarmScale))            --Default 1500
data.raw["unit"]["big-spitter"].max_health = math.ceil(375 * EnemyHealthScale)                              --Default 200
data.raw["unit"]["behemoth-spitter"].pollution_to_join_attack = math.ceil(6650 * (1.0 / EnemySwarmScale))   --Default 10000
data.raw["unit"]["behemoth-spitter"].max_health = math.ceil(2000 * EnemyHealthScale)                            --Default 2000

for _, name in pairs(biters) do
    data.raw["unit"][name].attack_parameters.ammo_type.action.action_delivery.target_effects.damage.amount =
        math.ceil(data.raw["unit"][name].attack_parameters.ammo_type.action.action_delivery.target_effects.damage.amount * BiterDamageScale)
    data.raw["unit"][name].movement_speed = data.raw["unit"][name].movement_speed * EnemyMovementScale
    data.raw["unit"][name].distance_per_frame = data.raw["unit"][name].distance_per_frame * EnemyMovementScale
    if settings.startup["pitch-addResistances"].value then
        if not data.raw["unit"][name].resistances then
            data.raw["unit"][name].resistances = {}
        end
        table.insert(data.raw["unit"][name].resistances, {type = "fire", percent = resistances[name]})
    end
end

log("Pitch Black adjusting spitters")
for _, name in pairs(spitters) do
    log(name .. ':')
    log('Original modifier: ' .. serpent.line(data.raw["unit"][name].attack_parameters.damage_modifier))
    data.raw["unit"][name].attack_parameters.damage_modifier = data.raw["unit"][name].attack_parameters.damage_modifier or 1
    data.raw["unit"][name].attack_parameters.damage_modifier =
        math.ceil(data.raw["unit"][name].attack_parameters.damage_modifier * SpitterDamageScale)
    log('New modifier: ' .. serpent.line(data.raw["unit"][name].attack_parameters.damage_modifier))
    data.raw["unit"][name].movement_speed = data.raw["unit"][name].movement_speed * EnemyMovementScale
    data.raw["unit"][name].distance_per_frame = data.raw["unit"][name].distance_per_frame * EnemyMovementScale
    if settings.startup["pitch-addResistances"].value then
        if not data.raw["unit"][name].resistances then
            data.raw["unit"][name].resistances = {}
        end
        table.insert(data.raw["unit"][name].resistances, {type = "fire", percent = resistances[name]})
    end
end

local speed = math.min(SpitterDamageScale, BiterDamageScale)
if speed ~= 1 then
    data.raw["repair-tool"]["repair-pack"].speed = data.raw["repair-tool"]["repair-pack"].speed * speed * 0.9
    --log(string.format("repair speed: %s", data.raw["repair-tool"]["repair-pack"].speed))
end

if settings.startup["pitch-disableSmoke"].value then
    data.raw.stream["flamethrower-fire-stream"].smoke_sources = nil
    data.raw.fire["fire-flame"].on_fuel_added_action = nil
    data.raw.fire["fire-flame"].smoke = nil
    data.raw.fire["fire-flame-on-tree"].smoke = nil
end

data:extend({
    {
        type = "explosion",
        name = "pitch_explosion",
        flags = {"not-on-map"},
        animations = {
            {
                filename = "__Pitch_Black__/trans1.png",
                priority = "extra-high",
                width = 1,
                height = 1,
                frame_count = 1,
                animation_speed = 0.5
            },
            {
                filename = "__Pitch_Black__/trans1.png",
                priority = "extra-high",
                width = 1,
                height = 1,
                frame_count = 1,
                animation_speed = 0.5
            },
            {
                filename = "__Pitch_Black__/trans1.png",
                priority = "extra-high",
                width = 1,
                height = 1,
                frame_count = 1,
                animation_speed = 0.5
            },
            {
                filename = "__Pitch_Black__/trans1.png",
                priority = "extra-high",
                width = 1,
                height = 1,
                frame_count = 1,
                animation_speed = 0.5
            }
        },
        light = {intensity = 0, size = 20, color = {r=1.0, g=1.0, b=1.0}},
        sound =
        {
            aggregation =
            {
                max_count = 1,
                remove = true
            },
            variations =
            {
                {
                    filename = '__Pitch_Black__/scream.ogg',
                    volume = 1
                }
            }
        }
    }
})
