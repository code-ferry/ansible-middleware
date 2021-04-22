## 命令
### 新建topic
```
kafka-topics.sh --create --bootstrap-server host202.example.com:9092,host203.example.com:9092 --replication-factor 1 --partitions 1 --topic test
```
### 生产与消费
```
kafka-console-producer.sh --broker-list host202.example.com:9092,host203.example.com:9092 --topic test
kafka-console-consumer.sh --bootstrap-server host202.example.com:9092,host203.example.com:9092 --topic test --group mygroup
```
### 生产与消费（含SSL）
```
kafka-console-producer.sh --broker-list host202.example.com:9093,host203.example.com:9093 --topic test --producer.config config/producer.properties
kafka-console-consumer.sh --bootstrap-server host202.example.com:9093,host203.example.com:9093 --topic test --group mygroup --consumer.config config/consumer.properties
```

bin/kafka-console-producer.sh --broker-list dap90:9092 --topic test --producer.config config/producer.properties

