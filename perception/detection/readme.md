# 功能介绍

使用YOLOv4目标检测模型对输入视频进行逐帧处理，检测每一个视频帧中的目标并在该帧中标记出来。

# 参数详解

`input_object.mp4`：需要处理的视频的名称

`output_detection.mp4`：使用YOLOv4模型处理后的视频的名称

# 使用说明

1. 将需要处理的视频文件与`Traffic_Detection.m`文件处在同一目录下；
2. 将`input_object.mp4`替换成需要处理的视频文件名称即可，输出的视频的名称`output_detection.mp4`可按自己的需求进行修改。

# 其他说明

1. 目前的函数实现比较粗糙，处理视频较长的视频文件需要很长的时间，`建议使用一些时长较短的视频文件，例如十几秒、一两分钟的视频，进行测试`；

2. 处理后的视频文件的`数据速率、总比特速率、帧速率以及占用大小等属性`发生了异常的变化；

3. 百度网盘`drving\crossroads\12号路口南向北-20220624130001.MP4`的处理结果的``部分片段可在以下连接中给获得：

    - 链接：https://pan.baidu.com/s/10gN5NKcy2ozCVQpoBSgQrg 
    - 提取码：ping 

    
