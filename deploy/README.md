# 程序的部署

## 安装 
Production Server 2016b


## 启动
1. 设置环境
```shell
mps-setup "C:\Program Files\MATLAB\MATLAB Runtime\v91"
```

3. 新建一个实例
```shell
mps-new D:\project\mps_instances\demo
```

2. 启动实例
```shell
mps-start -f -C D:\project\mps_instances\demo
```
查看实例的状态：
```shell
mps-status -C D:\project\mps_instances\demo
```

停止实例：
```shell
mps-stop -C D:\project\mps_instances\demo
```

注意：所使用的MCR版本也要是2016b。