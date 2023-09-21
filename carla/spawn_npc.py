"""在仿真环境中生成 NPCs （Non-Player Character, 游戏中的非玩家角色）"""
# 在命令行中输入：
# python spawn_npc.py -n 80
# 参考：<https://blog.csdn.net/qq_39004117/article/details/105680609>。
# 交通管理程序文档：<https://carla.readthedocs.io/en/latest/tuto_G_traffic_manager/>。

# 运行之前先启动 CarlaUE4.exe
# 运行参数示例：--number-of-vehicles 500  --number-of-walkers 500 --debug True

import glob
import os
import sys
import time

try:
    sys.path.append(glob.glob('../carla/dist/carla-*%d.%d-%s.egg' % (
        sys.version_info.major,
        sys.version_info.minor,
        'win-amd64' if os.name == 'nt' else 'linux-x86_64'))[0])
except IndexError:
    pass

import carla

import argparse
import logging
import random


def main():
    argparser = argparse.ArgumentParser(
        description=__doc__)
    argparser.add_argument(
        '--host',
        metavar='H',
        default='127.0.0.1',
        help='IP of the host server (default: 127.0.0.1)')
    argparser.add_argument(
        '-p', '--port',
        metavar='P',
        default=2000,
        type=int,
        help='TCP port to listen to (default: 2000)')
    argparser.add_argument(
        '-n', '--number-of-vehicles',
        metavar='N',
        default=10,
        type=int,
        help='number of vehicles (default: 10)')
    argparser.add_argument(
        '-w', '--number-of-walkers',
        metavar='W',
        default=50,
        type=int,
        help='number of walkers (default: 50)')
    argparser.add_argument(
        '--safe',
        action='store_true',
        help='avoid spawning vehicles prone to accidents')
    argparser.add_argument(
        '--filterv',
        metavar='PATTERN',
        default='vehicle.*',
        help='vehicles filter (default: "vehicle.*")')
    argparser.add_argument(
        '--filterw',
        metavar='PATTERN',
        default='walker.pedestrian.*',
        help='pedestrians filter (default: "walker.pedestrian.*")')
    argparser.add_argument(
        '-tm_p', '--tm_port',
        metavar='P',
        default=8000,
        type=int,
        help='port to communicate with TM (default: 8000)')
    argparser.add_argument(
        '--sync',
        action='store_true',
        help='Synchronous mode execution')
    argparser.add_argument(
        '--debug',
        type=bool,
        default=False,
        help='Synchronous mode execution')
    args = argparser.parse_args()

    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    vehicles_list = []
    walkers_list = []
    all_id = []
    # 生成客户端，用于连接 carla 服务器
    client = carla.Client(args.host, args.port)
    client.set_timeout(10.0)

    try:
        traffic_manager = client.get_trafficmanager(args.tm_port)  # 获得交通管理程序（TrafficManager, TM）
        # 设置车辆与其他车辆必须保持的最小距离（以米为单位）。
        # 距离以米为单位，会影响最小移动距离。它是从车辆对象的中心到中心计算的。
        traffic_manager.set_global_distance_to_leading_vehicle(4.0)
        world = client.get_world()  # 获得世界对象

        synchronous_master = False

        if args.sync:
            # 设置在同步模式下的仿真器
            settings = world.get_settings()
            traffic_manager.set_synchronous_mode(True)  # 启用同步模式
            if not settings.synchronous_mode:
                synchronous_master = True
                settings.synchronous_mode = True
                settings.fixed_delta_seconds = 0.05
                world.apply_settings(settings)
            else:
                synchronous_master = False

        # 从蓝图库中选择一些模型
        blueprints = world.get_blueprint_library().filter(args.filterv)
        blueprintsWalkers = world.get_blueprint_library().filter(args.filterw)

        if args.safe:
            blueprints = [x for x in blueprints if int(x.get_attribute('number_of_wheels')) == 4]
            blueprints = [x for x in blueprints if not x.id.endswith('isetta')]
            blueprints = [x for x in blueprints if not x.id.endswith('carlacola')]
            blueprints = [x for x in blueprints if not x.id.endswith('cybertruck')]
            blueprints = [x for x in blueprints if not x.id.endswith('t2')]

        # 当我们创建 TM 车辆时，它们需要一个生成的地图位置。
        # 我们可以使用自己选择的地图坐标自行定义这些。
        # 然而，为了解决这个问题，每个 CARLA 地图都有一组预定义的生成点，均匀分布在整个道路网络中。
        # 我们可以使用这些生成点来生成我们的车辆。
        spawn_points = world.get_map().get_spawn_points()
        number_of_spawn_points = len(spawn_points)

        # 可以使用 CARLA 的调试功能来查看生成点在哪里。
        # 运行以下代码，然后飞过地图并检查生成点的位置。
        # 当我们想要选择更具体的点用于产卵或引导车辆时，这会派上用场。
        if args.debug:
        # 将生成点位置绘制为地图中的数字
            for i, spawn_point in enumerate(spawn_points):
                world.debug.draw_string(spawn_point.location, str(i), life_time=10)
            # 在同步模式下，我们需要运行模拟来让观察者飞起来
            while True:
                world.tick()

        if args.number_of_vehicles < number_of_spawn_points:
            random.shuffle(spawn_points)
        elif args.number_of_vehicles > number_of_spawn_points:  # 场景中的生成点有最大值，即使参数设置太大也没用
            msg = 'requested %d vehicles, but could only find %d spawn points'
            logging.warning(msg, args.number_of_vehicles, number_of_spawn_points)
            args.number_of_vehicles = number_of_spawn_points

        # @todo cannot import these directly.
        SpawnActor = carla.command.SpawnActor
        SetAutopilot = carla.command.SetAutopilot
        FutureActor = carla.command.FutureActor

        # --------------
        # 生成车辆
        # --------------
        batch = []
        for n, transform in enumerate(spawn_points):
            if n >= args.number_of_vehicles:
                break
            blueprint = random.choice(blueprints)
            if blueprint.has_attribute('color'):
                color = random.choice(blueprint.get_attribute('color').recommended_values)
                blueprint.set_attribute('color', color)
            if blueprint.has_attribute('driver_id'):
                driver_id = random.choice(blueprint.get_attribute('driver_id').recommended_values)
                blueprint.set_attribute('driver_id', driver_id)
            blueprint.set_attribute('role_name', 'autopilot')
            batch.append(SpawnActor(blueprint, transform).then(SetAutopilot(FutureActor, True)))

        for response in client.apply_batch_sync(batch, synchronous_master):
            if response.error:
                logging.error(response.error)
            else:
                vehicles_list.append(response.actor_id)

        # -------------
        # 生成行人
        # -------------
        # 一些设置
        percentagePedestriansRunning = 0.0      # 运行多少行人
        percentagePedestriansCrossing = 0.0     # 有多少行人会穿过马路
        # 1. 获取所有随机位置来进行生成
        spawn_points = []
        for i in range(args.number_of_walkers):
            spawn_point = carla.Transform()
            loc = world.get_random_location_from_navigation()
            if (loc != None):
                spawn_point.location = loc
                spawn_points.append(spawn_point)
        # 2. 生成行人目标
        batch = []
        walker_speed = []
        for spawn_point in spawn_points:
            walker_bp = random.choice(blueprintsWalkers)
            # 设定为并非无敌
            if walker_bp.has_attribute('is_invincible'):
                walker_bp.set_attribute('is_invincible', 'false')
            # 设置最大速度
            if walker_bp.has_attribute('speed'):
                if (random.random() > percentagePedestriansRunning):
                    # 行走
                    walker_speed.append(walker_bp.get_attribute('speed').recommended_values[1])
                else:
                    # 运行
                    walker_speed.append(walker_bp.get_attribute('speed').recommended_values[2])
            else:
                print("Walker has no speed")
                walker_speed.append(0.0)
            batch.append(SpawnActor(walker_bp, spawn_point))
        results = client.apply_batch_sync(batch, True)
        walker_speed2 = []
        for i in range(len(results)):
            if results[i].error:
                logging.error(results[i].error)
            else:
                walkers_list.append({"id": results[i].actor_id})
                walker_speed2.append(walker_speed[i])
        walker_speed = walker_speed2
        # 3. 生成行人控制器
        batch = []
        walker_controller_bp = world.get_blueprint_library().find('controller.ai.walker')
        for i in range(len(walkers_list)):
            batch.append(SpawnActor(walker_controller_bp, carla.Transform(), walkers_list[i]["id"]))
        results = client.apply_batch_sync(batch, True)
        for i in range(len(results)):
            if results[i].error:
                logging.error(results[i].error)
            else:
                walkers_list[i]["con"] = results[i].actor_id
        # 4. 把步行者和控制器的id放在一起，从他们的id中获取对象
        for i in range(len(walkers_list)):
            all_id.append(walkers_list[i]["con"])
            all_id.append(walkers_list[i]["id"])
        all_actors = world.get_actors(all_id)

        # 等待勾选以确保客户端接收到刚刚创建的行人的最后一次转换
        if not args.sync or not synchronous_master:
            world.wait_for_tick()
        else:
            world.tick()

        # 5. 初始化每个控制器并设置要步行到的目标 (列表为 [控制器, 参与者, 控制器, 参与者 ...])
        # 设置有多少行人可以过马路
        world.set_pedestrians_cross_factor(percentagePedestriansCrossing)
        for i in range(0, len(all_id), 2):
            # 开始步行
            all_actors[i].start()
            # 将漫游设置为随机点
            all_actors[i].go_to_location(world.get_random_location_from_navigation())
            # 最大速度
            all_actors[i].set_max_speed(float(walker_speed[int(i/2)]))

        print('spawned %d vehicles and %d walkers, press Ctrl+C to exit.' % (len(vehicles_list), len(walkers_list)))

        # 如何使用参数的示例
        traffic_manager.global_percentage_speed_difference(30.0)

        while True:
            if args.sync and synchronous_master:
                world.tick()
            else:
                world.wait_for_tick()

    finally:
        if args.sync and synchronous_master:
            settings = world.get_settings()
            settings.synchronous_mode = False
            settings.fixed_delta_seconds = None
            world.apply_settings(settings)

        print('\ndestroying %d vehicles' % len(vehicles_list))
        client.apply_batch([carla.command.DestroyActor(x) for x in vehicles_list])

        # 停止行人控制器 (列表为 [控制器, 参与者, 控制器, 参与者 ...])
        for i in range(0, len(all_id), 2):
            all_actors[i].stop()

        print('\ndestroying %d walkers' % len(walkers_list))
        client.apply_batch([carla.command.DestroyActor(x) for x in all_id])

        time.sleep(0.5)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        pass
    finally:
        print('\ndone.')
