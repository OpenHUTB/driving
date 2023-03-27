function helperActivateGripperMobileArm(state)
% Copyright 2021 The MathWorks, Inc.
   
persistent gripAct gripGoal gripperCommand

if isempty(gripAct) || ~isvalid(gripAct)
     pause(1)
     [gripAct,gripGoal] = rosactionclient('/husky_gen3/custom_gripper_controller/gripper_cmd');
     gripperCommand = rosmessage('control_msgs/GripperCommand');
     pause(3);
end

if state == 1
           % Activate gripper
            %pause(1);
            gripperCommand.Position = 0.06; % 0.04 fully closed, 0 fully open
            gripperCommand.MaxEffort = 1000;
            gripGoal.Command = gripperCommand;            
            %pause(1);
            disp(gripAct)
            % Send command
            sendGoal(gripAct,gripGoal); 
            disp('Gripper closed...');
elseif state == 0 
           % Deactivate gripper
            %pause(1);
            gripperCommand.Position = 0.0; % 0.04 fully closed, 0 fully open
            gripperCommand.MaxEffort = 1000;
            gripGoal.Command = gripperCommand;
            %pause(1);
            % Send command
            sendGoal(gripAct,gripGoal);
            disp('Gripper open...');
end
end





