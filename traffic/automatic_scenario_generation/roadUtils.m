classdef roadUtils


    methods(Static)
        function[roadID,roadIndx,roadTypes,laneTypes]=pointToRoadLookup(points,roads,nodes)


            roadID=-1*ones(size(points,1),1);
            roadIndx=1*ones(size(points,1),1);
            roadTypes=-1*ones(size(points,1),1);
            laneTypes=-1*ones(size(points,1),1);
            checkTry=false(size(points,1),1);
            for indx=1:length(roads)
                if(roads(indx).ID==-1)
                    continue;
                end
                leftLines=roads(indx).RoadSegmentsPolygon.ShiftedLeft;
                centerPoints=roads(indx).RoadSegmentsPolygon.CenterPoints;
                rightLines=roads(indx).RoadSegmentsPolygon.ShiftedRight;

                polygonLeft=[leftLines;centerPoints(end:-1:1,:)];
                polygonRight=[rightLines;centerPoints(end:-1:1,:)];

                checkTryLeft=inpolygon(points(:,1),points(:,2),...
                polygonLeft(:,1),polygonLeft(:,2));
                checkTryRight=inpolygon(points(:,1),points(:,2),...
                polygonRight(:,1),polygonRight(:,2));
                checkTry=bitor(checkTryLeft,checkTryRight);
                if(sum(checkTry)>0)
                    roadID(checkTry)=roads(indx).ID;
                    roadIndx(checkTry)=roads(indx).Index;
                    roadTypes(checkTry)=1;
                    laneTypes(checkTryLeft)=-1;
                    laneTypes(checkTryRight)=1;
                end
            end
            previousCheckTry=checkTry;
            for indx=1:length(nodes)
                nodeSegmentsPolygon=nodes(indx).NodeSegmentsPolygon;
                for subIndx=1:length(nodeSegmentsPolygon)
                    leftLines=nodeSegmentsPolygon(subIndx).ShiftedLeft;
                    rightLines=nodeSegmentsPolygon(subIndx).ShiftedRight;
                    if(isempty(leftLines))
                        continue;
                    end

                    polygon=[leftLines;...
                    rightLines(end:-1:1,:)];

                    checkTry=inpolygon(points(:,1),points(:,2),...
                    polygon(:,1),polygon(:,2));
                    previousInfo=roadID(:)==-1;
                    checkTry=bitand(checkTry,previousInfo);
                    checkTry=bitand(checkTry,~previousCheckTry);
                    if(sum(checkTry)>0)
                        roadID(checkTry)=nodes(indx).ID;
                        roadIndx(checkTry)=nodes(indx).Index;
                        roadTypes(checkTry)=2;
                        laneTypes(checkTry)=1;
                    end
                end
            end
        end
        function nodePath=getNodesTraversal(rn,startRdID,endRdID)








            nodes=rn.Nodes;
            roads=rn.Roads;


            if(length(nodes)==1||startRdID==endRdID)
                nodePath=[];
                return;
            else

                if(rn.RoadsMap.isKey(startRdID)==1)
                    startRdIndex=rn.RoadsMap(startRdID);
                    startRoad=roads(startRdIndex);
                else
                    disp("Invalid start roadID");
                    nodePath=[];
                    return;
                end

                if(rn.RoadsMap.isKey(endRdID)==1)
                    endRdIndex=rn.RoadsMap(endRdID);
                    endRoad=roads(endRdIndex);
                else
                    disp("Invalid end roadID");
                    nodePath=[];
                    return;
                end
            end




            if(startRoad.Direction=='Forward')
                startNode1=startRoad.StartNode;
                startNode2=null(1,0);
            elseif(startRoad.Direction=='Backward')
                startNode1=startRoad.EndNode;
                startNode2=null(1,0);
            else
                startNode1=startRoad.StartNode;
                startNode2=startRoad.EndNode;
            end


            if(endRoad.direction=='Forward')
                endNode1=endRoad.StartNode;
                endNode2=null(1,0);
            elseif(endRoad.direction=='Backward')
                endNode1=endRoad.EndNode;
                endNode2=null(1,0);
            else
                endNode1=endRoad.StartNode;
                endNode2=endRoad.EndNode;
            end





            path1=roadUtils.shortestpath(rn,startNode1,endNode1);
            path2=roadUtils.shortestpath(rn,startNode1,endNode2);
            path3=roadUtils.shortestpath(rn,startNode2,endNode1);
            path4=roadUtils.shortestpath(rn,startNode2,endNode2);
            sizes=[length(path1),length(path2),length(path3),...
            length(path4)];
            minimum=intmax;
            index=-1;
            for i=1:4

                if(minimum>sizes(i)&&sizes(i)>0)
                    minimum=sizes(i);
                    index=i;
                end
            end
            if(index==-1)

                nodePath=[];
            elseif(index==1)
                nodePath=path1;
            elseif(index==2)
                nodePath=path2;
            elseif(index==3)
                nodePath=path3;
            elseif(index==4)
                nodePath=path4;
            end
        end
        function roadPath=getRoadTraversal(rn,nodePath)


            nodes=rn.Nodes;
            roads=rn.Roads;
            nodesMap=rn.NodesMap;
            roadsMap=rn.RoadsMap;
            roadPath=[];


            for idx=1:length(nodePath)-1
                startNodeID=nodePath(idx);
                endNodeID=nodePath(idx+1);
                if(roadUtils.checkCommonNode(rn,startNodeID,endNodeID))
                    continue;
                end
                startNodeIdx=nodesMap(startNodeID);
                endNodeIdx=nodesMap(endNodeID);

                roadsLocalID=[nodes(startNodeIdx).outgoingRoads...
                ,nodes(startNodeIdx).incomingRoads];
                count=0;
                roadsCopy=roadsLocalID;
                for subIdx=1:length(roadsLocalID)
                    road=rn.getRoad(roadsLocalID(indx));
                    rdStartNodeID=road.startNode;
                    rdEndNodeID=road.endNode;
                    if(road.direction=="Forward"&&...
                        roadUtils.checkCommonNode(rdStartNodeID,startNodeID)...
                        &&roadUtils.checkCommonNode(rdEndNodeID,endNodeID))
                        count=count+1;
                        roadsCopy(count)=roadsLocalID(indx);
                    elseif(road.direction=="Backward"&&...
                        roadUtils.checkCommonNode(rdEndNodeID,startNodeID)...
                        &&roadUtils.checkCommonNode(rdStartNodeID,endNodeID))
                        count=count+1;
                        roadsCopy(count)=roadsLocalID(indx);
                    elseif((road.direction=="Both"||...
                        road.direction=="Unknown")&&...
                        roadUtils.checkCommonNode(rdStartNodeID,startNodeID)...
                        &&roadUtils.checkCommonNode(rdEndNodeID,endNodeID)...
                        &&roadUtils.checkCommonNode(rdStartNodeID,endNodeID)...
                        &&roadUtils.checkCommonNode(rdEndNodeID,startNodeID))
                        count=count+1;
                        roadsCopy(count)=roadsLocalID(indx);
                    end
                end
                roadsLocalID=roadsCopy(1:count);
            end

        end

        function flag=checkCommonNode(rn,node1,node2)









            roadGraph=rn.roadGraph;
            if(isempty(node1)||isempty(node2))
                flag=0;
                return;
            end
            if(node1==node2)
                flag=1;
                return;
            else
                positionArray=roadGraph.Nodes.Position;
                namesArray=roadGraph.Nodes.Name;
                position1=[];
                position2=[];
                for idx=1:1:length(namesArray)
                    element=namesArray{idx};
                    if(str2double(element)==node1)
                        position1=positionArray(idx,:);
                    end
                    if(str2double(element)==node2)
                        position2=positionArray(idx,:);
                    end
                end
                diff=position1-position2;
                if(norm(diff)<1e-03)
                    flag=1;
                else
                    flag=0;
                end
            end
        end
        function[pathOut,pathTypeOut]=fixClosePoints(~,path,pathType)










            count=1;
            pathOut=zeros(size(path,1)+1,size(path,2));
            pathTypeOut=zeros(size(pathType,1)+1,1);
            for indx=1:size(path,1)-1
                point1=path(indx,:);
                point2=path(indx+1,:);
                dist=norm(point2-point1,2);
                if(indx==1&&dist<=2)
                    pathOut(count,:)=path(indx,:);
                    pathTypeOut(count)=pathType(indx);
                    count=count+1;
                elseif(indx==1&&dist<2)
                    pathOut(count,:)=path(indx,:);
                    pathTypeOut(count)=pathType(indx);
                    count=count+1;
                    pathOut(count,:)=path(indx+1,:);
                    pathTypeOut(count)=pathType(indx+1);
                    count=count+1;
                elseif(indx==size(path,1)-1&&dist>=2)
                    pathOut(count,:)=path(indx,:);
                    pathTypeOut(count)=pathType(indx);
                    count=count+1;
                    pathOut(count,:)=path(indx+1,:);
                    pathTypeOut(count)=pathType(indx+1);
                    count=count+1;
                elseif(indx==size(path,1)-1&&dist<2)
                    pathOut(count,:)=path(indx+1,:);
                    pathTypeOut(count)=pathType(indx+1);
                    count=count+1;
                elseif(dist>=2)
                    pathOut(count,:)=path(indx,:);
                    pathTypeOut(count)=pathType(indx);
                    count=count+1;
                end
            end
            pathOut=pathOut(1:count-1,:);
            pathTypeOut=pathTypeOut(1:count-1);
        end
        function[pathOut,pathTypeOut]=trimEnds(path,pathType,point)











            minDist=intmax;
            index=1;
            for indx=1:size(path,1)
                point1=path(indx,:);
                dist=mathUtils.norm(point1,point,2);
                if(dist<minDist)
                    index=indx;
                    minDist=dist;
                end
            end
            if(index==1)
                pointMin1=path(index,:);
                pointMin2=path(index+1,:);
            elseif(index==size(path,1))
                pointMin1=path(index-1,:);
                pointMin2=path(index,:);
                index=index-1;
            else
                point1=path(index-1,:);
                point2=path(index,:);
                point3=path(index+1,:);
                line1=mathUtils.getLineEquation(point1,point2);
                line2=mathUtils.getPerpedicularLineEquation(line1,point(1:2));
                projPoint1=mathUtils.getIntersectionPointLL(line1,line2);
                if(abs(mathUtils.norm(projPoint1,point1,2)+...
                    mathUtils.norm(projPoint1,point2,2)-...
                    mathUtils.norm(point1,point2,2))<=1e-03)
                    pointMin1=point1;
                    pointMin2=point2;
                    index=index-1;
                else
                    pointMin1=point2;
                    pointMin2=point3;
                end
            end



            line1=mathUtils.getLineEquation(pointMin1,pointMin2);
            line2=mathUtils.getPerpedicularLineEquation(line1,point(1:2));
            projPoint=mathUtils.getIntersectionPointLL(line1,line2);
            pathOut=[projPoint,0;path(index+1:end,:)];
            pathTypeOut=[pathType(index),pathType(index+1:end)];
        end
        function path=shortestPath(rn,startNode,endNode)


            if(isempty(startNode)||isempty(endNode))
                path=[];
                return;
            end
            if(roadUtils.checkCommonNode(startNode,endNode)==1)
                path=[];
                return;
            end
            startNode=num2str(startNode);
            endNode=num2str(endNode);
            graph=rn.roadGraph;
            path=shortestpath(graph,startNode,endNode);
        end

    end
end
