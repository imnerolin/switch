--!strict

--[[
	`donothing`: Token for luau switch library.
	```lua
	-- example:
	case "baz" {
		donothing
	};
	```
	Pass into a case body to specify that a case should do nothing.

	Will imply `stop` as the exit mode rather than respecting user config, except if `continue` is
	explicitly given; in which case it can be used to silence the error from passing `continue` only.
	```lua
	case "baz" {
		continue
	}; -- warning: 
	case "baz" {
		donothing, continue
	}; -- OK
	```
]]
local function donothing (...: any)
end

-->>	Out
return donothing