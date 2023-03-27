function helperSetModelParametersForPIL(algorithmModel)
% helperSetModelParametersForPIL sets model configuration parameters for
% PIL mode of simulation.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2022 The MathWorks, Inc.

% Load model if not loaded
if ~bdIsLoaded(algorithmModel)
    load_system(algorithmModel)
end

% Set parameters for algorithm model
paramNameValueDescription = {...
    'SystemTargetFile', 'ert.tlc', 'Code Generation>System target file';
    'TargetLang', 'C', 'Code Generation>Language';
    'PropagateVarSize', 'During execution', 'Model Referencing>Options for referencing this model';
    'MATLABDynamicMemAlloc', 'off', 'Simulation Target>Advanced parameters';
    'CodeInterfacePackaging', 'Reusable function','Code Generation>Interface>Code interface packaging';
    'EnableRuntimeRecursion', 'off', 'Simulation Target>Advanced parameters';
    'CodeExecutionProfiling', 'on', 'Code Generation>Verification>Measure task execution time';
    'CodeProfilingSaveOptions', 'AllData', 'Code Generation>Verification>Save options';
    'CodeExecutionProfileVariable', 'executionProfile', 'Code Generation>Verification>Workspace variable';
    'GenerateCodeMetricsReport', 'on', 'Code Generation>Report';
    'GenerateReport', 'on', 'Code Generation>Report'};

for index = 1:size(paramNameValueDescription,1)
    set_param(algorithmModel,paramNameValueDescription{index,1},paramNameValueDescription{index,2});
end

disp(' ');
disp([algorithmModel ' configuration parameters:']);
disp(' ');
disp(cell2table(paramNameValueDescription,...
     'VariableNames',{'Parameter', 'Value', 'Description'}));
end