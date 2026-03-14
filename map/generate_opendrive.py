import subprocess
import os

def convert_osm_to_opendrive(osm_file, output_xodr):
    """
    将 OSM 文件转换为 OpenDrive (.xodr) 格式
    """
    print(f"🚀 正在将 {osm_file} 转换为 OpenDrive 文件...")

    if not os.path.exists(osm_file):
        print(f"❌ 错误：文件 {osm_file} 不存在！")
        return False

    # 核心命令：移除了 --proj 参数
    cmd = [
        "netconvert",
        "--osm-files", osm_file,
        # 移除了 "--proj" 参数，使用默认的局部坐标系
        "--ramps.guess",
        "--junctions.join",
        "--tls.guess",
        "--opendrive-output", output_xodr
    ]

    try:
        subprocess.run(cmd, check=True)
        print(f"✅ 转换成功！OpenDrive 文件已生成：{output_xodr}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ 转换失败：{e}")
        return False

if __name__ == "__main__":
    # 运行转换
    convert_osm_to_opendrive("map.osm", "final_map.xodr")