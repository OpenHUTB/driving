function[PositionMat,varargout]=helperSamplePositions(obj,numActors,varargin)





























































% 设置允许的输出参数个数在0到3之间
nargoutchk(0, 3);

% 关闭特定警告信息，"variantgenerator:variantgenerator:noActorsPresent"
warning("off", "variantgenerator:variantgenerator:noActorsPresent");

% 获取场景描述符，Simulator类型为"DrivingScenario"的场景
sceneDescriptor = getScenarioDescriptor(obj, Simulator="DrivingScenario");

% 根据场景描述符创建临时DrivingScenario对象
tempDS = getScenario(sceneDescriptor, Simulator="DrivingScenario");

% 开启特定警告信息，"variantgenerator:variantgenerator:noActorsPresent"
warning("on", "variantgenerator:variantgenerator:noActorsPresent");

% 设置输入参数个数在2到14之间
narginchk(2, 14);

% 验证输入参数nargin为偶数
validateattributes(nargin, {'double'}, {'even'});

% 创建输入解析器对象
parsedInputs = inputParser;

% 添加可选参数'ROI'，默认为空
addOptional(parsedInputs, 'ROI', []);




    % 添加可选参数'LongitudinalDistance'，默认值为5，验证该参数满足一系列属性
addOptional(parsedInputs, 'LongitudinalDistance', 5, ...
    @(LongitudinalDistance) validateattributes(LongitudinalDistance, {'double'}, ...
    {'nonempty', 'nonnan', 'real', 'nonnegative', 'scalar', '>=', 5}));

% 添加可选参数'Seed'，默认为rng(0)，验证该参数满足一系列属性
addOptional(parsedInputs, 'Seed', rng(0), ...
    @(Seed) validateattributes(Seed, {'struct'}, {'nonempty'}));

% 添加可选参数'Length'，默认值为4.7，验证该参数满足一系列属性
addOptional(parsedInputs, 'Length', 4.7, ...
    @(Length) validateattributes(Length, {'double'}, ...
    {'nonempty', 'nonnan', 'real', 'nonnegative', 'integer'}));

% 添加可选参数'Width'，默认值为1.8，验证该参数满足一系列属性
addOptional(parsedInputs, 'Width', 1.8, ...
    @(Width) validateattributes(Width, {'double'}, ...
    {'nonempty', 'nonnan', 'real', 'nonnegative', 'integer'}));

% 添加可选参数'Height'，默认值为1.4，验证该参数满足一系列属性
addOptional(parsedInputs, 'Height', 1.4, ...
    @(Height) validateattributes(Height, {'double'}, ...
    {'nonempty', 'nonnan', 'real', 'nonnegative', 'integer'}));

% 添加可选参数'ClassID'，默认值为3，验证该参数满足一系列属性
addOptional(parsedInputs, 'ClassID', 3, ...
    @(ClassID) validateattributes(ClassID, {'double'}, ...
    {'nonempty', 'nonnan', 'real', 'integer'}));

% 添加可选参数'Lanes'，默认为空，验证该参数满足一系列属性
addOptional(parsedInputs, 'Lanes', [], ...
    @(Lanes) validateattributes(Lanes, {'double'}, ...
    {'nonnan', 'real', 'integer'}));

% 添加可选参数'AllLanesCheck'，默认为false，验证该参数满足一系列属性
addOptional(parsedInputs, 'AllLanesCheck', false, ...
    @(AllLanesCheck) validateattributes(AllLanesCheck, {'logical'}, ...
    {'nonempty'}));


   % 使用输入解析器parsedInputs解析传入的变长参数varargin
parse(parsedInputs, varargin{:});

% 验证输入参数obj为scalar（标量）
validateattributes(obj, {'drivingScenario'}, {'scalar'});

% 如果场景对象obj的RoadSegments为空，则抛出错误：无法在DrivingScenario中找到道路
if isempty(obj.RoadSegments)
    error(message('driving:scenario:RoadsUnavailableInDrivingScenario'));
end

% 如果场景对象obj的RoadTiles为空，则抛出错误：无法在DrivingScenario中找到道路瓷砖
if isempty(obj.RoadTiles)
    error(message('driving:scenario:TilesUnavailableInDrivingScenario'));
end

% 验证输入参数numActors为非空、非NaN、非零、实数、非负数、有限的整数向量
validateattributes(numActors, {'double'}, ...
    {'vector', 'nonempty', 'nonnan', 'nonzero', 'real', 'nonnegative', 'finite', 'integer'});

% 调用addActors函数，在tempDS场景对象中添加numActors个演员，使用解析后的输入参数parsedInputs
[actorList, s] = addActors(tempDS, numActors, parsedInputs);

% 判断是否有输出参数要获取演员的Yaw信息
findYaw = nargout > 1;

% 判断是否有输出参数要获取随机数生成器状态s
getSeed = nargout > 2;

% 使用arrayfun函数遍历actorList，判断每个元素是否为driving.scenario.Vehicle类型，返回逻辑索引idx
idx = arrayfun(@(x) isa(x, 'driving.scenario.Vehicle'), actorList);

% 根据逻辑索引idx，保留actorList中为driving.scenario.Vehicle类型的元素
actorList = actorList(idx);

% 将actorList中演员的位置信息按行排列，存储在PositionMat矩阵中
PositionMat = reshape([actorList.Position], 3, [])';

% 如果需要获取Yaw信息
if findYaw
    % 获取actorList中演员的Yaw信息，存储在Yaw向量中
    Yaw = [actorList.Yaw]';
    % 将Yaw向量作为输出参数保存在varargout的第一个位置
    varargout{1} = Yaw;
end

% 如果需要获取随机数生成器状态s
if getSeed
    % 将随机数生成器状态s作为输出参数保存在varargout的第二个位置
    varargout{2} = s;
end
end


























function[actorList,varargout]=addActors(obj,numActors,parsedInputs)
































% 计算输出参数个数nout，最小为1
    nout=max(nargout,1)-1;
% 初始化迭代次数为1
numIter = 1;

% 检查是否有未指定'Seed'的情况
if any(ismember(parsedInputs.UsingDefaults, 'Seed'))
    % 如果未指定'Seed'，则将随机数生成器重置为默认状态
    rng('default');
else
    % 否则，使用输入参数中指定的种子值初始化随机数生成器
    rng(parsedInputs.Results.Seed);
end

% 保存当前随机数生成器状态
s = rng;

% 已放置的演员数量初始化为0
actorPlaced = 0;

% 迭代直到numIter为0
    while numIter
        % 如果指定了输入参数ROI，则从解析后的输入参数中获取ROI
        if~isempty(parsedInputs.Results.ROI)
        ROI = parsedInputs.Results.ROI;

        % 如果ROI是cell数组
        if isa(ROI, 'cell')
            % 如果ROI元素数量小于numIter，则退出循环
            if numel(ROI) < numIter
                break;
            end
            % 获取ROI中的当前元素
            ROI = ROI{numIter};
            % 如果ROI不是double类型的或者第二维度不是2，则发出警告，并进入下一次循环
            if ~isa(ROI, 'double') || size(ROI, 2) ~= 2
                warning(message('driving:scenario:InvalidRegionOfInterestElements'));
                numIter = numIter + 1;
                continue;
            end
            % 增加迭代次数
            numIter = numIter + 1;
        else
            % 如果ROI不是cell数组，则设置numIter为0，退出循环
            numIter = 0;
        end

        % 验证ROI是一个NaN元素为空的2列数组
        validateattributes(ROI, {'double'}, {'size', [NaN, 2], 'nonnan'});

        % 如果ROI的行数小于2，则抛出错误
        if size(ROI, 1) < 2
            error(message('driving:scenario:ROICoordinatesInsufficient'));
        % 如果ROI的行数等于2，则复制成4行2列的矩阵
        elseif size(ROI, 1) == 2
            ROI = repmat(ROI, [2, 1]);
            ROI([2, 3]) = ROI([3, 2]);
        end

        % 对ROI按顺时针排序
        ROI = sortArea(ROI);




% 如果指定了输入参数ROI，则搜索满足ROI边界条件的道路瓷砖的索引，并将结果保存在index变量中
index = searchRoadBoundaries(obj, ROI);

% 根据索引获取满足ROI边界条件的道路瓷砖，保存在insideTiles变量中
insideTiles = obj.RoadTiles(index);

% 如果未指定输入参数ROI，则执行以下代码块
else
    % 将numIter设置为0，表示不需要继续迭代处理
    numIter = 0;

    % 获取所有非零TileID的道路瓷砖，保存在insideTiles变量中
    insideTiles = obj.RoadTiles([obj.RoadTiles.TileID] ~= 0);

    % 从所有非零道路瓷砖中筛选出非零RoadID的道路瓷砖，更新insideTiles变量
    insideTiles = insideTiles([insideTiles.RoadID] ~= 0);
end




        LongitudinalDistance=max(parsedInputs.Results.LongitudinalDistance,...
        parsedInputs.Results.Length);


        % 检查insideTiles是否为空，如果是，则表示在给定ROI范围内没有可用的道路瓷砖
% 抛出异常'RoadsUnavailableInROI'，并终止程序执行
if isempty(insideTiles)
    error('RoadsUnavailableInROI');
end

% 获取insideTiles中的道路ID，并保存在RoadIDList变量中
RoadIDList = [insideTiles.RoadID];

% 根据道路ID列表和LongitudinalDistance，创建一个加权的道路库roadBank
% 同时获取最大的加权值maxCount
[roadBank, maxCount] = createWeightedRoadBank(obj, RoadIDList, LongitudinalDistance, parsedInputs);

% 如果最大加权值maxCount为0，则表示在给定条件下无法添加更多的角色
% 抛出异常'ActorsOverloaded'，并终止程序执行
if ~maxCount
    error('ActorsOverloaded');
end

% 如果最大加权值maxCount小于numActors（角色数量），则输出警告信息
% 同时将numActors更新为maxCount，以限制生成的角色数量
if maxCount < numActors
    warning('ExceedActorCount');
    numActors = maxCount;
end

% 调用populateMap函数，生成并添加numActors数量的角色到道路瓷砖上
% 然后将新生成的角色actors保存在actors变量中
actors = populateMap(obj, roadBank, insideTiles, LongitudinalDistance, numActors, parsedInputs);

% 获取新生成的角色数量newActorsCount，并将这些角色添加到actorList变量中
actorList(actorPlaced+1:actorPlaced+newActorsCount) = actors;

% 更新actorPlaced变量，表示已经添加了新的角色数量
actorPlaced = actorPlaced + newActorsCount;
    end

% 从actorList列表中删除未使用的部分，actorPlaced之后的角色对象不会被使用
actorList(actorPlaced+1:end) = [];

% 创建一个cell数组varargout，并将其初始化为1x1大小的空cell数组
varargout = cell(1);

% 根据nout的值（最大输出参数数量-1），为varargout赋值
% 依次将之前保存在变量s中的rng对象赋给varargout的不同元素
% 这样在函数返回时，varargout将会包含不同的输出参数，取决于nout的值
for k = 1:nout
    varargout{k} = s;
end
end

% 这个函数用于在ds（drivingScenario对象）中搜索满足poly多边形边界条件的道路瓷砖的索引。
% 参数ds是drivingScenario对象，poly是多边形的顶点坐标数组。
% 函数使用inpolygon函数来判断道路瓷砖的中心坐标是否在多边形内部，并返回满足条件的道路瓷砖的索引。
function index = searchRoadBoundaries(ds, poly)
    index = inpolygon(ds.RoadTileCentroids(:,1), ds.RoadTileCentroids(:,2), poly(:,1), poly(:,2));
end

% 这个函数用于对ROI（Region of Interest）多边形的顶点按照顺时针角度进行排序。
% 参数ROI是一个多边形的顶点坐标数组。
% 函数首先计算ROI的中心坐标ROICentroid，然后计算每个顶点与中心坐标的极角VerticeAngles。
% 接着根据极角对ROI的顶点进行排序，并将排序后的ROI保存在ROI变量中。
% 最后，函数检查ROI的最后一个顶点是否与第一个顶点相同，如果不同，则将第一个顶点复制并添加到ROI的末尾，以确保ROI为闭合多边形。
function ROI = sortArea(ROI)
    ROICentroid = mean(ROI);
    VerticeAngles = atan2(ROI(:,2) - ROICentroid(2), ROI(:,1) - ROICentroid(1));
    [~, order] = sort(VerticeAngles);
    ROI = ROI(order, :);
    if ~isequal(ROI(end, :), ROI(1, :))
        ROI(end+1, :) = ROI(1, :);
    end
end
% 这个函数用于在道路瓷砖内部分布指定数量的角色，并将它们添加到actorList中。
% 参数obj是drivingScenario对象，roadBank是加权的道路库，insideTiles是在ROI内的道路瓷砖，DistanceOffset是角色之间的最小间隔，
% numActors是要生成的角色数量，parseInputs是输入参数解析器对象。

function [actorList] = populateMap(obj, roadBank, insideTiles, DistanceOffset, numActors, parseInputs)

    % 从roadBank中获取道路瓷砖的ID列表
    roads = roadBank(1, :);

    % 获取一个临时的drivingScenario类对象，用于生成角色对象
    tempScenario = eval(class(obj));

    % 使用repmat函数创建一个空的actorList数组，准备将生成的角色对象添加进去
    actorList = repmat(actor(tempScenario), [1, numActors]);

    % 初始化actorPlaced变量为0，用于记录已经放置的角色数量
    actorPlaced = 0;

    % 使用checkVehicleonRoad函数，检查道路上是否已经有其他角色存在，并将结果保存在actorsPresent变量中
    actorsPresent = checkVehicleonRoad(obj, roads);

    % 使用distributeActors函数，计算在每个道路上分布的角色数量
    actorDistNum = distributeActors(numActors, roadBank);

    % 开始生成并分布角色对象
    while actorPlaced < numActors
        % 从roads中随机选择一个道路
        i = randi([1, numel(roads)]);

        % 如果该道路已经达到了在该道路上分布的角色数量，则跳过这个道路，继续选择下一个道路
        if actorDistNum(i) == 0
            continue;
        end

        % 计算在当前道路上需要放置的角色数量
        if actorDistNum(i) + actorPlaced > numActors
            actorsToPlace = actorDistNum(i) + actorPlaced - numActors;
        else
            actorsToPlace = actorDistNum(i);
        end

        % 从insideTiles中获取当前道路的相关信息
        RoadListArray = insideTiles([insideTiles.RoadID] == roads(i));

        %从RoadListArray中选取具有交叉点的道路瓷砖。
        JunctionTiles=RoadListArray(JunctionIndexes);
        %移除具有交叉点的道路瓷砖
        RoadListArray(JunctionIndexes)=[];
        for junction=JunctionTiles
            AbTiles=junction.AbuttingTileIDs;
            [~,RemoveTiles]=intersect([RoadListArray.TileID],AbTiles);
            RoadListArray(RemoveTiles)=[];
        end

    % 将当前道路的信息保存在Tiles变量中
        Tiles = RoadListArray;

        % 在actorsPresent中找到属于当前道路的角色的索引
        structIdx = find([actorsPresent.RoadID] == roads(i));




% 检查 'structIdx' 变量是否非空
if ~isempty(structIdx)
    % 从 'structIdx' 数组中获取存在的演员（Actor）ID
    actorsOnLane = actorsPresent(structIdx).ActorID;
    % 根据各种输入条件（包括 'actorsOnLane'）获取可用车道（availLanes）
    availLanes = getAvailTileLanes(obj, Tiles, DistanceOffset, parseInputs, actorsOnLane);
else
    % 获取不考虑车道上任何演员的可用车道（availLanes）
    availLanes = getAvailTileLanes(obj, Tiles, DistanceOffset, parseInputs);
end

% 将演员（actorsToPlace）放置在上面获取的可用车道（availLanes）上
actors = putActorInLanes(obj, availLanes, actorsToPlace, parseInputs);

% 获取新放置演员（actors）的数量
newActorsCount = length(actors);

% 将新放置的演员（actors）从适当的位置添加到演员列表（actorList）中
actorList(actorPlaced + 1 : actorPlaced + newActorsCount) = actors;

% 更新 'actorPlaced' 变量，指向演员列表（actorList）中最后一个放置演员的位置
actorPlaced = actorPlaced + newActorsCount;

% 从 'roads' 数组中移除第 'i' 个元素
roads(i) = [];

% 从 'actorDistNum' 数组中移除第 'i' 个元素
actorDistNum(i) = [];

    end
    actorList(actorPlaced+1:end)=[];
end

function actorList = putActorInLanes(obj, availLanes, numActors, parseInputs, varargin)
    % 初始化演员计数器
    iActor = 1;
    
    % 创建一个临时场景以获取演员类型
    tempScenario = eval(class(obj));
    
    % 初始化演员列表，用于存放放置的演员
    actorList = repmat(actor(tempScenario), [1, numActors]);
    
    % 循环放置演员，直到放置完指定数量的演员
    while iActor <= numActors
        % 检查是否还有可用车道来放置演员
        if isempty([availLanes.TileID])
            warning('无法在道路上放置更多的演员');
            break;
        end
        
        % 获取可用车道的数量
        numTiles = size(availLanes, 2);
        
        % 随机选择一个车道来放置演员
        rowSel = randi([1, numTiles], 1);
        
        % 检查选定的车道是否没有可用的车道
        if isempty(availLanes(rowSel).Lanes)
            % 如果没有可用的车道，则从可用车道列表中删除该车道，并继续下一个演员的放置
            availLanes(rowSel) = [];
            continue;
        end
        
        % 获取选定车道所在的路段和路的属性
        Tile = obj.RoadTiles(availLanes(rowSel).TileID);
        road = obj.RoadSegments(Tile.RoadID);
        LaneWidthProps = road.LaneMarkingLocation;
        
        % 初始化标志变量，用于指示是否成功放置演员
        inLane = false;
        while ~inLane
    % 从可用车道中的当前车道中随机选择一个车道索引
    idx = randi([1, numel(availLanes(rowSel).Lanes)], 1);
    
    % 获取当前车道的索引
    currLane = availLanes(rowSel).Lanes(idx);
    
    % 获取当前车道的宽度
    currLaneWidth = LaneWidthProps(currLane + 1) - LaneWidthProps(currLane);

    % 检查当前车道是否宽度足够放置演员
    if currLaneWidth < parseInputs.Results.Width
        % 如果当前车道宽度不足，则继续尝试下一个车道
        inLane = false;
        % 从可用车道中删除该车道
        availLanes(rowSel).Lanes(idx) = [];
        % 检查是否还有其他车道可供选择
        if isempty(availLanes(rowSel).Lanes)
            % 如果当前道路没有其他可用车道，则从可用车道列表中删除该道路
            availLanes(rowSel) = [];
            break;
        end
        % 继续选择下一个车道进行尝试放置
        continue;
    end
    % 从可用车道中删除该车道，因为演员将被放置在这里
    availLanes(rowSel).Lanes(idx) = [];

    % 获取当前道路瓦片（Tile）的顶点
    Vertices = Tile.Vertices;
    A = Vertices(1, :);
    B = Vertices(4, :);
    C = Vertices(2, :);
    D = Vertices(3, :);
    u = diff([A; B]);

    % 计算车道的航向角（yaw）
    yaw = atan2d(u(2), u(1));
    
    % 如果路段的车道数不是标量，并且当前车道位于第一个车道（road.NumLanes(1)）之内，
    % 则将航向角（yaw）加上180度（因为车道方向可能与正方向相反）
    if ~isscalar(road.NumLanes) && currLane <= road.NumLanes(1)
        yaw = yaw + 180;
    end




% 计算车道的中心点
Center1 = (A + B) / 2;
Center2 = (C + D) / 2;

% 根据车道的方向（u向量）计算车道的俯仰角（pitch）
if all(u(1:2) == 0)
    pitch = 90;
else
    pitch = atan2d(-u(3), sqrt(sum(u(1:2).^2)));
end

% 计算车道的宽度信息
m = (LaneWidthProps(currLane + 1) - LaneWidthProps(currLane)) / 2 + LaneWidthProps(currLane);
n = LaneWidthProps(end) - m;

% 设置 inLane 为 true，表示演员将被放置在车道中
inLane = true;

% 计算放置演员的位置（Position）
Position = (n * Center1 + m * Center2) / LaneWidthProps(end);

% 创建演员对象（egoVehicle），并设置其位置、长度、宽度、高度、类别、航向角（yaw）和俯仰角（pitch）
egoVehicle = vehicle(obj, 'Position', Position, 'Length', parseInputs.Results.Length, ...
    'Width', parseInputs.Results.Width, 'Height', parseInputs.Results.Height, ...
    'ClassID', parseInputs.Results.ClassID, 'Yaw', yaw, 'Pitch', pitch);

% 找到当前瓦片在路段（road）中的索引
idx = find(road.TileID == Tile.TileID, 1);

% 获取车道距离
roadDistance = road.DistanceTraveled(idx);

% 获取演员放置时的车道距离偏移量（LongitudinalDistance）
DistanceOffset = parseInputs.Results.LongitudinalDistance;

% 计算演员放置位置的上界和下界
upperBound = min(roadDistance + DistanceOffset, road.DistanceTraveled(end));
lowerBound = max(roadDistance - DistanceOffset, road.DistanceTraveled(1));

% 获取车道在上界和下界之间的瓦片索引
TilesIDX = road.TileID(road.DistanceTraveled < upperBound & ...
    road.DistanceTraveled > lowerBound);

% 确定哪些可用车道（availLanes）包含这些瓦片
tf = ismember([availLanes.TileID], TilesIDX);

% 更新可用车道中的车道信息，从中删除当前车道
for j = 1:numel(tf)
    % 检查是否当前车道在可用车道（availLanes）中
    if tf(j)
        % 获取当前可用车道（availLanes）的车道信息
        Lanes = availLanes(j).Lanes;
        % 查找当前车道在车道信息中的索引
        idx = find(Lanes == currLane, 1);
        % 如果找到了当前车道的索引，则从可用车道中删除该车道
        if ~isempty(idx)
            Lanes(idx) = [];
        end
        % 更新可用车道中的车道信息
        availLanes(j).Lanes = Lanes;
    end
end



% 将成功放置的演员（egoVehicle）添加到演员列表（actorList）中
actorList(iActor) = egoVehicle;

% 增加演员计数器，以准备放置下一个演员
iActor = iActor + 1;
        end
    end
end

function actorsOnRoad=checkVehicleonRoad(ds,roads)


% 获取道路数量
numRoads = numel(roads);

% 初始化用于记录车辆信息的结构数组 actorsOnRoad
actorsOnRoad(numRoads) = struct('RoadID', [], 'ActorID', []);

% 初始化记录有车辆的道路数
RoadsWithCars = 0;

% 遍历数据集中的每个车辆
for i = 1:numel(ds.Actors)
    % 获取当前车辆
    actor = ds.Actors(i);
    
    % 获取当前车辆所在的车道
    currLane = actor.currentLane;
    
    % 如果当前车辆没有在车道上，则继续下一个车辆
    if isempty(currLane)
        continue;
    end
       % 查找最近的路段瓦片（roadTile）
    roadTile = closestRoadTile(ds, actor.Position);
    
    % 在 roads 数组中查找当前路段的索引
    idx = find(roads == roadTile.RoadID, 1);
    
    % 如果未找到索引，则继续下一个车辆
    if isempty(idx)
        continue;
    end
    
    % 检查是否已经记录了当前路段的车辆
    if isempty([actorsOnRoad.RoadID])
        % 如果还未记录当前路段的车辆，则创建新记录
        RoadsWithCars = 1;
        actorsOnRoad(RoadsWithCars).RoadID = roads(idx);
        actorsOnRoad(RoadsWithCars).ActorID = [actorsOnRoad.ActorID, actor.ActorID];
    else
        % 如果已经有记录了当前路段的车辆，则更新记录
        presentRoad = find([actorsOnRoad.RoadID] == roads(idx), 1);
        if isempty(presentRoad)
            % 如果当前路段尚未有车辆记录，则创建新记录
            RoadsWithCars = RoadsWithCars + 1;
            actorsOnRoad(RoadsWithCars).RoadID = roads(idx);
            actorsOnRoad(RoadsWithCars).ActorID = actor.ActorID;
        else
            % 如果当前路段已经有车辆记录，则将当前车辆添加到对应路段的车辆列表中
            actorsOnRoad(presentRoad).ActorID = [actorsOnRoad(presentRoad).ActorID, actor.ActorID];
        end
    end
end
end

function[roadBank,maxCount]=createWeightedRoadBank(ds,RoadIDList,DistanceOffset,parsedInputs)






   % 获取演员的宽度
ActorWidth = parsedInputs.Results.Width;

% 对路段ID列表进行直方图统计，得到每个路段出现的次数
Ncounts = histcounts(RoadIDList, [unique(RoadIDList), inf]);

% 按照路段出现次数降序排序，并记录排序后的路段ID顺序
[Ncounts, road_order] = sort(Ncounts, 'descend');

% 对路段ID列表进行去重
RoadIDList = unique(RoadIDList);

% 按照出现次数排序的路段ID列表
RoadIDList = RoadIDList(road_order);

% 创建一个记录路段ID和出现次数的银行 roadBank
roadBank = [RoadIDList; Ncounts];

% 查找出现次数小于2的路段，并进行移除
removeRoads = find(Ncounts < 2, 1);
roadBank(:, removeRoads:end) = [];

% 初始化最大出现次数
maxCount = 0;

% 调用 checkVehicleonRoad 函数，获取道路上存在的演员信息
actorsPresent = checkVehicleonRoad(ds, roadBank(1, :));


    i = 1;
while i <= size(roadBank, 2)
    % 初始化路段的最大出现次数和路段ID
    roadMaxCount = 0;
    roadID = roadBank(1, i);

    % 获取单个瓦片的长度
    TileLength = ds.RoadSegments(roadID).DistanceTraveled(2);

    % 计算整个路段的长度
    RoadLength = roadBank(2, i) * TileLength;

    % 检查整个路段的长度是否小于设定的距离偏移量（DistanceOffset）
    if RoadLength < DistanceOffset
        % 如果整个路段的长度小于设定的距离偏移量，则移除当前及后续的路段，并终止循环
        roadBank(:, i:end) = [];
        break;
    else
        % 根据输入的设置，筛选需要考虑的车道（Lanes）
        if parsedInputs.Results.AllLanesCheck
            % 如果需要考虑所有车道，则选择所有车道
            idx = 1:numel(ds.RoadSegments(roadID).LaneType);
        else
            % 否则，仅选择车道类型为 'Driving' 的车道
            idx = find(ds.RoadSegments(roadID).LaneType == 'Driving');
        end

        % 如果用户指定了特定的车道，则筛选出对应的车道
        if ~isempty(parsedInputs.Results.Lanes)
            idx = intersect(idx, parsedInputs.Results.Lanes);
        end

        % 如果没有找到符合条件的车道，则移除当前路段，并继续下一个路段的处理
        if isempty(idx)
            roadBank(:, i) = [];
            continue;
        else
            % 获取当前路段中满足演员宽度要求的车道宽度
            lanewidth = diff(ds.RoadSegments(roadID).LaneMarkingLocation);
            lanewidth = lanewidth(lanewidth(idx) > ActorWidth);

            % 如果没有找到满足演员宽度要求的车道，则移除当前路段，并继续下一个路段的处理
            if isempty(lanewidth)
                roadBank(:, i) = [];
                continue;
            end

               % 计算瓦片长度内的路段数目
clusterLength = ceil(DistanceOffset / TileLength);

% 获取当前路段的出现次数
numClusters = roadBank(2, i);



% 根据瓦片长度和路段出现次数计算当前路段的最大出现次数
roadMaxCount = roadMaxCount + floor(numClusters / clusterLength) ...
    * numel(lanewidth);

% 根据计算得到的最大出现次数进行修正
roadMaxCount = roadMaxCount - 3 * floor(roadMaxCount / 20);

% 在 actorsPresent 中查找当前路段是否有已存在的演员
structIdx = find([actorsPresent.RoadID] == roadID, 1);

% 如果当前路段有已存在的演员，则从最大出现次数中减去该路段已有的演员数量
if ~isempty(structIdx)
    roadMaxCount = roadMaxCount - numel(actorsPresent(structIdx).ActorID);
    
    % 如果最大出现次数小于等于0，则移除当前路段，并继续下一个路段的处理
    if roadMaxCount <= 0
        roadBank(:, i) = [];
        continue;
    end
end

% 更新 roadBank 中当前路段的最大出现次数
roadBank(2, i) = roadMaxCount;
        end
    end

% 更新整体最大出现次数
maxCount = maxCount + roadMaxCount;

% 增加路段索引，继续处理下一个路段
i = i + 1;
end

% 根据 roadBank 中路段的最大出现次数对 roadBank 进行降序排序，并记录排序后的索引顺序
[~, road_order] = sort(roadBank(2, :), 'descend');
roadBank = roadBank(:, road_order);

% 将 roadBank 中路段的最大出现次数进行归一化，得到每个路段所占比例
roadBank(2, :) = roadBank(2, :) / sum(roadBank(2, :));

end
function actorDist = distributeActors(numActors, roadBank)
    % 获取路段数目
    numRoads = size(roadBank, 2);
    
    % 获取路段的占比信息
    distribution = roadBank(2, :);
    
    % 将演员数量按照路段的占比分配
    actorDist = floor(numActors * distribution);
    actorLeft = numActors - sum(actorDist);

    % 如果剩余演员数量为0，则直接返回
    if actorLeft == 0
        return
    % 如果剩余演员数量小于路段数目，则将剩余演员依次添加到前面的路段中
    elseif actorLeft < numRoads
        actorDist(1:actorLeft) = actorDist(1:actorLeft) + 1;
    % 如果剩余演员数量大于路段数目，则进行更复杂的分配
    else
        % 重复迭代次数
        RepeatItr = ceil(actorLeft / numRoads);
        % 计算每次迭代中每个路段需要分配的演员数量
        actorPlus = zeros([1, RepeatItr]);
        actorPlus(RepeatItr) = mod(actorLeft, numRoads);
        actorPlus(actorPlus == 0) = numRoads;
        % 更新演员分配信息
        actorDist = actorDist + actorPlus;
    end
end

function [PositionMat, varargout] = getActorPositions(obj, numActors, varargin)
% 获取演员的位置信息
%
% 输入参数：
%   obj: 场景对象
%   numActors: 需要获取位置信息的演员数量
%   varargin: 可选输入参数，用于添加演员时指定其他信息
%
% 输出参数：
%   PositionMat: 演员的位置矩阵，大小为 [numActors, 3]，每行为一个演员的位置（x, y, z）
%   varargout: 可选输出参数，当 nargout > 1 时返回演员的航向角（Yaw）信息

    % 创建一个临时场景对象，用于操作和获取演员位置信息
    tempScenario = eval(class(obj));

    % 复制原场景对象的路段信息到临时场景对象
    copyRoad(tempScenario, obj);

    % 判断是否有其他参数传入，根据情况添加演员
    if isempty(varargin)
        actorList = addActors(tempScenario, numActors);
    else
        actorList = addActors(tempScenario, numActors, varargin{:});
    end

    % 判断是否需要返回演员的航向角信息
    findYaw = nargout > 1;

    % 初始化演员位置矩阵和航向角信息（如果需要）
    PositionMat = zeros([numel(actorList), 3]);
    if findYaw
        Yaw = zeros([numel(actorList), 1]);
    end

    % 遍历演员列表，获取演员的位置信息和航向角信息
    for iActor = 1:numel(actorList)
        actor = actorList(iActor);
        PositionMat(iActor, :) = actor.Position;
        if findYaw
            Yaw(iActor) = actor.Yaw;
        end
    end

    % 如果需要返回演员的航向角信息，则将其作为可选输出参数
    if findYaw
        varargout{1} = Yaw;
    end
end

function availLanes = getAvailTileLanes(ds, Tiles, DistanceOffset, parseInputs, varargin)
% 获取可用车道信息
%
% 输入参数：
%   ds: 场景对象
%   Tiles: 路段瓦片信息，作为查询的范围
%   DistanceOffset: 距离偏移量
%   parseInputs: 解析输入参数
%   varargin: 可选输入参数，用于指定当前车道上存在的演员信息
%
% 输出参数：
%   availLanes: 可用车道信息结构体数组，包含TileID和Lanes字段，用于记录每个瓦片的可用车道

    % 初始化可用车道信息结构体数组
    availLanes = struct('TileID', [], 'Lanes', []);

    % 获取第一个路段瓦片的路段信息
    road = ds.RoadSegments(Tiles(1).RoadID);

    % 判断是否需要考虑所有车道
    if parseInputs.Results.AllLanesCheck
        % 如果需要考虑所有车道，则选择所有车道
        totalLanes = 1:numel(road.LaneType);
    else
        % 否则，选择车道类型为 'Driving' 的车道
        totalLanes = find(road.LaneType == 'Driving');
    end

    % 遍历每个路段瓦片，记录可用车道信息
    for i = 1:numel(Tiles)
        availLanes(i).TileID = Tiles(i).TileID;

        % 判断是否指定了特定的车道
        if isempty(parseInputs.Results.Lanes)
            % 如果没有指定特定车道，则默认选择所有车道
            availLanes(i).Lanes = totalLanes;
        else
            % 否则，从所有车道中筛选出指定车道
            availLanes(i).Lanes = intersect(totalLanes, parseInputs.Results.Lanes);
        end
    end

    % 如果指定了当前车道上存在的演员信息，则进一步筛选可用车道信息
    if ~isempty(varargin)
        actorsOnLane = varargin{1};
        for actorID = actorsOnLane
            actor = ds.Actors(actorID);

            % 获取演员所在的路段瓦片
            roadTile = closestRoadTile(ds, actor.Position);

            % 获取演员朝向向量
            A = roadTile.Vertices(1, :);
            B = roadTile.Vertices(4, :);
            u = diff([A; B]);

            % 获取演员当前所在车道和总车道数
            [currLane, numLanes] = actor.currentLane;

            % 如果演员的朝向与车道方向相反，则需要调整当前车道索引
            if dot(u, actor.ForwardVector) < 0
                currLane = sum(numLanes) - currLane + 1;
            end

            % 获取演员所在路段的信息
            idx = find(road.TileID == roadTile.TileID, 1);
            roadDistance = road.DistanceTraveled(idx);
            upperBound = min(roadDistance + DistanceOffset, road.DistanceTraveled(end));
            lowerBound = max(roadDistance - DistanceOffset, road.DistanceTraveled(1));

            % 获取在指定距离范围内的路段索引
            TilesIDX = road.TileID(road.DistanceTraveled < upperBound & road.DistanceTraveled > lowerBound);

            % 判断可用车道是否在指定的路段范围内，并进行相应的筛选
            tf = ismember([availLanes.TileID], TilesIDX);
            for i = 1:numel(tf)
                if tf(i)
                    Lanes = availLanes(i).Lanes;
                    idx = find(Lanes == currLane, 1);
                    if ~isempty(idx)
                        Lanes(idx) = [];
                    end
                    availLanes(i).Lanes = Lanes;
                end
            end
        end
    end
end
