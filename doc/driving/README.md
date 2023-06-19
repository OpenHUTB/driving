

# 自动驾驶
文档位于目录`{matlab}\help\driving`，翻译后打开帮助文档自动加载已经翻译的内容。

## 步骤
### 翻译
1. 复制未翻译的文档，将副本文件名在原来的文件名基础上加`_zh_CN`。比如翻译文件`{matlab}\help\driving\ug\select-waypoints-for-3d-simulation.html`则新增文件`select-waypoints-for-3d-simulation_zh_CN.html`；
2. 使用html编辑器进行翻译。
3. 使用脚本`sync_doc.m`将matlab中翻译好的文档复制到仓库。

### 部署
1. 运行脚本`deploy_doc.m`将仓库中已翻译好的文档复制到matlab软件中。
