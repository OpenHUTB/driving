import pandas as pd

# 读取TXT文件并解析数据
data = []
with open('E:\\Climb-Baidu-Maps\\BD09百度坐标系.txt', 'r',encoding='utf-8') as file:
    lines = file.readlines()
    name = ''
    latitude = ''
    longitude = ''
    for line in lines:
        if line.startswith('Name:'):
            name = line.split(': ')[1].strip()
        elif line.startswith('Latitude:'):
            latitude = line.split(': ')[1].strip()
        elif line.startswith('Longitude:'):
            longitude = line.split(': ')[1].strip()
            data.append([name, longitude, latitude])

# 创建DataFrame
df = pd.DataFrame(data, columns=['Name', 'Longitude', 'Latitude'])

# 将数据保存为Excel文件
df.to_excel('E:\\Climb-Baidu-Maps\\BD09百度坐标系.xlsx', index=False)
