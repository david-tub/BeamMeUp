
if not JO_UpdateBuffer_Simple then
	JO_UpdateBuffer_Simple = function(id, func, ms)
		local updateName = "JO_UpdateBuffer_Simple_" .. id
		
		ms = ms or 100
		
		return function(...)
			local params = {...}
			EVENT_MANAGER:UnregisterForUpdate(updateName)
			
			local function OnUpdateHandler()
				EVENT_MANAGER:UnregisterForUpdate(updateName)
				func(unpack(params))
			end
			
			EVENT_MANAGER:RegisterForUpdate(updateName, ms, OnUpdateHandler)
		end
	end
end

if not jo_callLaterOnNextScene then
	jo_callLaterOnNextScene = function(id, func, ...)
		local params = {...}
		local sceneName = SCENE_MANAGER:GetCurrentSceneName()
		local updateName = "JO_CallLaterOnNextScene_" .. id
		EVENT_MANAGER:UnregisterForUpdate(updateName)
		
		local function OnUpdateHandler()
			if SCENE_MANAGER:GetCurrentSceneName() ~= sceneName then
				EVENT_MANAGER:UnregisterForUpdate(updateName)
				func(unpack(params))
			end
		end
		
		EVENT_MANAGER:RegisterForUpdate(updateName, 100, OnUpdateHandler)
	end
end

if not jo_callLater then
	jo_callLater = function(id, func, ms, ...)
		local params = {...}
		local ms = ms or 0
		local updateName = "jo_callLater" .. id
		EVENT_MANAGER:UnregisterForUpdate(updateName)
		
		local function OnUpdateHandler()
			EVENT_MANAGER:UnregisterForUpdate(updateName)
			func(unpack(params))
		end
		
		EVENT_MANAGER:RegisterForUpdate(updateName, ms, OnUpdateHandler)
	end
end