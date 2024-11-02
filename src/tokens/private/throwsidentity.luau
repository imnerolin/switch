--!strict

local NAME = "throwsidentity"

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
	`throwsidentity`: Private token for luau switch library.
	Used as a reference to the throw case for a switch expression internally.
]]
local throwsidentity = setmetatable({name = NAME}, table.freeze(meta))
export type throwsidentity = typeof(throwsidentity)

-->>	Out
return throwsidentity