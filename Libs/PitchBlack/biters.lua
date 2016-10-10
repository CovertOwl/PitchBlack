require 'Libs/Utility/logger'

Biters = 
{
	Phases = 
	{
		{
			--Some meta information
			name = 'NightStartCraze',
			title = 'Night Craze',
			
			--Text message(s) displayed when swapping to this phase
			StartWarnings = {'Sensing night-time, the biters having begun swarming the landscape!'},
			--Text message(s) displayed when repeating this phase
			ContinueWarnings = {},			
			
			--Values that change throughout this phase's lifetime
			State = 
			{			
				--Timer for how long until this phase expires
				remainingDurationSeconds = 0,
				--How much time the phase is due to last
				totalDurationSeconds = 0,
				--Evolution % at the beginning of this phase			
				evolutionStart = 0,
				--Evolution % at the end of this phase
				evolutionEnd = nil
			},
			
			--Can this phase repeat?
			canRepeat = false,
			
			--Minimum amount of seconds that need to pass for this phase to expire
			minDurationSeconds = 480,	--8min			
			--Maximum amount of seconds that need to pass for this phase to expire
			maxDurationSeconds = 720,	--12min
			
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
					
					--0.000004 default
					time_factor = -0.0001,			
					--0.002 default
					destroy_factor = 0.002,			
					--0.000015 default
					pollution_factor = 0.000015	
				},
				
				enemy_expansion = 
				{
					enabled = true,
					
					--0.1 default
					building_coefficient = 0, 
					
					max_expansion_distance = 12, 
					min_player_base_distance = 0,
					min_base_spacing = 3, 
					min_expansion_cooldown = 180,
					max_expansion_cooldown = 200,
					settler_group_min_size = 10,
					settler_group_max_size = 12
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
			name = 'NightStartCraze',
			title = 'Night Craze',
			
			--Text message(s) displayed when swapping to this phase
			StartWarnings = {'Sensing night-time, the biters having begun swarming the landscape!'},
			--Text message(s) displayed when repeating this phase
			ContinueWarnings = {},			
			
			--Values that change throughout this phase's lifetime
			State = 
			{			
				--Timer for how long until this phase expires
				remainingDurationSeconds = 0,
				--How much time the phase is due to last
				totalDurationSeconds = 0,
				--Evolution % at the beginning of this phase			
				evolutionStart = 0,
				--Evolution % at the end of this phase
				evolutionEnd = nil
			},
			
			--Can this phase repeat?
			canRepeat = false,
			
			--Minimum amount of seconds that need to pass for this phase to expire
			minDurationSeconds = 480,	--8min			
			--Maximum amount of seconds that need to pass for this phase to expire
			maxDurationSeconds = 720,	--12min
			
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
					
					--0.000004 default
					time_factor = -0.0001,			
					--0.002 default
					destroy_factor = 0.002,			
					--0.000015 default
					pollution_factor = 0.000015	
				},
				
				enemy_expansion = 
				{
					enabled = true,
					
					--0.1 default
					building_coefficient = 0, 
					
					max_expansion_distance = 12, 
					min_player_base_distance = 0,
					min_base_spacing = 3, 
					min_expansion_cooldown = 180,
					max_expansion_cooldown = 200,
					settler_group_min_size = 10,
					settler_group_max_size = 12
				},
				
				unit_group = 
				{				
					min_group_gathering_time = 3600 * 1,
					max_group_gathering_time = 3600 * 2, 
					max_wait_time_for_late_members = 3600 * 1
				}
			}
		}
	},

	Tick = function(self, deltaSeconds, currentState, previousState)
	end
}