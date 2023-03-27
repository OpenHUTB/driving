function helperPlotExecutionProfile(executionProfile)
%helperPlotExecutionProfile Plots the simulation time taken by the step
%function that is generated.
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2020-2021 The MathWorks, Inc.

%%  Extract Simulation time and sample time taken for step function
    % Iterate over all sections of execution profile data and get the index
    % of step section.
    for i =1 : size(executionProfile.Sections, 2)
        tf = strncmp(executionProfile.Sections(i).Name, "step",4);
        if(tf == 1)
            stepSectionIndex = i;
        break;
        end 
    end
    step0_executionTime = executionProfile.Sections(stepSectionIndex).ExecutionTimeInSeconds;
    step0_sampleTime = executionProfile.Sections(stepSectionIndex).Time;  
    endTime = step0_sampleTime(end);
    figure('Name','Execution profiles');
    h = subplot(1,1,1);
    line(h,step0_sampleTime,step0_executionTime,'Color','Red');
    grid on;
    title('SIL Task Execution Time')
    xlabel('Simulation Time (sec)');
    ylabel('Time (sec)');
    xlim([0 endTime]);
    ylim([0 0.25]);
end