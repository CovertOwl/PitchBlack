require 'Libs/Utility/logger'

Biters = 
{
	DefaultPhaseState =
	{
		--Timer for how long until this phase expires
		RemainingDurationSeconds = 0,
		--How much time the phase is due to last
		TotalDurationSeconds = 0,
		--Evolution % at the beginning of this phase			
		EvolutionStart = 0,
		--Evolution % at the end of this phase
		EvolutionEnd = nil,
		
		--The current copy of the time phase data
		CurrentPhaseConfig = nil,		
		--The phase config variable data
		CurrentPhaseVarData = nil
	}

	Phases = 
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
					MaxCyclesComplete = -1.0,
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = -1.0,
					MaxEvolution = 0.3,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = 0.1,
					MaxBrightness = 0.25,
					
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
					MaxEvolutionBreak = 0.3,
					
					--Phase expiry condition, if evolution changes by this much from the beginning of the phase
					EvolutionDeltaBreak = -1.0,
					
					--Phase expiry condition, if brightness falls out of this range the phase will end
					MinBrightnessBreak = 0.1,
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
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = 0.2,
					MaxEvolution = -1.0,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = 0.1,
					MaxBrightness = 0.3,
					
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
					MaxBrightnessBreak = 0.25,
					
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
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = 0.4,
					MaxEvolution = -1.0,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = -1,
					MaxBrightness = 0.15,
					
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
							
							--0.000004 default, equates to 1% per minute
							time_factor = 0.00024,			
							--0.002 default, equates to 10% reduction every 20 spawners killed
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
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = -1.0,
					MaxEvolution = 0.3,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = 0.1,
					MaxBrightness = 0.25,
					
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
					MinBrightnessBreak = 0.1,
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
							--0.002 default, equates to 10% reduction every 20 spawners killed
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
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = 0.2,
					MaxEvolution = -1.0,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = 0.0,
					MaxBrightness = 0.3,
					
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
							--0.002 default, equates to 15% reduction every 20 spawners killed
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
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = 0.2,
					MaxEvolution = 0.4,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = -1,
					MaxBrightness = 0.15,
					
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
					MinEvolutionBreak = 0.2,
					MaxEvolutionBreak = -1,
					
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
							--0.002 default, equates to 10% reduction every 20 spawners killed
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
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = 0.4,
					MaxEvolution = -1,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = -1,
					MaxBrightness = 0.15,
					
					--Minimum amount of seconds that need to pass for this phase to expire, 4min
					MinDuration = 300,					
					--Maximum amount of seconds that need to pass for this phase to expire, 6min
					MaxDuration = 420,
					
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
					EvolutionDeltaBreak = -1.0,
					
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
							--0.002 default, equates to 8% reduction every 20 spawners killed
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
			Name = 'DayRetreat_v1',
			Title = 'Day Retreat',
			
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
					Name = "DayRetreat_v1_1", 
					Title = " (Low Activity)",
					
					--Condition for whether this variation is used, if cycles completed between this range it is valid
					MinCyclesComplete = -1.0, 
					MaxCyclesComplete = -1.0,
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = -1.0,
					MaxEvolution = -1.0,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = -1.0,
					MaxBrightness = -1.0,
					
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
					EvolutionDeltaBreak = -0.1,
					
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
							
							--0.000004 default, equates to 6% per minute
							time_factor = -0.000004,			
							--0.002 default, equates to 10% reduction every 20 spawners killed
							destroy_factor = -0.005,			
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
			HintWarnings = {'Attacking them may provoke them.'},
			--Text message(s) displayed when repeating this phase
			ContinueWarnings = {'Biter activity continues to remain very low.'},
			
			VariableData = 
			{
				{
					--Some meta information
					Name = "Dormant_v1_1", 
					Title = " (Low Activity)",
					
					--Condition for whether this variation is used, if cycles completed between this range it is valid
					MinCyclesComplete = -1.0, 
					MaxCyclesComplete = -1.0,
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = -1.0,
					MaxEvolution = 0.25,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = -1.0,
					MaxBrightness = -1.0,
					
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
		
		BUILT ON FROM DORMANT, 2 phases... agitated and very agitated
		{
			--Some meta information
			Name = 'Aggitated_v1',
			Title = 'Aggitated',
			
			--Text message(s) displayed when swapping to this phase
			StartWarnings = {'Biter activity has decreased significantly.'},
			--Hint message
			HintWarnings = {'Attacking them may provoke them.'},
			--Text message(s) displayed when repeating this phase
			ContinueWarnings = {'Biter activity continues to remain very low.'},
			
			VariableData = 
			{
				{
					--Some meta information
					Name = "Dormant_v1_1", 
					Title = " (Low Activity)",
					
					--Condition for whether this variation is used, if cycles completed between this range it is valid
					MinCyclesComplete = -1.0, 
					MaxCyclesComplete = -1.0,
					
					--Condition for whether this variation is used, if evolution between this range it is valid
					MinEvolution = -1.0,
					MaxEvolution = 0.25,
					
					--Condition for whether this variation is used, if brightness between this range it is valid
					MinBrightness = -1.0,
					MaxBrightness = -1.0,
					
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
		}
	},

	Tick = function(self, deltaSeconds, currentState, previousState)
		MAKE IT SO THEIR PHASES HAVE A MIN/MAX BRIGHTNESS & MIN/MAX EVOLUTION condition. Tested every tick, if condition not met change phase
	end
}