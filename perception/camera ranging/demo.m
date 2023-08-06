function demo(image_path, cameraParams, is_correction)
if is_correction == 1
    distotrtion_correction(image_path, cameraParams)
    points = detect_by_YOLOv4("undistortion.jpg");
else
    points = detect_by_YOLOv4(image_path);
end
disp("=============================物体像素坐标如下：=============================")
disp(points)
XYZ = CameraRanging(1113, 0, 4, cameraParams, points);
disp("=============================物体三维坐标如下：=============================")
disp(XYZ);