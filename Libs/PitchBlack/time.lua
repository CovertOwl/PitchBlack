require 'Libs/Utility/logger'

--PHASE or TIME PHASE =  (day, dusk, night etc)

Time = 
{
	--The default state of time
	DefaultState = 
	{		
		--The index of the current phase of time
		PhaseIndex = 0,
	
		--How long the phase will last, in game days
		PhaseDuration = 0,
		
		--How long the phase has left until it finishes, in game days
		PhaseRemainingDuration = 0,
		
		--The current copy of the time phase data
		PhaseConfig = nil,
		
		--The phase config variable data index
		PhaseVarDataIndex = 0,
		
		--Whether the current phase is considered daytime (true), otherwise night (false)
		IsDay = false,
		
		--If this is not a transition phase (day, night) this is the brightness for the phase
		Brightness = 0,
		
		--If this is a transition phase (dawn, dusk) these are the brightness values to lerp between
		--Brightness at the start of the phase
		StartBrightness = 0,
		--Brightness at the end of the phase
		EndBrightness = 0,
	}
	
	--Cycle config for day
	DayPhaseConfig = 
	{
		--Is this phase considered day?
		IsDay = true,
		
		--Is this a transition phase?
		IsTransition = false,
		
		--Message(s) that appear for all players
		Warnings = {}
	
		--Data that has conditions that need to be met to be valid, such as cycles complete
		VariableData = 
		{
			{CyclesComplete = 0, MinLength = 17, MaxLength = 17, MinBrightness = 1, MaxBrightness = 1},
			{CyclesComplete = 1, MinLength = 15, MaxLength = 17, MinBrightness = 1, MaxBrightness = 1},
			{CyclesComplete = 4, MinLength = 14, MaxLength = 18, MinBrightness = 1, MaxBrightness = 1}
		}
	},
	
	--Cycle config for dusk
	DuskPhaseConfig = 
	{
		--Is this phase considered day?
		IsDay = true,
		
		--Is this a transition phase?
		IsTransition = true,
		
		--Message(s) that appear for all players
		Warnings = {'The sun is beggining to set!'}
	
		--Data that has conditions that need to be met to be valid, such as cycles complete
		VariableData = 
		{
			{CyclesComplete = 0, MinLength = 1, MaxLength = 1}
		}
	},
	
	--Cycle config for night
	NightPhaseConfig = 
	{
		--Is this phase considered day?
		IsDay = false,
		
		--Is this a transition phase?
		IsTransition = false,
		
		--Message(s) that appear for all players
		Warnings = {'Night has begun!'}
	
		--Data that has conditions that need to be met to be valid, such as cycles complete
		VariableData = 
		{
			{CyclesComplete = 0, MinLength = 2, MaxLength = 2, MinBrightness = 0.3, MaxBrightness = 0.3},
			{CyclesComplete = 1, MinLength = 3, MaxLength = 3, MinBrightness = 0.2, MaxBrightness = 0.3},
			{CyclesComplete = 2, MinLength = 4, MaxLength = 4, MinBrightness = 0.1, MaxBrightness = 0.2},
			{CyclesComplete = 3, MinLength = 4, MaxLength = 5, MinBrightness = 0.0, MaxBrightness = 0.2},
			{CyclesComplete = 4, MinLength = 4, MaxLength = 6, MinBrightness = 0.0, MaxBrightness = 0.2},
			{CyclesComplete = 5, MinLength = 4, MaxLength = 7, MinBrightness = 0.0, MaxBrightness = 0.2}
		}
	},
	
	--Cycle config for dawn
	DawnPhaseConfig = 
	{
		--Is this phase considered day?
		IsDay = true,
		
		--Is this a transition phase?
		IsTransition = true,
		
		--Message(s) that appear for all players
		Warnings = {'The sun is rising!'}
	
		--Data that has conditions that need to be met to be valid, such as cycles complete
		VariableData = 
		{
			{CyclesComplete = 0, MinLength = 1, MaxLength = 1}
		}
	},
		
	DayPhaseIndex = 1,
	DuskPhaseIndex = 2,
	NightPhaseIndex = 3,
	DawnPhaseIndex = 4,
		
	--CyclesComplete = 0,
	----Total number of days completed
	--TotalDays = 0,
	--
	----Elapsed days for the cycle
	--Day = 0,
	----Elapsed seconds for the day
	--Second = 0
	
	prev state?
	--Called when the mod changes/is added for first time
	Init = function(self, globalState, config)
		if globalState.TimeState == nil then
			globalState.TimeState = DeepCopy(Time.DefaultState)
			StartDay(globalState, config)
		end
	end
	
	rename currentstate and previousState
	
	This is what happens when you need to do a commit on the train before you enter the tunnel on the way to work
	
	--Called on every phase after it begins
	InitPhase = function(self, currentState, previousState, config)	
		local currentTimeState = currentState.TimeState
		
		TimeState.PhaseVarDataIndex = Self.GetPhaseVariableDataIndex(currentState, Time.DayPhaseConfig, config)
		
		local phaseVarData = TimeState.PhaseConfig.VariableData[TimeState.PhaseVarDataIndex]
		
		currentTimeState.IsDay = phaseVarData.IsDay
		local minPhaseDuration = phaseVarData.MinLength
		local maxPhaseDuration = phaseVarData.MaxLength
		
		currentTimeState.PhaseDuration = math.random(minPhaseDuration, maxPhaseDuration)
		currentTimeState.PhaseRemainingDuration = currentTimeState.PhaseDuration
		
		if currentTimeState.IsTransition == true then
			currentTimeState.StartBrightness = previousState.TimeState.Brightness
		end
	end
	
	GetPhaseVariableDataIndex = function(self, globalState, phase, config)
		local variableDataIndex = 0		
		
		for index, phaseVariableDataIter in ipairs(phase.VariableData) do
			if phaseVariableDataIter.CyclesComplete <= globalState.CyclesComplete then
				variableDataIndex = index
				break
			end
		end
		
		return variableDataIndex
	end	
	
	StartDay = function(self, currentState, previousState, config)
		local timeState = currentState.TimeState
		timeState.PhaseIndex = Time.DayPhaseIndex
		timeState.PhaseConfig = Time.DayPhaseConfig
		
		Self.InitPhase(currentState, previousState, Time.DayPhaseConfig, config)
	end
	
	--Called each mod tick (every 1 sec)
	Tick = function(self, currentState, previousState, config)
		if currentState.Second + 1 > config.DayLength then
			self.TransitionDay(currentState, previousState, config)
		else
			currentState.Second = currentState.Second + 1
		end
		
		
	end
	
	TransitionDay = function(self, currentState, previousState, config)
		currentState.Second = 0
		currentState.TotalDays = currentState.TotalDays + 1
	
		if currentState.Day + 1 > currentState.Time.
			--self.TransitionDay(currentState, previousState, config)
		else
			currentState.Day = currentState.Day + 1
		end
	end
}