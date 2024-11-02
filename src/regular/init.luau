--!strict

local dir = script.Parent

-->>	Includes
local errors = require(dir.errors)
local tokens = require(dir.tokens)
local config = require(dir.config)
local util = require(dir.util)

-->>	Types
type continue = tokens.continue
type stop = tokens.stop
type nilvalue = tokens.nilvalue

type func <T... = ...any, U... = ...any> = (T...) -> (U...)

type case <T> = {
	args: {T},
	exit: continue | stop,
	func: func <(T)>,
	size: number,
	type: "case" | "default"
}

export type switch <T> = func <T>
export type switchCases <T> = {case <T>}

-->>	Private
local continue = tokens.public.continue
local stop = tokens.public.stop
local donothing = tokens.public.donothing

local defaultidentity = tokens.private.defaultidentity
local nofunc = tokens.private.nofunc
local nilvalue = tokens.private.nilvalue

local function implicitExit(arg: func): continue | stop
	return if arg == donothing or config.ImplicitContinue == false
		then stop
		else continue
end

--- If the given value is nil, converts it to a unique value representing nil that can be used in tables.
local function toUsableNil <T> (arg: T?): T | nilvalue
	if arg == nil then
		return nilvalue
	else
		return arg
	end
end

local format = util.formatErrorMessage

-->>	Public
local function NEWSWITCH <T> (cases: switchCases <T>): switch <T>
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
			error(format(errors.E.INVALID_CASE_REG, case), 2)
		elseif case.type == "case" then
			local args = case.args
			for j = 1, case.size do
				local arg = args[j]
				local uarg = toUsableNil(arg)
				if map[uarg] ~= nil then
					util.warnTrace(format(errors.W.DUPLICATE_CASE, arg), 2)
					continue
				end
				map[uarg] = i
			end			
		elseif case.type == "default" then
			map[defaultidentity] = i
		end
	until i >= count
	
	return function(input: T)
		local index = map[input] or map[defaultidentity]
		local closed = false
		repeat
			if not index then closed = true; break end
			local case = cases[index]
			local func = case.func :: func <T>

			func(input)
			if case.type == "case" then
				if case.exit == stop then
					closed = true
					break
				end
				index += 1
			elseif case.type == "default" then
				closed = true
			end
		until closed
	end
end

local function NEWCASE <T> (...: T)
	local size = select("#", ...)
	if size == 0 then
		error(errors.E.MISSING_OPTIONS_REG, 2)
	end
	local args = {...}

	return function(construct: {func <T> | continue | stop}): case<T>
		local func: func <T> = nofunc
		local exit: continue | stop

		local count = #construct
		if count == 0 then
			-- empty case -> implicit stop
			exit = stop
		elseif count == 1 then
			local arg = construct[1]

			if type(arg) == "function" then
				-- action only -> implicit according to user settings
				func = arg
				exit = implicitExit(arg)
			elseif type(arg) == "table" then
				-- exit only -> explicit exit, no action
				if exit == continue then
					util.warnTrace(errors.W.UNNECESSARY_CONTINUE, 2)
				end
				exit = arg
			end
		else
			-- full case -> explicit exit and action
			local arg1, arg2 = construct[1], construct[2]
			if type(arg1) ~= "function" then
				error(format(errors.E.INVALID_CASE_FUNC, arg1), 2)
			elseif type(arg2) ~= "table" then
				error(format(errors.E.INVALID_CASE_EXIT, arg2), 2)
			end

			func, exit = arg1, arg2
			if count > 2 then
				util.warnTrace(errors.W.EXTRA_CASE_ARGS, 2)
			end
		end

		return {
			args = args,
			exit = exit,
			func = func,
			size = size,
			type = "case"
		}
	end
end

local function NEWDEFAULT <T> (construct: {func <T>}): case <T>
	local func: func<T> = construct[1]
	if func == nil then
		func = nofunc
		util.warnTrace(errors.W.EMPTY_DEFAULT, 2)
	elseif type(func) ~= "function" then
		error(format(errors.E.INVALID_DEFAULT_FUNC, func), 2)
	end
	if #construct > 1 then
		util.warnTrace(errors.W.EXTRA_DEFAULT_ARGS, 2)
	end
	
	return {
		args = {},
		exit = stop,
		func = func,
		size = 1,
		type = "default"
	}
end

-->>
return {
	switch = NEWSWITCH;
	case = NEWCASE;
	default = NEWDEFAULT;
}