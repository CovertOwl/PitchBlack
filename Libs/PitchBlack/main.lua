require 'Libs/Utility/generic'
require 'Libs/Utility/logger'
--require 'Libs/PitchBlack/biters'
require 'Libs/PitchBlack/time'

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
		Second = 0
	},
	
	Config = 
	{
		--Number of real seconds in a game day, 10 minutes
		DayLength = 2
	},
	
	--Some meta
	Name = 'HelloWorld',
	Title = 'Hello World',
	Version = '0.0.3',
	
	--Total elapsed ticks for the current second
	ElapsedTicksOfSecond = 0,
	
	--Total elapsed ticks
	TotalElapsedTicks = 0,
	
	--Current & Previous DefaultGlobalData.DefaultState
	PreviousState = nil,
	CurrentState = nil
}

Main = {}

function Main.On_Tick(self)
	global.Data.ElapsedTicksOfSecond = global.Data.ElapsedTicksOfSecond + 1
	global.Data.TotalElapsedTicks = global.Data.TotalElapsedTicks + 1

	if global.Data.ElapsedTicksOfSecond >= 60 then
		LogDebug('Start Main Tick')
		global.Data.ElapsedTicksOfSecond = 0
	
		--Transition simple state
		global.Data.PreviousState = DeepCopy(global.Data.CurrentState)
		
		--Update mod
		Time:Tick(global.Data.CurrentState, global.Data.PreviousState, global.Data.Config)
		--Biters:Tick(global.Data.CurrentState, global.Data.PreviousState, global.Data.Config)
		
		--Commit update to game state
		LogDebug('End Main Tick')
	end
end

function Main.On_Configuration_Changed(self, data)
	self:InitWorld()
end

function Main.On_Init(self)
	self:InitWorld()
end

--Run on first load of mod or when version changes
function Main.InitWorld(self)	
	game.map_settings.pollution.ageing = 0.75
	game.surfaces[1].freeze_daytime(true)

	--Look for existing data, if none... swap it over
	if global.Data == nil then		
		global.Data = self:GetNewGlobalData()
		
		LogDebug('Missing current global data, using default "' .. global.Data.Name 
					.. 'v' .. global.Data.Version .. '".')
	else
		LogDebug('Current global data already exists! -  "' .. global.Data.Name 
					.. 'v' .. global.Data.Version .. '".')
	end
	
	--Init other modules
	Time:Init(global.Data.CurrentState, global.Data.Config)
	--Biters:Init(global.Data.CurrentState, global.Data.Config)
	
	LogDebug('Main.InitWorld()')
end

--Init a new global data
function Main.GetNewGlobalData(self)
	local newGlobalData = DeepCopy(DefaultGlobalData)
	newGlobalData.CurrentState = DeepCopy(DefaultGlobalData.DefaultState)
	
	return newGlobalData
end