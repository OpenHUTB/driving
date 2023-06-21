


# OpenStreetMap

## [导入OSM(openstreetmap)数据到Mysql](https://wiyi.org/importing-osm-into-mysql.html) 

问题1：mysql数据库serverTimezone设置。
方法：
mysql-> set global time_zone='+08:00';
mysql-> show variables like '%time_zone%';

问题2：字符编码问题
方法：
修改osm.sql，在每个表格创建后面加入“CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci”。
比如
CREATE TABLE IF NOT EXISTS `acls` (
  `id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `netmask` varchar(255) NOT NULL,
  `k` varchar(255) NOT NULL,
  `v` varchar(255) default NULL
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci;

####修改member_type类型为varchar(20)!!!!!!!!!!!!!!!!!

修改my.ini如下（找不到可以创建）：
[mysql]  
# 设置 mysql 客户端默认字符集  
default-character-set=utf8mb4  

[mysqld]  
#设置 3306 端口  
port = 3306  

# 设置 mysql 的安装目录  
basedir= F:\BaiduNetdiskDownload\mysql 

# 设置 mysql 数据库的数据的存放目录  
datadir= F:\BaiduNetdiskDownload\mysql\data

# 允许最大连接数  
max_connections=200  

# 服务端使用的字符集默认为 8 比特编码的 latin1 字符集  
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

# 创建新表时将使用的默认存储引擎  
default-storage-engine=INNODB

设置数据库编码：
SET NAMES utf8mb4; 
ALTER DATABASE 你的数据库名字 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

------------------------------------
自动生成mysql 表格
mysql -u root -p
use osm;
source /tmp/osm.sql;   # 改成自己的路径
exit;
------------------------------------
osmosis 使用
osmosis --read-xml enableDateParsing=no file="清洗后的路网osm文件" --buffer --write-apidb dbType="mysql" host="数据库服务器IP" database="数据库名" user="用户名" password="密码" validateSchemaVersion=no




