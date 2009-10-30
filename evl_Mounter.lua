-- Some stuff borrowed from Noru (http://github.com/haste/Noru)
local inFlyableWintergrasp = function()
	return GetZoneText() == "Wintergrasp" and not GetWintergraspWaitTime()
end

local creatureCache, creatureId, creatureName
local mountCreatureName = function(name)
	local companionCount = GetNumCompanions("MOUNT")
	
	if not creatureCache or companionCount ~= #creatureCache then
		creatureCache = {}

		for i = 1, companionCount do
			creatureId, creatureName = GetCompanionInfo("MOUNT", i)
			creatureCache[creatureName] = i
		end
	end
	
	local creatureId = creatureCache[name]
	
	if creatureId then
		CallCompanion("MOUNT", creatureId)
		return true
	end
end

local argumentsPattern = "([^,]+),%s*(.+)"

SlashCmdList['EVL_MOUNTER'] = function(text, editBox)
	if not IsMounted() and not InCombatLockdown() then
		local grountMount, flyingMount = string.match(text, argumentsPattern)
		
		if not grountMount then
			grountMount = #text > 0 and text or nil
		end
		
		if grountMount then
			local mount = (flyingMount and IsFlyableArea() and not inFlyableWintergrasp()) and flyingMount or grountMount
			local success = mountCreatureName(mount)
			
			if not success then
				print("No such mount: " .. mount)
			end
		else
			print("Usage: /mounter <Grount mount>[, <Flying mount>]")
		end
	else
		Dismount()
	end
end

SLASH_EVL_MOUNTER1 = "/mounter"