require 'Libs/Utility/logger'

Biters = {}

Biters.DefaultState =
{	
	--Meta information
	Name = 'BitersState_v1',

	--Increase biter permanent evolution rate by 15% per 10 hours
	PermamnentEvolutionRate = 0.000004,

	--Permanent biter evolution cannot go above this
	MaxPermanentEvolution = 0.3,
	
	--Current permanent biter evolution cannot go above this
	PermanentEvolution = 0,
	
	--The evolution accumulated through the night which is temporary
	TempNightEvolution = 0,
	
	--Remove %2 temporary evolution per minute that accumulated over night (multiplied by brightness)
	TempNightEvolutionDissapateRate = -0.00033,
	
	PhaseState = 
	{
		--The current biter phase data
		CurrentPhase = nil,		
		--The current biter phase variable data
		CurrentPhaseVarData = nil,
	
		--Timer for how long until this phase expires
		RemainingDurationSeconds = 0,
		--How much time the phase is due to last
		TotalDurationSeconds = 0,
		--Evolution % at the beginning of this phase			
		EvolutionStart = 0
	},
	
	CurrentPhaseState = nil
}

Biters.Phases = 
{
	{
		--Some meta information
		Name = 'NightCraze_v1',
		Title = 'Night Craze',
		
		--Text message(s) displayed when swapping to this phase
		StartWarnings = {'The biters having begun swarming the landscape!'},
		--Hint message
		HintWarnings = {'Hitting them now will reduce their strength.', 'However, pollution output is agitating them greatly!'},
		--Text message(s) displayed when repeating this phase
		ContinueWarnings = nil,
		
		VariableData = 
		{
			{
				--Some meta information
				Name = "NightCraze_v1_1", 
				Title = " (Medium Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = -1.0, 
				MaxCyclesComplete = 3,
				Cond_ReqCycleComplete = true,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				Cond_MinEvolution = -1.0,
				Cond_MaxEvolution = 0.3,
				Cond_ReqEvolution = false,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 8min
				MinDuration = 480,					
				--Maximum amount of seconds that need to pass for this phase to expire, 12min
				MaxDuration = 720,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = false,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = 0.1,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = -1.0,
				MaxEvolutionBreak = -1.0,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1.0,
				MaxBrightnessBreak = 0.3,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 1,
				
				--Can this phase start when night begins
				NightStartPhase = true,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 1% per minute
						time_factor = 0.00016,			
						--0.002 default, equates to 5% reduction every 10 spawners killed
						destroy_factor = -0.005,			
						--0.000015 default, double during this phase
						pollution_factor = 0.00003	
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 8, 
						min_player_base_distance = 6,
						min_base_spacing = 5, 
						min_expansion_cooldown = 1200,	--20s
						max_expansion_cooldown = 1800,	--30s
						settler_group_min_size = 4,
						settler_group_max_size = 8
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 3600 * 1,
						max_group_gathering_time = 3600 * 2, 
						max_wait_time_for_late_members = 3600 * 1
					}
				}
			},
			{
				--Some meta information
				Name = "NightCraze_v1_2", 
				Title = " (High Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = 1, 
				MaxCyclesComplete = -1,
				Cond_ReqCycleComplete = false,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = 0.2,
				MaxEvolution = -1.0,
				Cond_ReqEvolution = false,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 8min
				MinDuration = 480,					
				--Maximum amount of seconds that need to pass for this phase to expire, 12min
				MaxDuration = 720,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = {'The biters are more active than usual.'},
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = false,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = 0.1,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = -1.0,
				MaxEvolutionBreak = -1.0,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1,
				MaxBrightnessBreak = 0.3,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 1,
				
				--Can this phase start when night begins
				NightStartPhase = true,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 1% per minute
						time_factor = 0.00016,			
						--0.002 default, equates to 10% reduction every 20 spawners killed
						destroy_factor = -0.005,			
						--0.000015 default, double during this phase
						pollution_factor = 0.00003	
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 12, 
						min_player_base_distance = 3,
						min_base_spacing = 4, 
						min_expansion_cooldown = 600,	--10s
						max_expansion_cooldown = 1200,	--20s
						settler_group_min_size = 7,
						settler_group_max_size = 10
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 3600 * 1,
						max_group_gathering_time = 3600 * 2, 
						max_wait_time_for_late_members = 3600 * 1
					}
				}
			},
			{
				--Some meta information
				Name = "NightCraze_v1_3", 
				Title = " (Very High Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = 2, 
				MaxCyclesComplete = -1,
				Cond_ReqCycleComplete = false,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = 0.4,
				MaxEvolution = -1.0,
				Cond_ReqEvolution = false,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 8min
				MinDuration = 480,					
				--Maximum amount of seconds that need to pass for this phase to expire, 12min
				MaxDuration = 720,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = {'The biters are much more active than usual.'},
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = false,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = 0.1,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = -1.0,
				MaxEvolutionBreak = -1.0,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1,
				MaxBrightnessBreak = 0.2,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 1,
				
				--Can this phase start when night begins
				NightStartPhase = true,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 1.5% per minute
						time_factor = 0.00024,			
						--0.002 default, equates to 5% reduction every 10 spawners killed
						destroy_factor = -0.005,			
						--0.000015 default, double during this phase
						pollution_factor = 0.00003	
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.0, 
						
						max_expansion_distance = 12, 
						min_player_base_distance = 0,
						min_base_spacing = 4, 
						min_expansion_cooldown = 120,	--2s
						max_expansion_cooldown = 180,	--3s
						settler_group_min_size = 10,
						settler_group_max_size = 15
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 3600 * 1,
						max_group_gathering_time = 3600 * 2, 
						max_wait_time_for_late_members = 3600 * 1
					}
				}
			}
		}
	},
	{
		--Some meta information
		Name = 'NightGrowth_v1',
		Title = 'Night Growth',
		
		--Text message(s) displayed when swapping to this phase
		StartWarnings = {'The biter swarm is swelling as the mass around their nests.'},
		--Hint message
		HintWarnings = {'Avoid attacking their nests or you risk provoking a stronger response.', 'Pollution output is agitating them greatly!'},
		--Text message(s) displayed when repeating this phase
		ContinueWarnings = {'The biters continue to mass around their nests.'},
		
		VariableData = 
		{
			{
				--Some meta information
				Name = "NightGrowth_v1_1", 
				Title = " (Medium Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = -1.0, 
				MaxCyclesComplete = -1.0,
				Cond_ReqCycleComplete = false,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = -1.0,
				MaxEvolution = 0.3,
				Cond_ReqEvolution = false,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 8min
				MinDuration = 480,					
				--Maximum amount of seconds that need to pass for this phase to expire, 12min
				MaxDuration = 720,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = true,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = 0.1,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = -1.0,
				MaxEvolutionBreak = 0.3,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1.0,
				MaxBrightnessBreak = 0.3,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 1,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 0.5% per minute
						time_factor = 0.00008,			
						--0.002 default, equates to 5% increase every 10 spawners killed
						destroy_factor = 0.005,			
						--0.000015 default, double during this phase
						pollution_factor = 0.00003	
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 5, 
						min_player_base_distance = 6,
						min_base_spacing = 3, 
						min_expansion_cooldown = 3600 * 7,	--7min
						max_expansion_cooldown = 3600 * 10,	--10min
						settler_group_min_size = 10,
						settler_group_max_size = 15
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 3600 * 3,
						max_group_gathering_time = 3600 * 6, 
						max_wait_time_for_late_members = 1800	--30s
					}
				}
			},
			{
				--Some meta information
				Name = "NightGrowth_v1_2", 
				Title = " (High Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = 1, 
				MaxCyclesComplete = -1,
				Cond_ReqCycleComplete = true,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = 0.2,
				MaxEvolution = -1.0,
				Cond_ReqEvolution = true,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 10min
				MinDuration = 600,					
				--Maximum amount of seconds that need to pass for this phase to expire, 15min
				MaxDuration = 900,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = {'The biters are more active than usual.'},
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = true,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = 0.1,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = -1.0,
				MaxEvolutionBreak = -1.0,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1,
				MaxBrightnessBreak = 0.25,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 1,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 0.5% per minute
						time_factor = 0.00008,			
						--0.002 default, equates to 7.5% increase every 10 spawners killed
						destroy_factor = 0.0075,			
						--0.000015 default, double during this phase
						pollution_factor = 0.00004	
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 5, 
						min_player_base_distance = 4,
						min_base_spacing = 3, 
						min_expansion_cooldown = 3600 * 7,	--7min
						max_expansion_cooldown = 3600 * 10,	--10min
						settler_group_min_size = 10,
						settler_group_max_size = 15
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 3600 * 3,
						max_group_gathering_time = 3600 * 6, 
						max_wait_time_for_late_members = 1800	--30s
					}
				}
			}
		}
	},
	{
		--Some meta information
		Name = 'NightEvolution_v1',
		Title = 'Night Evolution',
		
		--Text message(s) displayed when swapping to this phase
		StartWarnings = {'The biters have begun evolving rapidly!'},
		--Hint message
		HintWarnings = {'Hit them NOW before they grow in strength.'},
		--Text message(s) displayed when repeating this phase
		ContinueWarnings = {'The biters are continueing to evolve rapidly!'},
		
		VariableData = 
		{
			{
				--Some meta information
				Name = "NightEvolution_v1_1", 
				Title = " (High Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = 1, 
				MaxCyclesComplete = -1.0,
				Cond_ReqCycleComplete = true,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = 0.2,
				MaxEvolution = 0.4,
				Cond_ReqEvolution = true,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1,
				MaxBrightness = -1,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 4min
				MinDuration = 240,					
				--Maximum amount of seconds that need to pass for this phase to expire, 6min
				MaxDuration = 360,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = false,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = 0.1,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = 0.15,
				MaxEvolutionBreak = -1,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -0.15,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1,
				MaxBrightnessBreak = 0.2,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 1,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 6% per minute
						time_factor = 0.001,			
						--0.002 default, equates to 5% reduction every 10 spawners killed
						destroy_factor = 0.005,			
						--0.000015 default, double during this phase
						pollution_factor = 0.00002	
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 6, 
						min_player_base_distance = 6,
						min_base_spacing = 4, 
						min_expansion_cooldown = 3600 * 7,	--7min
						max_expansion_cooldown = 3600 * 10,	--10min
						settler_group_min_size = 7,
						settler_group_max_size = 10
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 1200,	--20s
						max_group_gathering_time = 1800, 	--30s
						max_wait_time_for_late_members = 600--10s
					}
				}
			},
			{
				--Some meta information
				Name = "NightEvolution_v1_2", 
				Title = " (Very High Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = 2, 
				MaxCyclesComplete = -1.0,
				Cond_ReqCycleComplete = true,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = 0.4,
				MaxEvolution = -1,
				Cond_ReqEvolution = true,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 5min
				MinDuration = 300,					
				--Maximum amount of seconds that need to pass for this phase to expire, 7min
				MaxDuration = 480,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = false,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = 0.1,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = 0.35,
				MaxEvolutionBreak = -1.0,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -0.2,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1,
				MaxBrightnessBreak = 0.2,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 1,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 9% per minute
						time_factor = 0.0015,			
						--0.002 default, equates to 4% reduction every 10 spawners killed
						destroy_factor = 0.004,			
						--0.000015 default, double during this phase
						pollution_factor = 0.00002	
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 6, 
						min_player_base_distance = 6,
						min_base_spacing = 4, 
						min_expansion_cooldown = 3600 * 7,	--7min
						max_expansion_cooldown = 3600 * 10,	--10min
						settler_group_min_size = 7,
						settler_group_max_size = 10
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 1200,	--20s
						max_group_gathering_time = 1800, 	--30s
						max_wait_time_for_late_members = 600--10s
					}
				}
			}
		}
	},
	{
		--Some meta information
		Name = 'Disorientated_v1',
		Title = 'Disorientated',
		
		--Text message(s) displayed when swapping to this phase
		StartWarnings = {'The biters are disorientated!'},
		--Hint message
		HintWarnings = {'Hit them now while they are weak.'},
		--Text message(s) displayed when repeating this phase
		ContinueWarnings = {'The biters are continueing to flounder.'},
		
		VariableData = 
		{
			{
				--Some meta information
				Name = "Disorientated_v1_1", 
				Title = " (Low Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = -1.0, 
				MaxCyclesComplete = -1.0,
				Cond_ReqCycleComplete = false,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = -1.0,
				MaxEvolution = -1.0,
				Cond_ReqEvolution = false,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 4min
				MinDuration = 240,					
				--Maximum amount of seconds that need to pass for this phase to expire, 6min
				MaxDuration = 360,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = false,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = -1.0,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = -1.0,
				MaxEvolutionBreak = -1.0,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -0.25,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1.0,
				MaxBrightnessBreak = -1.0,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 0.1,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 0,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = true,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 1% per minute
						time_factor = -0.00016,			
						--0.002 default, equates to 3% reduction every 10 spawners killed
						destroy_factor = -0.003,			
						--0.000015 default, double during this phase
						pollution_factor = 0.0	
					},
					
					enemy_expansion = 
					{
						enabled = false,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 6, 
						min_player_base_distance = 8,
						min_base_spacing = 4, 
						min_expansion_cooldown = 3600 * 7,	--7min
						max_expansion_cooldown = 3600 * 10,	--10min
						settler_group_min_size = 3,
						settler_group_max_size = 5
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 1 * 3600,		--1m
						max_group_gathering_time = 2 * 3600, 		--2m
						max_wait_time_for_late_members = 1 * 3600	--1m
					}
				}
			}
		}
	},
	{
		--Some meta information
		Name = 'Dormant_v1',
		Title = 'Dormant',
		
		--Text message(s) displayed when swapping to this phase
		StartWarnings = {'Biter activity has decreased significantly.'},
		--Hint message
		HintWarnings = {'Attacking & polluting them may provoke them.'},
		--Text message(s) displayed when repeating this phase
		ContinueWarnings = {'Biter activity continues to remain very low.'},
		
		VariableData = 
		{
			{
				--Some meta information
				Name = "Dormant_v1_1", 
				Title = " (Very Low Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = -1.0, 
				MaxCyclesComplete = -1.0,
				Cond_ReqCycleComplete = false,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = -1.0,
				MaxEvolution = 0.25,
				Cond_ReqEvolution = true,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 15min
				MinDuration = 900,					
				--Maximum amount of seconds that need to pass for this phase to expire, 20min
				MaxDuration = 1200,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = true,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = -1.0,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = -1.0,
				MaxEvolutionBreak = 0.3,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1.0,
				MaxBrightnessBreak = -1.0,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 1,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 0,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 10% per hour
						time_factor = -0.00003,			
						--0.002 default, equates to 1% increase every 3 spawners killed
						destroy_factor = 0.0033,			
						--0.000015 default, double during this phase
						pollution_factor = 0.000015
					},
					
					enemy_expansion = 
					{
						enabled = false,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 6, 
						min_player_base_distance = 8,
						min_base_spacing = 4, 
						min_expansion_cooldown = 3600 * 7,	--7min
						max_expansion_cooldown = 3600 * 10,	--10min
						settler_group_min_size = 3,
						settler_group_max_size = 5
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 4 * 3600,		--4m
						max_group_gathering_time = 6 * 3600, 		--6m
						max_wait_time_for_late_members = 1 * 3600	--1m
					}
				}
			}
		}
	},
	{
		--Some meta information
		Name = 'Aggitated_v1',
		Title = 'Aggitated',
		
		--Text message(s) displayed when swapping to this phase
		StartWarnings = {'The biters have become aggitated.'},
		--Hint message
		HintWarnings = {'Attacking & polluting them will provoke them.'},
		--Text message(s) displayed when repeating this phase
		ContinueWarnings = {'The biters are aggitated.'},
		
		VariableData = 
		{
			{
				--Some meta information
				Name = "Aggitated_v1_1", 
				Title = " (Low Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = -1.0, 
				MaxCyclesComplete = -1.0,
				Cond_ReqCycleComplete = false,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = 0.25,
				MaxEvolution = 0.45,
				Cond_ReqEvolution = true,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				Cond_ReqBrightness = false,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 10min
				MinDuration = 600,					
				--Maximum amount of seconds that need to pass for this phase to expire, 15min
				MaxDuration = 900,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = true,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = -1.0,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = 0.2,
				MaxEvolutionBreak = 0.5,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1.0,
				MaxBrightnessBreak = -1.0,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 1,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 0,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 10% per hour
						time_factor = -0.00003,			
						--0.002 default, equates to 1% increase every 3 spawners killed
						destroy_factor = 0.0033,			
						--0.000015 default, double during this phase
						pollution_factor = 0.000015
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 6, 
						min_player_base_distance = 8,
						min_base_spacing = 4, 
						min_expansion_cooldown = 3600 * 10,	--10min
						max_expansion_cooldown = 3600 * 15,	--15min
						settler_group_min_size = 3,
						settler_group_max_size = 5
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 2 * 3600,		--4m
						max_group_gathering_time = 3 * 3600, 		--6m
						max_wait_time_for_late_members = 1 * 3600	--1m
					}
				}
			},
			{
				--Some meta information
				Name = "Aggitated_v1_2", 
				Title = " (Low-Medium Activity)",
				
				--Condition for whether this variation is used, if cycles completed between this range it is valid
				MinCyclesComplete = -1.0, 
				MaxCyclesComplete = -1.0,
				
				--Condition for whether this variation is used, if evolution between this range it is valid
				MinEvolution = 0.45,
				MaxEvolution = -1.0,
				
				--Condition for whether this variation is used, if brightness between this range it is valid
				MinBrightness = -1.0,
				MaxBrightness = -1.0,
				
				--Minimum amount of seconds that need to pass for this phase to expire, 10min
				MinDuration = 600,					
				--Maximum amount of seconds that need to pass for this phase to expire, 15min
				MaxDuration = 900,
				
				--Extra messages that pop up when the phase begins
				StartExtraWarnings = nil,
				ContinueExtraWarnings = nil,
				
				--Whether the phase can repeat
				CanRepeat = true,
				
				--How much of the evolution is kept after night (the rest is slowly removed) 
				EvolutionRetainedAfterNight = -1.0,
				
				--Phase expiry condition, if evolution falls out of this range the phase will end
				MinEvolutionBreak = 0.4,
				MaxEvolutionBreak = -1.0,
				
				--Phase expiry condition, if evolution changes by this much from the beginning of the phase
				EvolutionDeltaBreak = -1.0,
				
				--Phase expiry condition, if brightness falls out of this range the phase will end
				MinBrightnessBreak = -1.0,
				MaxBrightnessBreak = -1.0,
				
				--Weighted chance for this phase to occur during the day time
				DayChanceWeight = 1,
				--Weighted chance for this phase to occur during the night time
				NightChanceWeight = 0,
				
				--Can this phase start when night begins
				NightStartPhase = false,
				--Can this phase start when day begins
				DayStartPhase = false,
				
				--See map-settings.lua that ships with Factorio, these settings are applied when the phase begins
				MapSettings = 
				{
					enemy_evolution =
					{					
						enabled = true,
						
						--0.000004 default, equates to 10% per hour
						time_factor = -0.00003,			
						--0.002 default, equates to 1% increase every 3 spawners killed
						destroy_factor = 0.0033,			
						--0.000015 default, double during this phase
						pollution_factor = 0.000015
					},
					
					enemy_expansion = 
					{
						enabled = true,
						
						--0.1 default
						building_coefficient = 0.1, 
						
						max_expansion_distance = 7, 
						min_player_base_distance = 6,
						min_base_spacing = 4, 
						min_expansion_cooldown = 3600 * 9,	--9min
						max_expansion_cooldown = 3600 * 12,	--12min
						settler_group_min_size = 6,
						settler_group_max_size = 8
					},
					
					unit_group = 
					{				
						min_group_gathering_time = 4 * 3600,		--4m
						max_group_gathering_time = 6 * 3600, 		--6m
						max_wait_time_for_late_members = 1 * 3600	--1m
					}
				}
			}
		}
	}
}

--Called when the mod changes/is added for first time
function Biters.Init(self, globalState, config)	
	LogDebug('Biters.Init()')
	
	--Ingame evolution time is silly and doesnt work properly methinks
	game.map_settings.enemy_evolution.time_factor = 0
	
	if globalState.BiterState == nil then
		
		LogDebug('Cycle state does not exist! Starting a new one...')
	
		globalState.BiterState = DeepCopy(Biters.DefaultState)
		self:StartNewPhase(globalState, nil, config)
	end
	
	LogInfo('Starting with Biters - ' .. globalState.BiterState.Name)
	
	LogDebug('Exit Biters.Init()')
end

--Called each mod tick (every 1 sec)
function Biters.Tick(self, currentState, previousState, config)
	LogDebug('Biters.Tick()')

	LogDebug('Permanen-t Evolution: ' .. currentBiterState.PermanentEvolution .. ', TempNightEvolution: ' .. currentBiterState.TempNightEvolution .. ', Phase: ' .. currentBiterPhaseVarData.Name)
	
	self:UpdateEvolution(currentState, previousState, config)
	
	self:UpdatePhase(currentState, previousState, config)
	
	LogDebug('Exit Biters.Tick()')
end

--Called when beginning a new phase
function Biters.StartNewPhase(self, currentState, previousState, config)
	local currentBiterPhase = currentState.BiterState.CurrentPhaseState.CurrentPhase
	local currentBiterPhaseVarData = currentState.BiterState.CurrentPhaseState.CurrentPhaseVarData
	
	local validPhaseData = {}
	local totalPhaseWeight = 0
	
	--Iterate through all phases looking for valid start phases
	for index,biterPhaseIter in ipairs(Biters.Phases) do
		--If phase not active, or active but not same as current iteration, or is same but can repeat
		if currentBiterPhase == nil 
		or currentBiterPhase.Name ~= biterPhaseIter.Name
		or currentBiterPhaseVarData.CanRepeat == true
		then
			local newPhaseVarData = self:GetValidStartPhaseVarData(biterPhaseIter, currentState, previousState, config)
			
			--If valid start phase var data found
			if newPhaseVarData ~= nil then
				--Get phase weight
				local phaseWeight = 0
				if currentState.CycleState.IsDay
					phaseWeight = newPhaseVarData.DayChanceWeight
				else
					phaseWeight = newPhaseVarData.NightChanceWeight
				end
			
				--Insert phase into valid phases table
				table.insert(validPhaseData, {Config = biterPhaseIter, VarData = newPhaseVarData, Weight = phaseWeight})
				
				--Accumulate weight chance
				totalPhaseWeight = totalPhaseWeight + phaseWeight
			end
		end --If phase not active, or active but not same as current iteration, or is same but can repeat
	end --Iterate through all phases looking for valid start phases
	
	local newBiterPhaseIndex = nil
	local currentWeight
	local randWeight = math.random(totalPhaseWeight)
	LogDebug('randWeight ' .. randWeight)
	
	--Pick a phase to start at random
	for index,currentBiterPhase in ipairs(validPhaseData) do
		currentWeightChance = currentWeightChance + currentBiterPhase.Weight
		
		if randWeight <= currentWeightChance then
			newBiterPhaseIndex = index
			break
		end	
	end

	IS INDEX FOUND?
	local currentPhaseState = currentState.Biters.CurrentPhaseState	
	currentPhaseState.CurrentPhase = validPhaseData[newBiterPhaseIndex].Config
	currentPhaseState.CurrentPhaseVarData = validPhaseData[newBiterPhaseIndex].VarData
	
	UPDATE THESE
	
		--Timer for how long until this phase expires
		RemainingDurationSeconds = 0,
		--How much time the phase is due to last
		TotalDurationSeconds = 0,
		--Evolution % at the beginning of this phase			
		EvolutionStart = 0
end

--Update the biter evolution
function Biters.UpdateEvolution(self, currentState, previousState, config)
	LogDebug('Biters.UpdateEvolution()')
	
	local currentBiterState = currentState.BiterState
	local currentBiterPhaseState = currentBiterState.CurrentPhaseState
	local currentBiterPhase = currentBiterPhaseState.CurrentPhase
	local currentBiterPhaseVarData = currentBiterPhaseState.CurrentPhaseVarData
	
	--Update permanent evolution
	currentBiterState.PermanentEvolution = math.Min(currentBiterState.MaxPermanentEvolution, currentBiterState.PermanentEvolution + currentBiterState.PermamnentEvolutionRate)
	
	local evolutionDelta = 0
	
	--Update temporary evolution
	if currentBiterState.TempNightEvolution > 0 then	
		local currentCycleState = currentState.CycleState
		
		if currentCycleState.IsDay then
			local dissapateRate = currentCycleState.Brightness * currentBiterState.TempNightEvolutionDissapateRate
			
			local newTempNightEvolution = math.max(0, TempNightEvolution + dissapateRate)
			
			evolutionDelta = evolutionDelta + (TempNightEvolution - newTempNightEvolution)
			
			TempNightEvolution = newTempNightEvolution
		end
	end
	
	--Update time based evolution
	evolutionDelta = evolutionDelta + currentBiterPhaseVarData.MapSettings.enemy_evolution.time_factor
	
	--Set game evolution
	game.evolution_factor = math.max(game.evolution_factor + evolutionDelta, currentBiterState.PermanentEvolution)
	
	LogDebug('Exit Biters.UpdateEvolution()')
end

--Update biter phase
function Biters.UpdatePhase(self, currentState, previousState, config)

end

--Return a valid phase if biter phase can start given current conditions
function Biters.GetValidStartPhaseVarData(self, biterPhase, currentState, previousState, config)
	local transitionToDay = false
	local transitionToNight = false
	if previousState ~= nil then
		transitionToDay = (previousState.CycleState.IsDay ~= true and currentState.CycleState.IsDay == true)
		transitionToNight = (previousState.CycleState.IsDay == true and currentState.CycleState.IsDay ~= true)
	end

	--Iterate through each var phase data
	for index,biterPhaseVarDataIter in ipairs(biterPhase.VariableData) do
		--Preliminary condition checks for valid phase
		if 		
			--Has chance to start
			(
				(currentState.CycleState.IsDay == true and biterPhaseVarDataIter.DayChanceWeight > 0.0) 
				or (currentState.CycleState.IsDay == false and biterPhaseVarDataIter.NightChanceWeight > 0.0)
			)
			--If day just started and this is a day start phase
			and (transitionToDay == false or biterPhaseVarDataIter.DayStartPhase == true)
			--If night just started and this is a night start phase
			and (transitionToNight == false or biterPhaseVarDataIter.NightStartPhase == true)
			--Phase will not break
			and self:CanPhaseBreak(biterPhaseVarDataIter, currentState, previousState, config) ~= true
		then
			--Check cycle condition
			local cycleConditionActive = biterPhaseVarDataIter.MinCyclesComplete > -1.0 or biterPhaseVarDataIter.MaxCyclesComplete > -1.0
			local cycleCondition = 
				(biterPhaseVarDataIter.MinCyclesComplete <= -1.0 or biterPhaseVarDataIter.MinCyclesComplete <= currentState.CyclesComplete)
				and
				(biterPhaseVarDataIter.MaxCyclesComplete <= -1.0 or biterPhaseVarDataIter.MaxCyclesComplete >= currentState.CyclesComplete)
			
			--Check evolution condition
			local evolutionConditionActive = biterPhaseVarDataIter.MinEvolution > -1.0 or biterPhaseVarDataIter.MaxEvolution > -1.0
			local evolutionCondition = 
				(biterPhaseVarDataIter.MinEvolution <= -1.0 or biterPhaseVarDataIter.MinEvolution <= game.evolution_factor)
				and
				(biterPhaseVarDataIter.MaxEvolution <= -1.0 or biterPhaseVarDataIter.MaxEvolution >= game.evolution_factor)
				
			--Check brightness condition
			local brightnessConditionActive = biterPhaseVarDataIter.MinBrightness > -1.0 or biterPhaseVarDataIter.MaxBrightness > -1.0
			local brightnessCondition = 
				(biterPhaseVarDataIter.MinBrightness <= -1.0 or biterPhaseVarDataIter.MinBrightness <= currentState.CycleState.Brightness)
				and
				(biterPhaseVarDataIter.MaxBrightness <= -1.0 or biterPhaseVarDataIter.MaxBrightness >= currentState.CycleState.Brightness)
			
			--canStart is true if at least one condition is active and true
			local canStart = 
			(cycleConditionActive == true and cycleCondition == true)
			or (evolutionConditionActive == true and evolutionCondition == true)
			or (brightnessConditionActive == true and brightnessCondition == true)
			
			--If cycle condition active, required and not true then set to can start to false
			if canStart == true and cycleConditionActive == true then
				if cycleCondition == false and biterPhaseVarDataIter.Cond_ReqCycleComplete == true then
					canStart = false
				end
			end
			
			--If evolution condition active, required and not true then set to can start to false
			if canStart == true and evolutionConditionActive == true then
				if evolutionCondition == false and biterPhaseVarDataIter.Cond_ReqEvolution == true then
					canStart = false
				end
			end
			
			--If brightness condition active, required and not true then set to can start to false
			if canStart == true and brightnessConditionActive == true then
				if brightnessCondition == false and biterPhaseVarDataIter.Cond_ReqBrightness == true then
					canStart = false
				end
			end
			
			--Finally, add to table if can start
			if canStart == true then
				return biterPhaseVarDataIter
			end		
		end	--If valid phase found
	end	--Iterate through each var phase data
	
	return nil
end

function Biters.CanPhaseBreak(self, biterPhaseVarData, currentState, previousState, config)

end