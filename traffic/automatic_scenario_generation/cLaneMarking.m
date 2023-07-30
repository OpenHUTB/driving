classdef cLaneMarking

    % 定义类属性
    properties(Access=public, Hidden=true)
        Color;      % 车道标线的颜色
        ID;         % 车道标线的ID
        Type;       % 车道标线的类型
        Width;      % 车道标线的宽度
        Strength;   % 车道标线的强度
    end

    % 定义类方法
    methods(Access=public, Hidden=true)

        % cLaneMarking类的构造函数
        function obj=cLaneMarking(laneMarking)

            % 设置ID属性
            obj.ID = laneMarking.ID;

            % 将颜色默认设置为[1,1,1]（白色）
            obj.Color = [1,1,1];

            % 将强度默认设置为1
            obj.Strength = 1;

            % 根据输入的laneMarking.Type确定车道标线的类型，并相应地创建一个cMarkingType对象
            if (laneMarking.Type == 'Aggregated')
                obj.Type = cMarkingType('Aggregated');
            elseif (laneMarking.Type == 'Dashed')
                obj.Type = cMarkingType('Dashed');
            elseif (laneMarking.Type == 'DashedSolid')
                obj.Type = cMarkingType('DashedSolid');
            elseif (laneMarking.Type == 'DoubleDashed')
                obj.Type = cMarkingType('DoubleDashed');
            elseif (laneMarking.Type == 'DoubleSolid')
                obj.Type = cMarkingType('DoubleSolid');
            elseif (laneMarking.Type == 'Solid')
                obj.Type = cMarkingType('Solid');
            elseif (laneMarking.Type == 'SolidDashed')
                obj.Type = cMarkingType('SolidDashed');
            elseif (laneMarking.Type == 'Unmarked')
                obj.Type = cMarkingType('Unmarked');
            else
                obj.Type = cMarkingType('Unknown'); % 如果无法识别车道标线类型，则将其设置为“Unknown”
            end
        end
    end
end

