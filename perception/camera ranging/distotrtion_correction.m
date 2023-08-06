function distotrtion_correction(image_path, cameraParams)
%读取原图路径
I=imread(image_path);
%使用函数undistortImage去畸变
%cameraParams为camera calibrator实验获得的相机相关参数，保存在工作区
[J,~] = undistortImage(I,cameraParams);
imwrite(J,'undistortion.jpg')