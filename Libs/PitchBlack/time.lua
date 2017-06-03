require 'Libs/Utility/logger'
require 'Libs/Utility/math'
require 'Libs/Utility/generic'

--PHASE or TIME PHASE =  (day, dusk, night etc)

Time = {} --luacheck: allow defined top
Time.DayLength = settings.global["pitch-DayLength"].value

--The default state of time
Time.DefaultState =
  {
    --Meta information
    Name = 'TimeState_v1',

    --How long the phase will last, in game days
    PhaseDuration = 0,

    --How many days in phase have passed
    PhaseDaysComplete = 0,

    --The current copy of the time phase data
    CurrentPhaseConfig = nil,

    --The phase config variable data
    CurrentPhaseVarData = nil,

    --Whether the current phase is considered daytime (true), otherwise night (false)
    IsDay = false,

    --The current brightness
    Brightness = nil,

    --If this is a transition phase (dawn, dusk) these are the brightness values to lerp between
    --Brightness at the start of the phase
    StartBrightness = 0,
    --Brightness at the end of the phase
    EndBrightness = 0,

    --When a transition phase begins (dusk, dawn) the next non-transition phase is determined
    --The next phase config after the transition
    NextNonTransitionPhaseConfig = nil,
    --The next phase var data after the transition
    NextNonTransitionPhaseVarData = nil
  }

--Used to identify which phase is active
Time.DayPhaseIndex = 1
Time.DuskPhaseIndex = 2
Time.NightPhaseIndex = 3
Time.DawnPhaseIndex = 4

--Cycle config for day
Time.DayPhaseConfig =
  {
    --Some meta information
    Name = 'Day_v1',
    Title = 'Day',

    --The index of this phase
    PhaseIndex = Time.DayPhaseIndex,

    --Is this phase considered day?
    IsDay = true,

    --Is this a transition phase?
    IsTransition = false,

    --Message(s) that appear for all players
    Warnings = nil,

    --Data that has conditions that need to be met to be valid, such as cycles complete
    VariableData =
    {
      {Name = "Day_v1_1", CyclesComplete = 0, MinLength = settings.global["pitch-FirstDayPhaseLength"].value,
        MaxLength = settings.global["pitch-FirstDayPhaseLength"].value, MinBrightness = 1, MaxBrightness = 1},
      {Name = "Day_v1_2", CyclesComplete = 1, MinLength = 6, MaxLength = 6, MinBrightness = 0.6, MaxBrightness = 0.6},
      {Name = "Day_v1_2", CyclesComplete = 2, MinLength = 5, MaxLength = 5, MinBrightness = 0.4, MaxBrightness = 0.5},
      {Name = "Day_v1_2", CyclesComplete = 3, MinLength = 4, MaxLength = 4, MinBrightness = 0.3, MaxBrightness = 0.4}
    }
  }

--Cycle config for dusk
Time.DuskPhaseConfig =
  {
    --Some meta information
    Name = 'Dusk_v1',
    Title = 'Dusk',

    --The index of this phase
    PhaseIndex = Time.DuskPhaseIndex,

    --Is this phase considered day?
    IsDay = true,

    --Is this a transition phase?
    IsTransition = true,

    --Message(s) that appear for all players
    Warnings = {'The sun is beggining to set!'},

    --Data that has conditions that need to be met to be valid, such as cycles complete
    VariableData =
    {
      {Name = "Dusk_v1_1", CyclesComplete = 0, MinLength = 1, MaxLength = 1}
    }
  }

--Cycle config for night
Time.NightPhaseConfig =
  {
    --Some meta information
    Name = 'Night_v1',
    Title = 'Night',

    --The index of this phase
    PhaseIndex = Time.NightPhaseIndex,

    --Is this phase considered day?
    IsDay = false,

    --Is this a transition phase?
    IsTransition = false,

    --Message(s) that appear for all players
    Warnings = {'Night has begun!'},

    --Data that has conditions that need to be met to be valid, such as cycles complete
    VariableData =
    {
      {Name = "Night_v1_1", CyclesComplete = 0, MinLength = 1, MaxLength = 1, MinBrightness = 0.0, MaxBrightness = 0.0},
      {Name = "Night_v1_2", CyclesComplete = 1, MinLength = 2, MaxLength = 2, MinBrightness = 0.0, MaxBrightness = 0.0},
      {Name = "Night_v1_3", CyclesComplete = 2, MinLength = 2, MaxLength = 2, MinBrightness = 0.0, MaxBrightness = 0.0},
      {Name = "Night_v1_4", CyclesComplete = 3, MinLength = 3, MaxLength = 3, MinBrightness = 0.0, MaxBrightness = 0.0}
    }
  }

--Cycle config for dawn
Time.DawnPhaseConfig =
  {
    --Some meta information
    Name = 'Dawn_v1',
    Title = 'Dawn',

    --The index of this phase
    PhaseIndex = Time.DawnPhaseIndex,

    --Is this phase considered day?
    IsDay = true,

    --Is this a transition phase?
    IsTransition = true,

    --Message(s) that appear for all players
    Warnings = {'The sun is rising!'},

    --Data that has conditions that need to be met to be valid, such as cycles complete
    VariableData =
    {
      {Name = "Dawn_v1_1", CyclesComplete = 0, MinLength = 1, MaxLength = 1}
    }
  }

--Called when the mod changes/is added for first time
function Time.Init(self, globalState)
  LogDebug('Time.Init()')

  if globalState.CycleState == nil then
    LogInfo('Cycle state does not exist! Starting a new one...')

    globalState.CycleState = DeepCopy(Time.DefaultState)
    self:StartDay(globalState)
  end

  LogInfo('Starting with Time - ' .. globalState.CycleState.Name)

  LogDebug('Exit Time.Init()')
end

--Called on every phase as it begins
function Time.InitPhase(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.InitPhase()')

  local currentCycleState = currentGlobalState.CycleState
  local currentPhaseConfig = currentCycleState.CurrentPhaseConfig
  local currentPhaseVarData = currentCycleState.CurrentPhaseVarData

  --Update state whether is day
  currentCycleState.IsDay = currentPhaseConfig.IsDay

  --Update state durations
  local minPhaseDuration = currentPhaseVarData.MinLength
  local maxPhaseDuration = currentPhaseVarData.MaxLength
  currentCycleState.PhaseDuration = math.random(minPhaseDuration, maxPhaseDuration)
  currentCycleState.PhaseDaysComplete = 0

  LogDebug('Phase Duration set: ' .. currentCycleState.PhaseDuration)

  --Update state brightness
  if currentPhaseConfig.IsTransition == false then
    LogDebug('Is not transition phase.')

    --if currentCycleState.Brightness == nil then
    local minBrightness = currentPhaseVarData.MinBrightness
    local maxBrightness = currentPhaseVarData.MaxBrightness

    currentCycleState.Brightness = Math.RandomFloat(minBrightness, maxBrightness)

    LogDebug('Phase Brightness set: ' .. currentCycleState.Brightness)
    --end
  else
    LogDebug('Is transition phase.')

    --Determine transition-to cycle
    currentCycleState.NextNonTransitionPhaseConfig = self:GetNextNonTransitionPhaseConfig(currentGlobalState)
    currentCycleState.NextNonTransitionPhaseVarData = self:GetPhaseVariableData(currentGlobalState, currentCycleState.NextNonTransitionPhaseConfig, 1)

    --Set transition brightness, which is last phase brightness to next phase brightness
    local minBrightness = currentCycleState.NextNonTransitionPhaseVarData.MinBrightness
    local maxBrightness = currentCycleState.NextNonTransitionPhaseVarData.MaxBrightness
    currentCycleState.StartBrightness = previousGlobalState.CycleState.Brightness
    currentCycleState.EndBrightness = Math.RandomFloat(minBrightness, maxBrightness)

    LogDebug('Phase Start & End Brightness set: ' .. currentCycleState.StartBrightness .. ', ' .. currentCycleState.EndBrightness)
  end

  --Message all warnings for beginning of phase
  if currentPhaseConfig.Warnings ~= nil then
    MessageAll(currentCycleState.CurrentPhaseConfig.Warnings[1])
  end

  --Get previous phase var data name
  local previousPhaseName = 'nil'
  if
    previousGlobalState ~= nil
    and previousGlobalState.CycleState ~= nil
    and previousGlobalState.CycleState.CurrentPhaseVarData ~= nil
  then
    previousPhaseName = previousGlobalState.CycleState.CurrentPhaseVarData.Name
  end

  LogInfo('Finishing phase: ' .. previousPhaseName .. 'Starting phase: ' .. currentPhaseConfig.Name)

  LogDebug('Exit Time.InitPhase()')
end

--Given a state, get the variable data
function Time.GetPhaseVariableData(_, globalState, phase, cycleOffset)
  LogDebug('Time.GetPhaseVariableData(' .. phase.Name .. ')')

  local lastVariableData = nil

  for _, phaseVariableDataIter in ipairs(phase.VariableData) do
    if (globalState.CyclesComplete + cycleOffset) < phaseVariableDataIter.CyclesComplete then
      break
    end

    lastVariableData = phaseVariableDataIter
  end

  LogDebug('Exit Time.GetPhaseVariableData(' .. phase.Name .. ') with ' .. lastVariableData.Name)
  return lastVariableData
end

--Given a state, get the variable data
function Time.GetNextNonTransitionPhaseConfig(_, globalState)
  LogDebug('Time.GetNextNonTransitionPhaseConfig()')

  local phaseConfig = globalState.CycleState.CurrentPhaseConfig

  --If day or dusk
  if phaseConfig.PhaseIndex == Time.DayPhaseIndex or phaseConfig.PhaseIndex == Time.DuskPhaseIndex then
    LogDebug('Exit Time.GetNextNonTransitionPhaseConfig() with ' .. Time.NightPhaseConfig.Name)
    return Time.NightPhaseConfig
      --If night or dawn
  else
    LogDebug('Exit Time.GetNextNonTransitionPhaseConfig() with ' .. Time.DayPhaseConfig.Name)
    return Time.DayPhaseConfig
  end
end

--Start phase day in the current global state
function Time.StartDay(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.StartDay()')

  local currentCycleState = currentGlobalState.CycleState
  local previousCycleState = nil

  if previousGlobalState ~= nil then
    previousCycleState = previousGlobalState.CycleState
  end

  --If transitioned from
  if
    previousCycleState ~= nil and
    previousCycleState.NextNonTransitionPhaseConfig ~= nil and
    previousCycleState.NextNonTransitionPhaseVarData ~= nil
  then
    currentCycleState.CurrentPhaseConfig = previousCycleState.NextNonTransitionPhaseConfig
    currentCycleState.CurrentPhaseVarData = previousCycleState.NextNonTransitionPhaseVarData

    LogDebug('Start day with previously select phase & data: ' .. currentCycleState.CurrentPhaseConfig.Name .. ', ' .. currentCycleState.CurrentPhaseVarData.Name)
    --This should only occur during init
  else
    currentCycleState.CurrentPhaseConfig = Time.DayPhaseConfig
    currentCycleState.CurrentPhaseVarData = self:GetPhaseVariableData(currentGlobalState, currentCycleState.CurrentPhaseConfig, 0)

    LogDebug('Start day with new phase & data: ' .. currentCycleState.CurrentPhaseConfig.Name .. ', ' .. currentCycleState.CurrentPhaseVarData.Name)
  end

  self:InitPhase(currentGlobalState, previousGlobalState)

  LogDebug('Exit Time.StartDay()')
end

--Start phase dusk in the current global state
function Time.StartDusk(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.StartDusk()')

  local cycleState = currentGlobalState.CycleState
  cycleState.CurrentPhaseConfig = Time.DuskPhaseConfig
  cycleState.CurrentPhaseVarData = self:GetPhaseVariableData(currentGlobalState, cycleState.CurrentPhaseConfig, 0)

  LogDebug('Start dusk with new phase & data: ' .. cycleState.CurrentPhaseConfig.Name .. ', ' .. cycleState.CurrentPhaseVarData.Name)

  self:InitPhase(currentGlobalState, previousGlobalState)

  LogDebug('Exit Time.StartDusk()')
end

--Start phase dawn in the current global state
function Time.StartDawn(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.StartDawn()')

  local cycleState = currentGlobalState.CycleState
  cycleState.CurrentPhaseConfig = Time.DawnPhaseConfig
  cycleState.CurrentPhaseVarData = self:GetPhaseVariableData(currentGlobalState, cycleState.CurrentPhaseConfig, 0)

  LogDebug('Start dawn with new phase & data: ' .. cycleState.CurrentPhaseConfig.Name .. ', ' .. cycleState.CurrentPhaseVarData.Name)

  self:InitPhase(currentGlobalState, previousGlobalState)

  LogDebug('Exit Time.StartDawn()')
end

--Start phase night in the current global state
function Time.StartNight(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.StartNight()')

  local currentCycleState = currentGlobalState.CycleState
  local previousCycleState = nil

  if previousGlobalState ~= nil then
    previousCycleState = previousGlobalState.CycleState
  end

  --If transitioned from
  if
    previousCycleState ~= nil and
    previousCycleState.NextNonTransitionPhaseConfig ~= nil and
    previousCycleState.NextNonTransitionPhaseVarData ~= nil
  then
    currentCycleState.CurrentPhaseConfig = previousCycleState.NextNonTransitionPhaseConfig
    currentCycleState.CurrentPhaseVarData = previousCycleState.NextNonTransitionPhaseVarData

    LogDebug('Start night with previously select phase & data: ' .. currentCycleState.CurrentPhaseConfig.Name .. ', ' .. previousCycleState.NextNonTransitionPhaseVarData.Name)
    --This should only occur during init
  else
    currentCycleState.CurrentPhaseConfig = Time.NightPhaseConfig
    currentCycleState.CurrentPhaseVarData = self:GetPhaseVariableData(currentGlobalState, currentCycleState.CurrentPhaseConfig, 0)

    LogDebug('Start night with new phase & data: ' .. currentCycleState.CurrentPhaseConfig.Name .. ', ' .. currentCycleState.CurrentPhaseVarData.Name)
  end

  self:InitPhase(currentGlobalState, previousGlobalState)

  LogDebug('Exit Time.StartNight()')
end

--Called each mod tick (every 1 sec)
function Time.Tick(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.Tick()')

  LogDebug('CyclesComplete: ' .. currentGlobalState.CyclesComplete .. ', Total Days: ' .. currentGlobalState.TotalDays .. ', Day: ' .. currentGlobalState.Day ..
    ', Second: ' .. currentGlobalState.Second)

  self:TransitionSecond(currentGlobalState, previousGlobalState)

  local currentCycleState = currentGlobalState.CycleState
  local previousCycleState = previousGlobalState.CycleState

  --If a transitioning phase, update brightness based on remaining duration
  if currentCycleState.CurrentPhaseConfig.IsTransition == true then
    local scaleBrightness = (currentGlobalState.Second + currentCycleState.PhaseDaysComplete * Time.DayLength) / (currentCycleState.PhaseDuration * Time.DayLength)
    LogDebug('Scale Brightness: ' .. scaleBrightness)

    currentCycleState.Brightness = Math.Lerp(currentCycleState.StartBrightness, currentCycleState.EndBrightness, scaleBrightness)
  end

  --Update game brightness if there is a difference
  LogDebug('Curr Brightness: ' .. currentCycleState.Brightness .. ', Prev Brightness: ' .. previousCycleState.Brightness)
  if currentCycleState.Brightness ~= previousCycleState.Brightness then
    LogDebug('Set Brightness: ' .. currentCycleState.Brightness)

    SetBrightness(currentCycleState.Brightness)
  end

  LogDebug('Exit Time.Tick()')
end

--Called at the end of a second
function Time.TransitionSecond(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.TransitionSecond()')

  currentGlobalState.Second = currentGlobalState.Second + 1

  if currentGlobalState.Second >= Time.DayLength then
    self:TransitionDay(currentGlobalState, previousGlobalState)
  end

  LogDebug('Exit Time.TransitionSecond()')
end

--Called when the current day finishes
function Time.TransitionDay(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.TransitionDay()')

  --Update global state
  currentGlobalState.Second = 0
  currentGlobalState.TotalDays = currentGlobalState.TotalDays + 1
  currentGlobalState.Day = currentGlobalState.Day + 1

  --Update cycle phase
  local currentCycleState = currentGlobalState.CycleState
  currentCycleState.PhaseDaysComplete = currentCycleState.PhaseDaysComplete + 1

  --Transition cycle phase
  if currentCycleState.PhaseDaysComplete >= currentCycleState.PhaseDuration then
    LogDebug('Phase time expired.')

    self:TransitionPhase(currentGlobalState, previousGlobalState)
  end

  LogDebug('Exit Time.TransitionDay()')
end

--Called when the current phase finishes
function Time.TransitionPhase(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.TransitionPhase()')

  local previousPhaseConfig = previousGlobalState.CycleState.CurrentPhaseConfig

  --If Day
  if previousPhaseConfig.PhaseIndex == Time.DayPhaseIndex then
    self:StartDusk(currentGlobalState, previousGlobalState)
    --If Dusk
  elseif previousPhaseConfig.PhaseIndex == Time.DuskPhaseIndex then
    self:StartNight(currentGlobalState, previousGlobalState)
    --If Night
  elseif previousPhaseConfig.PhaseIndex == Time.NightPhaseIndex then
    self:StartDawn(currentGlobalState, previousGlobalState)
    --If Dawn
  else
    self:TransitionCycle(currentGlobalState, previousGlobalState)
  end

  LogDebug('Exit Time.TransitionPhase()')
end

--Called when the current cycle finishes
function Time.TransitionCycle(self, currentGlobalState, previousGlobalState)
  LogDebug('Time.TransitionCycle()')

  LogInfo('Cycle Complete')

  currentGlobalState.CyclesComplete = currentGlobalState.CyclesComplete + 1

  currentGlobalState.Day = 0

  self:StartDay(currentGlobalState, previousGlobalState)

  LogDebug('Exit Time.TransitionCycle()')
end
