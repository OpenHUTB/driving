# 程序的部署

## 安装 
1. 安装 Production Server 2016b

2. 部署代码
参考[链接](https://github.com/OpenHUTB/matlab/blob/master/help/compiler_sdk/mps_restfuljson/example-web-based-bond-pricing-tool-using-javascript_zh_CN.html) 进行代码的部署。


## 启动
1. 设置环境
```shell
mps-setup "C:\Program Files\MATLAB\MATLAB Runtime\v91"
```

2. 新建一个实例
```shell
mps-new D:\project\mps_instances\demo
```

3. 启动实例
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

## 问题
1. 浏览器访问报错：`has been blocked by CORS policy`
使用以下参数启动chrome浏览器（参考 [链接](https://stackoverflow.com/questions/3102819/disable-same-origin-policy-in-chrome) ：
```shell
chrome.exe --disable-site-isolation-trials --disable-web-security --user-data-dir="D:\temp"
```
查找报错信息参考 [链接](https://ww2.mathworks.cn/help/mps/restfuljson/troubleshooting-restful-api-errors.html) 。


## 代理安装

1. 安装webpack 命令行工具
```shell
npm install webpack webpack-dev-server webpack-cli --save-dev
```

2. 创建webpack配置文件`webpack.config.js`在根目录下并配置
```
const path = require('path');

module.exports = {
  
  devServer: {
    contentBase: path.join(__dirname, 'public'), 
    compress: true,
    port: 9000,  // 端口
    proxy: {
      '/api': { 
        target: 'https://target-server.com',  // 服务器地址
        secure: false,
        changeOrigin: true,
        pathRewrite: {'^/api' : ''}
      }
    }
  }
};
```

3. 启动webpack服务器
```shell
npx webpack serve --config webpack.config.js
```
