#!/usr/bin/env bash

docker pull redis:5.0.3
docker pull peihuan/local-sentinel-cluster

# node-1 is default master
cluster_name=hello
redis_node_1_port=6301
redis_node_2_port=6302
redis_node_3_port=6303
sentinel_1_port=26001
sentinel_2_port=26002
sentinel_3_port=26003


local_ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
echo local ip ${local_ip}

# master
echo 'congfig node 1 (default master)'
docker run -it --name redis-node-1 -d -p ${redis_node_1_port}:${redis_node_1_port} redis:5.0.3 redis-server  --port ${redis_node_1_port} --appendonly yes

# node-2
echo 'congfig node 2'
docker run -it --name redis-node-2 -d -p ${redis_node_2_port}:${redis_node_2_port} redis:5.0.3 redis-server  --port ${redis_node_2_port} --appendonly yes --slaveof ${local_ip} ${redis_node_1_port}

# node-3
echo 'congfig node 3'
docker run -it --name redis-node-3 -d -p ${redis_node_3_port}:${redis_node_3_port} redis:5.0.3 redis-server  --port ${redis_node_3_port} --appendonly yes --slaveof ${local_ip} ${redis_node_1_port}

# sentinel 1
echo 'congfig sentinel 1'
docker run -it --name redis-sentinel-1 \
       -p ${sentinel_1_port}:${sentinel_1_port} \
       -e CLUSTER_NAME=${cluster_name} \
       -e MASTRE_REDIS_IP=${local_ip} \
       -e MASTRE_REDIS_PORT=${redis_node_1_port} \
       -e QUORUM=2 \
       -e SENTINEL_PROT=${sentinel_1_port} \
       -d \
       peihuan/local-sentinel-cluster

# sentinel 2
echo 'congfig sentinel 2'
docker run -it --name redis-sentinel-2 \
       -p ${sentinel_2_port}:${sentinel_2_port} \
       -e CLUSTER_NAME=${cluster_name} \
       -e MASTRE_REDIS_IP=${local_ip} \
       -e MASTRE_REDIS_PORT=${redis_node_1_port} \
       -e QUORUM=2 \
       -e SENTINEL_PROT=${sentinel_2_port} \
       -d \
       peihuan/local-sentinel-cluster

# sentinel 3
echo 'congfig sentinel 3'
docker run -it --name redis-sentinel-3 \
       -p ${sentinel_3_port}:${sentinel_3_port} \
       -e CLUSTER_NAME=${cluster_name} \
       -e MASTRE_REDIS_IP=${local_ip} \
       -e MASTRE_REDIS_PORT=${redis_node_1_port} \
       -e QUORUM=2 \
       -e SENTINEL_PROT=${sentinel_3_port} \
       -d \
       peihuan/local-sentinel-cluster