classdef cGeometry






properties(SetAccess=protected, Hidden=true)
    Length(1,:) double {mustBeNonNan, mustBeFinite, mustBePositive} = 4.7;  % 长度，默认值为4.7
    Width(1,:) double {mustBeNonNan, mustBeFinite, mustBePositive} = 1.8;  % 宽度，默认值为1.8
    Height(1,:) double {mustBeNonNan, mustBeFinite, mustBePositive} = 1.4;  % 高度，默认值为1.4

    Mesh = struct("Vertices", double.empty(0,3), 'Faces', double.empty(0,3));  % 网格信息，默认为空

    RCSPattern(2,2) = [10, 10; 10, 10];  % 雷达散射模式，默认值为[10, 10; 10, 10]

    RCSAzimuthAngles(1,2) = [-pi, pi];  % 雷达散射模式方位角角度范围，默认值为[-pi, pi]

    RCSElevationAngles(1,2) = [-pi/2, pi/2];  % 雷达散射模式俯仰角角度范围，默认值为[-pi/2, pi/2]
end

properties(Access=protected, Hidden=true)
    CuboidNums(1,:) uint32 {mustBeNonNan, mustBeFinite, mustBePositive} = 1;  % 立方体数量，默认值为1
end

methods(Access=public, Hidden=true)
    function obj = cGeometry(varargin)
        % 几何形状类构造函数
        %   obj = cGeometry() 构造一个几何形状类对象。
        %   obj = cGeometry(..., Name, Value, ...) 构造一个几何形状类对象，并设置属性值。

        % 构造函数可以接受一系列键值对参数（Name-Value pairs），用于设置属性值。
        % 如果传入多个输入参数，则调用updateParams方法来更新属性值。
        if nargin > 1
            obj = obj.updateParams(varargin{:});
        end
    end
        function obj=updateParams(obj,varargin)


            % 创建一个输入参数解析器对象
parser = inputParser;

% 添加可选的参数并设置默认值
addOptional(parser, 'Length', 4.7);
addOptional(parser, 'Width', 1.8);
addOptional(parser, 'Height', 1.4);
addOptional(parser, 'Mesh', -1);
addOptional(parser, 'RCSPattern', -1);
addOptional(parser, 'RCSAzimuthAngles', -1);
addOptional(parser, 'RCSElevationAngles', -1);

% 解析输入参数，并保存解析结果到results结构体中
parse(parser, varargin{:});
results = parser.Results;

% 从results结构体中获取解析后的属性值
len = results.Length;
wid = results.Width;
hei = results.Height;

            if(len~=-1&&wid~=-1&&hei~=-1)
                 % 检查长度、宽度和高度是否都不等于-1，即是否都被传入作为输入参数
                if(size(len,1)~=size(wid,1)&&size(len,1)~=...
                    size(hei,1)&&size(wid,1)~=size(hei,1))
                    % 检查长度、宽度和高度是否具有相同的维度
                    msg='Expected input to be of same dimension.';
                    disp(msg);
                       % 将长度、宽度和高度重置为默认值
                    len=4.7;
                    wid=1.8;
                    hei=1.4;
                     % 将立方体数量设置为1
                    obj.cuboidNums=1;
                end
                % 将解析后的长度、宽度和高度赋值给对象的属性
                obj.Length=len;
                obj.Width=wid;
                obj.Height=hei;
                 % 计算立方体数量，取长度、宽度和高度中的最大维度作为立方体数量
                obj.CuboidNums=max(size(len,1),size(len,2));
            end
   
            if(results.Mesh~=-1)
                % 将解析后的Mesh属性赋值给对象的Mesh属性
                obj.Mesh=results.Mesh;
            end
            % 检查解析后的参数results中是否包含非默认值的RCSPattern属性
            if(results.RCSPattern~=-1)
                % 将解析后的RCSPattern属性赋值给对象的RCSPattern属性
                obj.RCSPattern=results.RCSPattern;
            end
            % 检查解析后的参数results中是否包含非默认值的RCSAzimuthAngles属性
            if(results.RCSAzimuthAngles~=-1)
                % 将解析后的RCSAzimuthAngles属性赋值给对象的RCSAzimuthAngles属性
                obj.RCSAzimuthAngles=results.RCSAzimuthAngles;
            end
            % 检查解析后的参数results中是否包含非默认值的RCSElevationAngles属性
            if(results.RCSElevationAngles~=-1)
                % 将解析后的RCSElevationAngles属性赋值给对象的RCSElevationAngles属性
                obj.RCSElevationAngles=results.RCSElevationAngles;
            end
        end
        function data=getStruct(obj)

            % 创建一个名为"data"的结构体，用于存储"cGeometry"对象的属性值
          data.Length = obj.Length;  % 将对象的Length属性值赋值给data结构体的Length字段
          data.Width = obj.Width;    % 将对象的Width属性值赋值给data结构体的Width字段
          data.Height = obj.Height;  % 将对象的Height属性值赋值给data结构体的Height字段
          data.Mesh = obj.Mesh;      % 将对象的Mesh属性值赋值给data结构体的Mesh字段
          data.RCSPattern = obj.RCSPattern;  % 将对象的RCSPattern属性值赋值给data结构体的RCSPattern字段
          data.RCSAzimuthAngles = obj.RCSAzimuthAngles;  % 将对象的RCSAzimuthAngles属性值赋值给data结构体的RCSAzimuthAngles字段
          data.RCSElevationAngles = obj.RCSElevationAngles;  % 将对象的RCSElevationAngles属性值赋值给data结构体的RCSElevationAngles字段

        end
    end
end
