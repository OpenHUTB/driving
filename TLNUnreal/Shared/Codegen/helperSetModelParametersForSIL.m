function helperSetModelParametersForSIL(algorithmModel)
% helperSetModelParametersForSIL Sets model configuration parameters for
% SIL mode of simulation.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2020 The MathWorks, Inc.

% Load model if not loaded
if ~bdIsLoaded(algorithmModel)
    load_system(algorithmModel)
end

% Set parameters for algorithm model
paramNameValueDescription = {...
    'SystemTargetFile', 'ert.tlc', 'Code Generation>System target file';
    'TargetLang', 'C++', 'Code Generation>Language';
    'CodeExecutionProfiling', 'on', 'Code Generation>Verification>Measure task execution time';
    'CodeProfilingSaveOptions', 'AllData', 'Code Generation>Verification>Save options';
    'CodeExecutionProfileVariable', 'executionProfile', 'Code Generation>Verification>Workspace variable'};

for index = 1:size(paramNameValueDescription,1)
    set_param(algorithmModel,paramNameValueDescription{index,1},paramNameValueDescription{index,2});
end

disp(' ');
disp([algorithmModel ' configuration parameters:']);
disp(' ');
disp(cell2table(paramNameValueDescription,...
     'VariableNames',{'Parameter', 'Value', 'Description'}));
