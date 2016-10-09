--Global data table to be used when a new cycle begins or when no cycle exists
DefaultGlobalData = {
	DefaultState = 
	{
		TickNumber = 0,
		
		CyclesComplete = 0,
		DayNumber = 0,

		GameStateModifiers =
		{
			Brightness = 0
		}
	}
	
	--Some meta
	name = 'HelloWorld',
	title = 'Hello World',
	modVersion = '0.0.3',
	
	--Current & Previous DefaultGlobalData.DefaultState
	PreviousState = nil,
	CurrentState = nil,
	
	--Number of real seconds in a game day
	DayLength = 900,
	
	TimePhases = {}
	
	BiterPhases = {}
}

function Main.On_Tick()

end

function Main.On_Configuration_Changed(data)

end

function Main.On_Tick(event)

end