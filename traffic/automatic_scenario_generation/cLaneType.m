classdef cLaneType < uint32
    % cLaneType 类用于表示车道类型的不同枚举值，并继承自 uint32 类型。

    enumeration
        Unknown(0)          % 未知车道类型，对应值 0
        Unsupported(1)      % 不支持的车道类型，对应值 1
        Shoulder(2)         % 路肩车道，对应值 2
        Restricted(3)       % 限制通行车道，对应值 3
        Parking(4)          % 停车车道，对应值 4
        HOV(5)              % 高 Occupancy Vehicle (HOV) 车道，对应值 5
        Express(6)          % 快车道，对应值 6
        Driving(7)          % 普通行驶车道，对应值 7
        Bus(8)              % 公交车道，对应值 8
        Border(9)           % 边界车道，对应值 9
        Bicycle(10)         % 自行车道，对应值 10
        Pedestrian(11)      % 行人道，对应值 11
    end
end
