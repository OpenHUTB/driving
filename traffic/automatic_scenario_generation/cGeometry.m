classdef cGeometry






    properties(SetAccess=protected,Hidden=true)

        Length(1,:)double{mustBeNonNan,mustBeFinite,...
        mustBePositive}=4.7;

        Width(1,:)double{mustBeNonNan,mustBeFinite,...
        mustBePositive}=1.8;

        Height(1,:)double{mustBeNonNan,mustBeFinite,...
        mustBePositive}=1.4;

        Mesh=struct("Vertices",double.empty(0,3),'Faces',double.empty(0,3));

        RCSPattern(2,2)=[10,10;10,10];

        RCSAzimuthAngles(1,2)=[-pi,pi];

        RCSElevationAngles(1,2)=[-pi/2,pi/2];
    end
    properties(Access=protected,Hidden=true)

        CuboidNums(1,:)uint32{mustBeNonNan,mustBeFinite,...
        mustBePositive}=1;
    end
    methods(Access=public,Hidden=true)
        function obj=cGeometry(varargin)









            if(nargin>1)
                obj=obj.updateParams(varargin{:});
            end
        end
        function obj=updateParams(obj,varargin)


            parser=inputParser;
            addOptional(parser,'Length',4.7);
            addOptional(parser,'Width',1.8);
            addOptional(parser,'Height',1.4);
            addOptional(parser,'Mesh',-1);
            addOptional(parser,'RCSPattern',-1);
            addOptional(parser,'RCSAzimuthAngles',-1);
            addOptional(parser,'RCSElevationAngles',-1);
            parse(parser,varargin{:});
            results=parser.Results;

            len=results.Length;
            wid=results.Width;
            hei=results.Height;
            if(len~=-1&&wid~=-1&&hei~=-1)
                if(size(len,1)~=size(wid,1)&&size(len,1)~=...
                    size(hei,1)&&size(wid,1)~=size(hei,1))
                    msg='Expected input to be of same dimension.';
                    disp(msg);
                    len=4.7;
                    wid=1.8;
                    hei=1.4;
                    obj.cuboidNums=1;
                end
                obj.Length=len;
                obj.Width=wid;
                obj.Height=hei;
                obj.CuboidNums=max(size(len,1),size(len,2));
            end

            if(results.Mesh~=-1)
                obj.Mesh=results.Mesh;
            end
            if(results.RCSPattern~=-1)
                obj.RCSPattern=results.RCSPattern;
            end
            if(results.RCSAzimuthAngles~=-1)
                obj.RCSAzimuthAngles=results.RCSAzimuthAngles;
            end
            if(results.RCSElevationAngles~=-1)
                obj.RCSElevationAngles=results.RCSElevationAngles;
            end
        end
        function data=getStruct(obj)

            data.Length=obj.Length;
            data.Width=obj.Width;
            data.Height=obj.Height;
            data.Mesh=obj.Mesh;
            data.RCSPattern=obj.RCSPattern;
            data.RCSAzimuthAngles=obj.RCSAzimuthAngles;
            data.RCSElevationAngles=obj.RCSElevationAngles;
        end
    end
end

