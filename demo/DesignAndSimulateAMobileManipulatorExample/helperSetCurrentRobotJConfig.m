function configResp = helperSetCurrentRobotJConfig(JConfig)
% Set a desired robot configuration to Gazebo via ROS
        configClient = rossvcclient('/gazebo/set_model_configuration');
        configReq = rosmessage(configClient);
        configReq.ModelName = "husky_gen3";
        configReq.UrdfParamName = "/husky_gen3/robot_description";
        configReq.JointNames = {'joint_1','joint_2','joint_3','joint_4','joint_5','joint_6','joint_7'};
        configReq.JointPositions = JConfig; 
        configResp = call(configClient, configReq, 'Timeout', 3);
end