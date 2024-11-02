--!strict

local NAME = "defaultidentity"

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
	`defaultidentity`: Private token for luau switch library.
	Used as a reference to the default case for a switch internally.
]]
local defaultidentity = setmetatable({name = NAME}, table.freeze(meta))
export type defaultidentity = typeof(defaultidentity)

-->>	Out
return defaultidentity