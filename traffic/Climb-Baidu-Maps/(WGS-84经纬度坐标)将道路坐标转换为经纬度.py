import math

# 读取TXT文件
file_path = 'E:\\Climb-Baidu-Maps\\yueluqu道路汇总.txt'
with open(file_path, 'r', encoding='utf-8') as file:
    lines = file.readlines()

# 解析TXT文件
data = []
current_name = None
for line in lines:
    line = line.strip()
    if line.startswith('Name:'):
        current_name = line.split(':')[1].strip()
    elif line.startswith('RoadCenters:'):
        if current_name:
            coordinates = []
            data.append({'name': current_name, 'coordinates': coordinates})
            current_name = None
    elif line.startswith('[') and line.endswith(']'):
        coords = line.strip('[]').split(',')
        coordinates.append([float(coord) for coord in coords])

# 坐标转换
wgs84_origin = (28.21305, 112.8785)  # 原点的WGS-84经纬度
wgs84_data = []
for road in data:
    wgs84_coords = []
    for coord in road['coordinates']:
        wgs84_coord = (wgs84_origin[0] + coord[0] / 111111, wgs84_origin[1] + coord[1] / (111111 * math.cos(math.radians(wgs84_origin[0]))))
        wgs84_coords.append(wgs84_coord)
    wgs84_data.append({'name': road['name'], 'coordinates': wgs84_coords})

# 输出结果到TXT文档
output_file_path = 'E:\\Climb-Baidu-Maps\\WGS-84经纬度坐标.txt'
with open(output_file_path, 'w', encoding='utf-8') as file:
    for road in wgs84_data:
        file.write(f"Name: {road['name']}\n")
        file.write("RoadCenters:\n")
        for coord in road['coordinates']:
            file.write(f"[{coord[0]}, {coord[1]}]\n")
        file.write("\n")
