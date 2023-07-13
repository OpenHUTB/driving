function[PositionMat,varargout]=helperSamplePositions(obj,numActors,varargin)






























































    nargoutchk(0,3)

    warning("off","variantgenerator:variantgenerator:noActorsPresent");
    sceneDescriptor=getScenarioDescriptor(obj,Simulator="DrivingScenario");
    tempDS=getScenario(sceneDescriptor,Simulator="DrivingScenario");
    warning("on","variantgenerator:variantgenerator:noActorsPresent");




    narginchk(2,14)
    validateattributes(nargin,{'double'},{'even'})



    parsedInputs=inputParser;


    addOptional(parsedInputs,'ROI',[])





    addOptional(parsedInputs,'LongitudinalDistance',5,...
    @(LongitudinalDistance)validateattributes(LongitudinalDistance,{'double'},...
    {'nonempty','nonnan','real','nonnegative','scalar','>=',5}));

    addOptional(parsedInputs,'Seed',rng(0),...
    @(Seed)validateattributes(Seed,{'struct'},{'nonempty'}));


    addOptional(parsedInputs,'Length',4.7,...
    @(Length)validateattributes(Length,{'double'},...
    {'nonempty','nonnan','real','nonnegative','integer'}));

    addOptional(parsedInputs,'Width',1.8,...
    @(Width)validateattributes(Width,{'double'},...
    {'nonempty','nonnan','real','nonnegative','integer'}));

    addOptional(parsedInputs,'Height',1.4,...
    @(Height)validateattributes(Height,{'double'},...
    {'nonempty','nonnan','real','nonnegative','integer'}));

    addOptional(parsedInputs,'ClassID',3,...
    @(ClassID)validateattributes(ClassID,{'double'},...
    {'nonempty','nonnan','real','integer'}));

    addOptional(parsedInputs,'Lanes',[],...
    @(Lanes)validateattributes(Lanes,{'double'},...
    {'nonnan','real','integer'}));

    addOptional(parsedInputs,'AllLanesCheck',false,...
    @(AllLanesCheck)validateattributes(AllLanesCheck,{'logical'},...
    {'nonempty'}));


    parse(parsedInputs,varargin{:});



    validateattributes(obj,{'drivingScenario'},{'scalar'});


    if isempty(obj.RoadSegments)
        error(message('driving:scenario:RoadsUnavailableInDrivingScenario'));
    end


    if isempty(obj.RoadTiles)
        error(message('driving:scenario:TilesUnavailableInDrivingScenario'));
    end


    validateattributes(numActors,{'double'},...
    {'vector','nonempty','nonnan','nonzero',...
    'real','nonnegative','finite','integer'});

    [actorList,s]=addActors(tempDS,numActors,parsedInputs);


    findYaw=nargout>1;

    getSeed=nargout>2;



    idx=arrayfun(@(x)isa(x,'driving.scenario.Vehicle'),actorList);

    actorList=actorList(idx);


    PositionMat=reshape([actorList.Position],3,[])';
    if findYaw

        Yaw=[actorList.Yaw]';
        varargout{1}=Yaw;
    end

    if getSeed

        varargout{2}=s;
    end

end


























function[actorList,varargout]=addActors(obj,numActors,parsedInputs)

































    nout=max(nargout,1)-1;







    numIter=1;
    if any(ismember(parsedInputs.UsingDefaults,'Seed'))

        rng('default')
    else
        rng(parsedInputs.Results.Seed);
    end
    s=rng;
    actorPlaced=0;
    while numIter
        if~isempty(parsedInputs.Results.ROI)
            ROI=parsedInputs.Results.ROI;

            if isa(ROI,'cell')
                if numel(ROI)<numIter
                    break;
                end
                ROI=ROI{numIter};
                if~isa(ROI,'double')||size(ROI,2)~=2
                    warning(message...
                    ('driving:scenario:InvalidRegionOfInterestElements'));
                    numIter=numIter+1;
                    continue;
                end
                numIter=numIter+1;
            else
                numIter=0;
            end
            validateattributes(ROI,{'double'},{'size',[NaN,2],'nonnan'});

            if size(ROI,1)<2
                error(message('driving:scenario:ROICoordinatesInsufficient'));
            elseif size(ROI,1)==2
                ROI=repmat(ROI,[2,1]);
                ROI([2,3])=ROI([3,2]);
            end


            ROI=sortArea(ROI);




            index=searchRoadBoundaries(obj,ROI);
            insideTiles=obj.RoadTiles(index);
        else
            numIter=0;



            insideTiles=obj.RoadTiles([obj.RoadTiles.TileID]~=0);




            insideTiles=insideTiles([insideTiles.RoadID]~=0);
        end




        LongitudinalDistance=max(parsedInputs.Results.LongitudinalDistance,...
        parsedInputs.Results.Length);


        if isempty(insideTiles)

            error('RoadsUnavailableInROI');
        end

        RoadIDList=[insideTiles.RoadID];


        [roadBank,maxCount]=createWeightedRoadBank(obj,...
        RoadIDList,LongitudinalDistance,parsedInputs);

        if~maxCount
            error('ActorsOverloaded');
        end


        if maxCount<numActors
            warning('ExceedActorCount');
            numActors=maxCount;
        end

        actors=populateMap(obj,roadBank,...
        insideTiles,LongitudinalDistance,numActors,parsedInputs);

        newActorsCount=length(actors);
        actorList(actorPlaced+1:actorPlaced+newActorsCount)=actors;
        actorPlaced=actorPlaced+newActorsCount;
    end


    actorList(actorPlaced+1:end)=[];
    varargout=cell(1);
    for k=1:nout

        varargout{k}=s;
    end
end
function index=searchRoadBoundaries(ds,poly)

    index=inpolygon(ds.RoadTileCentroids(:,1),ds.RoadTileCentroids(:,2)...
    ,poly(:,1),poly(:,2));
end
function ROI=sortArea(ROI)

    ROICentroid=mean(ROI);
    VerticeAngles=atan2(ROI(:,2)-ROICentroid(2),ROI(:,1)-ROICentroid(1));
    [~,order]=sort(VerticeAngles);
    ROI=ROI(order,:);
    if~isequal(ROI(end,:),ROI(1,:))
        ROI(end+1,:)=ROI(1,:);
    end
end
function[actorList]=populateMap(obj,roadBank,insideTiles,DistanceOffset,numActors,parseInputs)

    roads=roadBank(1,:);


    tempScenario=eval(class(obj));
    actorList=repmat(actor(tempScenario),[1,numActors]);
    actorPlaced=0;
    actorsPresent=checkVehicleonRoad(obj,roads);


    actorDistNum=distributeActors(numActors,roadBank);

    while actorPlaced<numActors
        i=randi([1,numel(roads)]);

        if actorDistNum(i)==0
            continue;
        end
        if actorDistNum(i)+actorPlaced>numActors
            actorsToPlace=actorDistNum(i)+actorPlaced-numActors;
        else
            actorsToPlace=actorDistNum(i);
        end


        RoadListArray=insideTiles([insideTiles.RoadID]==roads(i));


        JunctionIndexes=arrayfun(@(x)size(x.Vertices,1)>4,RoadListArray);



        JunctionTiles=RoadListArray(JunctionIndexes);
        RoadListArray(JunctionIndexes)=[];
        for junction=JunctionTiles
            AbTiles=junction.AbuttingTileIDs;
            [~,RemoveTiles]=intersect([RoadListArray.TileID],AbTiles);
            RoadListArray(RemoveTiles)=[];
        end

        Tiles=RoadListArray;
        structIdx=find([actorsPresent.RoadID]==roads(i));





        if~isempty(structIdx)
            actorsOnLane=actorsPresent(structIdx).ActorID;
            availLanes=getAvailTileLanes(obj,Tiles,DistanceOffset,...
            parseInputs,actorsOnLane);
        else
            availLanes=getAvailTileLanes(obj,Tiles,DistanceOffset,...
            parseInputs);
        end




        actors=putActorInLanes(obj,availLanes,actorsToPlace,parseInputs);

        newActorsCount=length(actors);
        actorList(actorPlaced+1:actorPlaced+newActorsCount)=actors;
        actorPlaced=actorPlaced+newActorsCount;
        roads(i)=[];
        actorDistNum(i)=[];
    end
    actorList(actorPlaced+1:end)=[];
end

function actorList=putActorInLanes(obj,availLanes,numActors,parseInputs,varargin)

    iActor=1;
    tempScenario=eval(class(obj));
    actorList=repmat(actor(tempScenario),[1,numActors]);
    while iActor<=numActors
        if isempty([availLanes.TileID])
            warning('Can not place more actors on the road')
            break;
        end
        numTiles=size(availLanes,2);
        rowSel=randi([1,numTiles],1);
        if isempty(availLanes(rowSel).Lanes)
            availLanes(rowSel)=[];
            continue
        end
        Tile=obj.RoadTiles(availLanes(rowSel).TileID);
        road=obj.RoadSegments(Tile.RoadID);
        LaneWidthProps=road.LaneMarkingLocation;
        inLane=false;
        while~inLane

            idx=randi([1,numel(availLanes(rowSel).Lanes)],1);

            currLane=availLanes(rowSel).Lanes(idx);
            currLaneWidth=LaneWidthProps(currLane+1)-LaneWidthProps(currLane);

            if currLaneWidth<parseInputs.Results.Width
                inLane=false;
                availLanes(rowSel).Lanes(idx)=[];
                if isempty(availLanes(rowSel).Lanes)
                    availLanes(rowSel)=[];
                    break;
                end
                continue
            end
            availLanes(rowSel).Lanes(idx)=[];






            Vertices=Tile.Vertices;
            A=Vertices(1,:);
            B=Vertices(4,:);
            C=Vertices(2,:);
            D=Vertices(3,:);
            u=diff([A;B]);

            yaw=atan2d(u(2),u(1));
            if~isscalar(road.NumLanes)&&currLane<=road.NumLanes(1)
                yaw=yaw+180;
            end



            Center1=(A+B)/2;
            Center2=(C+D)/2;

            if all(u(1:2)==0)
                pitch=90;
            else
                pitch=atan2d(-u(3),sqrt(sum(u(1:2).^2)));
            end

            m=(LaneWidthProps(currLane+1)-LaneWidthProps(currLane))/2+LaneWidthProps(currLane);
            n=LaneWidthProps(end)-m;


            inLane=true;
            Position=(n*(Center1)+m*(Center2))/LaneWidthProps(end);
            egoVehicle=vehicle(obj,'Position',Position,'Length',parseInputs.Results.Length,...
            'Width',parseInputs.Results.Width,'Height',parseInputs.Results.Height,...
            'ClassID',parseInputs.Results.ClassID,'Yaw',yaw,'Pitch',pitch);
            idx=find(road.TileID==Tile.TileID,1);
            roadDistance=road.DistanceTraveled(idx);
            DistanceOffset=parseInputs.Results.LongitudinalDistance;
            upperBound=min(roadDistance+DistanceOffset,...
            road.DistanceTraveled(end));
            lowerBound=max(roadDistance-DistanceOffset,...
            road.DistanceTraveled(1));
            TilesIDX=road.TileID(road.DistanceTraveled<upperBound&...
            road.DistanceTraveled>lowerBound);
            tf=ismember([availLanes.TileID],TilesIDX);
            for j=1:numel(tf)
                if tf(j)
                    Lanes=availLanes(j).Lanes;
                    idx=find(Lanes==currLane,1);
                    if~isempty(idx)
                        Lanes(idx)=[];
                    end
                    availLanes(j).Lanes=Lanes;
                end
            end


            actorList(iActor)=egoVehicle;
            iActor=iActor+1;
        end
    end
end

function actorsOnRoad=checkVehicleonRoad(ds,roads)



    numRoads=numel(roads);
    actorsOnRoad(numRoads)=struct('RoadID',[],...
    'ActorID',[]);
    RoadsWithCars=0;
    for i=1:numel(ds.Actors)
        actor=ds.Actors(i);
        currLane=actor.currentLane;
        if isempty(currLane)
            continue
        end
        roadTile=closestRoadTile(ds,actor.Position);
        idx=find(roads==roadTile.RoadID,1);
        if isempty(idx)
            continue;
        end
        if isempty([actorsOnRoad.RoadID])
            RoadsWithCars=1;
            actorsOnRoad(RoadsWithCars).RoadID=roads(idx);
            actorsOnRoad(RoadsWithCars).ActorID=[actorsOnRoad.ActorID,actor.ActorID];

        else
            presentRoad=find([actorsOnRoad.RoadID]==roads(idx),1);
            if isempty(presentRoad)
                RoadsWithCars=RoadsWithCars+1;
                actorsOnRoad(RoadsWithCars).RoadID=roads(idx);
                actorsOnRoad(RoadsWithCars).ActorID=actor.ActorID;
            else
                actorsOnRoad(presentRoad).ActorID=[actorsOnRoad(presentRoad).ActorID,actor.ActorID];
            end

        end
    end
end
function[roadBank,maxCount]=createWeightedRoadBank(ds,RoadIDList,DistanceOffset,parsedInputs)






    ActorWidth=parsedInputs.Results.Width;
    Ncounts=histcounts(RoadIDList,[unique(RoadIDList),inf]);
    [Ncounts,road_order]=sort(Ncounts,'descend');
    RoadIDList=unique(RoadIDList);
    RoadIDList=RoadIDList(road_order);
    roadBank=[RoadIDList;Ncounts];


    removeRoads=find(Ncounts<2,1);
    roadBank(:,removeRoads:end)=[];
    maxCount=0;
    actorsPresent=checkVehicleonRoad(ds,roadBank(1,:));


    i=1;
    while i<=size(roadBank,2)

        roadMaxCount=0;
        roadID=roadBank(1,i);


        TileLength=ds.RoadSegments(roadID).DistanceTraveled(2);


        RoadLength=roadBank(2,i)*TileLength;

        if RoadLength<DistanceOffset
            roadBank(:,i:end)=[];
            break;
        else


            if parsedInputs.Results.AllLanesCheck
                idx=1:numel(ds.RoadSegments(roadID).LaneType);
            else
                idx=find(ds.RoadSegments(roadID).LaneType=='Driving');
            end
            if~isempty(parsedInputs.Results.Lanes)
                idx=intersect(idx,parsedInputs.Results.Lanes);
            end
            if isempty(idx)
                roadBank(:,i)=[];
                continue;
            else


                lanewidth=diff(ds.RoadSegments(roadID).LaneMarkingLocation);
                lanewidth=lanewidth(lanewidth(idx)>ActorWidth);
                if isempty(lanewidth)
                    roadBank(:,i)=[];
                    continue;
                end
                clusterLength=ceil(DistanceOffset/TileLength);
                numClusters=roadBank(2,i);


                roadMaxCount=roadMaxCount+floor(numClusters/clusterLength)...
                *numel(lanewidth);


                roadMaxCount=roadMaxCount-3*floor(roadMaxCount/20);
                structIdx=find([actorsPresent.RoadID]==roadID,1);
                if~isempty(structIdx)
                    roadMaxCount=roadMaxCount-numel(actorsPresent(structIdx).ActorID);
                    if roadMaxCount<=0
                        roadBank(:,i)=[];
                        continue;
                    end
                end
                roadBank(2,i)=roadMaxCount;
            end
        end

        maxCount=maxCount+roadMaxCount;
        i=i+1;
    end
    [~,road_order]=sort(roadBank(2,:),'descend');
    roadBank=roadBank(:,road_order);
    roadBank(2,:)=roadBank(2,:)/sum(roadBank(2,:));
end
function actorDist=distributeActors(numActors,roadBank)

    numRoads=size(roadBank,2);
    distribution=roadBank(2,:);
    actorDist=floor(numActors*distribution);
    actorLeft=numActors-sum(actorDist);

    if actorLeft==0
        return
    elseif actorLeft<numRoads
        actorDist(1:actorLeft)=actorDist(1:actorLeft)+1;
    else
        RepeatItr=ceil(actorLeft/numRoads);
        actorPlus=zeros([1,RepeatItr]);
        actorPlus(RepeatItr)=mod(actorLeft,numRoads);
        actorPlus(actorPlus==0)=numTiles;
        actorDist=actorDist+actorPlus;
    end
end
function[PositionMat,varargout]=getActorPositions(obj,numActors,varargin)

    tempScenario=eval(class(obj));
    copyRoad(tempScenario,obj)
    if isempty(varargin)
        actorList=addActors(tempScenario,numActors);
    else
        actorList=addActors(tempScenario,numActors,varargin{:});
    end

    findYaw=nargout>1;

    PositionMat=zeros([numel(actorList),3]);
    if findYaw
        Yaw=zeros([numel(actorList),1]);
    end

    for iActor=1:numel(actorList)
        actor=actorList(iActor);
        PositionMat(iActor,:)=actor.Position;
        if findYaw
            Yaw(iActor)=actor.Yaw;
        end
    end

    if findYaw
        varargout{1}=Yaw;
    end
end
function availLanes=getAvailTileLanes(ds,Tiles,DistanceOffset,parseInputs,varargin)


    availLanes=struct('TileID',[],'Lanes',[]);
    road=ds.RoadSegments(Tiles(1).RoadID);
    if parseInputs.Results.AllLanesCheck
        totalLanes=1:numel(road.LaneType);
    else
        totalLanes=find(road.LaneType=='Driving');
    end
    for i=1:numel(Tiles)
        availLanes(i).TileID=Tiles(i).TileID;
        if isempty(parseInputs.Results.Lanes)
            availLanes(i).Lanes=totalLanes;
        else
            availLanes(i).Lanes=intersect(totalLanes,parseInputs.Results.Lanes);
        end
    end
    if~isempty(varargin)
        actorsOnLane=varargin{1};
        for actorID=actorsOnLane
            actor=ds.Actors(actorID);
            roadTile=closestRoadTile(ds,actor.Position);
            A=roadTile.Vertices(1,:);
            B=roadTile.Vertices(4,:);
            u=diff([A;B]);
            [currLane,numLanes]=actor.currentLane;


            if dot(u,actor.ForwardVector)<0
                currLane=sum(numLanes)-currLane+1;
            end
            idx=find(road.TileID==roadTile.TileID,1);
            roadDistance=road.DistanceTraveled(idx);
            upperBound=min(roadDistance+DistanceOffset,...
            road.DistanceTraveled(end));
            lowerBound=max(roadDistance-DistanceOffset,...
            road.DistanceTraveled(1));
            TilesIDX=road.TileID(road.DistanceTraveled<upperBound&...
            road.DistanceTraveled>lowerBound);
            tf=ismember([availLanes.TileID],TilesIDX);
            for i=1:numel(tf)
                if tf(i)
                    Lanes=availLanes(i).Lanes;
                    idx=find(Lanes==currLane,1);
                    if~isempty(idx)
                        Lanes(idx)=[];
                    end
                    availLanes(i).Lanes=Lanes;
                end
            end

        end
    end
end