--!strict

local NAME = "continue"

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
	`continue`: Token for luau switch library.
	```lua
	-- example:
	case "foo" {
		function()
			print("The word is foo!")
		end, continue
	};
	```
	Pass into a case's body to explicitly continue the switch if the case is matched.
]]
local continue = setmetatable({name = NAME}, table.freeze(meta))
export type continue = typeof(continue)

-->>	Out
return continue