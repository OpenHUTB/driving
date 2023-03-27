function helperSetModelParametersForCodeGeneration(models)
% helperSetModelParametersForCodeGeneration Sets model configuration
% parameters for C++ code generation.
%
% This function can accept single model name and cell array of model names
% as shown below:
% Set parameters for single model: 
% helperSetModelParametersForCodeGeneration('Model1.slx');
%
% Set parameters for multiple models:
% helperSetModelParametersForCodeGeneration({'Model1.slx',Model2.slx',Model3.slx'});
%
% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2020-2021 The MathWorks, Inc.

% Set parameters for code generation
paramNameValueDescription = {...
    'SystemTargetFile', 'ert.tlc', 'Code Generation>System target file';
    'TargetLang', 'C++', 'Code Generation>Language';
    'SolverType', 'Fixed-step', 'Solver>Type';
    'FixedStep', 'auto', 'Solver>Fixed-step size (fundamental sample time)';
    'EnableMultiTasking', 'on', 'Solver>Treat each discrete rate as a separate task';
    'ProdLongLongMode', 'on', 'Hardware Implementation>Support long long';
    'BlockReduction', 'on', 'Simulation Target>Block reduction';
    'MATLABDynamicMemAlloc', 'on',  'Simulation Target>Simulation Target>Dynamic memory allocation in MATLAB functions';
    'OptimizeBlockIOStorage', 'on', 'Simulation Target>Signal storage reuse';
    'InlineInvariantSignals', 'on', 'Simulation Target>Inline invariant signals';
    'BuildConfiguration', 'Faster Runs', 'Code Generation>Build configuration';
    'RTWVerbose', 'off', 'Code Generation>Verbose build';
    'CombineSignalStateStructs', 'on', 'Code Generation>Interface>Combine signal/state structures';
    'SupportVariableSizeSignals', 'on', 'Code Generation>Interface>Support variable-size signals';
    'CodeInterfacePackaging','C++ class', 'Code Generation>Interface>Code interface packaging';
    'GenerateExternalIOAccessMethods','Method','Code Generation>Interface>Data Member Visibility>External I/O access';
    'EfficientFloat2IntCast', 'on', 'Code Generation>Optimization>Remove code from floating-point to integer conversions that wraps out-of-range values';
    'ZeroExternalMemoryAtStartup', 'off', 'Code Generation>Optimization>Remove root level I/O zero initialization (inverse logic)';
    'CustomSymbolStrGlobalVar', '$N$M', 'Code Generation>Symbols>Global variables';
    'CustomSymbolStrType', '$N$M_T', 'Code Generation>Symbols>Global types';
    'CustomSymbolStrField', '$N$M', 'Code Generation>Symbols>Field name of global types';
    'CustomSymbolStrFcn', 'APV_$N$M$F', 'Code Generation>Symbols>Subsystem methods';
    'CustomSymbolStrTmpVar', '$N$M', 'Code Generation>Symbols>Local temporary variables';
    'CustomSymbolStrMacro', '$N$M', 'Code Generation>Symbols>Constant macros'};


if iscell(models)
    for i=1:numel(models)
        model = models{i};

        % Load model if not loaded
        if ~bdIsLoaded(model)
            load_system(model)
        end

        for index = 1:size(paramNameValueDescription,1)
            set_param(model,paramNameValueDescription{index,1},paramNameValueDescription{index,2});
        end
    end
else
    % Load model if not loaded
    if ~bdIsLoaded(models)
        load_system(models)
    end
    for index = 1:size(paramNameValueDescription,1)
        set_param(models,paramNameValueDescription{index,1},paramNameValueDescription{index,2});
    end
end
disp(' ');
disp([' Model ' ' configuration parameters: ']);
disp(' ');
disp(cell2table(paramNameValueDescription,...
    'VariableNames',{'Parameter', 'Value', 'Description'}));
end