import carla
import random

# 参考：https://carla.readthedocs.io/en/latest/tuto_first_steps/

# Connect to the client and retrieve the world object
# 客户端对象用于维护客户端与服务器的连接，并具有许多用于应用命令和加载或导出数据的功能。
# 可以使用客户端对象加载替代地图或重新加载当前地图（重置为初始状态）。
# 端口可以​​选择任何可用端口，默认设置为 2000，
# 也可以使用计算机的 IP 地址选择与localhost不同的主机。这样，CARLA 服务器可以在联网的机器上运行
client = carla.Client('localhost', 2000)
world = client.get_world()

client.load_world('ScenarioBasic')


