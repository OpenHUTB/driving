function add(vehID, routeID, options)
%add Add a vehicle (new style with all possible parameters).
%   add(VEHID,ROUTEID) Adds a vehicle in the current time-step with ID
%   VEHID and assigns the route with ID ROUTEID to it.
%   add(...,TYPEID) Specify the type of the vehicle.
%   add(...,DEPART) Specify the departure time in seconds.
%   add(...,DEPARTLANE) Specify the lane in which the vehicle will start.
%   add(...,DEPARTPOS) Specify the position relative to the starting lane.
%   add(...,DEPARTSPEED) Specify the starting speed of the vehicle.
%   add(...,ARRIVALLANE) Specify the arrival lane of the vehicle.
%   add(...,ARRIVALPOS) Specify the arrival position of the vehicle.
%   add(...,ARRIVALSPEED) Specify the arrival speed of the vehicle.
%   add(...,FROMTAZ) Specify the starting Traffic Assignment Zone.
%   add(...,TOTAZ) Specify the arrival Traffic Assignment Zone.
%   add(...,LINE) Specify the line of this vehicle.
%   add(...,PERSONCAPACITY) Specify the person capacity of the vehicle.
%   add(...,PERSONUMBER) Specify the number of persons in the vehicle.

%   Copyright 2019 Universidad Nacional de Colombia,
%   Politecnico Jaime Isaza Cadavid.
%   Authors: Andres Acosta, Jairo Espinosa, Jorge Espinosa.
%   $Id: add.m 51 2018-12-30 22:32:29Z afacostag $

arguments
    vehID char
    routeID char
end
arguments
    options.typeID (1,:) char = 'DEFAULT_VEHTYPE'
    options.depart char = ''
    options.departLane = 'random'
    options.departPos = 'base'
    options.departSpeed = 0
    options.arrivalLane = 'current'
    options.arrivalPos char = 'max'
    options.arrivalSpeed = 'current'
    options.fromTaz char = ''
    options.toTaz char = ''
    options.line = ''
    options.personCapacity int8 {isnumeric} = 0
    options.personNumber int8 {isnumeric} = 0
end

global message
import traci.constants

typeID = options.typeID;
depart = options.depart;
departLane = options.departLane;
departPos = options.departPos;
departSpeed = options.departSpeed;
arrivalLane = options.arrivalLane;
arrivalPos = options.arrivalPos;
arrivalSpeed = options.arrivalSpeed;
fromTaz = options.fromTaz;
toTaz = options.toTaz;
line = options.line;
personCapacity = options.personCapacity;
personNumber = options.personNumber;

msgString = [uint8(sscanf(constants.TYPE_COMPOUND,'%x')) ...
    traci.packInt32(14)];

if isempty(depart)
    depart = num2str(traci.simulation.getTime());
end

values = {routeID, typeID, depart, departLane, departPos, departSpeed,...
    arrivalLane, arrivalPos, arrivalSpeed, fromTaz, toTaz, line};

for i = 1:length(values)
    msgString = [msgString uint8(sscanf(constants.TYPE_STRING,'%x')) ...
        traci.packInt32(length(values{i})) uint8(values{i})];
end

msgString = [msgString uint8(sscanf(constants.TYPE_INTEGER,'%x')) ...
    traci.packInt32(personCapacity)];
msgString = [msgString uint8(sscanf(constants.TYPE_INTEGER,'%x')) ...
    traci.packInt32(personNumber)];

traci.beginMessage(constants.CMD_SET_VEHICLE_VARIABLE, constants.ADD_FULL,...
    vehID, length(msgString));
message.string = [message.string msgString];
traci.sendExact();
end
