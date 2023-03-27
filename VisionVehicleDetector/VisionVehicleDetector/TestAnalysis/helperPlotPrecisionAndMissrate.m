function helperPlotPrecisionAndMissrate(detectionMetrics, detector)
% helperPlotPrecisionAndMissrate A helper function for plotting the vehicle
% detector metrics computed from VisionVehicleDetectorTestBench.slx.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the elements to be plotted.

% Copyright 2020-2021 The MathWorks, Inc.

arguments (Repeating)
    detectionMetrics
    detector string
end

newLineDispOffset = 0;
%% Compute the precision and miss rate from  logsout
for i = 1:size(detectionMetrics,2)

    f1 = figure(1);
    f1.Name= 'recall vs precision';
    f1.Position = [835 100 720 600];
    hold on;
    plot(detectionMetrics{i}.recall, detectionMetrics{i}.precision);
    grid on
    ylim([0 1]);
    title('recall vs precision ', 'Color', 'blue');

    newLineDispOffset = newLineDispOffset + 0.05;

    ylimit = get(gca,'ylim');
    xlimit = get(gca,'xlim');
    text(xlimit(1), ylimit(2), sprintf(' \n\n Average precision'), 'Color', 'blue')

    text(xlimit(1), ylimit(2) - newLineDispOffset , sprintf(' \n\n %s = %.1f ', detector{1,i}, detectionMetrics{i}.avgPrecision), 'Color', 'blue', 'FontSize', 8);

    xlabel('Recall');
    ylabel('Precision');

    f2 = figure(2);
    f2.Name= 'fppi vs missrate';
    f2.Position = [835 100 720 600];
    hold on;
    loglog(detectionMetrics{i}.fppi, detectionMetrics{i}.missRate);
    hold on;
    grid on
    ylim([0 1]);
    title('fppi vs missrate ', 'Color', 'blue');

    ylimit = get(gca,'ylim');
    xlimit = get(gca,'xlim');
    text(xlimit(1) , ylimit(2), sprintf(' \n\n Average Missrate'), 'Color', 'blue');
    text(xlimit(1) , ylimit(2) - newLineDispOffset , sprintf(' \n\n %s = %.1f', detector{1,i}, detectionMetrics{i}.averageMissrate), 'Color', 'blue', 'FontSize', 8);

    xlabel('False Positives Per Image (FPPI)');
    ylabel('Miss Rate');
    hold off;
end
end
