classdef cSafePolicyGenerator




    properties(Access=public)

        Scale=1;

        DeadLockVal=0;
    end
    methods(Access=public)
        function obj=cSafePolicyGenerator(varargin)

        end

        function[Scale,Speed]=recoverFromZeroSpeed(~,vehicle)










            Scale=vehicle.MotionModel.Scale;
            Speed=vehicle.MotionModel.ScaledSpeed;
            agentsInCollision=vehicle.CollisionBlock.AgentsInCollision;
            if isempty(agentsInCollision.Position)
                Scale=1;
                Speed=vehicle.MotionModel.Speed;
                return
            end
            vel=vehicle.MotionModel.ScaledSpeed;
            Yaw=vehicle.MotionModel.Pose.Orientation.Yaw;
            ve=[vel*cos(Yaw),vel*sin(Yaw)];
            CollisionSpeeds=agentsInCollision.Speed;
            CollisionYaw=agentsInCollision.Yaw;
            vo=[(CollisionSpeeds.*cos(CollisionYaw))',...
            (CollisionSpeeds.*sin(CollisionYaw))'];

            if(vehicle.MotionModel.ScaledSpeed<=0.0003)
                ve=[0,0];
            end

            [lowVelInd]=find(agentsInCollision.Speed<=0.0003);
            vo(lowVelInd',1)=cos(agentsInCollision.Yaw(lowVelInd));
            vo(lowVelInd',2)=sin(agentsInCollision.Yaw(lowVelInd));
            oppLaneCounter=0;

            for idx=1:size(agentsInCollision.Position,1)
                angleBetVectors=atan2d(norm(cross([ve,0],[vo(idx,:),0])),dot([ve,0],[vo(idx,:),0]));
                if((90<angleBetVectors)&&(angleBetVectors<181))
                    oppLaneCounter=oppLaneCounter+1;
                end
            end
            if(oppLaneCounter==size(agentsInCollision.Position,1))
                Speed=vehicle.MotionModel.Speed;
                Scale=1;
            end
        end

        function obj=computeScale(obj,vehicle)

            pos=[vehicle.Pose.Position.X,vehicle.Pose.Position.Y];
            vel=vehicle.MotionModel.ScaledSpeed;
            yawEgo=vehicle.MotionModel.Pose.Orientation.Yaw;
            vel=[vel*cos(yawEgo),vel*sin(yawEgo)];
            lengthEgo=vehicle.Geometry.Length;
            widthEgo=vehicle.Geometry.Width;
            agentsInCollision=vehicle.CollisionBlock.AgentsInCollision;
            if(~isempty(vehicle.CollisionBlock.AgentsInCollision.Position))
                [root1,root2,aInd,obj.DeadLockVal]=obj.calcRoots(...
                pos,vel,yawEgo,lengthEgo,widthEgo,...
                agentsInCollision);
                scale=obj.getFinalScale(root1,root2,aInd,obj.Scale);
                if(scale<0)
                    obj.Scale=0;
                else
                    obj.Scale=scale;
                end
            else
                obj.Scale=1;
            end
        end
    end
    methods(Access=public)
        function out=getMinkowskiSum(~,radius1,radius2)

            out=radius1+radius2;
        end
        function[root1,root2,aInd,deadLockCriteria]=calcRoots(obj,posEgo,velEgo,yawEgo,lengthEgo,widthEgo,agentsInCollision)








            idxColl=1;








            root1=zeros(size(agentsInCollision.Position,1),1);
            root2=zeros(size(agentsInCollision.Position,1),1);
            aInd=zeros(size(agentsInCollision.Position,1),1);
            deadLockCriteria=zeros(size(agentsInCollision.Position,1),1);
            multiCircleIntersectionBool=1;
            deadLockValCir=[];
            for idx=1:size(agentsInCollision.Position,1)
                posTgt=agentsInCollision.Position(idx,:);
                yawTgt=agentsInCollision.Yaw(idx);
                velTgt=(agentsInCollision.Speed(idx)).*...
                [cos(yawTgt),sin(yawTgt)];
                angleBetVect=atan2d(norm(cross([velEgo,0],...
                [velTgt,0])),dot([velEgo,0],[velTgt,0]));
                if(120<=angleBetVect&&angleBetVect<=181)

                    oppLane=1;
                else

                    oppLane=0;
                end
                if(oppLane==0&&multiCircleIntersectionBool==1)


                    [posTgtAll,velTgtAll,totalNumCirclesObs]=...
                    obj.getCircles(posTgt,velTgt,yawTgt,...
                    agentsInCollision.Length(idx),...
                    1.2*agentsInCollision.Width(idx));


                    [posEgoAll,velEgoAll,totalNumCirclesRobo]=...
                    obj.getCircles(posEgo,velEgo,yawEgo,...
                    lengthEgo,1.2*widthEgo);

                    cirIdx=1;

                    aCir=zeros(totalNumCirclesRobo*...
                    totalNumCirclesObs,1);
                    bCir=zeros(totalNumCirclesRobo*...
                    totalNumCirclesObs,1);
                    cCir=zeros(totalNumCirclesRobo*...
                    totalNumCirclesObs,1);
                    deadLockValCir=zeros(totalNumCirclesRobo*...
                    totalNumCirclesObs,1);
                    root1Cir=zeros(totalNumCirclesRobo*...
                    totalNumCirclesObs,1);
                    root2Cir=zeros(totalNumCirclesRobo*...
                    totalNumCirclesObs,1);
                    aIndCir=zeros(totalNumCirclesRobo*...
                    totalNumCirclesObs,1);
                    for jRobo=1:totalNumCirclesRobo
                        for jObst=1:totalNumCirclesObs

                            minkowskiSum=obj.getMinkowskiSum(1.2*(...
                            widthEgo)/2,1.2*...
                            agentsInCollision.Width(idx)/2);
                            [aCir(cirIdx),bCir(cirIdx),...
                            cCir(cirIdx),deadLockValCir(cirIdx)...
                            ]=obj.getABC(posTgtAll(jObst,:),...
                            velTgtAll(jObst,:),posEgoAll(jRobo,:),...
                            velEgoAll(jRobo,:),minkowskiSum);

                            [root1Cir(cirIdx),root2Cir(cirIdx,:),...
                            aIndCir(cirIdx)]=obj.solutionSpace(...
                            aCir(cirIdx),bCir(cirIdx),cCir(cirIdx));

                            cirIdx=cirIdx+1;
                        end
                    end


                    scaleTableCircles=[root1Cir,root2Cir,aIndCir];


                    scaleTableIntersectionCir=obj.findIntersection(...
                    scaleTableCircles);



                    if(scaleTableIntersectionCir(3)==0.5)
                        scaleTableIntersectionCir(3)=0;
                    end

                    root1(idxColl)=scaleTableIntersectionCir(1);
                    root2(idxColl)=scaleTableIntersectionCir(2);
                    aInd(idxColl)=scaleTableIntersectionCir(3);
                    deadLockCriteria(idxColl)=min(deadLockValCir);
                elseif(oppLane==0&&multiCircleIntersectionBool~=1)

                    minkowskiSum=obj.getMinkowskiSum(...
                    (lengthEgo)/2,agentsInCollision.Length(idx)/2);
                    [a,b,c,deadLockValCir]=obj.getABC(posTgt,...
                    velTgt,posEgo,velEgo,minkowskiSum);
                    [root1(idxColl),root2(idxColl),aInd(idxColl)]...
                    =obj.solutionSpace(a,b,c);
                    deadLockCriteria(idxColl)=min(deadLockValCir);
                end

                idxColl=idxColl+1;
            end

        end
        function scale=getFinalScale(obj,root1,root2,aInd,prevScale)

            weight1=99;
            weight2=1;
            scaleTable=[root1,root2,aInd];
            if(~isempty(scaleTable))
                scaleTableIntersection=obj.findIntersection(scaleTable);
            else
                scaleTableIntersection=[];
            end

            if(isempty(scaleTableIntersection))
                scale=1;
            else



                aFinal=scaleTableIntersection(3);
                if(aFinal==1)
















                    s1=linspace(0,scaleTableIntersection(1),500);
                    costFunction1=weight1*(s1-prevScale).^2+weight2*(s1-1).^2;
                    [minFirstHalf,idxFirstHalf]=min(costFunction1);


                    s2=linspace(scaleTableIntersection(2),1.7,500);
                    costFunction2=weight1*(s2-prevScale).^2+weight2*(s2-1).^2;
                    [minSecondHalf,idxSecondHalf]=min(costFunction2);

                    if isempty(costFunction2)&&isempty(costFunction1)
                        scale=prevScale;
                    elseif isempty(costFunction2)
                        scale=s1(idxFirstHalf);
                    elseif minFirstHalf<minSecondHalf
                        scale=s1(idxFirstHalf);
                    else
                        scale=s2(idxSecondHalf);
                    end
                else

















                    s=linspace(scaleTableIntersection(1),scaleTableIntersection(2),500);
                    costFunction=weight1*(s-prevScale).^2+weight2*(s-1).^2;
                    [~,idx]=min(costFunction);
                    scale=s(idx);
                end
            end


            if(scale>132.9&&scale<133.1)
                scale=0;
            end

            if(scale>1.7)
                scale=1.7;
            end
        end
        function solutionSpaceOneCovered=solutionSpaceHasOne(~,r1FinalIntersect,r2FinalIntersect,aValue)





            if((r1FinalIntersect>132.9&&r1FinalIntersect<133.1)||...
                (r2FinalIntersect>132.9&&r2FinalIntersect<133.1))
                solutionSpaceOneCovered=0;
            end
            if(aValue==0.5||aValue==0)

                if((r2FinalIntersect>0.98)&&r1FinalIntersect<1)
                    solutionSpaceOneCovered=1;
                else
                    solutionSpaceOneCovered=0;
                end
            else
                if(aValue==1)
                    if(r2FinalIntersect<0.98||r1FinalIntersect>0.98)
                        solutionSpaceOneCovered=1;
                    else
                        solutionSpaceOneCovered=0;
                    end
                end
            end
        end
        function[peAll,voAll,numCircles]=getCircles(~,position,velocity,theta,length,width)





            omega=0;






            increamentSize=width;
            numCircles=floor(length/increamentSize)+1;
            xoRef=position(1);
            yoRef=position(2);
            xc=zeros(numCircles+1,1);
            yc=zeros(numCircles+1,1);
            xcdot=zeros(numCircles+1,1);
            ycdot=zeros(numCircles+1,1);


            xc(1)=xoRef+(length/2)*cos(theta);
            yc(1)=yoRef+(length/2)*sin(theta);

            xcdot(1)=velocity(1)-(length/2)*sin(theta)*omega;
            ycdot(1)=velocity(2)+(length/2)*cos(theta)*omega;



            for i=2:numCircles
                xc(i)=xc(i-1)-increamentSize*cos(theta);
                yc(i)=yc(i-1)-increamentSize*sin(theta);
                xcdot(i)=xcdot(i-1)+increamentSize*sin(theta)*omega;
                ycdot(i)=ycdot(i-1)-increamentSize*cos(theta)*omega;
            end











            distanceCoveredByCircles=numCircles*width;
            padding=width/2;
            lengthActor=length+padding;

            if(distanceCoveredByCircles<lengthActor)

                xlower=(xoRef-1*(length/2)*cos(theta));
                ylower=(yoRef-1*(length/2)*sin(theta));
                xlowerdot=velocity(1)+(length/2)*sin(theta)*omega;
                ylowerdot=velocity(2)-(length/2)*cos(theta)*omega;
                amountLastCirclePushInsideRect=0.4;
                xc(numCircles+1)=xlower+(amountLastCirclePushInsideRect)*(width/2)*cos(theta);
                yc(numCircles+1)=ylower+(amountLastCirclePushInsideRect)*(width/2)*sin(theta);
                xcdot(numCircles+1)=xlowerdot-(amountLastCirclePushInsideRect)*(width/2)*sin(theta)*omega;
                ycdot(numCircles+1)=ylowerdot+(amountLastCirclePushInsideRect)*(width/2)*cos(theta)*omega;
            end



            if(rem(length,increamentSize)==0)
                amountLastCirclePushInsideRect=0.6;
                xc(numCircles)=xc(numCircles)+(amountLastCirclePushInsideRect)*(width/2)*cos(theta);
                yc(numCircles)=yc(numCircles)+(amountLastCirclePushInsideRect)*(width/2)*sin(theta);
                xcdot(numCircles)=xcdot(numCircles)-(amountLastCirclePushInsideRect)*(width/2)*cos(theta)*omega;
                ycdot(numCircles)=ycdot(numCircles)+(amountLastCirclePushInsideRect)*(width/2)*sin(theta)*omega;
            end
            peAll=[xc,yc,zeros(numel(xc),1)];
            voAll=[xcdot,ycdot,zeros(numel(xc),1)];
        end
        function[a,b,c,deadlockCond]=getABC(~,pos,vel,pEgo,vEgo,minKowskiSum)

            xNonEgo=pos(1);
            yNonEgo=pos(2);
            xNonEgoDot=vel(1);
            yNonEgoDot=vel(2);
            xEgo=pEgo(1);
            yEgo=pEgo(2);
            xEgoDot=vEgo(1);
            yEgoDot=vEgo(2);
            a=(-minKowskiSum.^2).*(xEgoDot.^2+yEgoDot.^2)+...
            ((xEgo-xNonEgo).*yEgoDot+xEgoDot.*(-yEgo+yNonEgo)).^2;
            b=2.*((-((xEgo-xNonEgo).*yEgoDot+xEgoDot.*(-yEgo+yNonEgo))).*(xNonEgoDot.*(-yEgo+yNonEgo)+(xEgo-xNonEgo).*yNonEgoDot)+minKowskiSum.^2.*(xEgoDot.*xNonEgoDot+yEgoDot.*yNonEgoDot));
            c=(xNonEgoDot.*(yEgo-yNonEgo)+(-xEgo+xNonEgo).*yNonEgoDot).^2-minKowskiSum.^2.*(xNonEgoDot.^2+yNonEgoDot.^2);
            deadlockCond=c/a;
        end
        function[root1,root2,aInd]=solutionSpace(~,a,b,c)

            r1=((-b-sqrt((b^2-4*(a*c))))/(2*a));
            r2=((-b+sqrt((b^2-4*(a*c))))/(2*a));
            if(a==0)
                if(isreal(r1)&&isreal(r2))
                    if(b==0)
                        root1=0;
                        root2=0;
                    else
                        root1=-c/b;
                        root2=-c/b;
                    end
                else

                    root1=0;
                    root2=0;
                end
            end
            if(isreal(r1)&&isreal(r2))
                if(a<0)
                    if((r2<=0)&&(r1<=0))


                        r2=0;
                        r1=0;
                    end
                    if(r2<=0)
                        r2=0;
                    end
                    if(r1<=0)
                        r1=0;
                    end

                    root2=r1;
                    root1=r2;
                else
                    if(a>0)
                        if((r1<0)&&(r2<0))


                            r1=1;
                            r2=1;
                        end
                        if(r1<=0)
                            r1=0;
                        end
                        if(r2<=0)
                            r2=0;
                        end

                        root1=r1;
                        root2=r2;
                    end
                end
            else

                root1=0;
                root2=0;
            end
            if(a>0)||((b^2-4*(a*c)==0)&&(root1>=1))
                aInd=1;
            elseif(a<=0)||((b^2-4*(a*c)==0)&&(root1<1))
                aInd=0;
            end

        end
        function scaleTableIntersection=findIntersection(obj,scaleTable)



            aColumn=scaleTable(:,3);
            aLessThanZeroIndex=find(aColumn==0);
            aGreaterThanZeroIndex=find(aColumn==1);
            r1FinalIntersect=0;
            r2FinalIntersect=0;
            aDisp=0;

            if(~isempty(aLessThanZeroIndex))
                r1ALessThanZero=scaleTable(aLessThanZeroIndex,1);
                r2ALessThanZero=scaleTable(aLessThanZeroIndex,2);
                r1ALessThanZeroIntersect=max(r1ALessThanZero);
                r2ALessThanZeroIntersect=min(r2ALessThanZero);

                if(r2ALessThanZeroIntersect<r1ALessThanZeroIntersect)
                    r1ALessThanZeroIntersect=133;
                    r2ALessThanZeroIntersect=133;
                end
            end

            if(~isempty(aGreaterThanZeroIndex))
                r1AGreaterThanZero=scaleTable(aGreaterThanZeroIndex,1);
                r2AGreaterThanZero=scaleTable(aGreaterThanZeroIndex,2);
                r1AGreaterThanZeroIntersect=min(r1AGreaterThanZero);
                r2AGreaterThanZeroIntersect=max(r2AGreaterThanZero);

            end

            if(~isempty(aLessThanZeroIndex)&&isempty(aGreaterThanZeroIndex))
                r1FinalIntersect=r1ALessThanZeroIntersect;
                r2FinalIntersect=r2ALessThanZeroIntersect;
                aDisp=0;
            else
                if(~isempty(aGreaterThanZeroIndex)&&isempty(aLessThanZeroIndex))
                    r1FinalIntersect=r1AGreaterThanZeroIntersect;
                    r2FinalIntersect=r2AGreaterThanZeroIntersect;
                    aDisp=1;
                end
            end

            if(~isempty(aLessThanZeroIndex)&&~isempty(aGreaterThanZeroIndex))
                r1=r1ALessThanZeroIntersect;
                r2=r2ALessThanZeroIntersect;
                r1Dash=r1AGreaterThanZeroIntersect;
                r2Dash=r2AGreaterThanZeroIntersect;
                [r1FinalIntersect,r2FinalIntersect]=obj.intersectionConvexConcave(r1,r2,r1Dash,r2Dash);
                aDisp=0.5;
            end

            scaleTableDisp=[r1FinalIntersect,r2FinalIntersect,aDisp];

            scaleTableIntersection=scaleTableDisp;
        end
        function[r1FinalIntersect,r2FinalIntersect]=intersectionConvexConcave(~,r1,r2,r1Dash,r2Dash)

            if((r1<=r1Dash)&&(r2<=r1Dash))
                r1FinalIntersect=r1;
                r2FinalIntersect=r2;
            end
            if(r1>=r1Dash&&r2>=r2Dash)
                r1FinalIntersect=r2Dash;
                r2FinalIntersect=r2;
            end
            if(r1>=r2Dash&&r2>=r2Dash)
                r1FinalIntersect=r1;
                r2FinalIntersect=r2;
            end
            if(r1<=r1Dash&&r2<=r2Dash&&r2>=r1Dash)
                r1FinalIntersect=r1;
                r2FinalIntersect=r1Dash;
            end
            if(r1<=r1Dash&&r2>=r2Dash)
                if(abs(r1Dash-1)<=abs(r2Dash-1))
                    r1FinalIntersect=r1;
                    r2FinalIntersect=r1Dash;
                end
                if(abs(r2Dash-1)<=abs(r1Dash-1))
                    r1FinalIntersect=r2Dash;
                    r2FinalIntersect=r2;
                end
            end

            if(r1>r1Dash&&r2<r2Dash)
                r1FinalIntersect=133;
                r2FinalIntersect=133;
            end
        end
    end
end