function toObj = helperSLMatchStructFields(toObj, fromObj)

%helperSLMatchStructFields assign field values for structs/objects.

% Copyright 2017-2018 The MathWorks, Inc.

fieldNames = fields(fromObj);
for n = 1 : numel(fieldNames)
    toObj.(fieldNames{n}) = fromObj.(fieldNames{n});
end
end
