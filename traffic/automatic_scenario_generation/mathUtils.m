classdef mathUtils



    properties(Access=public,Hidden=true,Constant)

        ParLengthVal=2;

        CurvaturFactor=0.3;
    end
    methods(Static)



        function[line2,dMin,centers,index]=getDistProjectionPoint(centers,position)













            centersX=centers(:,1);
            centersY=centers(:,2);
            centersZ=centers(:,3);
            dMin=65536;
            posVal=position(1:2);
            index=1;
            for idx=1:length(centersX)
                point1=[centersX(idx),centersY(idx)];
                diffPoint=point1-posVal;
                perDist=norm(diffPoint);




                if(perDist<=dMin)
                    dMin=perDist;
                    index=idx;
                end
            end
            if(index==1)
                pointMin1=[centersX(index),centersY(index)];
                pointMin2=[centersX(index+1),centersY(index+1)];
            elseif(index==length(centersX))
                pointMin1=[centersX(index-1),centersY(index-1)];
                pointMin2=[centersX(index),centersY(index)];
                index=index-1;
            else
                point1=[centersX(index-1),centersY(index-1)];
                point2=[centersX(index),centersY(index)];
                point3=[centersX(index+1),centersY(index+1)];
                line1=mathUtils.getLineEquation(point1,point2);
                line2=mathUtils.getPerpedicularLineEquation(line1,posVal);
                projPoint1=mathUtils.getIntersectionPointLL(line1,line2);
                line1=mathUtils.getLineEquation(point2,point3);
                line2=mathUtils.getPerpedicularLineEquation(line1,posVal);
                projPoint2=mathUtils.getIntersectionPointLL(line1,line2);
                if(mathUtils.norm(projPoint2,posVal,2)<mathUtils.norm(projPoint1,posVal,2))
                    pointMin1=point2;
                    pointMin2=point3;
                else
                    pointMin1=point1;
                    pointMin2=point2;
                    index=index-1;
                end
            end



            line1=mathUtils.getLineEquation(pointMin1,pointMin2);
            line2=mathUtils.getPerpedicularLineEquation(line1,posVal);
            projPoint=mathUtils.getIntersectionPointLL(line1,line2);
            dMin=mathUtils.norm(projPoint,posVal,2);











            sign=(posVal(1)-pointMin1(1))*(pointMin2(2)-pointMin1(2))...
            -(posVal(2)-pointMin1(2))*(pointMin2(1)-pointMin1(1));
            if(sign<0)
                dMin=-1*dMin;
            end
            centers=[centersX',centersY',centersZ'];
        end



        function line=getLineEquation(point1,point2)










            A=point1(2)-point2(2);
            B=point2(1)-point1(1);
            C=point1(1)*point2(2)-point2(1)*point1(2);
            line=[A,B,C];
        end



        function line=getPerpedicularLineEquation(line,point)










            A=line(2);
            B=-line(1);
            C=-A*point(1)-B*point(2);
            line=[A,B,C];
        end



        function point=getIntersectionPointLL(line1,line2)










            if(abs(abs(line1(2)/line1(1))-abs(line2(2)/line2(1)))<1e-07||(abs(line1(1))<=1e-07&&abs(line2(1))<=1e-07))
                point=[nan,nan];
            else
                y=(line1(1)*line2(3)-line2(1)*line1(3))/(line2(1)*line1(2)-line1(1)*line2(2));
                x=(line1(2)*line2(3)-line2(2)*line1(3))/(line1(1)*line2(2)-line1(2)*line2(1));
                point=[x,y];
            end

        end



        function line=getShiftedLineEquation(lineIn,dist)










            A=lineIn(1);
            B=lineIn(2);
            C=lineIn(3);

            C=C+dist*sqrt(A*A+B*B);
            line=[A,B,C];
        end



        function value=norm(pointA,pointB,count)










            if(count==1)
                if(size(pointA,2)>=1&&size(pointB,2)>=1)
                    diff=pointA(1)-pointB(1);
                    value=norm(diff,1);
                else
                    value=NaN;
                end
            elseif(count==2)
                if(size(pointA,2)>=2&&size(pointB,2)>=2)
                    diff=pointA(1:2)-pointB(1:2);
                    value=norm(diff,2);
                else
                    value=NaN;
                end
            elseif(count==3)
                if(size(pointA,2)>=3&&size(pointB,2)>=3)
                    diff=pointA(1:3)-pointB(1:3);
                    value=norm(diff,3);
                else
                    value=NaN;
                end
            end
        end



        function shiftedPath=shiftPoints(pathIn,shiftDist,shiftDir)





















            sizeR=size(pathIn,1);
            if(size(shiftDist,1)==1)
                shiftDist=shiftDist.*shiftDir;
                shiftDist=shiftDist.*ones(size(pathIn,1),1);
            else
                shiftDist=shiftDist.*shiftDir;
            end
            pointDiff=pathIn(2,1:2)-pathIn(1,1:2);
            sSlope=atan2(pointDiff(2),pointDiff(1));
            pointDiff=pathIn(end,:)-pathIn(end-1,:);
            eSlope=atan2(pointDiff(2),pointDiff(1));

            ndPathX=zeros(sizeR,1);
            ndPathY=zeros(sizeR,1);
            ndPathZ=zeros(sizeR,1);


            ndPathX(1)=pathIn(1,1)+shiftDist(1)*sin(sSlope);
            ndPathY(1)=pathIn(1,2)-shiftDist(1)*cos(sSlope);
            ndPathZ(1)=pathIn(1,3);
            cLine=mathUtils.getLineEquation(pathIn(1,:),pathIn(2,:));
            cLine=mathUtils.getShiftedLineEquation(cLine,shiftDist(1));
            for idx=2:sizeR-1

                fLine=mathUtils.getLineEquation(pathIn(idx,1:2),pathIn(idx+1,1:2));
                fLine=mathUtils.getShiftedLineEquation(fLine,shiftDist(idx));
                point=mathUtils.getIntersectionPointLL(cLine,fLine);



                if(isnan(point(1)))
                    pointDiff=pathIn(idx+1,1:2)-pathIn(idx,1:2);
                    slope=atan2(pointDiff(2),pointDiff(1));
                    ndPathX(idx)=pathIn(idx,1)+shiftDist(end)*sin(slope);
                    ndPathY(idx)=pathIn(idx,2)-shiftDist(end)*cos(slope);
                else
                    ndPathX(idx)=point(1);
                    ndPathY(idx)=point(2);
                end
                ndPathZ(idx)=pathIn(idx,3);
                cLine=fLine;
            end


            ndPathX(end)=pathIn(end,1)+shiftDist(end)*sin(eSlope);
            ndPathY(end)=pathIn(end,2)-shiftDist(end)*cos(eSlope);
            ndPathZ(end)=pathIn(end,3);


            shiftedPath=[ndPathX,ndPathY,ndPathZ];
        end



        function sign=getPointInLineSegment(point1,point2,point)
















            A=norm(point1-point);
            B=norm(point2-point);
            C=norm(point2-point1);
            if(A+B-C<=1e-03)
                sign=1;
            elseif(A<B)
                sign=-1;
            else
                sign=1;
            end
        end



        function dist=getPerpendicularDistance(line,point)














            A=line(1);
            B=line(2);
            C=line(3);
            dist=(A*point(1)+B*point(2)+C)/sqrt(A*A+B*B);
        end



        function projPoint=getProjectionPoint(line,point)


























            A=line(1);
            B=line(2);
            C=line(3);
            D=A*point(2)-B*point(1);
            x=-(A*C+B*D)/(A*A+B*B);
            y=-(A*D+B*C)/(A*A+B*B);
            projPoint=[x,y];
        end



        function[newStartPoint,angle]=getLangeChangeStartPoint(path,startPoint,lengthVal)















            point1=path(1,:);
            point2=path(2,:);
            diff=point2-point1;
            dist=norm(diff);
            angle=atan2(diff(2),diff(1));
            newStartPoint=[0,0,0];
            newStartPoint(1)=startPoint(1)+lengthVal*cos(angle);
            newStartPoint(2)=startPoint(2)+lengthVal*sin(angle);
            newStartPoint(3)=(lengthVal*point1(3)+(dist-lengthVal)*point2(3))/dist;
        end



        function[newEndPoint,angle]=getLangeChangeEndPoint(path,endPoint,lengthVal)















            point1=path(end-1,:);
            point2=path(end,:);
            diff=point2-point1;
            dist=norm(diff);
            angle=atan2(diff(2),diff(1));
            newEndPoint=[0,0,endPoint(3)];
            newEndPoint(1)=endPoint(1)-lengthVal*cos(angle);
            newEndPoint(2)=endPoint(2)-lengthVal*sin(angle);
            newEndPoint(3)=(lengthVal*point1(3)+(dist-lengthVal)*point2(3))/dist;
        end



        function points=generateLaneChangePoints(pointA,pointB,angle1,angle2,numPoints)


            pointANew=pointA;
            pointANew(1)=pointANew(1)+mathUtils.ParLengthVal*cos(angle1);
            pointANew(2)=pointANew(2)+mathUtils.ParLengthVal*sin(angle1);

            pointBNew=pointB;
            pointBNew(1)=pointBNew(1)-mathUtils.ParLengthVal*cos(angle2);
            pointBNew(2)=pointBNew(2)-mathUtils.ParLengthVal*sin(angle2);

            wayPoints=[pointANew;pointB];
            angles=[angle1,angle2];
            multiplier=mathUtils.CurvaturFactor;
            points=mathUtils.getBezier(wayPoints,angles,numPoints,multiplier);
            points(:,3)=pointA(3);
            points=[pointA;points];
        end



        function pathOut=removeNAN(path)










            pathOut=zeros(size(path));
            count=1;
            for idx=1:size(path,1)
                if~isnan(path(idx,1))
                    pathOut(count,:)=path(idx,:);
                    count=count+1;
                end
            end
            pathOut=pathOut(1:count-1,:);
        end



        function curvature=getCurvatureValue(path)



















            pathX=path(:,1);
            pathY=path(:,2);

            n=size(pathX,1);
            hl=zeros(n-1,1);
            k0=zeros(n-1,1);
            k1=zeros(n-1,1);


            course=matlabshared.tracking.internal.scenario.clothoidG2fitCourse([pathX,pathY]);

            hip=complex(pathX,pathY);


            for i=1:n-1
                [k0(i),k1(i),hl(i)]=matlabshared.tracking.internal.scenario.clothoidG1fit(hip(i),course(i),hip(i+1),course(i+1));
            end
            curvature=[k0;k0(end)];
        end



        function pathOut=linearInterpolate(pathIn,pathCurved,distLimit)













            pathLen=size(pathIn,1);
            pathOut=zeros(pathLen*4,3);
            pNum=1;
            ptInsert=5;
            for indx=1:pathLen-1
                if(pathCurved(indx)==1)
                    noOfPointsToInsert=1;
                else
                    noOfPointsToInsert=ptInsert;
                end
                cPoint=pathIn(indx,:);
                fPoint=pathIn(indx+1,:);
                u=fPoint-cPoint;
                dist=norm(u);
                uNormalized=u/dist;
                if(dist>=distLimit)

                    for insertIndx=pNum:pNum+noOfPointsToInsert-1
                        pathOut(insertIndx,:)=cPoint+(insertIndx...
                        -pNum)*uNormalized...
                        *dist/noOfPointsToInsert;
                    end
                    pNum=pNum+noOfPointsToInsert;
                else
                    pathOut(pNum,:)=pathIn(indx,:);
                    pNum=pNum+1;
                end
            end
            pathOut(pNum,:)=pathIn(pathLen,:);

            pathOut=pathOut(1:pNum,:);
        end



        function path=clothoidInterpolation(pointArray,ptsNum)









            pathIpldX=pointArray(:,1);
            pathIpldY=pointArray(:,2);
            [u,v]=driving.scenario.clothoid(pathIpldX,pathIpldY,...
            gradient(pathIpldX),gradient(pathIpldY),ptsNum);
            if(size(u,1)==1)
                u=transpose(u);
            end
            if(size(v,1)==1)
                v=transpose(v);
            end
            w=pointArray(1,3)*ones(size(u,1),1);
            path=[u,v,w];
        end



        function path=circularInterpolation(path,pivotPoint,startAngle,endAngle)
















            sizePath=size(path);
            midPoint=pivotPoint;
            e=1.2;
            arrayA=zeros(sizePath);

            line1Angle=startAngle;

            line2Angle=endAngle;


            angleBisector=line2Angle+(180-line1Angle-line2Angle)/2;
            if(angleBisector<30)
                mesg='Angle between the lines is less than thirty.';
                return;
            end


            angleBisectorR=angleBisector*pi/180;
            oDist=0.02;
            counter=1;
            for i=1:size(path,1)
                dist=mathUtils.norm(midPoint,path(i,:),2);
                if(dist==0)
                    arrayA(counter,1)=path(i,1)+oDist*e*cos(angleBisectorR);
                    arrayA(counter,2)=path(i,2)+oDist*e*sin(angleBisectorR);
                    midCount=counter;
                    midPointLoc=i;
                    counter=counter+1;
                elseif(dist>=0.06)
                    arrayA(counter,1)=path(i,1);
                    arrayA(counter,2)=path(i,2);
                    counter=counter+1;
                end
            end
            pt1=arrayA(midCount-1,:);
            pt2=path(midPointLoc,:);
            pt3=arrayA(midCount+1,:);
            line1=mathUtils.getLineEquation(pt1,pt2);
            line2=mathUtils.getLineEquation(pt2,pt3);
            line3=mathUtils.getPerpedicularLineEquation(line1,pt1);
            line4=mathUtils.getPerpedicularLineEquation(line2,pt3);
            point=mathUtils.getIntersectionPointLL(line3,line4);


            normR=mathUtils.norm(point,pt1,2);
            diffFinal=midPoint-point;
            slopefinale=atan2(diffFinal(2),diffFinal(1));
            pt4(1)=point(1)+normR*cos(slopefinale);
            pt4(2)=point(2)+normR*sin(slopefinale);


            arrayA(midCount,:)=pt4;
            path=arrayA(1:counter-1,:);
        end



        function trajectory=getBezier(wayPoints,angles,ptCount,multiplier)













            ctrlPoints=mathUtils.getControlPoints(wayPoints,angles,multiplier);
            sizeCtrlPoints=length(ctrlPoints);


            basis=mathUtils.getBasis(sizeCtrlPoints);

            if(size(wayPoints,2)==2)
                trajectory=zeros(ptCount,2);
            else
                trajectory=zeros(ptCount,3);
            end
            for t=0:ptCount-1


                B=mathUtils.getTimeMultiplier(sizeCtrlPoints,t/(ptCount-1))*basis;
                val=(ctrlPoints*B')';
                trajectory(t+1,:)=val;
            end
        end



        function basis=getBasis(n)












            basis=zeros(n,n);
            for k=0:n-1
                coeff=nchoosek(n-1,k);
                for p=n-1-k:-1:0
                    basis(k+1,n-k-p)=coeff*nchoosek(n-1-k,p)*((-1)^p);
                end
            end
        end



        function preMultiplier=getTimeMultiplier(n,t)








            preMultiplier=zeros(1,n);
            preMultiplier(n)=1;
            for k=n-2:-1:0
                preMultiplier(k+1)=preMultiplier(k+2)*t;
            end
        end



        function ctrlPoints=getControlPoints(wayPoints,angles,multiplier)









            theta1=angles(1);
            theta2=angles(2);
            point1=wayPoints(1,:);
            point4=wayPoints(end,:);
            d=multiplier*norm(point4-point1);
            if(size(wayPoints,2)==2)
                point2=wayPoints(1,:)+[d*cos(theta1),d*sin(theta1)];
                point2Alt=wayPoints(1,:)-[d*cos(theta1),d*sin(theta1)];
            else
                point2=wayPoints(1,:)+[d*cos(theta1),d*sin(theta1),0];
                point2Alt=wayPoints(1,:)-[d*cos(theta1),d*sin(theta1),0];
            end
            if(norm(point4-point2Alt)<norm(point4-point2))
                point2=point2Alt;
            end

            if(size(wayPoints,2)==2)
                point3=wayPoints(end,:)+[d*cos(theta2),d*sin(theta2)];
                point3Alt=wayPoints(end,:)-[d*cos(theta2),d*sin(theta2)];
            else
                point3=wayPoints(end,:)+[d*cos(theta2),d*sin(theta2),0];
                point3Alt=wayPoints(end,:)-[d*cos(theta2),d*sin(theta2),0];
            end
            if(norm(point1-point3Alt)<norm(point1-point3))
                point3=point3Alt;
            end
            ctrlPoints=[point1',point2',point3',point4'];
        end


    end
end
