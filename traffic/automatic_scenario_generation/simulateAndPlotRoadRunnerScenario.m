function simulateAndPlotRoadRunnerScenario(rrProjPath, rrAppPath, scenarioFileName)
    % % 您可以使用roadrunner函数创建对象并启动 RoadRunner 方案会话。该函数需要一个参数来指定 RoadRunner 项目的位置。
    rrApp = roadrunner(rrProjPath, InstallationFolder=rrAppPath);
    
    % 通过使用函数并指定要打开的对象和特定方案，在 RoadRunner 方案中打开现有方案。
    openScenario(rrApp, scenarioFileName);
    
    % 将场景加载到 RoadRunner 场景中后，通过使用 createSimulation函数创建模拟对象来自动执行模拟任务。模拟对象使您能够以编程方式与方案模拟进行交互。
    rrSim = createSimulation(rrApp);
    
    % 将最大模拟时间设置为 20 秒。
    maxSimulationTimeSec = 20;
    set(rrSim, 'MaxSimulationTime', maxSimulationTimeSec);
%     启用仿真结果日志记录，以便以后可以绘制结果
    set(rrSim, 'Logging', 'on');
    
    % 开始模拟。使用while循环监视模拟的状态，并等待模拟完成。
    set(rrSim, 'SimulationCommand', 'Start');
    while strcmp(get(rrSim, 'SimulationStatus'), 'Running')
        pause(1);
    end
    
    % Retrieve simulation log
    rrLog = get(rrSim, 'SimulationLog');
    
    % Extract velocity data
    numActors = 4;
    velocityData = cell(1, numActors);
    for actorID = 1:numActors
        velocityData{actorID} = get(rrLog, 'Velocity', 'ActorID', actorID);
    end
    
    time = [velocityData{1}.Time];
    
    % Calculate velocity magnitudes
    velMagData = cell(1, numActors);
    for actorID = 1:numActors
        velMagData{actorID} = arrayfun(@(x) norm(x.Velocity, 2), velocityData{actorID});
    end
    
    % Plot agent velocities
    figure
    hold on
    colors = ['r', 'b', 'g', 'k'];
    for actorID = 1:numActors
        plot(time, velMagData{actorID}, colors(actorID));
    end
    grid on
    title("Agent Velocities from RoadRunner Scenario")
    ylabel("Velocity (m/sec)")
    xlabel("Time (sec)")
    legend("Actor ID = 1", "Actor ID = 2", "Actor ID = 3", "Actor ID = 4")
    
    % Retrieve map information
    hdMap = getMap(rrSim);
    lanes = hdMap.map.lanes;
    
    % Plot lanes and actor positions
    figure
    hold on
    for i = 1:numel(lanes)
        control_points = lanes(i).geometry.values;
        x_coordinates = arrayfun(@(cp) cp.x, control_points);
        y_coordinates = arrayfun(@(cp) cp.y, control_points);
        plot(x_coordinates, y_coordinates, 'black');
    end
    
    actorPositions = cell(1, numActors);
    for actorID = 1:numActors
        poseActor = rrLog.get('Pose', 'ActorID', actorID);
        position_x = arrayfun(@(x) x.Pose(1, 4), poseActor);
        position_y = arrayfun(@(x) x.Pose(2, 4), poseActor);
        actorPositions{actorID} = [position_x', position_y'];
    end
    
    for actorID = 1:numActors
        plot(actorPositions{actorID}(:, 1), actorPositions{actorID}(:, 2), 'LineWidth', 2);
    end
    
    axis equal
    title("Vehicle Positions in RoadRunner Scenario")
    ylabel("Y (m)")
    xlabel("X (m)")
    figure(gcf)
    
    % Write position data to a file
    fid = fopen('positions.txt', 'w');
    fprintf(fid, 'timestamp ');
    for actorID = 1:numActors
        fprintf(fid, 'Actor%d_x \t\t Actor%d_y ', actorID, actorID);   
    end
    fprintf(fid, '\n');
    
    for timestep = 1:numel(position_x) 
        timestamp = time(timestep);  
        fprintf(fid, '%f ', timestamp); 
        
        for actorID = 1:numActors      
            fprintf(fid, '%f %f ', actorPositions{actorID}(timestep, 1),...
                                    actorPositions{actorID}(timestep, 2));
        end
        fprintf(fid, '\n');
    end
    
    fclose(fid);
    
    % Close simulation and application
    close(rrApp)
end

