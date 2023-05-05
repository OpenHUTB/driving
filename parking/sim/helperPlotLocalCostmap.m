function helperPlotLocalCostmap(costmap, refPath)
%helperPlotLocalCostmap Plot the final parking maneuver

% Plot path
fh=figure;
fh.Name        = 'Parking Maneuver';
fh.NumberTitle = 'off';
ax             = axes(fh);
plot(costmap, 'Parent', ax, 'Inflation', 'off');
legend off
axis tight
hold(ax, 'on');
title(ax, '');

plot(refath);

ax.XLim = costmap.MapExtent(1:2);
ax.YLim = costmap.MapExtent(3:4);

end