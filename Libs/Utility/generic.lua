require 'Libs/Utility/math'

function MessageAll(s)
	for _, player in pairs(game.players) do
		if player.connected then
			player.print(s)
		end
	end
end

function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function SetBrightness(scalar)
	--Lerp between day (0.5 = noon) and night (0.0 = midnight)
	game.surfaces.nauvis.daytime = Math.Lerp(0.5, 0.25, scalar)
end