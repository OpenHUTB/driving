classdef cActor<matlab.mixin.Heterogeneous
    
    %定义隐藏的公共属性
    properties(Access=public,Hidden=true)

        %表示道路 ID 的无符号 32 位整数。它必须是非 NaN 和有限值。
        RoadID(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        %表示道路索引的有符号 32 位整数。它必须是非 NaN 和有限值。
        RoadIndex(1,1)int32{mustBeNonNan,mustBeFinite}=0;

        %表示道路类型的无符号 32 位整数。它必须是非 NaN 和有限值。
        RoadType(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        %表示通道类型的无符号 32 位整数。它必须是非 NaN 和有限值。
        LaneType(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        %表示属性类型的无符号 32 位整数。它必须是非 NaN 和有限值。
        Type(1,1)uint32{mustBeNonNan,mustBeFinite}=0;
    end

    properties(SetAccess=protected,Hidden=true)

        %ID：一个无符号的 32 位整数，表示对象的 ID。
        ID(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        %表示对象的姿势（位置和方向）的属性。
        Pose;

        %表示对象几何图形的属性。
        Geometry(1,1)cGeometry;

        %表示对象的索引的属性
        Index;

        %表示对象名称的字符数组。
        Name(1,:)char;

        %表示对象颜色的属性。它是一个 1 x 3 无符号 32 位整数数组，用于存储颜色的 RGB 值。
        Color(1,3)uint32{mustBeNonNan,mustBeFinite};
    end

    methods(Access=public,Hidden=true)
        function obj=cActor(actor,index)
            % 创建cActor类的实例对象obj
            % actor:传入的参考actor对象 
            % index:cActor对象的索引值

            %  设置对象属性：id、名字、索引
            obj.ID=actor.ID;
            obj.Name=actor.Name;
            obj.Index=uint32(index);
           
             % 调用cPose构造函数,创建Pose属性对象
             % 将actor的位置和姿态数据传给cPose
            obj.Pose=cPose([actor.PositionX,actor.PositionY...
            ,actor.PositionZ],[actor.Yaw...
            ,actor.Pitch,actor.Roll]);
            
            % 调用cGeometry构造函数,创建Geometry属性对象
            % 将actor的大小数据传给cGeometry 
            obj.Geometry=cGeometry('Length',actor.Length,'Width',...
            actor.Width,'Height',actor.Height);
            % 设置Color属性为RGB颜色数组
            obj.Color=[actor.Color(1),actor.Color(2),actor.Color(3)];
        end

        % 获取对象的3D位置
        function pos=getPosition(obj)

            pos=[obj.Pose.Position.X,obj.Pose.Position.Y...
            ,obj.Pose.Position.Z];
        end

        % 获取对象的3D位置
        function pos=getPosition2D(obj)

            pos=[obj.Pose.Position.X,obj.Pose.Position.Y];
        end

        % 更新Geometry对象参数
        function obj=updateGeometry(obj,varargin)

            obj.Geometry=obj.Geometry.updateParams(varargin{:});
        end


        function data=getStruct(obj)
 
            % 复制对象的属性到数据结构
            data.Color=obj.Color;

            % 调用其他对象的获取结构方法
            data.Pose=obj.Pose.getStruct();
            data.Geometry=obj.Geometry.getStruct();
            
            % 复制剩余属性
            data.FOVDist=obj.FOVDist;
            data.ID=obj.ID;
            data.Index=obj.Index;
            data.Name=obj.Name;
            data.RoadID=obj.RoadID;
            data.RoadIndex=obj.RoadIndex;
            data.RoadType=obj.RoadType;
            data.Type=obj.Type;
        end
    end
end
