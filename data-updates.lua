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