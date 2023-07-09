import requests
from tqdm import tqdm


def wgs84_to_bd09(latitude, longitude):
    # 使用百度地图Web API进行坐标转换
    url = f'http://api.map.baidu.com/geoconv/v1/?coords={longitude},{latitude}&from=1&to=5&ak=RenIdNxaLovWxTPjihNhOzQZLqILPeKH'
    response = requests.get(url)
    data = response.json()

    if data['status'] == 0:
        result = data['result'][0]
        return result['y'], result['x']  # 返回百度经纬度坐标（BD09）
    else:
        return None


# 读取WGS-84经纬度坐标文件
input_file_path = 'E:\\Climb-Baidu-Maps\\WGS-84经纬度坐标.txt'
output_file_path = 'E:\\Climb-Baidu-Maps\\BD09百度坐标系.txt'

with open(input_file_path, 'r', encoding='utf-8') as file:
    lines = file.readlines()

converted_data = []

total_lines = len(lines)

# 转换坐标
for line in tqdm(lines, desc="转换进度"):
    line = line.strip()
    if line.startswith('Name:'):
        name = line.split(':')[1].strip()
    elif line.startswith('[') and line.endswith(']'):
        coords = line.strip('[]').split(',')
        wgs84_latitude = float(coords[0].strip())
        wgs84_longitude = float(coords[1].strip())
        bd09_latitude, bd09_longitude = wgs84_to_bd09(wgs84_latitude, wgs84_longitude)
        converted_data.append({'name': name, 'bd09_latitude': bd09_latitude, 'bd09_longitude': bd09_longitude})

# 将转换后的坐标写入文件
with open(output_file_path, 'w', encoding='utf-8') as file:
    for data in converted_data:
        file.write(f"Name: {data['name']}\n")
        file.write("BD09Coordinates:\n")
        file.write(f"Latitude: {data['bd09_latitude']}\n")
        file.write(f"Longitude: {data['bd09_longitude']}\n")
        file.write("\n")

print(f"转换完成，结果保存在文件：{output_file_path}")
