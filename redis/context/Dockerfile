FROM redis

COPY sentinel.conf /usr/local/etc/redis/sentinel.conf

CMD sed -i "/# config/a   port ${SENTINEL_PROT} " /usr/local/etc/redis/sentinel.conf \
    && sed -i "/# config/a   sentinel parallel-syncs ${CLUSTER_NAME} 1 " /usr/local/etc/redis/sentinel.conf \
    && sed -i "/# config/a   sentinel failover-timeout ${CLUSTER_NAME} 180000 " /usr/local/etc/redis/sentinel.conf \
    && sed -i "/# config/a   sentinel down-after-milliseconds ${CLUSTER_NAME} 30000" /usr/local/etc/redis/sentinel.conf \
    && sed -i "/# config/a   sentinel monitor ${CLUSTER_NAME} ${MASTRE_REDIS_IP} ${MASTRE_REDIS_PORT} ${QUORUM} " /usr/local/etc/redis/sentinel.conf \
    && cat /usr/local/etc/redis/sentinel.conf \
    && redis-server /usr/local/etc/redis/sentinel.conf --sentinel --port ${SENTINEL_PROT} && bash