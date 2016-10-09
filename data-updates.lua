--Increase all pollution
for key, prototype_type in pairs(data.raw) do
    for name, prototype in pairs(prototype_type) do
        if prototype.energy_source then
            if prototype.energy_source.emissions and prototype.energy_source.emissions > 0.001 then				
                prototype.energy_source.emissions = prototype.energy_source.emissions * 5
            end
        end
    end
end

--Spawners spawn more and more frequently
for _, prototype in pairs(data.raw["unit-spawner"]) do
    prototype.max_count_of_owned_units = 8
    prototype.max_friends_around_to_spawn = 10
	spawning_cooldown = {60, 50}
end

--Biters have more HP and join the attack more rapidly if you're polluting too much
data.raw["unit"]["small-biter"].pollution_to_join_attack = 100		--200
data.raw["unit"]["small-biter"].max_health = 20						--15
data.raw["unit"]["medium-biter"].pollution_to_join_attack = 500		--1000
data.raw["unit"]["medium-biter"].max_health = 100					--75
data.raw["unit"]["big-biter"].pollution_to_join_attack = 2000		--4000			
data.raw["unit"]["big-biter"].max_health = 1000						--375
data.raw["unit"]["behemoth-biter"].pollution_to_join_attack = 5000	--20000
data.raw["unit"]["behemoth-biter"].max_health = 5000				--5000
data.raw["unit"]["small-spitter"].pollution_to_join_attack = 100	--200
data.raw["unit"]["small-spitter"].max_health = 15					--10
data.raw["unit"]["medium-spitter"].pollution_to_join_attack = 500	--600
data.raw["unit"]["medium-spitter"].max_health = 75					--50
data.raw["unit"]["big-spitter"].pollution_to_join_attack = 2000		--1500
data.raw["unit"]["big-spitter"].max_health = 750					--200
data.raw["unit"]["behemoth-spitter"].pollution_to_join_attack = 5000--10000
data.raw["unit"]["behemoth-spitter"].max_health = 4000				--2000