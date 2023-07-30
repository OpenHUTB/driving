classdef cMarkingType < uint32
    % cMarkingType 类用于表示车道标线类型的不同枚举值，并继承自 uint32 类型。

    enumeration
        Unknown(0)                  % 未知车道标线类型，对应值 0
        Unsupported(1)              % 不支持的车道标线类型，对应值 1
        CrossWalk(2)                % 斑马线，对应值 2
        LeftTurn(3)                 % 左转车道标线，对应值 3
        LeftTurnOnly(4)             % 左转专用车道标线，对应值 4
        RightTurn(5)                % 右转车道标线，对应值 5
        RightTurnOnly(6)            % 右转专用车道标线，对应值 6
        Ahead(7)                    % 直行车道标线，对应值 7
        Merge(8)                    % 合并车道标线，对应值 8
        Diverge(9)                  % 分离车道标线，对应值 9
        DoNotCross(10)              % 禁止穿越标线，对应值 10
        AheadOrLeft(11)             % 直行或左转车道标线，对应值 11
        AheadOrRight(12)            % 直行或右转车道标线，对应值 12
        LeftOrRight(13)             % 左转或右转车道标线，对应值 13
        AheadOrLeftOrRight(14)      % 直行或左转或右转车道标线，对应值 14
        DoNotEnter(15)              % 禁止进入标线，对应值 15
        ZebraCrossing(16)           % 斑马线过街标线，对应值 16
        NoParking(17)               % 禁止停车标线，对应值 17
        Stop(18)                    % 停车标线，对应值 18
        Warning(19)                 % 警告标线，对应值 19
        EnterToAcceleratorLane(20)  % 进入加速车道标线，对应值 20
        ExitToSlowLane(21)          % 进入减速车道标线，对应值 21
        Hazard(22)                  % 危险标线，对应值 22
        Aggregated(23)              % 聚合车道标线，对应值 23
        Dashed(24)                  % 虚线车道标线，对应值 24
        DashedSolid(25)             % 虚线与实线组合车道标线，对应值 25
        DoubleDashed(26)            % 双虚线车道标线，对应值 26
        DoubleSolid(27)             % 双实线车道标线，对应值 27
        Solid(28)                   % 实线车道标线，对应值 28
        SolidDashed(29)             % 实线与虚线组合车道标线，对应值 29
        Unmarked(30)                % 未标记车道标线，对应值 30
    end
end
