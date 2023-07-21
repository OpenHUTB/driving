[toc]

<center><font color="" size="10px">代码使用说明</font>
    </center>

以下代码均为matlab代码。

# 应用场景

![image-20230721162309797](E:\Typora_images_Repository\image-20230721162309797.png)

- 该场景下目标特征像素点为预测框底边的中点。
- 目标特征像素点的坐标用于计算该目标在相机视角下的三维坐标。
- 相机坐标系的坐标轴正方向符合[右手系](https://baike.baidu.com/item/右手系/9751780)。

# 目标检测

```matlab
name = "csp-darknet53-coco";
detector = yolov4ObjectDetector(name); % 加载目标检测模型
img = imread("input.jpg"); % 读取输入图片
[bboxes,scores,labels] = detect(detector,img); % 获取检测结果
detectedImg = insertObjectAnnotation(img,"Rectangle",bboxes,labels); % 在图片上显示检测结果
figure
imshow(detectedImg)
```

==bboxes变量存储模型输出的预测框，具体的数据格式为:$[[x_1,y_1,w_1,h_1],...,[x_n,y_n,w_n,h_n]]$，其中$[x_i,y_i,w_i,h_i]$表示第i个预测框左顶点的像素坐标$(x_i,y_i)$以及预测框的像素宽度$w_i$与像素长度$h_i$。==目标特征像素点的坐标如下：
$$
\begin{cases}
u=x+\frac{w}{2} \\
v=y+h
\end{cases}
$$

# 相机测距

```matlab
% 0.目标特征像素点的坐标
u = bboxes[0][0]+bboxes[0][2]/2; % 目标特征像素点的x值
v = bboxes[0][1]+bboxes[0][3]; % 目标特征像素点的y值
% 1.需要人工测量的参数
H = 215; % 相机高度 mm
alpha = 0; % 相机光轴与水平线形成的夹角
% 2.相机的内部参数
CameraIntrinsicMatrix = [958 72 547;
                         0 953 564;
                         0 0 1]; % 内参矩阵
f = 4; % 相机焦距 毫米/mm
s = 0; % 相机轴倾斜 通常默认为0
dx = f/CameraIntrinsicMatrix(1,1); % 焦距在x轴上的像素表示 
dy = f/CameraIntrinsicMatrix(2,2); % 焦距在y轴上的像素表示
% 3.像素坐标转图像物理坐标
temp = CameraIntrinsicMatrix;
temp(1,1) = 1/dx;
temp(2,2) = 1/dy;
TransformationMatrix = temp; % 坐标转换矩阵
xy1 = TransformationMatrix^(-1)*[u;v;1]; % 图片物理坐标
% 4.获取深度
b1 = atan2d(xy1(2),f);
b = b1;
c = b1 +  alpha;
Z = H/sind(c)*cosd(b);
% 5.像素坐标转相机坐标
XYZ = CameraIntrinsicMatrix^(-1)*[u;v;1]*Z; % 像素点对应的相机坐标
disp(XYZ) % Y值需要加符号
```

# 误差分析

1. 相机高度H与夹角a测量不准确；
2. 目标检测模型输出的预测框与目标真实边框之间的IOU过小，导致特征点的像素坐标$(u,v)$不准确，进而造成测距不精准`(模型训练时，提高IOU阈值)`；
3. 镜片畸变现象导致像素点不能按照理想得情况分布，例如现实中的直被拍成了曲线等`（可使用畸变参数进行纠正）`；
4. 目标在相机坐标系下的三维坐标人工测量不准。

# 其他说明

1. 单相机测距原理请见下文；

2. 只能测出`紧贴地面的物体`的三维坐标；

3. 目前的计算机结果的误差较大，有待提升，考虑畸变参数的代码还在思索。

    ------

    <center><font color="" size="10px">单目相机测距原理</font>
        </center>

# 1 目的

基于目标在图片上的二维像素坐标$(u,v)$，通过一定的计算，得出它在相机坐标系下的三维坐标点$(X_c,Y_c,Z_c)$，进而可计算出相机与目标之间的欧式距离$d=\sqrt {X_c^2+Y_c^2+Z_c^2}$。

# 2 四大坐标系

![image-20230716154631534](E:\Typora_images_Repository\image-20230716154631534.png)

1. 世界坐标系：真实世界中任意指定的三维坐标系，坐标由$(X_w,Y_w,Z_w)$ 表示，用于描述相机在真实世界中的位置；
2. 相机坐标系：以相机透镜的几何中心（光心）为原点，坐标系满足右手法则，用$(X_c,Y_c,Z_c)$来表示，相机光轴为坐标系的Z轴，X轴水平，Y轴竖直，单位米m；
3. 图像坐标系：以CCD图像的中心为原点，坐标由$(x,y)$ 表示，坐标原点为相机光轴与成像平面的交点（一般情况下，这个交点是接近于图像的正中心），单位毫米mm；
4. 像素坐标系：以像素为单位，坐标原点在图片的左上角，坐标由$(u,v)$ 表示，单位像素pixel

当然明显看出CCD传感器以mm单位到像素中间有转换的。举个例子，CCD传感上面的8mm x 6mm，转换到像素大小是640x480. 假如dx表示像素坐标系中每个像素的物理大小就是1/80. 也就是说毫米与像素点的之间关系是piexl/mm.

<font color="red" size="6px">本项目不考虑世界坐标系</font>

![image-20230716192648424](E:\Typora_images_Repository\image-20230716192648424.png)

参考资料

1. [(45条消息) 【相机标定】四个坐标系之间的变换关系_skycrygg的博客-CSDN博客](https://blog.csdn.net/qq_42518956/article/details/103903514?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-103903514-blog-102974952.235^v38^pc_relevant_sort&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-103903514-blog-102974952.235^v38^pc_relevant_sort&utm_relevant_index=1)
2. [(45条消息) 世界坐标系、相机坐标系和图像坐标系的转换_相机坐标系到图像坐标系_滴滴滴'cv的博客-CSDN博客](https://blog.csdn.net/weixin_38842821/article/details/125933604?spm=1001.2101.3001.6650.7&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-7-125933604-blog-102974952.235^v38^pc_relevant_sort&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-7-125933604-blog-102974952.235^v38^pc_relevant_sort&utm_relevant_index=14)
3. [(45条消息) 相机标定（1）——四个坐标系_相机坐标系_白水煮蝎子的博客-CSDN博客](https://blog.csdn.net/weixin_44278406/article/details/112986651)

# 3 $(u,v)转(X_c,Y_c,Z_c)$


$$
\left[
\begin{matrix}
u \\
v \\
1
\end{matrix}
\right]
=
\frac{1}{Z_c}
\left[
\begin{matrix}
f_x & s & c_x \\
0 & f_y & c_y \\
0 & 0& 1
\end{matrix}
\right]
\left[
\begin{matrix}
X_c \\
Y_c \\
Z_c
\end{matrix}
\right]=
\frac{1}{Z_c}K
\left[
\begin{matrix}
X_c \\
Y_c \\
Z_c
\end{matrix}
\right] \tag 1
$$

$$
\left[
\begin{matrix}
X_c \\
Y_c \\
Z_c
\end{matrix}
\right]=Z_c\cdot K^{-1} \cdot
\left[
\begin{matrix}
u \\
v \\
1
\end{matrix}
\right] \tag 2
$$

$$
K^{-1}=
\left[
\begin{matrix}
\frac{1}{f_x} & -\frac{s}{f_xf_y} & \frac{c_ys-c_xf_y}{f_xf_y} \\
0 & \frac{1}{f_y} & -\frac{c_y}{f_y} \\
0 & 0& 1
\end{matrix}
\right] \tag 3
$$

- $(u,v)$：物体Q在像素坐标系下的坐标点，可从图片上得到；
- $(X_c,Y_c,Z_c)$：物体Q在相机坐标系下的坐标点，待求；
- $K$：相机的内参矩阵，用来将相机坐标投影成像素坐标可，由相机标定实验得出。
    - $(c_x,c_y)$：成像平面中心点在图片像素坐标系下的坐标点
    - $s(skwed)$：[歪斜参数](https://zhuanlan.zhihu.com/p/87334006)，当且仅当x轴与y轴垂直时$s=0$
    - $f_{x\ or\ y}$：焦距在x/y轴上的像素点表示


在等式（2）中，三个未知数，两个方程，故无法求出$(X_c,Y_c,Z_c)$。但可以通过使用`深度估计`或`传统测量法`获得$Z_c$。由于本项的目场景具有许多先验数据，例如相机高度等，采用传统的几何关系测量法。具体方法如下。

需要注意的是，在相机测距的场景下，`目标只能是地面上的目标且目标的特征像素点为预测框底边的中点，`即仅能通过该点计算目标在相机视角下的三维坐标。假设目标检测模型输出的预测框表示方式为$[x,y,w,h]$，其中$(x,y)$表示目标预测框左上角顶点在图片中的像素坐标，$w与h$分别表示预测框的宽和高（单位为像素），那么目标特征点的像素坐标的计算公式如下：
$$
\begin{cases}
u=x+\frac{w}{2} \\
v=y+h
\end{cases} \tag 4
$$
![image-20230711184615037](E:\Typora_images_Repository\image-20230711184615037.png)

# 4 应用场景分析

交通路口高架上的单目相机测距场景具有以下特性：

1. 相机距离水平面的高度`H`可人工测量；
2. 相机光轴与水平线的额夹角`a`可人工测量；
3. 将路面视为光滑的平面。

如下图所示，$X_c Y_c Z_c$表示相机坐标系，$xo_1y$表示平面成像坐标系（图像物理坐标系）

![image-20230705151845451](E:\Typora_images_Repository\image-20230705151845451.png)

# 5 计算像素点的深度

$$
b^{'}=arctan\frac{0_1P^{'}}{f} \\
\angle b^{'} = \angle b \\
\angle c = \angle b + \angle a \\
OP = \frac{H}{sinc} \\
OD = OP \times cosb \\
Z = OD
$$

$$
Z =\frac{H}{sin(\angle a + \angle arctan\frac{0_1P^{'}}{f})} \times cosb \tag 5
$$

$$
\begin{cases}
X_c=\frac{f_y(u-c_x)-s(v-c_y)}{f_xf_y}\times Z_c \\
Y_c=\frac{v-c_y}{f_y} \times Z_c
\end{cases} \tag 6
$$

==如何得到$o_1P^{'}$的值呢？即如何得到图像坐标的y值呢？==

# 6 $(u,v)转(x,y)$

首先是`像素坐标系UV`和`图像坐标系XY`之间的关系。在拿到一张照片之后，我们应该可以想到，这其实是一张由一个一个像素组成的图像，并且我们可以很简单地拿到像素的坐标，也即$(u,v)$. 但这个坐标只是图像上用来指示像素的位置，并不是物理的成像平面上的坐标，因此不能直接用于三维坐标的恢复。这个时候我们需要先去恢复图像坐标$(x,y)$，也即物理的成像平面上的坐标。

![image-20230705161920556](E:\Typora_images_Repository\image-20230705161920556.png)
$$
\begin{cases}
u=\frac{x}{dx}+u_0 \\
v=\frac{y}{dy}+v_0
\end{cases}
$$

$$
\left[
\begin{matrix}
u \\
v \\
1
\end{matrix}
\right]
=
\left[
\begin{matrix}
\frac{1}{dx} & s & u_0 \\
0 & \frac{1}{dy} & v_0 \\
0 & 0& 1
\end{matrix}
\right]
\left[
\begin{matrix}
x \\
y \\
1
\end{matrix}
\right]
$$

$$
o_1p^{'} = y \tag 5
$$

1. $(x_0,y_0)$图像坐标系的原点在像素坐标系当中的坐标；理想情况下，若图片尺寸为$W \times H$，那么$x_0=\frac{W}{2},y_0=\frac{H}{2}$；
2. $dx$：表示x轴方向上的一个像素在相机感光板上的物理长度，即一个像素在感光板上是多少毫米；
3. $dy$：表示y轴方向上的一个像素在相机感光板上的物理长度

<font color="green" size = "6px">如何求得$dx与dy呢？$</font>

通过`相机标定`可以得到一个具体的$3 \times 3$内参矩阵，如下所示：
$$
\left[
\begin{matrix}
x_{11} & x_{12} & x_{13} \\
x_{21} & x_{22} & x_{23} \\
x_{31} & x_{32} & x_{33} 
\end{matrix}
\right]
$$
焦距$f$由相机的商品包装给出，则
$$
K=
\left[
\begin{matrix}
f_x & s & c_x \\
0 & f_y & c_y \\
0 & 0& 1
\end{matrix}
\right]=
\left[
\begin{matrix}
\frac{f}{dx} & s & c_x \\
0 & \frac{f}{dy} & c_y \\
0 & 0& 1
\end{matrix}
\right]=
\left[
\begin{matrix}
x_{11} & x_{12} & x_{13} \\
x_{21} & x_{22} & x_{23} \\
x_{31} & x_{32} & x_{33} 
\end{matrix}
\right]
$$

$$
\frac{f}{dx}=x_{11} & or & \frac{f}{dy}=x_{22}\\
dx=\frac{f}{x_{11}} & or & dy=\frac{f}{x_{22}}\tag 6
$$

参考文章

1. [理想针孔相机模型入门：从像素坐标系到相机坐标系 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/331832549)

# 7 相机标定流程

1. 固定相机，测量高度`H`以及夹角`a`
2. 使用相机拍摄标定板（15-30张左右），拍摄要求如下：
    1. 远近
    2. 上下左右以及重点
    3. 标定板平面平整光滑，拍摄时可有一定程度的倾斜（任意方向，但必须能拍出标定板的完整内容）
3. 打开matlab的相机标定APP![image-20230718102652188](E:\Typora_images_Repository\image-20230718102652188.png)
4. 现在拍摄的图片![image-20230718103804189](E:\Typora_images_Repository\image-20230718103804189.png)
5. 选择标定算法并填写标定板的详细信息![image-20230718104209402](E:\Typora_images_Repository\image-20230718104209402.png)
6. 三个参数的时候由于k3所对应的非线性较为剧烈。估计的不好，容易产生极大的扭曲，所以我们在MATLAB中选择使用两参数，并且选择错切和桶形畸变，然后由matlab计算出相机的参数。 ![image-20230718162438712](E:\Typora_images_Repository\image-20230718162438712.png)
7. 导出cameraParameters![image-20230721170641891](E:\Typora_images_Repository\image-20230721170641891.png)
8. 查看cameraParameters![image-20230721170040747](E:\Typora_images_Repository\image-20230721170040747.png)

==matlab中获得的内参矩阵需要装置才使用==

# 8 畸变纠正

无论是单目相机还是双目相机，拍摄的图像都会存在畸变。它们和鱼眼相机的畸变矫正原理也是一样的：`核心是求解一个好的重映射矩阵（remap matrix）。`

畸变矫正就是将原图中的部分像素点（或插值点）进行重新排列，“拼”成一张矩形图。

[Correct image for lens distortion - MATLAB undistortImage - MathWorks 中国](https://ww2.mathworks.cn/help/vision/ref/undistortimage.html)

[Image Undistortion - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/visionhdl/ug/image-undistort.html?searchHighlight=undistortion&s_tid=srchtitle_undistortion_1)

[(45条消息) 利用matlab进行畸变矫正_matlab矫正畸变_下山打蚂蚁的博客-CSDN博客](https://blog.csdn.net/weixin_43847322/article/details/130879972)

[相机标定究竟在标定什么？ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/30813733)

[相机标定究竟在标定什么？ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/30813733)

[Dissecting the Camera Matrix, Part 3: The Intrinsic Matrix ← (ksimek.github.io)](http://ksimek.github.io/2013/08/13/intrinsic/)

[相机模型和单目测距原理 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/626913010)
