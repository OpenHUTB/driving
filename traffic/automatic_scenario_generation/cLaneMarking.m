classdef cLaneMarking



    properties(Access=public,Hidden=true)

        Color;

        ID;

        Type;

        Width;

        Strength;
    end
    methods(Access=public,Hidden=true)
        function obj=cLaneMarking(laneMarking)

            obj.ID=laneMarking.ID;
            obj.Color=[1,1,1];
            obj.Strength=1;
            if(laneMarking.Type=='Aggregated')
                obj.Type=cMarkingType('Aggregated');
            elseif(laneMarking.Type=='Dashed')
                obj.Type=cMarkingType('Dashed');
            elseif(laneMarking.Type=='DashedSolid')
                obj.Type=cMarkingType('DashedSolid');
            elseif(laneMarking.Type=='DoubleDashed')
                obj.Type=cMarkingType('DoubleDashed');
            elseif(laneMarking.Type=='DoubleSolid')
                obj.Type=cMarkingType('DoubleSolid');
            elseif(laneMarking.Type=='Solid')
                obj.Type=cMarkingType('Solid');
            elseif(laneMarking.Type=='SolidDashed')
                obj.Type=cMarkingType('SolidDashed');
            elseif(laneMarking.Type=='Unmarked')
                obj.Type=cMarkingType('Unmarked');
            else
                obj.Type=cMarkingType('Unknown');
            end
        end
    end
end

