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
local EnemyHealthScale = 1
local EnemySwarmScale =  1
local BiterDamageScale = 1
local SpitterDamageScale = 1
local EnemyMovementScale = 1

if not mods["Rampant"] then
    EnemyHealthScale = settings.startup["pitch-EnemyHealthScale"].value
    EnemySwarmScale = settings.startup["pitch-EnemySwarmScale"].value
    BiterDamageScale = settings.startup["pitch-BiterDamageScale"].value
    SpitterDamageScale = settings.startup["pitch-SpitterDamageScale"].value
    EnemyMovementScale = settings.startup["pitch-EnemyMovementScale"].value
end

--Spawners spawn more and more frequently
for _, prototype in pairs(data.raw["unit-spawner"]) do
    prototype.max_count_of_owned_units = math.ceil(7 * EnemySwarmScale)
    prototype.max_friends_around_to_spawn = math.ceil(5 * EnemySwarmScale)
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

for name, unit in pairs(data.raw["unit"]) do
    if string.find(name, "biter") then
        unit.pollution_to_join_attack = math.ceil(unit.pollution_to_join_attack * (1 / EnemySwarmScale))
        unit.max_health = math.ceil(unit.max_health * EnemyHealthScale)
        if unit.attack_parameters.ammo_type.action.action_delivery then
			if unit.attack_parameters.ammo_type.action.action_delivery.target_effects
			and unit.attack_parameters.ammo_type.action.action_delivery.target_effects.damage then				
				unit.attack_parameters.ammo_type.action.action_delivery.target_effects.damage.amount =
					math.ceil(unit.attack_parameters.ammo_type.action.action_delivery.target_effects.damage.amount * BiterDamageScale)
			end
        elseif unit.attack_parameters.ammo_type.action[1] then
            for _, action in pairs(unit.attack_parameters.ammo_type.action) do
				if action.action_delivery.target_effects.damage then
					action.action_delivery.target_effects.damage.amount = math.ceil(action.action_delivery.target_effects.damage.amount * BiterDamageScale)
				end
            end
        end
        unit.movement_speed = unit.movement_speed * EnemyMovementScale
        unit.distance_per_frame = unit.distance_per_frame * EnemyMovementScale
        if settings.startup["pitch-addResistances"].value and resistances[name] then
            if not unit.resistances then
                unit.resistances = {}
            end
            table.insert(unit.resistances, {type = "fire", percent = resistances[name]})
        end
    end
end

for name, unit in pairs(data.raw["unit"]) do
    if string.find(name, "spitter") then
        unit.attack_parameters.damage_modifier = unit.attack_parameters.damage_modifier or 1
        unit.attack_parameters.damage_modifier =
            math.ceil(unit.attack_parameters.damage_modifier * SpitterDamageScale)
        unit.movement_speed = unit.movement_speed * EnemyMovementScale
        unit.distance_per_frame = unit.distance_per_frame * EnemyMovementScale
        if settings.startup["pitch-addResistances"].value and resistances[name] then
            if not unit.resistances then
                unit.resistances = {}
            end
            table.insert(unit.resistances, {type = "fire", percent = resistances[name]})
        end
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
