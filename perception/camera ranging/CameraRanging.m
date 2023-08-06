function XYZ = CameraRanging(H, alpha, f, cameraParams, points)
CameraIntrinsicMatrix = transpose(cameraParams.IntrinsicMatrix);
dx = f/CameraIntrinsicMatrix(1,1);
dy = f/CameraIntrinsicMatrix(2,2); 
temp = CameraIntrinsicMatrix;
temp(1,1) = 1/dx;
temp(2,2) = 1/dy;
TransformationMatrix = temp;
[r, ~] = size(points);
XYZ = ones(r, 3);
for i = 1:r
    xy1 = TransformationMatrix^(-1)*[points(i,1);points(i,2);1];
    b1 = atan2d(xy1(2),f);
    b = b1;
    c = b1 +  alpha;
    Z = H/sind(c)*cosd(b);
    XYZ(i,1:3) = CameraIntrinsicMatrix^(-1)*[points(i,1);points(i,2);1]*Z;
end












% % 1.外部参数
% H = 216; % 相机高度 mm
% alpha = 2; % 相机光轴与水平线形成的夹角
% 
% % 2.内部参数
% CameraIntrinsicMatrix = transpose(cameraParams.IntrinsicMatrix); % 内参矩阵
% f = 4; % 相机焦距 毫米/mm
% s = 0; % 相机轴倾斜
% dx = f/CameraIntrinsicMatrix(1,1); % 焦距在x轴上的像素表示 
% dy = f/CameraIntrinsicMatrix(2,2); % 焦距在y轴上的像素表示
% 
% % 3.像素坐标转图像物理坐标
% temp = CameraIntrinsicMatrix;
% temp(1,1) = 1/dx;
% temp(2,2) = 1/dy;
% TransformationMatrix = temp; % 坐标转换矩阵
% u = 1034; % 像素坐标的x值
% v = 808; % 像素坐标的y值
% xy1 = TransformationMatrix^(-1)*[u;v;1]; % 图片物理坐标
% % 4.获取深度
% b1 = atan2d(xy1(2),f); % 绝对值，去除正负
% b = b1;
% c = b1 +  alpha;
% Z = H/sind(c)*cosd(b);
% % 5.像素坐标转相机坐标
% XYZ = CameraIntrinsicMatrix^(-1)*[u;v;1]*Z; % 像素点对应的相机坐标
% disp(XYZ)
