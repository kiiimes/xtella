#!/bin/sh

curl 'http://localhost:9090/api/v1/query_range?query=rate(container_cpu_usage_seconds_total[1m])&start=1626678132&end=1626678193&step=60s' > cpu_usage_seconds.txt
curl 'http://localhost:9090/api/v1/query_range?query=container_cpu_usage_seconds_total&start=1626678132&end=1626678193&step=1s' > cpu_usage_seconds_total.txt

curl 'http://localhost:9090/api/v1/query_range?query=irate(container_network_transmit_bytes_total[1m])*8&start=1626678132&end=1626678193&step=60s' > network_transmit_bps.txt
curl 'http://localhost:9090/api/v1/query_range?query=irate(container_network_receive_bytes_total[1m])*8&start=1626678132&end=1626678193&step=60s' > network_receive_bps.txt
curl 'http://localhost:9090/api/v1/query_range?query=container_network_transmit_bytes_total&start=1626678132&end=1626678193&step=1s' > network_transmit_bytes.txt
curl 'http://localhost:9090/api/v1/query_range?query=container_network_receive_bytes_total&start=1626678132&end=1626678193&step=1s' > network_receive_bytes.txt

curl 'http://localhost:9090/api/v1/query_range?query=rate(container_fs_reads_bytes_total[1m])&start=1626678132&end=1626678193&step=60s' > fs_reads_bytes.txt
curl 'http://localhost:9090/api/v1/query_range?query=container_fs_reads_bytes_total&start=1626678132&end=1626678193&step=1s' > fs_reads_bytes_total.txt

curl 'http://localhost:9090/api/v1/query_range?query=rate(container_fs_writes_bytes_total[1m])&start=1626678132&end=1626678193&step=60s' > fs_writes_bytes.txt
curl 'http://localhost:9090/api/v1/query_range?query=container_fs_writes_bytes_total&start=1626678132&end=1626678193&step=1s' > fs_writes_bytes_total.txt

curl 'http://localhost:9090/api/v1/query_range?query=rate(container_fs_usage_bytes[1m])&start=1626678132&end=1626678193&step=60s' > fs_usage_bytes.txt
curl 'http://localhost:9090/api/v1/query_range?query=container_fs_usage_bytes&start=1626678132&end=1626678193&step=1s' > fs_usage_bytes_total.txt
