classdef cLane




    properties(Access=public, Hidden=true)

    ID;  % 车辆的ID属性

    Direction;  % 行驶方向属性，表示车辆的行驶方向

    LeftMarkingID;  % 左侧标记ID属性，表示车辆左侧的标记物的ID

    LeftMarkingIndex;  % 左侧标记索引属性，表示车辆左侧的标记物的索引

    RightMarkingID;  % 右侧标记ID属性，表示车辆右侧的标记物的ID

    RightMarkingIndex;  % 右侧标记索引属性，表示车辆右侧的标记物的索引

    SpeedLimit = -1;  % 速度限制属性，表示车辆的速度限制，默认值为-1，表示未设置速度限制

    Type;  % 车辆类型属性，表示车辆的类型

    Width;  % 车辆宽度属性，表示车辆的宽度
end

    methods(Access=public,Hidden=true)
        function obj=cLane(lane)

            % 根据输入参数lane中的Direction属性值，设置obj对象的Direction属性为相应的枚举值

if(strcmpi(lane.Direction,'Forward'))
    % 如果lane.Direction为'Forward'，则设置obj.Direction为cDirectionOfTravel枚举类型的'Forward'
    obj.Direction = cDirectionOfTravel('Forward');
elseif strcmpi(lane.Direction, 'Backward')
    % 如果lane.Direction为'Backward'，则设置obj.Direction为cDirectionOfTravel枚举类型的'Backward'
    obj.Direction = cDirectionOfTravel('Backward');
elseif strcmpi(lane.Direction, 'None')
    % 如果lane.Direction为'None'，则设置obj.Direction为cDirectionOfTravel枚举类型的'None'
    obj.Direction = cDirectionOfTravel('None');
elseif strcmpi(lane.Direction, 'Both')
    % 如果lane.Direction为'Both'，则设置obj.Direction为cDirectionOfTravel枚举类型的'Both'
    obj.Direction = cDirectionOfTravel('Both');
else
    % 如果lane.Direction既不是'Forward'、'Backward'、'None'、'Both'中的任何一个，则设置obj.Direction为cDirectionOfTravel枚举类型的'Unknown'
    obj.Direction = cDirectionOfTravel('Unknown');
end

            obj.ID = lane.ID;  % 将lane对象的ID属性值赋值给obj对象的ID属性
obj.Direction = lane.Direction;  % 将lane对象的Direction属性值赋值给obj对象的Direction属性
obj.Width = lane.Width;  % 将lane对象的Width属性值赋值给obj对象的Width属性
obj.LeftMarkingID = lane.LeftMarkingID;  % 将lane对象的LeftMarkingID属性值赋值给obj对象的LeftMarkingID属性
obj.RightMarkingID = lane.RightMarkingID;  % 将lane对象的RightMarkingID属性值赋值给obj对象的RightMarkingID属性

% 根据输入参数lane的Type属性值，设置obj对象的Type属性为相应的枚举值
            if(strcmpi(lane.Type,'Shoulder'))
        % 如果lane.Type为'Shoulder'，则设置obj.Type为cLaneType枚举类型的'Shoulder'
                obj.Type=cLaneType('Shoulder');
            elseif(strcmpi(lane.Type,'Restricted'))
        % 如果lane.Type为'Restricted'，则设置obj.Type为cLaneType枚举类型的'Restricted'
                obj.Type=cLaneType('Restricted');
            elseif(strcmpi(lane.Type,'Parking'))
        % 如果lane.Type为'Parking'，则设置obj.Type为cLaneType枚举类型的'Parking'
                obj.Type=cLaneType('Parking');
            elseif(strcmpi(lane.Type,'HOV'))
                % 如果lane.Type为'HOV'，则设置obj.Type为cLaneType枚举类型的'HOV'
                obj.Type=cLaneType('HOV');
            elseif(strcmpi(lane.Type,'Express'))
                 % 如果lane.Type为'Express'，则设置obj.Type为cLaneType枚举类型的'Express'
                obj.Type=cLaneType('Express');
            elseif(strcmpi(lane.Type,'Driving'))
                 % 如果lane.Type为'Driving'，则设置obj.Type为cLaneType枚举类型的'Driving'
                obj.Type=cLaneType('Driving');
            elseif(strcmpi(lane.Type,'Bus'))
                % 如果lane.Type为'Bus'，则设置obj.Type为cLaneType枚举类型的'Bus'
                obj.Type=cLaneType('Bus');
            elseif(strcmpi(lane.Type,'Border'))
                % 如果lane.Type为'Border'，则设置obj.Type为cLaneType枚举类型的'Border'
                obj.Type=cLaneType('Border');
            elseif(strcmpi(lane.Type,'Bicycle'))
                % 如果lane.Type为'Bicycle'，则设置obj.Type为cLaneType枚举类型的'Bicycle'
                obj.Type=cLaneType('Bicycle');
            elseif(strcmpi(lane.Type,'Pedestrian'))
                 % 如果lane.Type为'Pedestrian'，则设置obj.Type为cLaneType枚举类型的'Pedestrian'
                obj.Type=cLaneType('Pedestrian');
            else
                % 如果lane.Type既不是上述情况中的任何一个，则设置obj.Type为cLaneType枚举类型的'Unknown'
                obj.Type=cLaneType('Unknown');
            end
        end
        function[color,strength]=getColor(~,lane)

            strength = lane.Strength;  % 获取lane对象的Strength属性值，并赋给变量strength

laneColor = lane.Color.toArray;  % 将lane对象的Color属性转换为数组，并赋给变量laneColor

if ~isempty(laneColor)
    % 如果laneColor非空，则将其前三个元素分别作为color数组的红、绿、蓝分量
    color = [laneColor(1), laneColor(2), laneColor(3)];
else
    % 如果laneColor为空，则将color数组的三个分量都设置为0，表示黑色
    color = [0, 0, 0];
end

        end
        function data=getStruct(obj)
           data.ID = obj.ID;  % 将obj对象的ID属性值赋值给data结构体的ID字段
data.Direction = obj.Direction;  % 将obj对象的Direction属性值赋值给data结构体的Direction字段
data.LeftMarkingID = obj.LeftMarkingID;  % 将obj对象的LeftMarkingID属性值赋值给data结构体的LeftMarkingID字段
data.LeftMarkingIndex = obj.LeftMarkingIndex;  % 将obj对象的LeftMarkingIndex属性值赋值给data结构体的LeftMarkingIndex字段
data.RightMarkingID = obj.RightMarkingID;  % 将obj对象的RightMarkingID属性值赋值给data结构体的RightMarkingID字段
data.RightMarkingIndex = obj.RightMarkingIndex;  % 将obj对象的RightMarkingIndex属性值赋值给data结构体的RightMarkingIndex字段
data.SpeedLimit = obj.SpeedLimit;  % 将obj对象的SpeedLimit属性值赋值给data结构体的SpeedLimit字段
data.Type = obj.Type;  % 将obj对象的Type属性值赋值给data结构体的Type字段
data.Width = obj.Width;  % 将obj对象的Width属性值赋值给data结构体的Width字段

        end

    end
end
