require 'Libs/Utility/generic'
require 'Libs/Utility/logger'
require 'Libs/PitchBlack/biters'
require 'Libs/PitchBlack/time'

--Global data table to be used when a new cycle begins or when no cycle exists
DefaultGlobalData = { --luacheck: allow defined top
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

	--Some meta
	Name = 'HelloWorld',
	Title = 'Hello World',
	Version = '0.0.4',

	--Total elapsed ticks for the current second
	ElapsedTicksOfSecond = 0,

	--Total elapsed ticks
	TotalElapsedTicks = 0,

	--Current & Previous DefaultGlobalData.DefaultState
	PreviousState = nil,
	CurrentState = nil,  
  
	AllPollutionHarmables = nil,
	AllPollutionHarmablesIter = 1
}

Main = 
{
} --luacheck: allow defined top

function Main.On_Tick(_)
	local ticksPerSecond = 60
	global.Data.ElapsedTicksOfSecond = global.Data.ElapsedTicksOfSecond + 1
	global.Data.TotalElapsedTicks = global.Data.TotalElapsedTicks + 1

	if global.Data.ElapsedTicksOfSecond >= ticksPerSecond then
		LogDebug('Start Main Tick')
		global.Data.ElapsedTicksOfSecond = 0

		--Transition simple state
		global.Data.PreviousState = DeepCopy(global.Data.CurrentState)

		--Update mod
		Time:Tick(global.Data.CurrentState, global.Data.PreviousState)
		Biters:Tick(global.Data.CurrentState, global.Data.PreviousState)

		--Commit update to game state
		LogDebug('End Main Tick')
	end
  
	--Apply pollution harmables damage, 100 per tick
	local brightness = GetBrightness()
	local brightnessScale = brightness * settings.global["pitch-ScalePollutionDamage"].value
	local minBrightnessMinPollutionDamage = 0.2
	local minPollutionDamagePerSecond = 2
	local maxPollutionDamagePerSecond = 20
	local maxPollutionPerSecond = 8000 	--Linear scale damage 
	local pollutionDamageScales = 
	{
		{Max = 0, Scale = 0.05},
		{Max = 500, Scale = 0.1},
		{Max = 3000, Scale = 0.4},
		{Max = 5000, Scale = 0.7},
		{Max = maxPollutionPerSecond, Scale = 1.0}
	}
  
	if (brightnessScale > 0.1) then
		local iterCount = 0
		while true do
			if (iterCount > 99) then 
				break 
			end
			
			iterCount = iterCount + 1
			pollutionHarmable = global.Data.AllPollutionHarmables[global.Data.AllPollutionHarmablesIter]
			if (global.Data.AllPollutionHarmablesIter <= #global.Data.AllPollutionHarmables and pollutionHarmable) then
				if (pollutionHarmable.LastTick < 0) then
					pollutionHarmable.LastTick = global.Data.TotalElapsedTicks
				end
				
				local secondsSinceUpdate = (global.Data.TotalElapsedTicks - pollutionHarmable.LastTick) / ticksPerSecond
				pollutionHarmable.LastTick = global.Data.TotalElapsedTicks
				
				if (pollutionHarmable.Harmable.valid) then
					LogDebug('Polluting: ' .. global.Data.AllPollutionHarmablesIter);
				
					local pollution = game.surfaces.nauvis.get_pollution(pollutionHarmable.Harmable.position)
					local pollutionClamped = Math.Clamp(pollution, 0, maxPollutionPerSecond - 1)
					
					local minPol = 0
					local minScale = 0
					local polScale = 0
					
					if (pollution > 0) then				
						for _,pollutionDamageScale in ipairs(pollutionDamageScales) do
							if (pollutionClamped >= pollutionDamageScale.Max) then
								minPol = pollutionDamageScale.Max
								minScale = pollutionDamageScale.Scale
							else				
								polScale = Math.Lerp(minScale, pollutionDamageScale.Scale, (pollutionClamped - minPol) / (pollutionDamageScale.Max - minPol))
								
								break
							end
						end
					
						local damageScaled = maxPollutionDamagePerSecond * brightnessScale * secondsSinceUpdate * polScale
						local minDamageBrightness = Math.Clamp(brightnessScale, 0, minBrightnessMinPollutionDamage)
						local minDamage = Math.Lerp(0, minPollutionDamagePerSecond, minDamageBrightness / minBrightnessMinPollutionDamage) * secondsSinceUpdate
						
						if (damageScaled < minDamage) then
							damageScaled = minDamage
						end
						
						if (damageScaled > 0) then							
							LogDebug('D: ' .. damageScaled
							.. ', DPS: ' .. maxPollutionDamagePerSecond
							.. ', P: ' .. pollution
							.. ', BR: ' .. brightnessScale
							.. ', T: ' .. secondsSinceUpdate
							.. ', P: ' .. polScale
							
							)
						end
						
						pollutionHarmable.Harmable.damage(damageScaled, "enemy")
					end

					global.Data.AllPollutionHarmablesIter = global.Data.AllPollutionHarmablesIter + 1	
				else
					LogDebug('Removing: ' .. global.Data.AllPollutionHarmablesIter);
					table.remove(global.Data.AllPollutionHarmables, global.Data.AllPollutionHarmablesIter)
				end			
			else
				--LogDebug('Restarting from: ' .. global.Data.AllPollutionHarmablesIter);
				global.Data.AllPollutionHarmablesIter = 1
			end
		end
	end
end

function Main.On_Configuration_Changed(self, _)
  self:InitWorld()
end

function Main.On_Init(self)
  self:InitWorld()
end

--Run on first load of mod or when version changes
function Main.InitWorld(self)
  game.map_settings.pollution.ageing = 0.75
  --workaround to work with any 0.15 version
  if game.active_mods["base"] and game.active_mods['base'] >= '0.15.13' then
    game.surfaces[1].freeze_daytime = true
  else
    game.surfaces[1].freeze_daytime()
  end

  --Look for existing data, if none... swap it over
  if global.Data == nil then
    global.Data = self:GetNewGlobalData()

    LogDebug('Missing current global data, using default "' .. global.Data.Name
      .. 'v' .. global.Data.Version .. '".')
  else
    LogDebug('Current global data already exists! -  "' .. global.Data.Name
      .. 'v' .. global.Data.Version .. '".')
  end 
  
  if (global.Data.AllPollutionHarmables == nil) then
	  --Discover all Harmables that can be harmed
	  local biterHarmables = game.surfaces[1].find_entities_filtered{type= "unit-spawner"}
	  global.Data.AllPollutionHarmables = {}
	  global.Data.AllPollutionHarmablesIter = 1  
	  for i,biterHarmableIter in ipairs(biterHarmables) do  
		global.Data.AllPollutionHarmables[i] = {
			LastTick = -1,
			Harmable = biterHarmableIter
		}
	  end
  end

  --If old mod exists
  if global.CurrentCycle ~= nil then
    LogInfo('Removing old mod: ' .. global.CurrentCycle.name)

    global.CurrentCycle = nil
  end

  --Init other modules
  Time:Init(global.Data.CurrentState)
  Biters:Init(global.Data.CurrentState)

  LogDebug('Main.InitWorld()')
end

--Init a new global data
function Main.GetNewGlobalData(_)
  local newGlobalData = DeepCopy(DefaultGlobalData)
  newGlobalData.CurrentState = DeepCopy(DefaultGlobalData.DefaultState)

  return newGlobalData
end

function Main.On_BiterBuild(_, event)
	local base = event.entity
	if base.type == "unit-spawner" then
		global.Data.AllPollutionHarmables[#global.Data.AllPollutionHarmables + 1] = {
			LastTick = -1,
			Harmable = base
		}
		return
	end
end