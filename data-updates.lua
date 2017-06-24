require 'Libs/Utility/math'

--Increase all pollution
for _, prototype_type in pairs(data.raw) do
    for _, prototype in pairs(prototype_type) do
        if prototype.energy_source then
            if prototype.energy_source.emissions and prototype.energy_source.emissions > 0.001 then
                prototype.energy_source.emissions = prototype.energy_source.emissions * 10
            end
        end

        --Manually buff powerrr as night is more painful
        if prototype.type == "solar-panel" then
            local stringMetric = string.sub(prototype.production, string.len(prototype.production) - 2)
            local stringVal = string.sub(prototype.production, 0, string.len(prototype.production) - 2)
            local numericalVal = tonumber(stringVal)
            numericalVal = (numericalVal * 3) / 10

            prototype.production = numericalVal .. stringMetric
        end
    end
end

local EnemyHealthScale = settings.startup["pitch-EnemyHealthScale"].value
local EnemySwarmScale = settings.startup["pitch-EnemySwarmScale"].value

--Spawners spawn more and more frequently
for _, prototype in pairs(data.raw["unit-spawner"]) do
    prototype.max_count_of_owned_units = math.ceil(6 * EnemySwarmScale)
    prototype.max_friends_around_to_spawn = math.ceil(8 * EnemySwarmScale)
end

--Biters have more HP and join the attack more rapidly if you're polluting too much
data.raw["unit"]["small-biter"].pollution_to_join_attack = math.ceil(133 * (1.0 / EnemySwarmScale))			--Default 200
data.raw["unit"]["small-biter"].max_health = math.ceil(10 * EnemyHealthScale)								--Default 15
data.raw["unit"]["medium-biter"].pollution_to_join_attack = math.ceil(666 * (1.0 / EnemySwarmScale))			--Default 1000
data.raw["unit"]["medium-biter"].max_health = math.ceil(50 * EnemyHealthScale)								--Default 75
data.raw["unit"]["big-biter"].pollution_to_join_attack = math.ceil(2666 * (1.0 / EnemySwarmScale))			--Default 4000
data.raw["unit"]["big-biter"].max_health = math.ceil(500 * EnemyHealthScale)									--Default 375
data.raw["unit"]["behemoth-biter"].pollution_to_join_attack = math.ceil(6650 * (1.0 / EnemySwarmScale))		--Default 20000
data.raw["unit"]["behemoth-biter"].max_health = math.ceil(2500 * EnemyHealthScale)							--Default 3000
data.raw["unit"]["small-spitter"].pollution_to_join_attack = math.ceil(133 * (1.0 / EnemySwarmScale))		--Default 200
data.raw["unit"]["small-spitter"].max_health = math.ceil(8 * EnemyHealthScale)								--Default 10
data.raw["unit"]["medium-spitter"].pollution_to_join_attack = math.ceil(665 * (1.0 / EnemySwarmScale))		--Default 600
data.raw["unit"]["medium-spitter"].max_health = math.ceil(37 * EnemyHealthScale)								--Default 50
data.raw["unit"]["big-spitter"].pollution_to_join_attack = math.ceil(2666 * (1.0 / EnemySwarmScale))			--Default 1500
data.raw["unit"]["big-spitter"].max_health = math.ceil(375 * EnemyHealthScale)								--Default 200
data.raw["unit"]["behemoth-spitter"].pollution_to_join_attack = math.ceil(6650 * (1.0 / EnemySwarmScale))	--Default 10000
data.raw["unit"]["behemoth-spitter"].max_health = math.ceil(2000 * EnemyHealthScale)							--Default 2000

if settings.startup["pitch-disableSmoke"].value then
    --    data.raw['utility-sounds']['default']['alert_damage'] = {
    --        {
    --            filename = '__Pitch_Black__/scream.ogg'
    --        }
    --    }
    --local spitters = {'small-biter', 'medium-biter', 'big-biter', 'behemoth-biter', 'small-spitter', 'medium-spitter', 'big-spitter', 'behemoth-spitter'}
    --for _, biter in pairs(spitters) do
    --    if data.raw.unit[biter] then
    --        data.raw.unit[biter].dying_sound[1].filename = '__Pitch_Black__/scream.ogg'
    --        data.raw.unit[biter].dying_sound[1].volume = 1
    --        log(serpent.block(data.raw.unit[biter].attack_parameters.sound))
    --    end
    --end
    data.raw.stream["flamethrower-fire-stream"].smoke_sources = nil
    data.raw.fire["fire-flame"].on_fuel_added_action = nil
    data.raw.fire["fire-flame"].smoke = nil
    data.raw.fire["fire-flame-on-tree"].smoke = nil
end

data.raw["utility-sounds"]["default"]["game_lost"] =
    {
        {
            filename = '__Pitch_Black__/scream.ogg'
        }
    }
