--!strict

local dir = script.Parent

-->>	Includes
local errors = require(dir.errors)
local tokens = require(dir.tokens)
local util = require(dir.util)

-->>	Types
type nilvalue = tokens.nilvalue

type func <T... = ...any, U... = ...any> = (T...) -> (U...)

type case <T, U> = {
	args: {T},
	out: U,
	type: "case" | "default" | "throws"
}

-->>	Private
local nilvalue = tokens.private.nilvalue
local defaultidentity = tokens.private.defaultidentity
local throwsidentity = tokens.private.throwsidentity

local function toUsableNil <T> (arg: T?): T | nilvalue
	if arg == nil then
		return nilvalue
	else
		return arg
	end
end

local format = util.formatErrorMessage

-->>	Public
local function XNEWSWITCH <T, U> (cases: {case <T, U>}): (T) -> U
	local map = {}
	local i = 0
	local count = #cases

	if type(count) ~= "number" or count < 0 then
		error(errors.U.HOW_DID_WE_GET_HERE_1, 2)
	elseif count == 0 then
		error(errors.E.EMPTY_SWITCH, 2)
	end

	repeat i += 1
		local case = cases[i]
		if type(case) ~= "table" then
			error(format(errors.E.INVALID_CASE_EXP, case), 2)
		elseif case.type == "case" then
			local args = case.args
			for j = 1, #args do
				local arg = args[j]
				local uarg = toUsableNil(arg)
				if map[uarg] ~= nil then
					util.warnTrace(format(errors.W.DUPLICATE_CASE, arg), 2)
					continue
				end
				map[uarg] = i
			end
		elseif case.type == "default" then
			if map[throwsidentity] then
				error(errors.E.THROWS_DEFAULT_MIX, 2)
			elseif map[defaultidentity] then
				error(errors.E.DUPLICATE_DEFAULT, 2)
			end
			map[defaultidentity] = i
		elseif case.type == "throws" then
			if map[defaultidentity] then
				error(errors.E.THROWS_DEFAULT_MIX, 2)
			elseif map[throwsidentity] then
				error(errors.E.DUPLICATE_THROWS, 2)
			end
			map[throwsidentity] = i
		else
			return error(errors.E.MISSING_DEFAULT_EXP, 2)
		end
	until i >= count

	return function(input: T): U
		local index = map[input] or map[defaultidentity]
		local case = cases[index]
		if case then
			return cases[index].out
		else
			local throws = cases[map[throwsidentity]]
			if throws then
				local throw: throwable <T> = (throws.out :: any)

				local message: string
				if type(throw) == "string" then
					message = throw
				elseif type(throw) == "function" then
					local _, result = pcall(throw, input)
					message = result
				else
					message = errors.U.MISSING_THROWABLE
				end
				return error(format(message, input), 2)
			else
				return error(format(errors.E.NO_RESOLVE_EXP, input), 2)
			end
		end
	end
end

local function XNEWCASE <T, U> (...: T)
	local size = select("#", ...)
	if size == 0 then
		error(errors.E.MISSING_OPTIONS_EXP, 2)
	end
	local args = {...}

	return function(out: U): case <T, U>
		return {
			args = args,
			out = out,
			type = "case"
		}
	end
end

local function XNEWDEFAULT <T, U> (out: U): case <T, U>
	return {
		args = {},
		out = out,
		type = "default"
	}
end

type throwable <T> = string | (T) -> string
local function XNEWTHROWS <T, U> (throwable: throwable <T>): case <T, U>
	if type(throwable) ~= "string" and type(throwable) ~= "function" then
		error(format(errors.E.INVALID_THROWABLE, throwable), 2)
	end
	return {
		args = {},
		out = throwable :: any,
		type = "throws"
	}
end

-->>
return {
	switch = XNEWSWITCH;
	case = XNEWCASE;
	default = XNEWDEFAULT;
	throws = XNEWTHROWS;
}