require 'Libs/PitchBlack/main'

--On load game for first time
script.on_init(function(data)
	Main.On_Init() 
end)

--On mod version different or if mod did not previously exist
script.on_configuration_changed(function(data)
	Main.On_Configuration_Changed(data)
end)

--Called once per in-game tick
script.on_event(defines.events.on_tick, function(event)
	Main.On_Tick(event)
end)