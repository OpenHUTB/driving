classdef cVector




    properties(Access=public,Hidden=true)

        X=0;

        Y=0;

        Z=0;
    end
    properties(Access=public,Hidden=true)

        Type(1,:)char{mustBeMember(Type,{'2D','3D'})}='2D';
    end
    methods(Access=public,Hidden=true)
        function obj=cVector(varargin)








            if nargin==2
                obj.X=varargin{1};
                obj.Y=varargin{2};
            elseif nargin==3
                obj.X=varargin{1};
                obj.Y=varargin{2};
                obj.Z=varargin{3};
                obj.Type='3D';
            elseif nargin==0
                obj.X=0;
                obj.Y=0;
                obj.Z=0;
                obj.Type='3D';
            end
        end
        function obj=plus(obj,obj2)

            obj.X=obj.X+obj2.X;
            obj.Y=obj.Y+obj2.Y;
            obj.Z=obj.Z+obj2.Z;
        end
        function obj=minus(obj,obj2)

            obj.X=obj.X-obj2.X;
            obj.Y=obj.Y-obj2.Y;
            obj.Z=obj.Z-obj2.Z;
        end
        function obj=mtimes(obj,obj2)

            obj.X=obj.Y*obj2.Z-obj.Z*obj2.Y;
            obj.Y=obj.Z*obj2.X-obj.X*obj2.Z;
            obj.Z=obj.X*obj2.Y-obj.Y*obj2.X;
        end
        function flag=ne(obj,obj2)

            flag=obj.X~=obj2.X||obj.Y~=obj2.Y||obj.Z~=obj2.Z;
        end
        function flag=eq(obj,obj2)

            flag=obj.X==obj2.X&&obj.Y==obj2.Y&&obj.Z==obj2.Z;
        end
        function val=determinant(obj)

            val=sqrt(obj.X*obj.X+obj.Y*obj.Y+obj.Z*obj.Z);
        end
        function data=getStruct(obj)

            data.X=obj.X;
            data.Y=obj.Y;
            data.Z=obj.Z;
        end
    end
end

