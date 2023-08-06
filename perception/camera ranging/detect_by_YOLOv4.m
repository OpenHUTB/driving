function points = detect_by_YOLOv4(image_path)
detector = yolov4ObjectDetector("csp-darknet53-coco");
img = imread(image_path);
[bboxes,~,labels] = detect(detector,img);
detectedImg = insertObjectAnnotation(img,"Rectangle",bboxes,labels);
[r,c] = size(bboxes);
points =  ones(r, c/2);
for i = 1:r
    points(i,1) = bboxes(i,1)+bboxes(i,3)/2;
    points(i,2) = bboxes(i,2)+bboxes(i,4);
end
figure
imshow(detectedImg)


% name = "csp-darknet53-coco";
% detector = yolov4ObjectDetector(name);
% % disp(detector);
% % analyzeNetwork(detector.Network);
% img = imread("undistortion.jpg");
% [bboxes,scores,labels] = detect(detector,img);
% detectedImg = insertObjectAnnotation(img,"Rectangle",bboxes,labels);
% [r,c] = size(bboxes);
% points =  ones(r, c/2);
% for i = 1:length(bboxes)-1
%     points(i,1) = bboxes(i,1)+bboxes(i,3)/2;
%     points(i,2) = bboxes(i,2)+bboxes(i,4);
%     disp("第"+i+"个目标的特征像素点的坐标为["+points(i,1)+","+points(i,1)+"]");
% end
% disp(points);
% figure
% imshow(detectedImg)
