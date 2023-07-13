classdef cMarkingType<uint32



    enumeration
        Unknown(0)
        Unsupported(1)
        CrossWalk(2)
        LeftTurn(3)
        LeftTurnOnly(4)
        RightTurn(5)
        RightTurnOnly(6)
        Ahead(7)
        Merge(8)
        Diverge(9)
        DoNotCross(10)
        AheadOrLeft(11)
        AheadOrRight(12)
        LeftOrRight(13)
        AheadOrLeftOrRight(14)
        DoNotEnter(15)
        ZebraCrossing(16)
        NoParking(17)
        Stop(18)
        Warning(19)
        EnterToAcceleratorLane(20)
        ExitToSlowLane(21)
        Hazard(22)
        Aggregated(23)
        Dashed(24)
        DashedSolid(25)
        DoubleDashed(26)
        DoubleSolid(27)
        Solid(28)
        SolidDashed(29)
        Unmarked(30)
    end
end