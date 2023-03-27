function hFigure = helperPlotChannelInfo(V2VRange1,V2VRange2)
% Helper file to plot and compare the SNR and throughput characteristics of 
% V2V communication channel for different range

% NOTE: This is a helper function for example purposes and may be 
% removed or modified in the future.

% Copyright 2021 The MathWorks, Inc.

%   V2VRange1: - Option to set V2VRange1
%                - Valid values (0 - 1000 meter)
%                - 150 meter is default 

%   V2VRange2: - Option to set V2VRange2
%                - Valid values (0 - 1000 meter)
%                - 50 meter is default 

%   Examples of calling this function:
%   -----------------------------------
%   To plot the channel characteristics:
%       helperPlotChannelInfo();
%       helperPlotChannelInfo(300);
%   To compare the channel characteristics for 2 different range:
%       helperPlotChannelInfo(150,50);
%       helperPlotChannelInfo(300,500);

arguments
    % Vehicle-to-Vehicle communication Range. Default value set to 150m
    V2VRange1(1,1) {mustBeNonnegative(V2VRange1), ...
    mustBeLessThanOrEqual(V2VRange1,1000)} = 150;
    % Vehicle-to-Vehicle communication Range. Default value set to 150m
    V2VRange2(1,1) {mustBeNonnegative(V2VRange2), ...
    mustBeLessThanOrEqual(V2VRange2,1000)} = 50;
end

% Create the figure object
figureName = 'V2V Channel Characteristics';
hFigure = findobj('Type','figure','Name',figureName);
if isempty(hFigure)
    screenSize = double(get(groot,'ScreenSize'));
    hFigure = figure('Name',figureName,'Tag',figureName);
    hFigure.Position = [screenSize(3)*0.25 screenSize(4)*0.255 screenSize(3)*0.5 screenSize(4)*0.5];
    hFigure.NumberTitle = 'off';
end
 % Clear figure
 clf(hFigure)

 % Load Channel Info
snrCurves = load('V2XChannelInfo.mat').snrCurves;
[dist2snr,snr2tput,dist2tput] = getChannelData(snrCurves,V2VRange1);

% plot Distance vs SNR
h1 = subplot(3,1,1);
plot(dist2snr(:,1),dist2snr(:,2))
grid on;
xlabel('Distance (m)')
ylabel('SNR (dB)')
title('Distance vs SNR')

% plot SNR vs Throughput
h2 = subplot(3,1,2);
plot(snr2tput(:,1),snr2tput(:,2))
grid on;
xlabel('SNR (dB)')
ylabel('Throughput (%)')
title('SNR vs Throughput')


h3 = subplot(3,1,3);
% plot Distance vs Throughput
plot(dist2tput)
grid on;
xlabel('Distance (m)')
ylabel('Throughput (%)')
xticks(0:50:1100)
title('Distance vs Throughput')

if nargin == 2
    [dist2snr,snr2tput,dist2tput] = getChannelData(snrCurves,V2VRange2);
    legendstr1 = sprintf("%d m Range",V2VRange1);
    legendstr2 = sprintf("%d m Range",V2VRange2);

    set(h1,'NextPlot','add');
    plot(h1,dist2snr(:,1),dist2snr(:,2),'--',LineWidth=2)
    legend(h1,legendstr1,legendstr2)

    set(h2,'NextPlot','add'); 
    plot(h2,snr2tput(:,1),snr2tput(:,2),'--',LineWidth=2)
    legend(h2,legendstr1,legendstr2)

    set(h3,'NextPlot','add');
    plot(h3,dist2tput,'--',LineWidth=2)
    legend(h3,legendstr1,legendstr2)
else
    legendstr1 = sprintf("%d m Range",V2VRange1);
    legend(h1,legendstr1)
    legend(h2,legendstr1)
    legend(h3,legendstr1)
end

end

function [dist2snr,snr2tput,dist2tput] = getChannelData(snrCurves,range)
    % Extract the SNR & Throughtput data
    dist2snr = snrCurves.dist2snr;
    snr2tput = snrCurves.snr2tput;
    % SNR Offset index
    index = range + 1;
    % Shift the Distance vs SNR curve based on range
    dist2snr(:,2) = dist2snr(:,2) +  snrCurves.snrOffset(index);
    fsnr  = @(x)interp1(dist2snr(:,1),dist2snr(:,2),x,"spline");
    ftput = @(x)interp1(snr2tput(:,1),snr2tput(:,2),x,"spline");
    dist2tput = [];
    n = size(dist2snr,1);
    % compute distance vs throughput data
    for i = 1:n
        snr = fsnr(i);
        if snr>15
            tput = 100;
        elseif snr<-15
            tput = 0;
        else
            tput = ftput(snr);
        end
        dist2tput = [dist2tput;tput];
    end
end
