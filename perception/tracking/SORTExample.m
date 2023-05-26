%% 实现简单的在线和实时跟踪
% 此示例说明如何使用 Sensor Fusion and Tracking Toolbox™ 和 Computer Vision Toolbox™实施简单在线和实时 
% (SORT) 对象跟踪算法 [1]。该示例还展示了如何使用 CLEAR MOT 指标评估 SORT。
%% *下载行人跟踪视频*
loal_video_name = '12号路口南向北-20220624093003_1fps.avi';
pro_dir = fileparts(fileparts(fileparts(mfilename('fullpath'))));
cur_video_path = fullfile(pro_dir, 'data', 'crossroads', loal_video_name);

if ~exist(cur_video_path, 'file')
    % 下载行人跟踪视频文件。
    datasetname="PedestrianTracking";
    videoURL = "https://ssd.mathworks.com/supportfiles/vision/data/PedestrianTrackingVideo.avi";
    if ~exist("PedestrianTrackingVideo.avi","file")
        disp("Downloading Pedestrian Tracking Video (35 MB)")
        websave("PedestrianTrackingVideo.avi",videoURL);
    end
    
    cur_video_path = datasetname+"Video.avi";
end



%% 
% 请参阅<https://ww2.mathworks.cn/help/fusion/ug/import-camera-based-datasets-in-mot-challenge-format-for-object-tracking.html 
% 以 MOT 挑战格式导入基于相机的数据集以进行对象跟踪>（传感器融合和跟踪工具箱）示例，了解如何将地面实况和检测数据导入适当的传感器融合和跟踪工具箱™ 
% 格式。您在此示例中使用相同的行人跟踪数据集。此示例为视频提供了两组检测。MAT|PedestrianTrackingACFDetections|文件包含使用聚合通道特征 
% (ACF) 从人体检测器生成的检测。<https://ww2.mathworks.cn/help/vision/ref/peopledetectoracf.html 
% |peopleDetectorACF|>有关详细信息，请参阅函数。MAT文件|PedestrianTrackingYOLODetections|包含使用 
% CSP-DarkNet-53 网络从 YOLO v4 对象检测器生成并在 COCO 数据集上训练的检测。见<https://ww2.mathworks.cn/help/vision/ref/yolov4objectdetector.html 
% |yolov4ObjectDetector|>对象了解更多详情。两个检测集都以（传感器融合和跟踪工具箱）格式保存。首先使用 ACF 检测。<https://ww2.mathworks.cn/help/fusion/ref/objectdetection.html 
% |objectDetection|>

load("PedestrianTrackingACFDetections.mat","detections");
%% *为 SORT 定义跟踪器组件*
% SORT算法是一种多目标跟踪器，具有以下特点：
%% 
% * 估计滤波器：具有恒速运动模型的卡尔曼滤波器。
% * 关联成本：检测边界框与预测轨迹边界框的并集交集。
% * 关联类型：使用匈牙利算法的全局最近邻。
% * 轨道维护：根据轨道历史逻辑对轨道进行初始化和删除。有关详细信息，请参阅<https://ww2.mathworks.cn/help/fusion/ug/introduction-to-track-logic.html 
% 跟踪逻辑简介>（传感器融合和跟踪工具箱）示例。
% *定义卡尔曼滤波器*
% 检测测量是一个二维边界框：
% 
% |_Z =[_x , _y , _w , _h_]|
% 
% 在哪里|_X_|和|_和_|是以像素为单位的边界框左上角的坐标，和|_在_|和|_H_|分别是边界框的宽度和高度（以像素为单位）。
% 
% 估计边界框的状态遵循以下定义：
% 
% |_X =[_u , _v , _s , _r ,_˙在_,_˙在_,_˙秒_,_˙_ _r_]|
% 
% 在哪里|_在_|和|_在_|是边界框中心的坐标，|_秒_|是边界框的比例（或面积），并且|_r_|是边界框的宽高比。后四个元素分别为前四个元素的时间变化率。与[1]不同的是，在本例中，纵横比的时间变化率包含在状态中。
% 
% 因此，将测量值转换为状态的方程式由下式给出：
% 
% |_你_= _x +_在_2_v = _y +_H_2_小号_=_大号__ _r =_在H_|
% 
% 请注意，方程是非线性的。转换可以作为过滤器外部的预处理步骤完成。因此，您可以将线性卡尔曼滤波器与（传感器融合和跟踪工具箱）对象一起使用。或者，可以在卡尔曼滤波器测量功能中完成转换，这需要扩展的卡尔曼滤波器来处理非线性。本例使用第一种方法，[1] 
% 中也采用了这种方法。要为第二种方法设置测量函数，请使用本示例提供的函数。<https://ww2.mathworks.cn/help/fusion/ref/trackingkf.html 
% |trackingKF|>|helperBBMeasurementFcn|
% 
% 假设检测噪声是零均值高斯分布，具有协方差|_R_|对应于标准偏差|1|对于中心位置和纵横比。它还有一个标准偏差|√10|比例的像素。
% 
% |_R =⎡⎢⎢⎢⎢⎣10000100001000001⎤⎥⎥⎥⎥⎦|
% 
% 使用该|helperConvertBoundingBox|函数将所有检测转换为状态约定并设置测量噪声协方差。

R = diag([1, 1, 10, 1]);
convertedDets = helperConvertBoundingBox(detections,R);
%% 
% 时代的状态转变|_吨k_ 到|_吨k + 1=_吨k_+_d吨_|遵循由下式给出的恒速模型：
% 
% |_Xk + 1=_一个_ _Xk_=[_我_404 _d吨_× _我_4_我_4]_Xk_ 
% 
% 在此示例中，视频每秒 1 帧，因此|_d吨_=1|. 如果您使用不同的视频，请相应地调整该值。
% 
% 以零速度和大标准差初始化速度状态以表示高运动不确定性。
% 
% 恒速模型是一种粗略的近似，不能准确描述视频中行人的实际运动，也不能准确描述面积和纵横比状态的变化。如下图所示，较大的过程噪声|_˙在_,_˙在_,_˙秒_|状态元素通过当前选择的测量噪声为该应用产生理想的结果。
% 
% 该|helperInitcvbbkf|函数从初始检测构建卡尔曼滤波器。您可以为您的应用程序修改此功能。
%%
% 
%   function filter = helperInitcvbbkf(detection)
%   % Initialize a linear Constant-Velocity Kalman filter for Bounding Box tracking.
%   
%   % Detection must have a measurement following the [u, v, s, r] format
%   measurement = detection.Measurement;
%   
%   % Initialize state with null velocity
%   X0 = [measurement(1:4)' ; zeros(4,1)];
%   
%   % Initialize state covariance with high variance on velocity states
%   P0 = diag([1 1 10 10 1e4 1e4 1e4 1e2]);
%   
%   % Add some process noise to capture unknown acceleration
%   Q = diag([1 1 1 1 10 10 10 1]);
%   
%   dt = 1;
%   A = [eye(4), dt*eye(4); zeros(4), eye(4)];
%   H = [eye(4), zeros(4)];
%   
%   % Construct the filter
%   filter = trackingKF(State = X0,...
%       StateCovariance = P0,...
%       ProcessNoise = Q, ...
%       MotionModel = "custom",...
%       StateTransitionModel = A,...
%       MeasurementModel = H);
%   
%   end
%
%% 
% 请参阅<https://ww2.mathworks.cn/help/fusion/ug/linear-kalman-filters.html 线性卡尔曼滤波器>（传感器融合和跟踪工具箱）以了解有关线性卡尔曼滤波器的更多信息。*定义关联成本函数和关联阈值*
% 
% 在 SORT 中，边界框检测与当前轨迹之间的关联需要计算每个检测与每个当前轨迹之间的关联成本。此外，较低的成本必须表明检测更有可能源自配对轨道。使用<https://ww2.mathworks.cn/help/vision/ref/bboxoverlapratio.html 
% |bboxOverlapRatio|>Computer Vision Toolbox™ 中的函数计算每个检测和跟踪对的交集相似度。在使用 之前，您必须将检测测量和跟踪状态转换回初始边界框格式|bboxOverlapRatio|。
%%
% 
%   function iou = similarityIoU(tracks, detections)
%   % Calculate the Intersection over Union similarity between tracks and
%   % detections
%   
%   states = [tracks.State];
%   bbstate = helperBBMeasurementFcn(states); % Convert states to [x, y, w, h] for bboxOverlapRatio
%   bbmeas = vertcat(detections.Measurement);
%   bbmeas = helperBBMeasurementFcn(bbmeas')';
%   iou = bboxOverlapRatio(bbstate', bbmeas); % Bounding boxes must be concatenated vertically
%   end
%
%% 
% 重叠率是相似性的度量，值越高表示匹配越强。因此，您使用相似度的负数作为成本值。该|helperSORTCost|函数预测跟踪器维护的所有当前轨迹，并为所有检测轨迹对制定成本矩阵。
%%
% 
%   function costMatrix = helperSORTCost(tracker, dets)
%   D = numel(dets);
%   T = tracker.NumTracks;
%   
%   % Return early if no detections or no tracks
%   if D*T == 0
%       costMatrix = zeros(T,D);
%       return
%   end
%   
%   time = dets(1).Time;
%   tracks = predictTracksToTime(tracker, "all",time);
%   costMatrix = -similarityIoU(tracks, dets);
%   end
%
%% 
% 与大多数多目标 跟踪算法一样，为检测与跟踪的关联设置阈值在 SORT 中是有益的。当关联成本超过此阈值时，分配将被禁止。您将阈值表示为最小相似度|IoUmin.|应该为每个应用程序调整 
% SORT 算法的这个参数。对于本例中使用的视频，由于行人密度低且帧率低，因此最小相似度值为 0.05 可提供良好的结果。

IoUmin =0.05;
%% 
% |AssignmentThreshold|在下一节中将跟踪器的属性设置为最小相似度的负值。
% *使用全球最近邻关联*
% SORT 通过找到关联的最小成本来依赖检测和跟踪之间的一对一关联。这在多目标 跟踪领域也被称为全局最近邻（GNN）。因此，您可以使用(Sensor 
% Fusion and Tracking Toolbox) System Object™ 来实现 SORT。创建跟踪器时，将跟踪过滤器初始化函数指定为并将属性设置为使用自定义函数而不是默认成本计算。<https://ww2.mathworks.cn/help/fusion/ref/trackergnn-system-object.html 
% |trackerGNN|>|helperInitcvbbkfHasCostMatrixInputtruehelperSortCost|

tracker = trackerGNN(FilterInitializationFcn=@helperInitcvbbkf,...
    HasCostMatrixInput=true,...
    AssignmentThreshold= -IoUmin);
%% 
% *定义轨迹维护*
% 
% 对象可能会离开视频帧或短暂或长时间被遮挡。您需要定义没有指定检测的最大帧数，|_吨_丢失的|, 在删除曲目之前。跟踪器参数|_吨_丢失的|可以针对每个应用程序进行调整，值为 
% 3 表示此视频效果良好。此外，SORT 要求在确认轨道之前在两个连续帧中检测到一个对象。您相应地设置|ConfirmationThreshold|跟踪器的属性。

TLost = 3; % 删除轨迹的连续失帧数
tracker.ConfirmationThreshold=[2 2];
tracker.DeletionThreshold=[TLost TLost];
% *使用 ACF 检测运行 SORT*
% 对视频和检测运行 SORT。过滤掉分数低于 15 的 ACF 检测以提高跟踪性能。
% 您可以针对特定场景调整分数阈值。在每个时间步记录轨迹以进行离线评估。

detectionScoreThreshold = 15;
% 初始化跟踪日志
acfSORTTrackLog = objectTrack.empty;
reader = VideoReader(cur_video_path);

for i=1:reader.NumFrames

    % 在第i帧上分析检测集来获取检测结果
    curFrameDetections = convertedDets{i};
    attributes = [curFrameDetections.ObjectAttributes];
    scores = [attributes.Score];
    highScoreDetections = curFrameDetections(scores > detectionScoreThreshold);

    % 计算关联代价矩阵
    iouCost = helperSORTCost(tracker,highScoreDetections );
    % 更新跟踪器
    tracks = tracker(highScoreDetections, reader.CurrentTime, iouCost);

    % 视频帧读取器指针向前移动
    frame = readFrame(reader);
    frame = helperAnnotateTrack(tracks, frame);
    % 取消下面一行的注释可以显示检测结果
    % frame = helperAnnotateConvertedDetection(highScoreDetections, frame);
    imshow(frame);

    % 记录下轨迹用于评估
    acfSORTTrackLog = [acfSORTTrackLog ; tracks]; %#ok<AGROW>
end
%% 
% 在视频结束时，一个行人被跟踪到|trackID|45。该序列恰好包含 16 个不同的行人。
% 显然，跟踪器已多次确认同一真实物体的新轨迹以及可能确认的误报轨迹。
% 
% SORT 可能难以启动以跟踪快速移动的对象，因为它在第一帧中以零速度初始化暂定轨迹，并且下一帧中同一对象的检测可能不会与预测重叠。在像本例中的视频这样的低帧率视频中，这一挑战进一步加剧。例如，直到对多个帧可见时才确认轨道 
% 5。
% 
% 请注意，离开摄像机视野或被其他人遮挡几帧的行人会被跟踪器丢失。这个结果是使用恒速模型预测轨迹位置和使用 IoU 关联成本的组合，如果位置太远，它不能将预测轨迹与新检测相关联。
% 
% 检测的质量也会对跟踪结果产生显着影响。例如，街道尽头的树的 ACF 检测与轨道 3 相关联。
% 
% 在下一节中，您将使用 YOLOv4 检测评估 SORT。
% *使用 YOLOv4 检测运行 SORT*
% 在本节中，您将使用从 YOLOv4 检测器获得的检测运行 SORT。该|helperRunSORT|函数重复上一节中的模拟循环。YOLOv4 的分数范围要高得多，检测质量也足够好，因此您无需过滤掉低分检测。

% Load and convert YOLOv4 detections
load("PedestrianTrackingYOLODetections.mat","detections");
convertedDets = helperConvertBoundingBox(detections, R);
detectionScoreThreshold = -1;
showAnimation = true;

yoloSORTTrackLog = helperRunSORT(tracker, convertedDets, detectionScoreThreshold, showAnimation);
%% 
% YOLOv4-SORT 组合在视频上总共创建了 24 个轨道，表明与 ACF 检测相比，发生的轨道碎片更少。从结果来看，track fragmentations 
% 和 ID switches 仍然很明显。
% 
% 最近的跟踪算法，例如 DeepSORT，修改了关联成本以包括除 IoU 之外的外观特征。由于重新识别网络，这些算法显示出准确性的巨大改进，并且能够跟踪更长的遮挡。
%% *使用 CLEAR MOT 指标评估 SORT*
% CLEAR多目标 跟踪指标提供了一组标准的跟踪指标来评估跟踪算法的质量[2]。这些指标在基于视频的跟踪应用程序中很受欢迎。使用（传感器融合和跟踪工具箱）对象评估两次 
% SORT 运行的 CLEAR 指标。<https://ww2.mathworks.cn/help/fusion/ref/trackclearmetrics.html 
% |trackCLEARMetrics|>
% 
% CLEAR 指标需要一种相似性方法来匹配每一帧中的轨迹和真实对象对。在此示例中，您使用|IoU2d|相似度方法并将该|SimilarityThreshold|属性设置为 
% 0.1。这意味着如果轨道的边界框重叠至少 10%，则只能将轨道视为与真实对象的真阳性匹配。度量结果可能会根据此阈值的选择而有所不同。

threshold = 0.1;
% tcm = trackCLEARMetrics(SimilarityMethod ="IoU2d", SimilarityThreshold = threshold);
%% 
% 第一步是将|objectTrack|格式转换为|trackCLEARMetrics|特定于|IoU2d|相似度方法的输入格式。转换之前获得的两个轨道日志。

acfTrackedObjects = repmat(struct("Time",0,"TrackID",1,"BoundingBox", [0 0 0 0]),size(acfSORTTrackLog));
for i=1:numel(acfTrackedObjects)
    acfTrackedObjects(i).Time = acfSORTTrackLog(i).UpdateTime;
    acfTrackedObjects(i).TrackID = acfSORTTrackLog(i).TrackID;
    acfTrackedObjects(i).BoundingBox(:) = helperBBMeasurementFcn(acfSORTTrackLog(i).State(1:4));
end

yoloTrackedObjects = repmat(struct("Time",0,"TrackID",1,"BoundingBox", [0 0 0 0]),size(yoloSORTTrackLog));
for i=1:numel(yoloTrackedObjects)
    yoloTrackedObjects(i).Time = yoloSORTTrackLog(i).UpdateTime;
    yoloTrackedObjects(i).TrackID = yoloSORTTrackLog(i).TrackID;
    yoloTrackedObjects(i).BoundingBox(:) = helperBBMeasurementFcn(yoloSORTTrackLog(i).State(1:4));
end
%% 
% MAT文件|PedestrianTrackingGroundTruth|包含格式为结构数组的真值对象日志。每个结构包含以下字段：|TruthID|、|Time|和|BoundingBox|。加载ground 
% truth后，调用|evaluate|object函数获取metrics表。

load("PedestrianTrackingGroundTruth.mat","truths");
% acfSORTresults = evaluate(tcm, acfTrackedObjects, truths);
% yoloSORTresults = evaluate(tcm, yoloTrackedObjects, truths);
%% 
% 连接两个表并添加一个列，其中包含每个跟踪器和对象检测器的名称。

% allResults = [table("ACF+SORT",VariableNames = "Tracker") , acfSORTresults ; ...
%     table("YOLOv4+SORT",VariableNames = "Tracker"), yoloSORTresults];
% 
% disp(allResults);
%% 
% 两个主要的摘要指标是多目标 跟踪精度 (MOTA) 和多目标 跟踪精度 (MOTP)。MOTA 是数据关联质量的良好指标，而 MOTP 表示每个轨道边界框与其匹配的真实边界框的相似性。这些指标证实 
% YOLOv4 和 SORT 组合比 ACF 和 SORT 组合跟踪得更好。它在 MOTA 和 MOTP 上的得分都高出大约 20%。
% 
% ID 开关和碎片是另外两个指标，可以很好地了解跟踪器使用唯一轨道 ID 跟踪每个行人的能力。当真实物体被遮挡并且跟踪器无法在多个帧上连续保持跟踪时，可能会发生碎片。当真实对象轨迹交叉并且其分配的轨道 
% ID 随后切换时，可能会发生 ID 切换。
% 
% 有关所有 CLEAR 指标数量及其重要性的更多信息，请参阅（传感器融合和跟踪工具箱）页面。<https://ww2.mathworks.cn/help/fusion/ref/trackclearmetrics.html 
% |trackCLEARMetrics|>
%% *结论*
% 在本示例中，您学习了如何实现 SORT。此外，您还在行人跟踪视频上评估了此跟踪算法。您发现整体跟踪性能在很大程度上取决于检测的质量。您可以将此示例重复用于您自己的视频和检测。此外，您可以使用<https://ww2.mathworks.cn/help/fusion/ug/import-camera-based-datasets-in-mot-challenge-format-for-object-tracking.html 
% 以 MOT 挑战格式导入基于相机的数据集以进行对象><https://ww2.mathworks.cn/help/fusion/ug/import-camera-based-datasets-in-mot-challenge-format-for-object-tracking.html 
% 跟踪>（传感器融合和跟踪工具箱）示例，从 MOT 挑战 [3] 中导入视频和检测。
%% Reference
% [1] Bewley, Alex, Zongyuan Ge, Lionel Ott, Fabio Ramos, and Ben Upcroft. "Simple 
% online and realtime tracking." In _2016 IEEE international conference on image 
% processing (ICIP)_, pp. 3464-3468. IEEE, 2016.
% 
% [2] Bernardin, Keni, and Rainer Stiefelhagen. "Evaluating multiple object 
% tracking performance: the clear mot metrics." _EURASIP Journal on Image and 
% Video Processing_ 2008 (2008): 1-10.
% 
% [3] <https://motchallenge.net/ https://motchallenge.net/> 
% 
% 
% 
% _Copyright 2022 The MathWorks, Inc._