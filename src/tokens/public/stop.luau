--!strict

local NAME = "stop"

local meta = {}
function meta.__index(_, key)
	error(`Attempt to read from key '{key}' ({typeof(key)}) of {NAME} token`, 2)
end
function meta.__newindex(_, key, value)
	error(`Attempt to write '{value}' ({typeof(value)}) to key '{key}' ({typeof(key)}) of {NAME} token`, 2)
end
function meta.__tostring(): string
	return NAME
end
meta.__metatable = NAME

--[[
	`stop`: Token for luau switch library.
	```lua
	-- example:
	case "bar" {
		function()
			print("The word is bar!")
		end, stop
	};
	```
	Pass into a case's body to explicitly stop the switch if the case is matched.
]]
local stop = setmetatable({name = NAME}, table.freeze(meta))
export type stop = typeof(stop)

-->>	Out
return stop