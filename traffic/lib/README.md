# 交通工具


该库是一个 MATLAB® 环境，能够模拟车辆和路口控制器的简单交通场景。
该模拟器提供了人类驾驶员和交通信号灯的模型，但其设计目的是让用户可以指定自己的车辆和交通信号控制逻辑。
该模拟器的目的是测试多智能体自主车辆控制算法和智能交通控制算法。


该模拟器利用自动驾驶工具箱中的工具，即驾驶场景设计器应用程序及其生成的 DrivingScenario 对象。
这些工具可以有效地用于表示道路网络、在其中填充车辆并指定其轨迹。
然而，车辆的运动应该在运行模拟之前通过手动指定车辆轨迹的路点来指定。
该工具旨在通过在闭环仿真中模拟交通来扩展此功能，其中车辆的速度轨迹不是先验给出的，而是状态相关控制逻辑的产物。


**驾驶场景设计器应用程序** 是自动驾驶工具箱的一部分。
请参阅 [此处](https://www.mathworks.com/help/driving/ref/drivingscenariodesigner-app.html) 的文档以获取更多信息


## MATLAB&reg; 工具箱依赖项
该模型已使用 MATLAB R2020b 进行了测试。

要运行此模型，您需要： MATLAB和自动驾驶工具箱。

## 入门
首先，用户可以通过 [OpenTrafficLabIntroductoryExample.mlx]() 获取记录示例，涵盖场景创建、路口控制器创建、车辆生成以及使用提供的汽车跟随模型运行模拟。


## 架构
该库使用面向对象编程 (OOP) 架构构建。OOP 的概念以及 MATLAB 中的 OOP 可以 [here](https://www.mathworks.com/products/matlab/object-oriented-programming.html?s_tid=srchtitle_object%20oriented%20programming_1) 回顾。
模拟器的结构利用了驾驶场景设计器应用程序的现有类，如驾驶场景、车辆和演员。
至关重要的是，添加了三个需要理解的类：

* A [Node]() 类用于三个主要目的：
    1. 将网络表示为连接车道和转弯的有向图，车辆可以使用它来指定其通过网络的路线。
    2. 提供全局位置、沿车道长度的站点距离以及车道方向和曲率之间的映射
    3. 连接车辆和交通控制器。
* 控制网络中车辆的 [DrivingStrategy]() 类。
    1. 对象实现汽车跟随纵向控制，并静态跟踪中心车道，也就是说，它假设没有动态保持车道。
    2. 两个汽车跟随模型（吉普斯汽车跟随模型和智能驾驶员模型）已预先编程到 DrivingStrategy 类中，它们可用于针对人类驾驶场景进行基准测试。这些模型保证安全的前后驾驶，但依靠适当的路口控制器来避免横向碰撞。
    3. 为了实现用户定义的驾驶逻辑，可以使用DrivingStrategy作为父类并重写相关方法。
* [TrafficController]() 类，用于建模和实现交通规则和信号 。
    1. TrafficController 对象与其要控制的所有节点（即车道或转弯）相关联。它通过将节点设置为打开或关闭来控制它们。车辆应对即将到来的封闭节点做出反应，不进入该节点。
    2. 为了实现用户定义的流量控制逻辑，可以使用TrafficController作为父类并重写相关方法。该存储库包含一个这样的控制器，位于继承自 TrafficController 的 [TrafficLight]() 类中。


## 交通仿真

要设置模拟，用户必须创建道路网络并指定行驶方向以及车道和转弯的连接性。包含道路网络的 DrivingScenario 对象可以使用 DrivingScenarioDesigner 或其编程 API 创建。存储库中包含用于创建两个示例场景的函数，一种用于 T 形路口 ([createTJunctionScenario.m]()) ，一种用于四路路口 ([createFourWayJunctionScenario.m]()) 。然后，通过将道路网络中的每个车道或转弯与节点相关联，并相应地将节点链接在一起来构建节点对象的网络。还提供了两个示例的创建节点及其连接的函数（请参阅 [createTJunctionNetwork.m]() 和 [createFourWayJunctionNetwork.m]()) 。

必须生成接下来的车辆及其进入时间，以及控制它们的 DrivingStrategy 对象。可以使用提供的泊松到达过程模型生成进入时间，该模型在DrivingBehavior [package](https://www.mathworks.com/help/matlab/matlab_oop/scoping-classes-with-packages.html) 内的 [generatePoissonEntryTimes.m]() 函数中实现。提供了为两个名义示例创建车辆和驱动程序的函数（请参阅 [createVehiclesForTJunction.m]() 和 [createVehiclesForFourWayJunction.m]()) 。

可以创建交通控制器（例如交通灯）来动态控制车辆何时可以进入节点（即车道或转弯）。

最后，可以通过调用 DrivingScenario 对象上的 [advance](https://www.mathworks.com/help/driving/ref/drivingscenario.advance.html?s_tid=srchtitle) 函数来执行模拟。

## 参考
[开放交通实验室](https://github.com/mathworks/OpenTrafficLab) 