# -*- coding: utf-8 -*-
import cv2
import numpy as np

def detect_lane_edges(image_path):
    # 1. 读取图片
    image = cv2.imread(image_path)
    # 调试：检查图片是否成功读取
    if image is None:
        print("❌ 错误：无法读取图片！请确认文件名是否正确。")
        return

    # 2. 转换颜色空间：BGR 转 HLS
    # 解释：OpenCV 默认读取是 BGR（蓝绿红），但 HLS（色相、亮度、饱和度）更适合找车道线。
    # 因为车道线通常是“很亮”的，不管它是白色还是黄色，我们在 HLS 里只看“亮度”高的部分。
    hls = cv2.cvtColor(image, cv2.COLOR_BGR2HLS)
    
    # 3. 定义颜色阈值 (核心：只提取白色的线)
    # 解释：我们要在图片里找“像素值”在某个范围内的点。
    # L 通道代表亮度。[180, 255] 意思是：只保留亮度在 180 到 255 之间的像素（也就是非常白的地方）。
    # 这样可以把灰色的路沿石、绿色的树挡在外面。
    lower_white = np.array([0, 120, 0])   # 最低阈值 (H, L, S)
    upper_white = np.array([255, 255, 255]) # 最高阈值
    mask = cv2.inRange(hls, lower_white, upper_white) # 生成黑白掩膜（只有白线是白的，其他是黑的）

    # 4. 形态学操作：闭运算 (Closing)
    # 解释：车道线有时候因为磨损是断断续续的。
    # 这一步的作用是“把断开的线连起来”。就像用胶水把短线粘成整条线。
    kernel = np.ones((5, 5), np.uint8) # 定义一个5x5的小方块作为“画笔”
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel) # 执行闭运算

    # 5. 定义感兴趣区域 (ROI) - 梯形区域
    # 解释：这是解决“误检路边物体”的关键！
    # 我们强制程序只看图片中间的路面，忽略最左边和最右边（那里通常有树、路沿石）。
    height, width = image.shape[:2]
    # 定义一个梯形的四个顶点（按顺序：左下 -> 左上 -> 右上 -> 右下）
    # 调整这里的数字可以改变框的大小：
    # width*0.1 和 width*0.9：左右边界，离边缘留一点空隙。
    # height*0.6：梯形的顶部高度，太高会切掉远处的线，太低会包含路边杂物。
    vertices = np.array([[
        (width * 0.1, height),       # 左下角 (靠左一点点)
        (width * 0.45, height * 0.65), # 左上角 (中间靠左)
        (width * 0.55, height * 0.65), # 右上角 (中间靠右)
        (width * 0.9, height)        # 右下角 (靠右一点点)
    ]], dtype=np.int32)
    
    # 创建一个全黑的蒙版
    roi_mask = np.zeros_like(mask)
    # 在蒙版上把梯形区域涂白 (255)
    cv2.fillPoly(roi_mask, vertices, 255)
    # 应用蒙版：只有梯形区域内的白色线条会被保留
    masked_edges = cv2.bitwise_and(mask, roi_mask)

    # 6. 霍夫变换检测直线 (Hough Lines)
    # 解释：把上面处理好的“白线图片”变成“几何直线”。
    # 参数解释：
    # threshold=50：值越小，越短的线也认为是线（建议保持50-100）。
    # minLineLength=60：线的像素长度必须超过60才被认为是车道线（过滤掉小石子）。
    # maxLineGap=30：如果线中间断了30个像素以内，就把它连起来（容忍磨损）。
    lines = cv2.HoughLinesP(masked_edges, 1, np.pi/180, threshold=50, 
                           minLineLength=60, maxLineGap=30)

    # 7. 绘制结果
    line_image = np.copy(image)
    if lines is not None:
        for line in lines:
            x1, y1, x2, y2 = line[0]
            # 过滤掉几乎是垂直的线（路边的树、电线杆通常是垂直的）
            # 如果线的两个点Y坐标差很小，说明它是横着的或者竖着的，车道线通常是斜的或者竖的，但路边的树是绝对竖的。
            # 这里我们简单点，只画线，靠 ROI 框定区域。
            cv2.line(line_image, (x1, y1), (x2, y2), (0, 0, 255), 5) # 画成红色，粗一点好看

    # 8. 保存结果
    cv2.imwrite('detected_lanes.png', line_image)
    cv2.imwrite('debug_mask.png', masked_edges) # 保存中间过程，方便你调试
    print("✅ 车道线检测完成！请查看 detected_lanes.png")
    print("💡 提示：如果效果不好，请看 debug_mask.png。如果里面线是断的，调大 minLineLength；如果里面有杂点，调高亮度阈值。")

# 运行函数
detect_lane_edges("road.png")