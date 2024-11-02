--!strict

-->>	Public
local continue = require(script.public.continue)
local stop = require(script.public.stop)
local donothing = require(script.public.donothing)

-->>	Private
local defaultidentity = require(script.private.defaultidentity)
local throwsidentity = require(script.private.throwsidentity)
local nilvalue = require(script.private.nilvalue)
local nofunc = require(script.private.nofunc)

-->>	Exports
export type continue = continue.continue
export type stop = stop.stop

export type defaultidentity = defaultidentity.defaultidentity
export type throwsidentity = throwsidentity.throwsidentity
export type nilvalue = nilvalue.nilvalue

-->>	Pass
return table.freeze {
	public = table.freeze {
		continue = continue;
		stop = stop;
		donothing = donothing;
	};
	private = table.freeze {
		defaultidentity = defaultidentity;
		throwsidentity = throwsidentity;
		nilvalue = nilvalue;
		nofunc = nofunc;
	};
}