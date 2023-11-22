
import glob
import os
import sys
import time
import numpy as np
import math
try:
    sys.path.append(glob.glob('../carla/dist/carla-*%d.%d-%s.egg' % (
        sys.version_info.major,
        sys.version_info.minor,
        'win-amd64' if os.name == 'nt' else 'linux-x86_64'))[0])
except IndexError:
    pass

import carla

from carla import VehicleLightState as vls

import argparse
import logging
from numpy import random

import cv2

IM_WIDTH = 640
IM_HEIGHT = 480

# def get_distance(location1, location2):
#     dx = location1.x - location2.x
#     dy = location1.y - location2.y
#     return math.sqrt(dx**2 + dy**2)

# def process_img(image):
#     i = np.array(image.raw_data)
#     i2 = i.reshape((IM_HEIGHT, IM_WIDTH, 4))
#     i3 = i2[:, :, :3]
#     cv2.imshow("", i3)
#     cv2.waitKey(1)
#     return i3 / 255.0

def read_data(file, frame_num):
    file.seek(0)
    lines = file.readlines()  # 读取所有行数据
    result = []
    for line in lines:
        elements = line.strip().split(',')  # 去除换行符并按逗号分割元素
        if len(elements) > 0 and float(elements[0]) == frame_num:  # 检查第一个元素是否为 9
            result.append(line)
    return result
# 需要设置精确的从航点到航点方向盘的变化
def control_drection_by_waypointn(vehicle,next_waypoint, mid_value=1):

    if vehicle is not None:
        # 获取车辆当前位置
        current_location = vehicle.get_location()
        # print(current_location)
        # 计算目标朝向EE
        target_rotation = math.degrees(
            math.atan2(next_waypoint.y - current_location.y,
                       next_waypoint.x - current_location.x))
        print(vehicle)
        print(current_location)
        print(next_waypoint)
        print(target_rotation)
        # 设置车辆的朝向
        vehicle.set_transform(carla.Transform(current_location, carla.Rotation(yaw=target_rotation)))

        # 当车辆修改方向幅度过大时，减小车辆的速度，或者增加车辆的刹车
        # 判断什么时候车辆转角过大需要减速
        if abs(target_rotation) > mid_value:
            vehicle.apply_control(carla.VehicleControl(throttle=0.1, steer=0.0, brake=0.0))
        else:
            vehicle.apply_control(carla.VehicleControl(throttle=1.0, steer=0.0, brake=0.0))
        # # 计算车辆当前方向
        # current_rotation = vehicle.get_transform().rotation
        # current_yaw = math.radians(current_rotation.yaw)
        # current_location = vehicle.get_location()
        #
        # # 计算车辆到目标航点的方向
        # target_yaw = math.atan2(next_waypoint.y - current_location.y,
        #                         next_waypoint.x - current_location.x)
        #
        # # 计算偏差角度
        # angle_diff = target_yaw - current_yaw
        #
        # # 将偏差角度映射到 [-pi, pi] 范围
        # angle_diff = math.atan2(math.sin(angle_diff), math.cos(angle_diff))
        # print(angle_diff)
        # # 设置方向盘转向角度，可以根据需要进行调整
        # # 获取当前车辆控制参数
        # current_control = vehicle.get_control()
        # # 修改方向盘转向值
        # current_control.steer = angle_diff
        # # 应用修改后的控制参数到车辆
        # vehicle.apply_control(current_control)

# 判断坐标有效，无效则不添加车辆
def valid_value(artical_value):
    if artical_value <= 8.8 and artical_value >= -8.8:
        return True

def check_vehicles_exist(vehicle_list, vehicle_id):
    flag = False
    for vehicle_list_item in vehicle_list:
         if vehicle_list_item[0] == vehicle_id:
             flag = True
    return flag
class Node:
    def __init__(self, location):
        self.location = location
        self.next = None

# 创建每辆车的路径结点
class LocationLinkedList:
    def __init__(self):
        self.head = None
        self.length = 0

    def __len__(self):
        return self.length

    # 添加路径结点
    def append(self, location):
        new_node = Node(location)
        if not self.head:
            self.head = new_node
            return
        last_node = self.head
        while last_node.next:
            last_node = last_node.next
        last_node.next = new_node
        self.length += 1

    def display(self):
        current = self.head
        while current:
            print(f"Location(x={current.location.x}, y={current.location.y}, z={current.location.z})", end=" -> ")
            current = current.next
        print("None")


def main():
    argparser = argparse.ArgumentParser(
        description='CARLA Manual Control Client')
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
        default=30,
        type=int,
        help='Number of vehicles (default: 30)')
    argparser.add_argument(
        '-w', '--number-of-walkers',
        metavar='W',
        default=10,
        type=int,
        help='Number of walkers (default: 10)')
    argparser.add_argument(
        '--tm-port',
        metavar='P',
        default=8000,
        type=int,
        help='Port to communicate with TM (default: 8000)')
    args = argparser.parse_args()
    client = carla.Client(args.host, args.port)  # 多客户端模式和多交通管理器模式
    client.set_timeout(2000.0)  # 设置超时
    world = client.get_world()  # 获取世界对象

    try:

        # 生成车辆蓝图
        vehicle_bp = world.get_blueprint_library().find('vehicle.tesla.model3')

        # vehicle_list_item = [vehicle_id, vehicle_instance, route_linklist,next_waypoint_pointer]
        vehicle_list = []
        destroy_num_list = []
        file_path = "C:/Users/xiaopengfei/Desktop/route.txt"
        with open('C:/Users/xiaopengfei/Desktop/route.txt', 'r') as file:
            frame_num = 0
            while True:

                    # 读取当前帧数据,将车辆信息添加到vehicle_list
                    for frame_data in read_data(file, frame_num):

                        if frame_data is not None:
                            # 分割text_info = 0,109758367,179,120.2,8.8,12,0.25,3
                            numbers = [float(num) for num in frame_data.strip().split(",")]

                            location = carla.Location(x=-numbers[3], y=-numbers[4], z=0.1)

                            # 遍历vehicle_list,检查是否有这个编号的车辆,没有则添加车辆
                            if valid_value(numbers[4]) and not check_vehicles_exist(vehicle_list, numbers[2]):
                                     # 根据location 生成车辆，这里还得根据location计算可以生成车辆的spawn_point
                                     # transform = calculatate_spawn_point(location,spawn_points)
                                     # 生成头节点，节点数据表示生成点的next_waypoint,但是这里spawn_point就作为next_waypoint
                                     # 创建route链表
                                     linked_list = LocationLinkedList()
                                     linked_list.head = Node(location)

                                     #world.debug.draw_string(carla.Location(x=-numbers[3], y=-numbers[4], z=0.1), str(0), life_time=60, color=carla.Color(255, 0, 0))

                                     # 判断yaw, 生成车辆
                                     if numbers[4] < 0:
                                         vehicle_instance = world.try_spawn_actor(vehicle_bp, carla.Transform(carla.Location(x=-numbers[3], y=-numbers[4], z=0.1), carla.Rotation(yaw=0)))
                                     else:
                                         vehicle_instance = world.try_spawn_actor(vehicle_bp, carla.Transform(carla.Location(x=-numbers[3], y=-numbers[4], z=0.1),carla.Rotation(yaw=180)))


                                     # 将车辆添加到vehicle_list
                                     # transform.location表示设置当前车辆的next_waypoint就是spawn_point
                                     # vehicle_list_item = [vehicle_id, vehicle_instance, route_linklist,next_waypoint_pointer]
                                     vehicle_list_item = [numbers[2], vehicle_instance, linked_list, linked_list.head]
                                     vehicle_list.append(vehicle_list_item)
                                     # 使车辆直线跑起来，给油门，不转向，不刹车
                                     if vehicle_instance is not None:
                                        vehicle_instance.apply_control(carla.VehicleControl(throttle=1.0, steer=0.0, brake=0.0))
                            else:
                                     # 当不是生成车辆的时候，读取way_point添加到vehicle的route链表后面
                                     # 遍历vehicle_list找到添加路径的车辆所在的链表，追加到链表表尾
                                     for vehicle_list_item in vehicle_list:
                                           # vehicle_list_item[0] == numbers[2]表示找到了文件读取出来的那条数据的车
                                           if vehicle_list_item[0] == numbers[2]:
                                                # 添加way_point到表尾
                                                vehicle_list_item[2].append(location)

                    frame_num +=1

                    # # 设置下一帧的航点
                    # for vehicle_list_item in vehicle_list:
                    #     # 给的都是每一帧的航点，那么不用判断是否到达了
                    #     # # 判断是否到达next_waypoint
                    #     # # is_to_next_waypoint(vehicle, next_waypoint)
                    #     # if is_to_next_waypoint(vehicle_list_item[1], vehicle_list_item[3].location):
                    #
                    #           # 车辆到达下一个航点，且下下个航点存在
                    #           if vehicle_list_item[3].next is not None:
                    #               # 设置下个航点
                    #               vehicle_list_item[3] = vehicle_list_item[3].next
                    #           # else:
                    #           #     # # 车子到达目的地后销毁，或者是车辆航点链表到了末尾节点，即next_waypoint.next == None，就销毁车辆
                    #           #     if vehicle_list_item[1] is not None:
                    #                   # if reached_destination_to_destroy(vehicle):
                    #                   # 销毁车辆
                    #                  # vehicle_list_item[1].destroy()
                    #                  # vehicle_list_item[1] = None
                    #
                    #                   # 删除车辆在vehicle_list中的信息,添加到destroy_num_list
                    #                   #destroy_num_list.append(n)
                    #          #    车子前进的同时不停的修改车辆的方向
                    #           control_drection_by_waypointn(vehicle_list_item[1], vehicle_list_item[3].location)



                    world.wait_for_tick()

    finally:
            settings = world.get_settings()
            settings.synchronous_mode = False
            settings.no_rendering_mode = False
            settings.fixed_delta_seconds = None
            world.apply_settings(settings)

if __name__ == '__main__':
    main()
