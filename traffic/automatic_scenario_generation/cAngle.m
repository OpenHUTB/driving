classdef cAngle




    properties(Access=public,Hidden=true)

        Pitch=0;

        Roll=0;

        Yaw=0;
    end
    methods(Access=public,Hidden=true)
        function obj=cAngle(varargin)

            if nargin==1
                obj.Yaw=varargin{1};
            elseif nargin==3
                obj.Yaw=varargin{1};
                obj.Pitch=varargin{2};
                obj.Roll=varargin{3};
            elseif nargin==0
                obj.Yaw=0;
                obj.Pitch=0;
                obj.Roll=0;
            end
        end
        function flag=eq(obj,obj2)

            if(obj.Yaw==obj2.Yaw&&obj.Pitch==obj2.Pitch&&...
                obj.Roll==obj2.Roll)
                flag=1;
            else
                flag=0;
            end
        end
        function data=getStruct(obj)

            data.Yaw=obj.Yaw;
            data.Pitch=obj.Pitch;
            data.Roll=obj.Roll;
        end
    end
end

