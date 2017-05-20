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
script.on_event(defines.events.on_tick, function(event)
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
