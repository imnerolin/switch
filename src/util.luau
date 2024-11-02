--!strict

local util = {}

-->>	Private
local function pack(...: any): {any}
	-- wrapper around {...} syntax
	-- uses any type as a compromise between the
	-- old solver throwing a tantrum when you pack a variadic generic into a table
	-- and new solver being weird with converting to any type
	return {...}
end

-->>	Public
--[[
	Adds a stack trace to a message and outputs it as a warning.
	```lua
	local message = "Something went wrong!"
	warnTrace(message)
	```
	The code above will output the text below:
	```x
	Something went wrong!
	Stack Begin
		Workspace.Script:27 function warnTrace
		ReplicatedStorage.Libraries.NeroUtils.switch.util:29
	Stack End
	```
]]
function util.warnTrace(message: any, level: number?)
	warn(`{message}\nStack Begin\n\t{debug.traceback(nil,(level or 1)+1):gsub("\n","\n\t"):sub(1,-2)}Stack End`)
end

function util.freeze <T...> (...: T...): T...
	for _, t in pack (...) do
		pcall(table.freeze, t)
	end
	return ...
end

function util.formatErrorMessage (message: string, arg: any): string
	message = tostring(message):gsub("$ARG", `{arg}`)
	message = message:gsub("$TYPE", typeof(arg))
	message = message:gsub("$INFO", `[{typeof(arg)}] '{arg}'`)
	return message
end

-->>	Out
return util