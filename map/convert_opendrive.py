import subprocess

def convert_xodr_to_net(xodr_file, net_file):
    print(f"🚀 正在将 {xodr_file} 转换为 SUMO 网络文件...")

    # 标准命令，无需任何额外参数
    cmd = [
        "netconvert",
        "--opendrive-files", xodr_file,
        "--output-file", net_file
        # 注意：不需要 --opendrive.proj-string，也不需要 --proj.utm
        # 因为 .xodr 文件里已经自带了正确的投影信息
    ]

    try:
        subprocess.run(cmd, check=True)
        print(f"✅ 转换成功！SUMO 网络文件已生成：{net_file}")
        print("💡 现在生成的 .net.xml 文件将具有真实的地理坐标。")
    except subprocess.CalledProcessError as e:
        print(f"❌ 转换失败：{e}")

if __name__ == "__main__":
    convert_xodr_to_net("final_map.xodr", "final_map.net.xml")