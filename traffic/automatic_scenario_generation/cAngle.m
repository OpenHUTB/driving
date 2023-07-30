classdef cAngle

    properties(Access=public,Hidden=true)
        % 飞行角度的属性，设置为public访问级别但是隐藏起来
        Pitch=0; % 俯仰角（绕X轴旋转角度）
        Roll=0;  % 横滚角（绕Y轴旋转角度）
        Yaw=0;   % 偏航角（绕Z轴旋转角度）
    end
    
    methods(Access=public,Hidden=true)
        function obj=cAngle(varargin)
            % cAngle类的构造函数，创建cAngle对象

            % 根据输入参数个数，初始化Yaw、Pitch和Roll属性
            if nargin == 1
                obj.Yaw = varargin{1};
            elseif nargin == 3
                obj.Yaw = varargin{1};
                obj.Pitch = varargin{2};
                obj.Roll = varargin{3};
            elseif nargin == 0
                obj.Yaw = 0;
                obj.Pitch = 0;
                obj.Roll = 0;
            end
        end
        
        function flag=eq(obj,obj2)
            % 判断两个cAngle对象是否相等的方法

            % 比较两个对象的Yaw、Pitch和Roll属性是否相等
            if(obj.Yaw==obj2.Yaw && obj.Pitch==obj2.Pitch && obj.Roll==obj2.Roll)
                flag=1; % 相等，返回1
            else
                flag=0; % 不相等，返回0
            end
        end
        
        function data=getStruct(obj)
            % 获取包含Yaw、Pitch和Roll属性的结构体的方法

            % 将Yaw、Pitch和Roll属性存入结构体data中
            data.Yaw = obj.Yaw;
            data.Pitch = obj.Pitch;
            data.Roll = obj.Roll;
        end
    end
    
end
