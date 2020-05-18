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
根据要安装的软件，修改中间件的配置，如：
* host-config-hadoop
* host-config-hive
* host-config-flink
* host-config-kafka
* host-config-zookeeper
* host-config-etcd
* ...

### 约束说明
本脚本只在centos7上做过严格测试。

# 安装准备
## 初始化操作系统
hosts-configs-all中是否设置操作系统的初始化（yes表示开启），接着运行安装命令。

可支持的设置如下：
* 是否关闭操作系统selinux
* 是否关闭防火墙
* 是否修改操作系统最大进程数和最大文件打开数限制
* 是否修改内核参数
* 是否进行时钟同步  

运行安装命令：
```
ansible-playbook 01.os.yaml -t install
```
## JDK安装
hosts-configs-all中配置jdk_install_home等变量后，运行安装命令。

运行安装命令：
```
ansible-playbook 01.jdk.yaml -t install
```

## 应用服务器间的免密
```
ansible-playbook 01.crypo.yaml -t dispatch
```

## kerberos的安装
```
ansible-playbook 01.kerberos.yaml -t install
ansible-playbook 01.kerberos.yaml -t createdb
ansible-playbook 01.kerberos.yaml -t createkeytab
ansible-playbook 01.kerberos.yaml -t start

ansible-playbook 01.kerberos-client.yaml -t install
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
# 需要提权到root用户下的一些安装步骤
ansible-playbook 02.hadoop.yaml -t install-root -e "ansible_become=true"
# 格式化datanode
ansible-playbook 02.hadoop.yaml -t format
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
```
ansible-playbook 03.etcd.yaml -t install
ansible-playbook 03.etcd.yaml -t start
```

## elasticsearch安装
```
ansible-playbook 03.elasticsearch.yaml -t install
ansible-playbook 03.elasticsearch.yaml -t start
```

# 说明
文档不是很严谨，只是列出了关键步骤，后续有时间逐步完善。