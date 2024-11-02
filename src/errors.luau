--!strict

local f = table.freeze
local messages = f{
    --// Errors
    E = f{
        DUPLICATE_DEFAULT = "More than one default case found when parsing switch, please delete this default case";
        DUPLICATE_THROWS = "More than one throw case found when parsing switch expression, please delete this throw case";
        EMPTY_SWITCH = "Switch construction requires at least one case.";
        INVALID_CASE_EXIT = "Invalid argument 2 when parsing case with 2 args: expected exit token, got $INFO";
        INVALID_CASE_EXP = "Invalid case $INFO; expected case, default or throw";
        INVALID_CASE_FUNC = "Invalid argument 1 when parsing case with 2 args: expected function, got $INFO";
        INVALID_CASE_REG = "Invalid case $INFO; expected case or default";
        INVALID_DEFAULT_FUNC = "Invalid argument 1 when parsing default case: expected function, got $INFO";
        INVALID_THROWABLE = "Invalid throwable $INFO: expected string or a function that returns a string";
        MISSING_DEFAULT_EXP = "Attempt to create a switch expression without a default case or throw case, please add one";
        MISSING_OPTIONS_EXP = "Must provide at least one option to case expression, did you mean 'xcase (nil)'?";
        MISSING_OPTIONS_REG = "Must provide at least one option to case, did you mean 'case (nil)'?";
        NO_RESOLVE_EXP = "Switch expression resolved to nothing with input $INFO; consider adding a default case or a throw case, or make sure you cover all possible values";
        THROWS_DEFAULT_MIX = "Attempt to create a switch expression with a default case and a throw case, please remove one";
    };

    --// Warnings
    W = f{
        DUPLICATE_CASE = "Duplicate option $INFO when parsing cases; remove this option";
        EMPTY_DEFAULT = "No function provided for default case; consider removing the default case entirely";
        EXTRA_CASE_ARGS = "More than 2 arguments passed to case body; consider removing these arguments as they do nothing";
        EXTRA_DEFAULT_ARGS = "More than 1 argument passed to default case body; consider removing these arguments as they do nothing";
        UNNECESSARY_CONTINUE = "Using continue without any associated action is redundant; consider removing case entirely, or pass donothing token first to silence";
    };

    --// Unique
    U = f{
        HOW_DID_WE_GET_HERE_1 = "You cannot create a switch using a table with a __len metamethod that returns a value that isn't a positive number... what were you even thinking?";
        MISSING_THROWABLE = "Switch expression threw an error with input $INFO (consider adding a throwable to throw case)";
    };
};

-->>
return messages