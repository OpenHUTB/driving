% 加载内置的YOLOv4模型
detector = yolov4ObjectDetector("csp-darknet53-coco");

% 创建视频读取器和视频编写器
videoReader = VideoReader('input_object.mp4');
videoWriter = VideoWriter('output_detection.mp4', "MPEG-4");

% 打开视频编写器并读取第一帧
open(videoWriter);
frame = readFrame(videoReader);

% 循环读取视频的每一帧
while hasFrame(videoReader)
    % 对每一帧进行目标检测和分类
    [bboxes, scores, labels] = detect(detector, frame);
    
    % 在视频帧上绘制检测结果
    annotatedFrame = insertObjectAnnotation(frame, 'rectangle', bboxes, labels);
    
    % 将处理过的视频帧写入视频编写器中
    writeVideo(videoWriter, annotatedFrame);
    
    % 读取下一帧
    frame = readFrame(videoReader);
end

% 关闭视频读取器和编写器
close(videoWriter);