function lgraph = create_critic_network()

lgraph = layerGraph();
% Add layer branches
tempLayers = [
    imageInputLayer([100 100 1],"Name","OccupancyGrid","Normalization","none")
    convolution2dLayer([10 10],2,"Name","grid_conv1","Padding","same","Stride",[5 5])
    reluLayer("Name","grid_relu")
    dropoutLayer(0.25,"Name","dropout_1")
    fullyConnectedLayer(400,"Name","critic_action_fc1")
    reluLayer("Name","relu_1")
    fullyConnectedLayer(300,"Name","fc")
    dropoutLayer(0.25,"Name","dropout_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    imageInputLayer([1 1 1],"Name","CurrentLane","Normalization","none")
    fullyConnectedLayer(400,"Name","CriticLaneFC1")
    reluLayer("Name","critic_state_Relu1_2")
    fullyConnectedLayer(300,"Name","CriticLaneFC2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    imageInputLayer([5 1 1],"Name","VehicleStates","Normalization","none")
    fullyConnectedLayer(400,"Name","CriticStateFC1")
    reluLayer("Name","critic_state_Relu1_1")
    fullyConnectedLayer(300,"Name","CriticStateFC2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    imageInputLayer([1 1 1],"Name","VehicleDiscreteMetaAction","Normalization","none")
    fullyConnectedLayer(300,"Name","ActionFC1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(4,"Name","addition")
    reluLayer("Name","relu_2")
    fullyConnectedLayer(1,"Name","stateValue")];
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;

% connect layer branches
lgraph = connectLayers(lgraph,"CriticStateFC2","addition/in2");
lgraph = connectLayers(lgraph,"dropout_2","addition/in1");
lgraph = connectLayers(lgraph,"CriticLaneFC2","addition/in3");
lgraph = connectLayers(lgraph,"ActionFC1","addition/in4");
% Plot layers
figure
plot(lgraph);
end