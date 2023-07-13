classdef cPose




    properties(Access=public,Hidden=true)

        Position;

        Orientation;
    end
    methods(Access=public,Hidden=true)
        function obj=cPose(varargin)










            obj.Position=cVector();
            obj.Orientation=cAngle();
            if nargin==0
                obj.Position=cVector(0,0,0);
                obj.Orientation=cAngle(0,0,0);
            elseif nargin==1
                value=varargin{1};
                obj.Position.X=value(1);
                obj.Position.Y=value(2);
                if(size(value,2)==3)
                    obj.Position.Z=value(3);
                end
            elseif nargin==2
                value=varargin{1};
                obj.Position.X=value(1);
                obj.Position.Y=value(2);
                if(size(value,2)==3)
                    obj.Position.Z=value(3);
                end
                value=varargin{2};
                obj.Orientation.Yaw=value(1);
                if(size(value,2)==3)
                    obj.Orientation.Pitch=value(2);
                    obj.Orientation.Roll=value(3);
                end
            elseif nargin==6
                obj.Position.X=varargin{1};
                obj.Position.Y=varargin{2};
                obj.Position.Z=varargin{3};
                obj.Orientation.Yaw=varargin{4};
                obj.Orientation.Pitch=varargin{5};
                obj.Orientation.Roll=varargin{6};
            end
        end
        function obj=setPosition(obj,value)

            if(numel(value)==2)
                obj.Position.X=value(1);
                obj.Position.Y=value(2);
            elseif(numel(value)==3)
                obj.Position.X=value(1);
                obj.Position.Y=value(2);
                obj.Position.Z=value(3);
            else
                disp('Input error in position.');
            end
        end
        function obj=setOrientation(obj,value)


            if(numel(value)==1)
                obj.Orientation.Yaw=value(1);
            elseif(numel(value)==3)
                obj.Orientation.Yaw=value(1);
                obj.Orientation.Pitch=value(2);
                obj.Orientation.Roll=value(3);
            else
                disp('Input error in orientation');
            end
        end
        function obj=plus(obj,obj2)

            obj.Position=obj.Position+obj2.Position;
        end
        function obj=minus(obj,obj2)

            obj.Position=obj.Position-obj2.Position;
        end
        function flag=eq(obj,obj2)

            if(obj.Position==obj2.Position&&obj.Orientation...
                ==obj2.Orientation)
                flag=1;
            else
                flag=0;
            end
        end
        function T=getTranslationMatrix(~,input)

            if(length(input)==2)
                xVal=input(1);
                yVal=input(2);
                zVal=0;
            elseif(length(input)==3)
                xVal=input(1);
                yVal=input(2);
                zVal=input(3);
            else
                disp('The argument needs to be of the type of [x y z]');
                return;
            end
            T=[1,0,0,xVal;
            0,1,0,yVal;
            0,0,1,zVal;
            0,0,0,1;];
        end
        function R=getRotationMatix(~,angles)

            if(length(angles)==1)
                alpha=angles(1);
                beta=0;
                gamma=0;
            elseif(length(angles)==2)
                alpha=angles(1);
                beta=angles(2);
                gamma=0;
            elseif(length(angles)==3)
                alpha=angles(1);
                beta=angles(2);
                gamma=angles(3);
            end
            R_z=[cos(alpha),-sin(alpha),0,0;
            sin(alpha),cos(alpha),0,0;
            0,0,1,0;
            0,0,0,1;];
            R_y=[cos(beta),0,sin(beta),0;
            0,1,0,0;
            -sin(beta),0,cos(beta),0;
            0,0,0,1;];
            R_x=[1,0,0,0;
            0,cos(gamma),-sin(gamma),0;
            0,sin(gamma),cos(gamma),0;
            0,0,0,1;];
            R=R_z*R_y*R_x;
        end
        function obj=transform(obj,varargin)





            if(nargin==1)
                T=obj.getRotationMatix(varargin{1});
            elseif(nargin==2)
                R=obj.getRotationMatix(varargin{1});
                T=obj.getTranslateMatrix(varargin{2});
                T=R*T;
            else
                disp('Invalid input');
                return;
            end
            out=T*[obj.Position.X;
            obj.Position.Y;
            obj.Position.Z;
            1;];
            obj.Position.X=out(1);
            obj.Position.Y=out(2);
            obj.Position.Z=out(3);
        end
        function data=getStruct(obj)

            data.Position=obj.Position.getStruct();
            data.Orientation=obj.Orientation.getStruct();
        end
    end
end
