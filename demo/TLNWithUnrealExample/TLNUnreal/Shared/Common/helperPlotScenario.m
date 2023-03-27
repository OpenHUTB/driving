function hFigure = helperPlotScenario(scenarioFcnName)
% helperPlotScenario A helper function for plotting the scenario.
%
%   scenario is a drivingScenario
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%

% Copyright 2021 The MathWorks, Inc.

% Call scenario function
scenarioFcnHandle = str2func(scenarioFcnName);
scenario = scenarioFcnHandle();

hFigure = figure('Name','Scenario Test (open loop results)');
panel1 = uipanel('Position',[0 0 0.6 1]);
axis1 = axes('Parent',panel1);     
panel2 = uipanel('Position',[0.6 0 0.4 1]);
axis2 = axes('Parent',panel2);

plot(scenario,'Parent',axis1)
chasePlot(scenario.Actors(1),'Parent',axis2)

titleStr = ...
    scenarioFcnName + newline + ...
    "scenario stop time = " + scenario.StopTime + " sec";
axis1.Title.Interpreter = "none";
axis1.Title.FontWeight = "normal";
axis1.Title.String = titleStr;

vehicleProfiles = actorProfiles(scenario);

collisionDetected = false;
collisionTime = nan;

while advance(scenario) && ~collisionDetected

    vehiclePosesWorld = actorPoses(scenario);
    
    egoPoseWorld = vehiclePosesWorld(1);
    targetPosesWorld = vehiclePosesWorld(2:end);
    targetPoses = driving.scenario.targetsToEgo(targetPosesWorld,egoPoseWorld);
    
    collisionDetected = (helperSLDetectVehicleCollision(targetPoses, vehicleProfiles));
    if collisionDetected
        collisionTime = scenario.SimulationTime;
    end
    
end

if collisionDetected
    titleStr = titleStr + newline + ...
        "collision at " + collisionTime + " sec";
else
    titleStr = titleStr + newline + ...
        "no collision in scenario";
end
axis1.Title.String = titleStr;

end