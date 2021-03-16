# 概述
学习与工作中经常要安装一些中间件以及应用软件，以及一些环境的准备。  
通过ansible可以实现快速的安装，开发过程可以有更关注于代码实现、源代码分析、业务逻辑理解等更重要的工作。

# ansible脚本的配置
## 应用服务器
本脚本根据ansible.cfg中的inventory配置项信息选择配置文件的地址。  
本脚本以'inventory/cluster201'文件夹下的配置为示例，包括：
* 修改主机配置'hosts'
* 修改全局配置'hosts-configs-all'
* 修改各应用软件配置hosts-configs-xxx

### 修改主机配置'hosts'
配置应用服务器ip地址

### 修改全局配置'hosts-configs-all'
* 修改安装用户，用户组配置等
* 修改初始化操作系统一些配置等，参见'初始化操作系统'章节。
* 修改ansible脚本用到软件下载的目录，示例中用软件   
链接：https://pan.baidu.com/s/1YvgPdBGOPXfEdG7EkXGB7A 
提取码：o9jh

### 修改各应用软件配置hosts-configs-xxx
TODO: 这部分内容补齐。   
通常情况下配置文件common目录下，为了避免同一个中间件不同版本之间配置相互影响。   
比如kafka的不同版本就在目录kafka-0.10，kafka-2.3.0目录下。

根据要安装的软件，修改中间件的配置，如：
* host-config-hadoop
* host-config-hive
* host-config-flink
* host-config-kafka
* host-config-zookeeper
* host-config-etcd
* ...

### 约束说明
最新的脚本只在CentOS 7.5.1804，ansible 2.9.17上做过严格测试。

# 脚本准备工作  
配置公共

bin目录下存放着一些已经简化过的脚本，可以方便脚本的使用。在使用之前先运行如下脚本：
```
./bin/ansible-prepare.sh
```
![prepare-images](./images/prepare-script.png)

## 运行脚本的两种方式
下面的例子以ansible-playbook的命令为主  
方法1：直接采用ansible-playbook的命令  
```
ansible-playbook 01.jdk.yaml -i ./inventory/cluster201/jdk -t install
```
方法2：用简化的命令
```
./bin/role-jdk.sh -t install
```
# 安装准备
## 初始化操作系统(os)
hosts-configs-all中是否设置操作系统的初始化（yes表示开启），接着运行安装命令。

可支持的设置如下：  
* 是否关闭操作系统selinux  
* 是否关闭防火墙  
* 是否修改操作系统最大进程数和最大文件打开数限制  
* 是否修改内核参数  
* 是否进行时钟同步  

运行安装命令：
```
ansible-playbook 01.os.yaml -i ./inventory/cluster201/os -t install
```
## JDK安装
hosts-configs-all中配置jdk_install_home等变量后，运行安装命令。

运行安装命令：
```
ansible-playbook 01.jdk.yaml -i ./inventory/cluster201/jdk -t install
```

## 应用服务器间的免密
脚本支持两种情况：应用服务器之间的相互免密，以及部署服务器到应用服务器的免密
### 应用服务器之间的相互免密
```
ansible-playbook 01.crypo.yaml -i ./inventory/cluster201/crypo -t dispatch
```
### 部署服务器到应用服务器的免密
```
ansible-playbook 01.crypo.yaml -i ./inventory/cluster201/crypo -t deploy-dispatch
```
### 删除部署服务器与应用服务器的.ssh目录下内容
```
ansible-playbook 01.crypo.yaml -i ./inventory/cluster201/crypo -t delete
```

## kerberos的安装
```
# 安装kerberos KDC
ansible-playbook 01.kerberos.yaml -t install
# 创建与初始化kerberos数据库
ansible-playbook 01.kerberos.yaml -t createdb
# 创建与初始化kerberos数据库
ansible-playbook 01.kerberos.yaml -t createkeytab
ansible-playbook 01.kerberos.yaml -t start

# 安装kerberos客户端
ansible-playbook 01.kerberos-client.yaml -t install
```

## ssl的安装
ssl的生成，根据不同的应用对应到不同的inventory目录。比如kafka中ssl的安装对应的就是kafka-ssl目录。
### SSL生成的准备工作
```
# 生成ssl文件存放的目录(-i的参数根据不同的应用进行调整)；如果生成的目录要求root权限，则需要通过参数-b进行提权。
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t prepare
# 或者可以用bin目录下简化shell脚本：
./bin/kafka2-ssl.sh -t prepare
# 需要提权时，命令如下
./bin/kafka2-ssl.sh -t prepare -b
```
### 生成SSL相关文件的操作
```
# 生成CA的私钥、证书（直接在部署机生成，再分发到应用服务器）
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t ca
# 生成服务端、客户端的truststore（直接在部署机生成，再分发到应用服务器）
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t ts
# 生成服务端、客户端的keystore（客户端的keystore直接在部署机生成，再分发到应用服务器；服务端的keystore分别在对应的应用服务器上生成）
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t ks
# 也可以一次性生成CA的私钥、证书；生成服务端、客户端的truststore；生成服务端、客户端的keystore
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t install
```
### 删除SSL相关文件的操作
```
# 删除CA的私钥、证书
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t delete-ca
# 删除服务端、客户端的truststore
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t delete-ts
# 删除服务端、客户端的keystore
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t delete-ks
# 也可以一次性删除CA的私钥、证书；生成服务端、客户端的truststore；生成服务端、客户端的keystore
ansible-playbook 01.ssl.yaml -i ./inventory/cluster201/kafka-ssl -t delete
```

# 应用安装

## flink安装
### 安装步骤
本脚本支持HA
```
ansible-playbook 02.hadoop.yaml -t install 
```
### 启动
```
ansible-playbook 02.hadoop.yaml -t install 
```
### 说明事项
#### 1. 版本调整
修改invertory目录下hosts-configs-flink文件中的配置项
* flink_version
* flink_shaded_hadoop_jar 
##### 比如1.8配置如下
```
flink_version = 1.8.1
flink_shaded_hadoop_jar = "flink-shaded-hadoop-2-uber-2.8.3-8.0.jar"
```
##### 比如1.9配置如下
```
flink_version = 1.9.2
flink_shaded_hadoop_jar = "flink-shaded-hadoop-2-uber-2.8.3-9.0.jar"
```
##### 比如1.10配置如下
```
flink_version = 1.10.0
flink_shaded_hadoop_jar = "flink-shaded-hadoop-2-uber-2.8.3-10.0.jar"
```
#### 2. HA配置说明
flink_ha高可用(HA)的变量，使用时配置zookeeper，不需要时配置NONE，如下
```
# 不采用'高可用'
flink_ha = NONE
# 或者，采用'高可用'
flink_ha = zookeeper
```
flink_ha选择zookeeper，不仅需要配置zk的地址，还需要配置hadoop集群的resource manager（HA的信息存储在hdfs）
```
# hadoop集群的resource manager（HA的信息存储在hdfs）
flink_resource_manager = 192.168.128.201:9000
# 
flink_ha_zookeeper_quorum = 192.168.128.201:2181
```
如果zk不是独立使用的，在zk路径上加上一个数据说明，如
```
flink_ha_zookeeper_quorum = 192.168.128.201:2181/xxxxx
```
#### 3. 开启historyserver
需要开启historyserver时，需要设置flink_run_historyserver为true。  
```
flink_run_historyserver = true
```
## hadoop安装
本脚本支持kb的安装
```
ansible-playbook 02.hadoop.yaml -t install
# 需要提权到root用户下的一些安装步骤，需要通过参数-b进行提权
ansible-playbook 02.hadoop.yaml -t install-root -b
# 格式化datanode
ansible-playbook 02.hadoop.yaml -t format
# 生成yarn的cgroup，用于资源控制，需要通过参数-b进行提权
ansible-playbook 02.hadoop.yaml -t install-cgroup -b
# 启动hadoop
ansible-playbook 02.hadoop.yaml -t start
```

## hive安装
```
ansible-playbook 02.hive.yaml -t install
ansible-playbook 02.hive.yaml -t start
```

## zookeeper安装
```
ansible-playbook 02.hive.yaml -t install
ansible-playbook 02.hive.yaml -t start
```

## kafka安装
### 安装步骤
```
ansible-playbook 02.kafka.yaml -t install
```
### 启动
```
ansible-playbook 02.kafka.yaml -t start 
```
### 创建与删除主题
修改invertory目录下hosts-configs-kafka文件中的配置项
* kafka_topic表示主题名
* kafka_replication表示复本数
* kafka_partition表示分区数  
以上三个配置项是都是列表的结构（用中括号表示），配置项的相同索引位置的配置组合表示一个主题的相关信息。  
如下所示：bigdata主题，有一个复本数，三个分区。  
```
kafka_topic = ['bigdata','test','mytest']
kafka_replication = [1,1,1]
kafka_partition = [3,2,1]
```
运行命令创建
```
# 新建主题
ansible-playbook 02.kafka.yaml -t createtopic
# 删除主题 
ansible-playbook 02.kafka.yaml -t deletetopic 
```
### 其他命令
```
# 停止kafka
ansible-playbook 02.kafka.yaml -t stop 
# 卸载kafka
ansible-playbook 02.kafka.yaml -t uninstall 
```
### 说明事项
#### 1. 版本调整
修改invertory目录下hosts-configs-kafka文件中的配置项，已验证版本1.1.1，2.3.0：
* kafka_version
* kafka_scala_version
#### 2. 部署多个kafka注意事项  
如果两个kafka同时使用一个zookeeper的情况，还要修改如下zk根路径配置，让两个kafka集群的配置不会相互干扰：
* kafka_zk_root

## etcd安装
etcd常用的几个命令
```
# 安装 
ansible-playbook 03.etcd.yaml -i ./inventory/cluster201/ -t install
# 启动
ansible-playbook 03.etcd.yaml -i ./inventory/cluster201/ -t start
# 启动
ansible-playbook 03.etcd.yaml -i ./inventory/cluster201/ -t start
# 卸载
ansible-playbook 03.etcd.yaml -i ./inventory/cluster201/ -t stop
```
etcd也支持备份与恢复。本脚本为了简化只保留一个备份。
```
# 备份。会在部署机的software/snapshot目录下生成snapshot.db文件，用于需要时恢复。
ansible-playbook 03.etcd.yaml -i ./inventory/cluster201/ -t i snapshot
......
......
# 当需要恢复时，可以调用restore命令。
ansible-playbook 03.etcd.yaml -i ./inventory/cluster201/ -t restore
# 恢复后，需要再重新启动下。
ansible-playbook 03.etcd.yaml -i ./inventory/cluster201/ -t start
```

## elasticsearch安装
```
ansible-playbook 03.elasticsearch.yaml -t install
ansible-playbook 03.elasticsearch.yaml -t start
```

# 说明
文档不是很严谨，只是列出了关键步骤，后续有时间逐步完善。  
