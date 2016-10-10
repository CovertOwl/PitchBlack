require 'Libs/Utility/generic'
require 'Libs/Utility/logger'
require 'Libs/PitchBlack/Biters'

--Global data table to be used when a new cycle begins or when no cycle exists
DefaultGlobalData = {
	DefaultState = 
	{
		--Total number of cycles completed
		CyclesComplete = 0,
		--Total number of days completed
		TotalDays = 0,
		
		--Elapsed days for the cycle
		Day = 0,
		--Elapsed seconds for the day
		Second = 0,
		--Elapsed ticks for the second
		Tick = 0,

		--Values that will be used to alter the game state
		GameStateModifiers =
		{
			Brightness = 0
		}
	},
	
	--Some meta
	name = 'HelloWorld',
	title = 'Hello World',
	modVersion = '0.0.3',
	
	--Current & Previous DefaultGlobalData.DefaultState
	PreviousState = nil,
	CurrentState = nil,
	
	--Number of real seconds in a game day, 10 minutes
	DayLength = 600
}

Main = 
{
	On_Tick = function(self)
		--Transition simple state
		global.Data.PreviousState = DeepCopy(global.Data.CurrentState)
		global.Data.CurrentState = DeepCopy(DefaultGlobalData.DefaultState)
		
		--Update mod
		Time.Tick(deltaSeconds, lobal.Data.CurrentState, global.Data.PreviousState)
		Biters.Tick(deltaSeconds, lobal.Data.CurrentState, global.Data.PreviousState)
		
		--Commit update to game state
	end,

	On_Configuration_Changed = function(self, data)
		selft.InitWorld()
	end,
	
	On_Init = function(self)
		self.InitWorld()
	end,
	
	--Run on first load of mod or when version changes
	InitWorld = function(self)		
		game.map_settings.pollution.ageing = 0.75
		game.surfaces[1].freeze_daytime(true)
	
		--Look for existing data, if none... swap it over
		if global.Data == nil then		
			global.Data = self.GetNewGlobalData()
			
			logDebug('Missing current global data, using default "' .. global.Data.name 
						.. 'v' .. global.Data.version .. '".')
		else
			logDebug('Current global data already exists! -  "' .. global.Data.name 
						.. 'v' .. global.Data.version .. '".')
		end
	end,
	
	--Init a new global data
	GetNewGlobalData = function(self)
		local newGlobalData = DeepCopy(DefaultGlobalData)
		newGlobalData.CurrentState = DeepCopy(DefaultGlobalData.DefaultState)
		
		return newGlobalData
	end
}