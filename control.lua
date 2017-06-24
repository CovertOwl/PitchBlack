require 'Libs/PitchBlack/main'


--On load game for first time
script.on_init(function()
    Main:On_Init()
end)

--On mod version different or if mod did not previously exist
script.on_configuration_changed(function(data)
    Main:On_Configuration_Changed(data)
end)

--Called once per in-game tick
--local smoke = {"fire-smoke", "fire-smoke-without-glow", "soft-fire-smoke"}
--local max = 0
--local triggered = false
script.on_event(defines.events.on_tick, function(event)
    --    local count
    --    for _, name in pairs(smoke) do
    --        count = game.surfaces.nauvis.count_entities_filtered{type="smoke"}
    --        if count > max then max = count end
    --        if count and count > 0 then
    --            if not triggered then triggered = true end
    --            log(string.format("%s: %s", name, count))
    --        end
    --        if count == 0 and triggered then
    --            log("max: " .. max)
    --            triggered = false
    --        end
    --    end
    Main:On_Tick(event)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "pitch-DebugMode" then
        pbLogger.debug_mode = settings.global["pitch-DebugMode"].value
    end
    if event.setting == "pitch-DayLength" then
        Time.DayLength = settings.global["pitch-DayLength"].value
    end
    if event.setting == "pitch-FirstDayPhaseLength" then
        Time.DayPhaseConfig.VariableData[1].MinLength = settings.global["pitch-FirstDayPhaseLength"].value
        Time.DayPhaseConfig.VariableData[1].MaxLength = settings.global["pitch-FirstDayPhaseLength"].value
    end
end)

script.on_event(defines.events.on_player_died, function(event)
    local _, _ = pcall(function()
        local player = game.players[event.player_index]
        player.surface.create_entity({name = "pitch_explosion", position=player.position})
    end)
end)
