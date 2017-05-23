require 'Libs/Utility/logger'
require 'Libs/Utility/generic'

Biters = {} --luacheck: allow defined top

Biters.DefaultState =
  {
    --Meta information
    Name = 'BitersState_v2',

    --Increase permanent biter by a fixed rate ([#][2]) per second if current biter evolution is below margin ([#][1])
    --2.5 hours to get to 25%
    --another 3.75 hours to get to 50%
    --another 7 hours to get to 75%
    --After that it will stop
    PermamnentEvolutionRates = {{0.25, 0.00003},{0.5,0.00002},{0.75,0.00001},{1.0,0.0}},

    --Current biter evolution cannot go below this
    PermanentEvolution = 0,

    --The evolution accumulated through the night which is temporary
    TempNightEvolution = 0,

    --Remove %2 temporary evolution per minute that accumulated over night (multiplied by brightness)
    TempNightEvolutionDissapateRate = -0.00033,

    CurrentPhaseState =
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
      EvolutionStart = 0,

      Messages = nil
    }
  }

Biters.Phases =
  {
    {
      --Some meta information
      Name = 'NightCraze_v1',
      Title = 'Night Craze',

      --Text message(s) displayed when swapping to this phase
      StartWarnings = {'The biters have begun swarming the landscape!'},
      --Hint message
      HintWarnings = {'Hitting them now will reduce their strength.', 'However, pollution output is agitating them greatly!'},
      --Text message(s) displayed when repeating this phase
      ContinueWarnings = {'The biters continue to swarm the landscape.'},

      VariableData =
      {
        {
          --Some meta information
          Name = "NightCraze_v1_1",
          Title = " (Medium Activity)",

          --Condition for whether this variation is used, if cycles completed between this range it is valid
          Cond_MinCyclesComplete = -1.0,
          Cond_MaxCyclesComplete = 3,
          Cond_ReqCycleComplete = true,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = -1.0,
          Cond_MaxEvolution = 0.3,
          Cond_ReqEvolution = false,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
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
          MaxEvolutionBreak = -1.0,

          --Phase expiry condition, if evolution changes by this much from the beginning of the phase
          EvolutionDeltaBreak = -1.0,

          --Phase expiry condition, if brightness falls out of this range the phase will end
          MinBrightnessBreak = -1.0,
          MaxBrightnessBreak = -1.0,

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
              building_coefficient = 0.0,

              max_expansion_distance = 8,
              min_player_base_distance = 0,
              min_base_spacing = 3,
              min_expansion_cooldown = 600,	--10s
              max_expansion_cooldown = 1200,	--20s
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
          Cond_MinCyclesComplete = 1,
          Cond_MaxCyclesComplete = -1,
          Cond_ReqCycleComplete = false,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = 0.3,
          Cond_MaxEvolution = -1.0,
          Cond_ReqEvolution = false,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
          Cond_ReqBrightness = false,

          --Minimum amount of seconds that need to pass for this phase to expire, 8min
          MinDuration = 480,
          --Maximum amount of seconds that need to pass for this phase to expire, 12min
          MaxDuration = 720,

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
          MaxBrightnessBreak = -1.0,

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
              building_coefficient = 0.0,

              max_expansion_distance = 12,
              min_player_base_distance = 0,
              min_base_spacing = 3,
              min_expansion_cooldown = 120,	--2s
              max_expansion_cooldown = 360,	--6s
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
          Cond_MinCyclesComplete = 2,
          Cond_MaxCyclesComplete = -1,
          Cond_ReqCycleComplete = false,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = 0.5,
          Cond_MaxEvolution = -1.0,
          Cond_ReqEvolution = false,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
          Cond_ReqBrightness = false,

          --Minimum amount of seconds that need to pass for this phase to expire, 8min
          MinDuration = 480,
          --Maximum amount of seconds that need to pass for this phase to expire, 12min
          MaxDuration = 720,

          --Extra messages that pop up when the phase begins
          StartExtraWarnings = {'The biters are much more active than usual.'},
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
          MaxBrightnessBreak = -1.0,

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
              min_base_spacing = 3,
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
      StartWarnings = {'The biter swarm is swelling as they mass around their nests.'},
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
          Cond_MinCyclesComplete = -1.0,
          Cond_MaxCyclesComplete = -1.0,
          Cond_ReqCycleComplete = false,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = -1.0,
          Cond_MaxEvolution = 0.3,
          Cond_ReqEvolution = false,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
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
          MaxBrightnessBreak = -1.0,

          --Weighted chance for this phase to occur during the day time
          DayChanceWeight = 0,
          --Weighted chance for this phase to occur during the night time
          NightChanceWeight = 0.5,

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
              building_coefficient = 0.0,

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
          Cond_MinCyclesComplete = 1,
          Cond_MaxCyclesComplete = -1,
          Cond_ReqCycleComplete = false,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = 0.2,
          Cond_MaxEvolution = -1.0,
          Cond_ReqEvolution = false,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
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
          MaxBrightnessBreak = -1.0,

          --Weighted chance for this phase to occur during the day time
          DayChanceWeight = 0,
          --Weighted chance for this phase to occur during the night time
          NightChanceWeight = 0.5,

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
              building_coefficient = 0.0,

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
          Cond_MinCyclesComplete = 1,
          Cond_MaxCyclesComplete = 3,
          Cond_ReqCycleComplete = true,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = 0.5,
          Cond_MaxEvolution = -1.0,
          Cond_ReqEvolution = true,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1,
          Cond_MaxBrightness = -1,
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
          MaxBrightnessBreak = -1.0,

          --Weighted chance for this phase to occur during the day time
          DayChanceWeight = 0,
          --Weighted chance for this phase to occur during the night time
          NightChanceWeight = 0.25,

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

              --0.000004 default, equates to 3% per minute
              time_factor = 0.0005,
              --0.002 default, equates to 20% reduction every 10 spawners killed
              destroy_factor = -0.02,
              --0.000015 default, double during this phase
              pollution_factor = 0.00002
            },

            enemy_expansion =
            {
              enabled = true,

              --0.1 default
              building_coefficient = 0.0,

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
          Cond_MinCyclesComplete = 3,
          Cond_MaxCyclesComplete = -1.0,
          Cond_ReqCycleComplete = true,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = 0.4,
          Cond_MaxEvolution = -1,
          Cond_ReqEvolution = true,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1,
          Cond_MaxBrightness = -1.0,
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
          MaxBrightnessBreak = -1.0,

          --Weighted chance for this phase to occur during the day time
          DayChanceWeight = 0,
          --Weighted chance for this phase to occur during the night time
          NightChanceWeight = 0.5,

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

              --0.000004 default, equates to 4% per minute
              time_factor = 0.00066,
              --0.002 default, equates to 15% reduction every 10 spawners killed
              destroy_factor = -0.02,
              --0.000015 default, double during this phase
              pollution_factor = 0.00002
            },

            enemy_expansion =
            {
              enabled = true,

              --0.1 default
              building_coefficient = 0.0,

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
          Cond_MinCyclesComplete = -1.0,
          Cond_MaxCyclesComplete = -1.0,
          Cond_ReqCycleComplete = false,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = -1.0,
          Cond_MaxEvolution = -1.0,
          Cond_ReqEvolution = false,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
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
          Cond_MinCyclesComplete = -1.0,
          Cond_MaxCyclesComplete = -1.0,
          Cond_ReqCycleComplete = false,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = -1.0,
          Cond_MaxEvolution = 0.25,
          Cond_ReqEvolution = true,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
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
      HintWarnings = {'Attacking & polluting them will continue to provoke them.'},
      --Text message(s) displayed when repeating this phase
      ContinueWarnings = {'The biters are aggitated.'},

      VariableData =
      {
        {
          --Some meta information
          Name = "Aggitated_v1_1",
          Title = " (Low Activity)",

          --Condition for whether this variation is used, if cycles completed between this range it is valid
          Cond_MinCyclesComplete = -1.0,
          Cond_MaxCyclesComplete = -1.0,
          Cond_ReqCycleComplete = false,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = 0.25,
          Cond_MaxEvolution = 0.45,
          Cond_ReqEvolution = true,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,
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
          Cond_MinCyclesComplete = -1.0,
          Cond_MaxCyclesComplete = -1.0,

          --Condition for whether this variation is used, if evolution between this range it is valid
          Cond_MinEvolution = 0.45,
          Cond_MaxEvolution = -1.0,

          --Condition for whether this variation is used, if brightness between this range it is valid
          Cond_MinBrightness = -1.0,
          Cond_MaxBrightness = -1.0,

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
function Biters.Init(self, globalState)
  LogDebug('Biters.Init()')

  --Ingame evolution time is silly and doesnt work properly methinks
  game.map_settings.enemy_evolution.time_factor = 0

  if globalState.BiterState ~= nil and globalState.BiterState.Name ~= Biters.DefaultState.Name then

    LogDebug('Cycle state is old! Starting a new one...')

    globalState.BiterState = DeepCopy(Biters.DefaultState)
    self:StartNewPhase(globalState)
  end

  if globalState.BiterState == nil then

    LogDebug('Cycle state does not exist! Starting a new one...')

    globalState.BiterState = DeepCopy(Biters.DefaultState)
    self:StartNewPhase(globalState)
  end

  LogInfo('Starting with Biters - ' .. globalState.BiterState.Name)

  LogDebug('Exit Biters.Init()')
end

--Called each mod tick (every 1 sec)
function Biters.Tick(self, currentState, previousState)
  LogDebug('Biters.Tick()')

  local currentBiterState = currentState.BiterState
  local currentPhaseState = currentBiterState.CurrentPhaseState
  --local currentPhaseConfig = currentPhaseState.CurrentPhase
  local currentPhaseVarData = currentPhaseState.CurrentPhaseVarData

  LogDebug('Permanent Evolution: ' .. currentBiterState.PermanentEvolution .. ', TempNightEvolution: ' .. currentBiterState.TempNightEvolution .. ', Phase: ' .. currentPhaseVarData.Name)

  self:UpdatePhase(currentState, previousState)

  self:UpdateEvolution(currentState, previousState)

  LogDebug('Exit Biters.Tick()')
end

--Called when beginning a new phase
function Biters.StartNewPhase(self, currentState, previousState)
  LogDebug('Biters.StartNewPhase()')

  local currentBiterPhaseState = currentState.BiterState.CurrentPhaseState
  local currentBiterPhase = nil
  local currentBiterPhaseVarData = nil
  if currentBiterPhaseState ~= nil then
    currentBiterPhase = currentBiterPhaseState.CurrentPhase
    currentBiterPhaseVarData = currentBiterPhaseState.CurrentPhaseVarData
  end

  local validPhaseData = {}
  local totalPhaseWeight = 0

  --Iterate through all phases looking for valid start phases
  for _,biterPhaseIter in ipairs(Biters.Phases) do
    LogDebug('Phase: ' .. biterPhaseIter.Name)

    --If phase not active, or active but not same as current iteration, or is same but can repeat
    if currentBiterPhase == nil
      or currentBiterPhase.Name ~= biterPhaseIter.Name
      or currentBiterPhaseVarData.CanRepeat == true
    then
      local newPhaseVarData = self:GetValidStartPhaseVarData(currentBiterPhaseState, biterPhaseIter, currentState, previousState)

      --If valid start phase var data found
      if newPhaseVarData ~= nil then
        --Get phase weight
        local phaseWeight
        if currentState.CycleState.IsDay then
          phaseWeight = newPhaseVarData.DayChanceWeight
        else
          phaseWeight = newPhaseVarData.NightChanceWeight
        end

        LogDebug('Valid phase data with weight: ' .. phaseWeight)

        --Insert phase into valid phases table
        table.insert(validPhaseData, {Config = biterPhaseIter, VarData = newPhaseVarData, Weight = phaseWeight})

        --Accumulate weight chance
        totalPhaseWeight = totalPhaseWeight + phaseWeight
        LogDebug('Total weight: ' .. totalPhaseWeight)
      else
        LogDebug('No valid phase data')
      end
    else
      LogDebug('Can not repeat phase')
    end --If phase not active, or active but not same as current iteration, or is same but can repeat
  end --Iterate through all phases looking for valid start phases

  local newBiterPhaseIndex = nil
  local currentWeightChance = 0
  local randWeight = math.random() * totalPhaseWeight
  LogDebug('randWeight ' .. randWeight)

  --Pick a phase to start at random
  for index,iterBiterPhase in ipairs(validPhaseData) do
    currentWeightChance = currentWeightChance + iterBiterPhase.Weight

    LogDebug('Phase: ' .. iterBiterPhase.Config.Name .. ', CurrentWeight: ' .. currentWeightChance)

    if randWeight <= currentWeightChance then
      newBiterPhaseIndex = index
      break
    end
  end

  --Log error if no biter phase discovered :(
  if newBiterPhaseIndex == nil then
    LogError('No valid biter phase discovered :(')
  end

  --Init state
  local currentPhaseState = currentState.BiterState.CurrentPhaseState
  local isRepeat = currentBiterPhase ~= nil and currentBiterPhase.Name == validPhaseData[newBiterPhaseIndex].Config.Name
  currentPhaseState.CurrentPhase = validPhaseData[newBiterPhaseIndex].Config
  currentPhaseState.CurrentPhaseVarData = validPhaseData[newBiterPhaseIndex].VarData
  currentPhaseState.TotalDurationSeconds = math.random(currentPhaseState.CurrentPhaseVarData.MinDuration, currentPhaseState.CurrentPhaseVarData.MaxDuration)

  --currentPhaseState.TotalDurationSeconds = 8

  currentPhaseState.RemainingDurationSeconds = currentPhaseState.TotalDurationSeconds
  currentPhaseState.EvolutionStart = game.forces.enemy.evolution_factor

  LogInfo('Chosen phase:' .. currentPhaseState.CurrentPhase.Name .. ', Duration: ' .. currentPhaseState.TotalDurationSeconds .. ', StartEvolution: ' .. currentPhaseState.EvolutionStart)

  --Apply phase map settings
  local newMapSettings = currentPhaseState.CurrentPhaseVarData.MapSettings

  --Apply time settings
  --game.map_settings.enemy_evolution.time_factor = newMapSettings.enemy_evolution.time_factor
  local scale = settings.global["pitch-ScaleEvolutionRate"].value
  game.map_settings.enemy_evolution.destroy_factor = newMapSettings.enemy_evolution.destroy_factor * scale
  game.map_settings.enemy_evolution.pollution_factor = newMapSettings.enemy_evolution.pollution_factor * scale

  --Apply expansion settings
  game.map_settings.enemy_expansion.enabled 						= newMapSettings.enemy_expansion.enabled
  game.map_settings.enemy_expansion.building_coefficient 			= newMapSettings.enemy_expansion.building_coefficient
  game.map_settings.enemy_expansion.max_expansion_distance 		= newMapSettings.enemy_expansion.max_expansion_distance
  game.map_settings.enemy_expansion.min_player_base_distance 		= newMapSettings.enemy_expansion.min_player_base_distance
  game.map_settings.enemy_expansion.min_base_spacing				= newMapSettings.enemy_expansion.min_base_spacing
  game.map_settings.enemy_expansion.min_expansion_cooldown 		= newMapSettings.enemy_expansion.min_expansion_cooldown
  game.map_settings.enemy_expansion.max_expansion_cooldown 		= newMapSettings.enemy_expansion.max_expansion_cooldown
  game.map_settings.enemy_expansion.settler_group_min_size 		= newMapSettings.enemy_expansion.settler_group_min_size
  game.map_settings.enemy_expansion.settler_group_max_size 		= newMapSettings.enemy_expansion.settler_group_max_size

  --Apply unit group settings
  game.map_settings.unit_group.min_group_gathering_time 			= newMapSettings.unit_group.min_group_gathering_time
  game.map_settings.unit_group.max_group_gathering_time 			= newMapSettings.unit_group.max_group_gathering_time
  game.map_settings.unit_group.max_wait_time_for_late_members 	= newMapSettings.unit_group.max_wait_time_for_late_members

  LogDebug('enemy_evolution.time_factor - ' .. newMapSettings.enemy_evolution.time_factor
    .. ', enemy_evolution.destroy_factor - ' .. newMapSettings.enemy_evolution.destroy_factor
    .. ', enemy_evolution.pollution_factor - ' .. newMapSettings.enemy_evolution.pollution_factor
    .. ', enemy_expansion.enabled - ' .. tostring(newMapSettings.enemy_expansion.enabled)
    .. ', enemy_expansion.building_coefficient - ' .. newMapSettings.enemy_expansion.building_coefficient
    .. ', enemy_expansion.max_expansion_distance - ' .. newMapSettings.enemy_expansion.max_expansion_distance
    .. ', enemy_expansion.min_player_base_distance - ' .. newMapSettings.enemy_expansion.min_player_base_distance
    .. ', enemy_expansion.min_base_spacing - ' .. newMapSettings.enemy_expansion.min_base_spacing
    .. ', enemy_expansion.min_expansion_cooldown - ' .. newMapSettings.enemy_expansion.min_expansion_cooldown
    .. ', enemy_expansion.max_expansion_cooldown - ' .. newMapSettings.enemy_expansion.max_expansion_cooldown
    .. ', enemy_expansion.settler_group_min_size - ' .. newMapSettings.enemy_expansion.settler_group_min_size
    .. ', enemy_expansion.settler_group_max_size - ' .. newMapSettings.enemy_expansion.settler_group_max_size
    .. ', unit_group.min_group_gathering_time - ' .. newMapSettings.unit_group.min_group_gathering_time
    .. ', unit_group.max_group_gathering_time - ' .. newMapSettings.unit_group.max_group_gathering_time
    .. ', unit_group.max_wait_time_for_late_members - ' .. newMapSettings.unit_group.max_wait_time_for_late_members
  )

  currentPhaseState.Messages = {}

  --Start at 5 second delay
  local messageCounter = 5
  local messageGroupBuffer = 3

  --If phase not repeating
  if isRepeat == false
  then
    --Add start warning messages
    for _,currentMessage in ipairs(currentPhaseState.CurrentPhase.StartWarnings) do
      table.insert(currentPhaseState.Messages, {Message = currentMessage, Delay = messageCounter})
    end
    messageCounter = messageCounter + messageGroupBuffer

    --Add extra start warning messages
    if currentPhaseState.CurrentPhaseVarData.StartExtraWarnings ~= nil then
      for _,currentMessage in ipairs(currentPhaseState.CurrentPhaseVarData.StartExtraWarnings) do
        table.insert(currentPhaseState.Messages, {Message = currentMessage, Delay = messageCounter})
      end

      messageCounter = messageCounter + messageGroupBuffer
    end
    --If phase repeating
  else
    --Add continue warning messages
    if currentPhaseState.CurrentPhase.ContinueWarnings ~= nil then
      for _,currentMessage in ipairs(currentPhaseState.CurrentPhase.ContinueWarnings) do
        table.insert(currentPhaseState.Messages, {Message = currentMessage, Delay = messageCounter})
      end

      messageCounter = messageCounter + messageGroupBuffer
    end

    --Add continue start warning messages
    if currentPhaseState.CurrentPhaseVarData.ContinueExtraWarnings ~= nil then
      for _,currentMessage in ipairs(currentPhaseState.CurrentPhaseVarData.ContinueExtraWarnings) do
        table.insert(currentPhaseState.Messages, {Message = currentMessage, Delay = messageCounter})
      end

      messageCounter = messageCounter + messageGroupBuffer
    end
  end

  --Add hint messages
  if currentPhaseState.CurrentPhase.HintWarnings ~= nil then
    for _,currentMessage in ipairs(currentPhaseState.CurrentPhase.HintWarnings) do
      table.insert(currentPhaseState.Messages, {Message = currentMessage, Delay = messageCounter})
    end

    --messageCounter = messageCounter + messageGroupBuffer
  end

  LogDebug('Exit Biters.StartNewPhase()')
end

--Update the biter evolution
function Biters.UpdateEvolution(_, currentState, _, _)
  LogDebug('Biters.UpdateEvolution()')

  local currentBiterState = currentState.BiterState
  local currentBiterPhaseState = currentBiterState.CurrentPhaseState
  --local currentBiterPhase = currentBiterPhaseState.CurrentPhase
  local currentBiterPhaseVarData = currentBiterPhaseState.CurrentPhaseVarData

  local scaleEvolutionRate =  settings.global["pitch-ScaleEvolutionRate"].value

  local permamnentEvolutionRate = 0.0

  --Iterate through permanent evolution scale rates to find the current one
  for _,scalePair in ipairs(currentBiterState.PermamnentEvolutionRates) do
    if currentBiterState.PermanentEvolution < scalePair[1] then
      permamnentEvolutionRate = scalePair[2]
      break
    end
  end

  LogDebug('PermamnentEvolutionRate: ' .. permamnentEvolutionRate)

  --Update permanent evolution
  currentBiterState.PermanentEvolution = math.min(1.0, currentBiterState.PermanentEvolution + (permamnentEvolutionRate * scaleEvolutionRate))

  local evolutionDelta = 0

  --Update temporary evolution
  if currentBiterState.TempNightEvolution > 0 then
    local currentCycleState = currentState.CycleState

    if currentCycleState.IsDay then
      local dissapateRate = currentCycleState.Brightness * currentBiterState.TempNightEvolutionDissapateRate

      local newTempNightEvolution = math.max(0, currentBiterState.TempNightEvolution + dissapateRate)

      evolutionDelta = evolutionDelta - (currentBiterState.TempNightEvolution - newTempNightEvolution)

      currentBiterState.TempNightEvolution = newTempNightEvolution
    end
  end

  --Update time based evolution
  evolutionDelta = evolutionDelta + currentBiterPhaseVarData.MapSettings.enemy_evolution.time_factor

  --Set game evolution
  game.forces.enemy.evolution_factor = math.max(game.forces.enemy.evolution_factor + (evolutionDelta * scaleEvolutionRate), currentBiterState.PermanentEvolution)

  LogDebug(
    'Evolution: ' .. game.forces.enemy.evolution_factor
    .. ', PermanentEvolution: ' .. currentBiterState.PermanentEvolution
    .. ', TempNightEvolution: ' .. currentBiterState.TempNightEvolution)

  LogDebug('Exit Biters.UpdateEvolution()')
end

--Update biter phase
function Biters.UpdatePhase(self, currentState, previousState)
  LogDebug('Biters.UpdatePhase()')

  local currentBiterState = currentState.BiterState
  local currentPhaseState = currentBiterState.CurrentPhaseState
  local currentPhaseConfig = currentPhaseState.CurrentPhase
  local currentPhaseVarData = currentPhaseState.CurrentPhaseVarData

  --Decrease timer
  currentPhaseState.RemainingDurationSeconds = currentPhaseState.RemainingDurationSeconds - 1
  local secondsElapsed = currentPhaseState.TotalDurationSeconds - currentPhaseState.RemainingDurationSeconds

  --Display messages
  local messageRemoveCount = 0
  if currentPhaseState.Messages ~= nil then
    for _,currentMessage in ipairs(currentPhaseState.Messages) do
      if currentMessage.Delay > secondsElapsed then
        break
      end

      MessageAll(currentMessage.Message)

      messageRemoveCount = messageRemoveCount + 1
    end
  end

  if messageRemoveCount > 0 then
    LogDebug('Popping ' .. messageRemoveCount .. ' messages')

    --Remove displayed messages
    for _=1, messageRemoveCount do
      table.remove(currentPhaseState.Messages, 1)
    end
  end

  --Determine what conditions will break/expire the phase
  local transitionToDay = false
  local transitionToNight = false
  if previousState ~= nil then
    transitionToDay = (previousState.CycleState.IsDay ~= true and currentState.CycleState.IsDay == true)
    transitionToNight = (previousState.CycleState.IsDay == true and currentState.CycleState.IsDay ~= true)
  end
  local phaseExpired = currentPhaseState.RemainingDurationSeconds <= 0
  local phaseBreak = self:CanPhaseBreak(currentPhaseState, currentPhaseConfig, currentPhaseVarData, currentState, previousState) == true

  LogDebug(
    'transitionToDay: ' .. tostring(transitionToDay) ..
    ', transitionToNight: ' .. tostring(transitionToNight) ..
    ', phaseExpired: ' .. tostring(phaseExpired) ..
    ', phaseBreak: ' .. tostring(phaseBreak))

  --If phase is breaking/expiring
  if transitionToDay or transitionToNight or phaseExpired or phaseBreak then
    LogInfo('Phase ' .. currentPhaseVarData.Name .. ' expired')

    --If was night
    if previousState.CycleState.IsDay == false then
      local evolutionDelta = game.forces.enemy.evolution_factor - currentPhaseState.EvolutionStart
      local tempEvolution = evolutionDelta - (evolutionDelta * currentPhaseVarData.EvolutionRetainedAfterNight)

      LogDebug('Evolution: ' .. game.forces.enemy.evolution_factor .. ', TempEvolutionForPhase: ' .. tempEvolution)

      currentBiterState.TempNightEvolution = currentBiterState.TempNightEvolution + tempEvolution
    end

    self:StartNewPhase(currentState, previousState)
  end

  LogDebug('Exit Biters.UpdatePhase()')
end

--Return a valid phase if biter phase can start given current conditions
function Biters.GetValidStartPhaseVarData(self, _, biterPhase, currentState, previousState)
  LogDebug('Biters.GetValidStartPhaseVarData(' .. biterPhase.Name .. ')')

  local transitionToDay = false
  local transitionToNight = false
  if previousState ~= nil then
    transitionToDay = (previousState.CycleState.IsDay ~= true and currentState.CycleState.IsDay == true)
    transitionToNight = (previousState.CycleState.IsDay == true and currentState.CycleState.IsDay ~= true)
  end

  LogDebug('Transition to day & night: ' .. tostring(transitionToDay) .. ', ' .. tostring(transitionToNight))

  --Iterate through each var phase data
  for _,biterPhaseVarDataIter in ipairs(biterPhase.VariableData) do
    LogDebug('Iter: ' .. biterPhaseVarDataIter.Name)

    local dayWeightChance = (currentState.CycleState.IsDay == true and biterPhaseVarDataIter.DayChanceWeight > 0.0)
    local nightWeightChance = (currentState.CycleState.IsDay == false and biterPhaseVarDataIter.NightChanceWeight > 0.0)
    local dayStartValid = (transitionToDay == false or biterPhaseVarDataIter.DayStartPhase == true)
    local nightStartValid = (transitionToNight == false or biterPhaseVarDataIter.NightStartPhase == true)
    local canBreak = self:CanPhaseBreak(nil, biterPhase, biterPhaseVarDataIter, currentState, previousState) == true

    LogDebug(
      'dayWeightChance: ' .. tostring(dayWeightChance) ..
      ', nightWeightChance: ' .. tostring(nightWeightChance) ..
      ', dayStartValid: ' .. tostring(dayStartValid) ..
      ', nightStartValid: ' .. tostring(nightStartValid) ..
      ', willBreak: ' .. tostring(canBreak))

    --Preliminary condition checks for valid phase
    if
      --Has chance to start
      (
      dayWeightChance
      or nightWeightChance
      )
      --If day just started and this is a day start phase
      and dayStartValid == true
      --If night just started and this is a night start phase
      and nightStartValid == true
      --Phase will not break
      and canBreak ~= true
    then
      LogDebug('Passed preliminary conditions')

      --Check cycle condition
      local cycleConditionActive = biterPhaseVarDataIter.Cond_MinCyclesComplete > -1.0 or biterPhaseVarDataIter.Cond_MaxCyclesComplete > -1.0
      local cycleCondition =
        (biterPhaseVarDataIter.Cond_MinCyclesComplete <= -1.0 or biterPhaseVarDataIter.Cond_MinCyclesComplete <= currentState.CyclesComplete)
        and
        (biterPhaseVarDataIter.Cond_MaxCyclesComplete <= -1.0 or biterPhaseVarDataIter.Cond_MaxCyclesComplete >= currentState.CyclesComplete)

      --Check evolution condition
      local evolutionConditionActive = biterPhaseVarDataIter.Cond_MinEvolution > -1.0 or biterPhaseVarDataIter.Cond_MaxEvolution > -1.0
      local evolutionCondition =
        (biterPhaseVarDataIter.Cond_MinEvolution <= -1.0 or biterPhaseVarDataIter.Cond_MinEvolution <= game.forces.enemy.evolution_factor)
        and
        (biterPhaseVarDataIter.Cond_MaxEvolution <= -1.0 or biterPhaseVarDataIter.Cond_MaxEvolution >= game.forces.enemy.evolution_factor)

      --Check brightness condition
      local brightnessConditionActive = biterPhaseVarDataIter.Cond_MinBrightness > -1.0 or biterPhaseVarDataIter.Cond_MaxBrightness > -1.0
      local brightnessCondition =
        (biterPhaseVarDataIter.Cond_MinBrightness <= -1.0 or biterPhaseVarDataIter.Cond_MinBrightness <= currentState.CycleState.Brightness)
        and
        (biterPhaseVarDataIter.Cond_MaxBrightness <= -1.0 or biterPhaseVarDataIter.Cond_MaxBrightness >= currentState.CycleState.Brightness)

      --canStart is true if at least one condition is active and true
      local canStart =
        (cycleConditionActive == true and cycleCondition == true)
        or (evolutionConditionActive == true and evolutionCondition == true)
        or (brightnessConditionActive == true and brightnessCondition == true)
        --Or no condition active
        or (cycleConditionActive == false and evolutionConditionActive == false and brightnessConditionActive == false)

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

      LogDebug(
        'cycleConditionActive: ' .. tostring(cycleConditionActive)
        .. ',  cycleCondition: ' .. tostring(cycleCondition)
        .. ',  evolutionConditionActive: ' .. tostring(evolutionConditionActive)
        .. ',  evolutionCondition: ' .. tostring(evolutionCondition)
        .. ',  brightnessConditionActive: ' .. tostring(brightnessConditionActive)
        .. ',  brightnessCondition: ' .. tostring(brightnessCondition)
        .. ',  canStart: ' .. tostring(canStart))

      --Finally, add to table if can start
      if canStart == true then

        LogDebug('Exit Biters.GetValidStartPhaseVarData(' .. biterPhase.Name .. ') with ' .. biterPhaseVarDataIter.Name)

        return biterPhaseVarDataIter
      end
    end	--If valid phase found
  end	--Iterate through each var phase data

  LogDebug('Exit Biters.GetValidStartPhaseVarData(' .. biterPhase.Name .. ') with nil')
  return nil
end

--Checks, given current conditions, whether a phase is due to break
function Biters.CanPhaseBreak(_, biterState, _, biterPhaseVarData, currentState, _, _)
  LogDebug('Biters.CanPhaseBreak(' .. biterPhaseVarData.Name .. ')')

  --Check evolution range break
  local breakMinEvolution =
    biterPhaseVarData.MinEvolutionBreak > -1.0
    and game.forces.enemy.evolution_factor < biterPhaseVarData.MinEvolutionBreak
  local breakMaxEvolution =
    biterPhaseVarData.MaxEvolutionBreak > -1.0
    and game.forces.enemy.evolution_factor > biterPhaseVarData.MaxEvolutionBreak

  --Check evolution delta break
  local breakEvolutionDelta = false
  if biterState ~= nil and biterPhaseVarData.EvolutionDeltaBreak > -1.0 and biterPhaseVarData.EvolutionDeltaBreak ~= 0.0 then
    if biterPhaseVarData.EvolutionDeltaBreak > 0.0 then
      breakEvolutionDelta = game.forces.enemy.evolution_factor > biterState.EvolutionStart + biterPhaseVarData.EvolutionDeltaBreak
    else
      breakEvolutionDelta = game.forces.enemy.evolution_factor < biterState.EvolutionStart + biterPhaseVarData.EvolutionDeltaBreak
    end
  end

  --Check brightness range break
  local breakMinBrightness =
    biterPhaseVarData.MinBrightnessBreak > -1.0
    and currentState.CycleState.Brightness < biterPhaseVarData.MinBrightnessBreak
  local breakMaxBrightness =
    biterPhaseVarData.MaxBrightnessBreak > -1.0
    and currentState.CycleState.Brightness > biterPhaseVarData.MaxBrightnessBreak

  LogDebug(
    'breakMinEvolution: ' .. tostring(breakMinEvolution)
    .. ', breakMaxEvolution: ' .. tostring(breakMaxEvolution)
    .. ', breakEvolutionDelta: ' .. tostring(breakEvolutionDelta)
    .. ', breakMinBrightness: ' .. tostring(breakMinBrightness)
    .. ', breakMaxBrightness: ' .. tostring(breakMaxBrightness)
  )

  local canBreak = breakMinEvolution or breakMaxEvolution or breakEvolutionDelta or breakMinBrightness or breakMaxBrightness

  LogDebug('Exit Biters.CanPhaseBreak(' .. biterPhaseVarData.Name .. ') with ' .. tostring(canBreak))

  return canBreak
end
