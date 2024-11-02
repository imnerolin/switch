--!strict

local NAME = "nilvalue"

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
	`nilvalue`: Private token for luau switch library.
	Used as a placeholder for nil values in case arguments internally.
]]
local nilvalue = setmetatable({name = NAME}, table.freeze(meta))
export type nilvalue = typeof(nilvalue)

-->>	Out
return nilvalue