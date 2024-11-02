--!strict

-->>	Includes
local regular = require(script.regular)
local express = require(script.express)
local tokens = require(script.tokens)
local config = require(script.config)
local util = require(script.util)

-->>	Types
type tbl <K = any, V = any> = {[K]: V}
type func <T... = ...any, U... = ...any> = (T...) -> (U...)

export type continue = tokens.continue
export type stop = tokens.stop

-->>	Private
local freeze = util.freeze

-->>	Out
return freeze {
	tokens = freeze {
		stop = tokens.public.stop;
		continue = tokens.public.continue;
	};
	config = config;

	switch = regular.switch;
	case = regular.case;
	default = regular.default;

	xswitch = express.switch;
	xcase = express.case;
	xdefault = express.default;
	xthrows = express.throws;
}