import urllib.request
import pandas as pd
import os
from tqdm import tqdm

# 设置图片保存路径
save_path = r'E:\Climb-Baidu-Maps\poi爬取'
ak = "RenIdNxaLovWxTPjihNhOzQZLqILPeKH"

# 检查保存路径是否存在，如果不存在则创建
if not os.path.exists(save_path):
    os.makedirs(save_path)

# 从Excel文件中读取数据
data = pd.read_excel(r"E:\Climb-Baidu-Maps\BD09百度坐标系.xlsx")


def scrap_img():
    # 遍历每个地点的坐标
    for i in tqdm(range(len(data)), desc='Processing'):
        # 获取地点名称、地址、经度和纬度
        location_name = str(data.iloc[i]['name'])
        location_address = str(data.iloc[i]['address'])
        location_number = str(data.iloc[i]['bd09_lng']) + ',' + str(data.iloc[i]['bd09_lat'])

        # 在四个不同的方向（0度、90度、180度、270度）拍摄全景图片
        for j in range(4):
            # 计算旋转角度
            heading_number = str(90 * j)

            url = r"https://api.map.baidu.com/panorama/v2?" \
                  "&width=512&height=256" \
                  "&location=" + location_number + \
                  "&heading=" + heading_number + \
                  "&pitch=" + str(45) + \
                  "fov=" + str(90) + \
                  "&ak=" + ak

            # 设置保存图片的文件名
            save_name = f"{location_name}_{location_address}_{j + 1}_{location_number}.jpg"

            # 打开URL
            rep = urllib.request.urlopen(url)

            # 读取图片数据
            image_data = rep.read()

            # 计算图片大小
            im_occupy = len(image_data)

            # 如果图片大小大于105字节，则保存图片
            if im_occupy > 105:
                # 将图片保存到本地
                with open(os.path.join(save_path, save_name), 'wb') as f:
                    f.write(image_data)
            else:
                # 图片大小小于105字节，跳过保存
                pass


# 调用函数
scrap_img()
