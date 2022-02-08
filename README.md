# xTella 내용 정리
## xTella란?
* xTella는 user가 목표로 하는 여러 성능 메트릭(throughput, latency)을 워크로드 특성에 따라 필요로 하는 컴퓨팅 자원을 트레이닝을 통해 예측하여 성능 메트릭을 달성할 수 있도록 하는 연구
	* 여기에서 워크로드는 마이크로서비스에 해당
		* 마이크로서비스란 소프트웨어를 구축하기 위한 아키텍처이자 하나의 접근 방식, 어플리케이션을 상호 독립적인 최소 구성 요소로 분할하여 모든 요소가 독립적으로 연동되어 하나의 기능을 구성하도록 함. 
	* Kubernetes 환경에서 실제 워크로드에 가장 좋은 결과를 내는 학습 모델을 선정하여 최적의 컴퓨팅 자원을 pod에 할당하도록 함. 

## 마이크로서비스의 자원 사용량 특성 분석
* 내가 맡은 역할은 마이크로서비스 자원 사용량의 특성 분석 파트
* 실험을 통해 자원 사용량 raw data를 워크로드 별로 수집 후 워크로드의 마이크로 서비스별 frontend, business logic, backend로 나누어 특성 분석 진행
	* 정리할 지표는 PARTIES 논문, FIRM에 나온 측정 지표 및 툴을 기반으로 함.

## 워크로드 선정 (DeathStarBench)
### DeathStarBench
* 클라우드 마이크로 서비스를 위한 오픈소스 벤치마크
	* 총 5개의 end-to-end service 제공
		* Social network, Media service, Hotel reservation 워크로드 등이 있음. 
* Social network 워크로드 구성은 compose post (13개 마이크로 서비스), read home timeline (2개 마이크로서비스), read user timeline (2개 마이크로서비스)으로 구성.
* Hotel reservation 워크로드의 각 마이크로 서비스는 frontend, business logic, caching & DB 3가지 카테고리로 구성. 
	* 모든 http request는 frontend를 거쳐 전달되고 Search, User, Recommend, Reserve 중 요청하는 서비스에 따라 그 뒤에 실행되는 마이크로 서비스가 달라짐. 
		* Business logic은 컴퓨터 프로그램에서 실세계의 규칙에 따라 데이터를 생성, 표시, 저장, 변경하는 부분을 일컫음. 특히, 데이터베이스, 표시장치 등 프로그램의 다른 부분과 대조되는 개념으로 쓰임
	* caching & DB는 memcached와 mongoDB로 이루어짐. Memcached의 hit, miss 여부에 따라 mongoDB의 접근 여부가 달라짐 
* 워크로드 실행은 wrk라는 http workload generator를 이용하여 thread 수, connection 수, workload 실행 시간 등을 조정하여 실험 가능 

## http load generator (wrk2)
* wrk와 wrk2는 http load generator이다. request는 스케줄에 따라 발송되고, 서버 측의 모든 트래픽은 실제 latency에서 직접 반영되므로 wrk2와 같이 대략적으로 계산할 필요가 없다. Latency reporting은 wrk와 동일.
* 파일에 대한 모든 request의 end-to-end latency를 프린트하려면 -P 파라미터를 추가하고, 파일 수는 thread 수와 동일함. 시간은 1/(target QPS)로 고정된다. 
* 초당 요청수를 지정할 수 있고 기본 값은 1000임. Lua 확장자 파일로 작성.
* 	파라미터 별 설명 [출처; [wrk - 간편하고 가벼운 HTTP 벤치마킹 도구 - 소소한 행복](https://wellstyle.github.io/2020/04/18/wrk-a-HTTP-benchmarking-tool/)]
	* -t20 : Thread 20개 실행
	* -c200 : HTTP Connection 200개를 서버에 연결하고 (각 Thread 별로 10개의 Connection 연결) 
	* -d60s : 60초 동안 지속적으로 트래픽 발생
	* -R : 초당 요청 수 
![AC60946E-64E1-4975-BBCE-3AF77247E7D2](https://user-images.githubusercontent.com/28219985/147912820-a38a290a-ecac-4920-a9fe-9be027909f5a.png)

* 출력 값 설명
	* Latency 61.21ms : 평균 응답시간, 6.23ms : 표준 편차, 최대 값 : 137.15ms, 표준편차 1 범위에 들어가는 확률은 83.66% 를 나타냄	.
		* (Stdev가 낮을 수록 +/- Stdev가 높을 수록 latency가 안정적이라고 봄)
	* 196134 requests in 1.00m, 103.06MB read : 1분 동안 196,314 번의 request를 보냈고, 103.06MB 데이터를 읽었음 
	* Requests/sec : 3263.40 : 초당 3,263 번의 요청을 보내서 응답을 받음.
	* 한 번에 한 URL밖에 실행을 못함 
	* latency 백분위 정보를 plot으로 나타낼 수 있는 사이트도 있음 
	-> [사이트] [HdrHistogram](http://hdrhistogram.org/)

## DeathStarBench를 Kubernetes 환경에서 분산 실행
* 디렉토리 : /mnt/eskim/DeathStarBench_2
	* mount한 디렉토리이므로 아래의 커맨드 실행하여 mount
	`mount -t nfs 10.0.0.23:/mnt/s2 /mnt/eskim`
* DeathStarBench 소스코드는 아래의 커맨드 실행하여 다운
`git clone 	https://github.com/delimitrou/DeathStarBench.git`
	* 해당 소스코드는 다른 브랜치나 tag 없이 commit 하여 버전이 따로 없음
	* 내가 실험을 진행했던 버전은 21년 07월 버전
* Kubernetes 클러스터 구성
	* https://hiseon.me/linux/ubuntu/ubuntu-kubernetes-install/
* 실험 환경
	* 1번, 2번 서버 사용
	* 1번 서버의 master taint 제거 하여 1번과 2번에 pod가 나누어 생성 될 수 있도록 함
	`kubectl taint nodes {해제할 노드 이름} node-role.kubernetes.io/master-`
### SocialNetwork
* SocialNetwork 워크로드의 경우에는 Kubernetes 환경에서 실행할 수 있는 yaml 파일을 제공하지 않음
	* docker 파일을 Kubernetes 형식의 파일로 변경할 수 있는 툴이 있음 
		* Kompose : [링크] https://kompose.io/docs/getting-started.html
		* 하나하나 형식 맞춰가며 변경할 수도 있지만 굉장히 번거로움. kompose도 모든 형식을 지원하는 것은 아니기 때문에 어느 정도의 수정은 필요로 함
* github에서 poanpan이라는 분의 social-network 구성 파일을 clone하여 가져와서 persistent volume의 경로만 수정하여 사용함
	* 디렉토리 : /mnt/eskim/DeathStarBench_others/socialNetwork
* persistent volume 경로 수정 후 아래의 커맨드를 이용하여 pod 분산 실행 가능
	`kubectl create -f k8s-yaml`

### HotelReservation
* hotelReservation 디렉토리에서 아래의 커맨드 실행하여 pod 생성
`kubectl create -f kubernetes_2`
	* 모든 서비스들이 Running 상태로 바뀌었는지 확인해야 함

### wrk load generator 실행 
* 디렉토리 : /mnt/eskim/DeathStarBench_2/hotelReservation/wrk2_lua_scripts
* mixed-workload_type_1.lua 파일에서 local path에 frontend-service의 IP 주소를 기입 (4 군데)
	* 예시 : local path = "http://10.244.2.16:5000/hotels?inDate=" .. in_date_str ..
* wrk load generator 실행 방법
`./wrk -D exp -t <num-threads> -c <num-conns> -d <duration> -L -s ./wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua http://x.x.x.x:5000 -R <reqs-per-sec>`
	* url 부분에는 frontend-service의 ip address가 들어가야 함.
		* 모든 서비스들이 frontend-service를 통해 요청되기 때문

## 실험 환경 및 방법
### 실험 환경
* 2대의 서버 사용
	* 1번 서버 : Intel E5-2650v3 10 cores CPU, 256 memory (Master, untaint)
	* 2번 서버 : Intel E5-2650v3 10 cores CPU, 128 memory (Worker)
	* 10Gbit Ethernet network interface로 연결
### 실험 방법
* server 1개 (2번 서버), client 1개 (1번 서버)를 사용 
* wrk(http load generator)를 이용하여 워크로드 실행, 1분 동안 마이크로서비스별 자원 사용량 측정하였고 총 5회 실험 값의 평균 계산
	* thread 수 : 10, connection 수 : 1000, 초당 request 수 : 60000
`./wrk -D exp -t 10 -c 1000 -d 60 -L -s wrk2_lua_scripts/mixed-workload_type_1.lua http://x.x.x.x:5000 -R 60000`
* 측정 지표 : CPU 사용량, network (tx, rx), disk bandwidth (read, write), LLC & memory bandwidth 
	* LLC & memory bandwidth의 경우 마이크로서비스들의 total 값을 측정하였고 그 외 지표들은 마이크로서비스 별로 측정 하였음
	* 측정 지표는 FIRM 논문과 PARTIES 논문을 기반으로 선정
* 프로메테우스 실행 후 wrk 및 pcm을 함께 실행하여 실험 진행
	* xtella_experiment_2.sh 스크립트 이용하여 실험 진행 
		* 디렉토리 : /mnt/eskim/xtella/experiment/prometheus-2.28.1.linux-amd64
```
#!/bin/sh

time1=`date "+%s"`
echo $time1 >> time.txt
./pcm.x 1 -i=60 -csv=mem_llc_bandwidth.csv
time2=`date "+%s"`
echo $time2 >> time.txt	
```
* wrk 커맨드 실행시 위의 스크립트를 함께 실행
	* 측정 시작 시간을 time.txt에 저장하고 pcm을 이용하여 LLC & memory bandwidth를 측정함
	* 측정 종료 후 측정 종료 시간을 time.txt에 저장함.

* 프로메테우스 측정 지표 저장 방법
	* get_data.sh 스크립트 이용 
		* 디렉토리 : /mnt/eskim/xtella/experiment/prometheus-2.28.1.linux-amd64
```
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
```
* API server에 데이터 값을 요청하여 저장함. 
	* 줄바꿈 기준으로 각 데이터는 다음과 같음
		* CPU usage[1분 평균값] / CPU usage[1초 간격] , network tx/rx[1분 평균 값] / network tx/rx[1초 간격], disk read bytes[1분 평균값]/[1초 간격], disk write bytes[1분 평균값]/[1초 간격], disk usage bytes[1분 평균값]/[1초 간격]
	* start=(start time), end=(end time), step=1s (1초 간격)
		* script에서 생성된 time.txt를 가지고 시작 시간 종료 시간을 변경하여 메트릭 저장
* prometheus data는 data 디렉토리에 저장
* 각 실험 raw data 디렉토리 : experiment_5times 
* 각 메트릭별 정리 방법 : 
	* 프로메테우스에서 메트릭을 저장하면 각 마이크로 서비스별로 얼만큼의 CPU, network, disk 등을 사용했는지 확인 가능
	* CPU usage : 수집한 메트릭 중 1분 평균 값(cpu_usage_seconds.txt)에서 end time 기준으로 CPU usage 정리 -> 서버가 10개 코어 이므로 1000% 기준으로 정리 (1개 core == 100%)
	* network tx / rx : 수집한 메트릭 중 1초 간격으로 측정한 값(network_transmit_bytes.txt, network_receive_bytes.txt)에서 1초 간격으로 측정한 값은 누적 값이므로 현재 bytes 값에서 이전 초 bytes 값을 빼서 현재 보내진 bytes 를 구하고 평균을 내서 초당 byte 수를 구할 수 있음 -> 이를 Mbps로 변환함
	* disk bandwidth (read / write) : 수집한 메트릭 중 1분 평균 값(fs_reads_bytes.txt, fs_writes_bytes.txt)에서 end time 기준으로 disk bandwidth (read / write) 정리  -> 이를 KB/s 로 변환함
	* LLC & memory bandwidth : PCM으로 수집한 결과는 전체 core의 memory, LLC bandwidth  또는 각 core 별 memory, LLC bandwidth를 얻을 수 있음. 전체 core의 memory, LLC bandwidth를 측정. LLC bandwidth는 1초 당 Socket0의 L3OCC 값의 1분 평균, memory bandwidth는 1초 당 Socker0의 READ, WRITE 값의 1분 평균을 각각 구한 합 -> LLC bandwidth의 단위는 Mbps(변환 필요), memory Bandwidth는 Gbps 

### 실험 툴 정리
* CPU, network (tx, rx), disk bandwidth (read, write) 측정 툴
	* prometheus + cadvisor를 이용하여 측정
		* prometheus는 시스템 모니터링을 위한 오픈소스 시스템
		* kubernetes에서도 prometheus를 이용하여 메트릭 수집 가능
		* [🎤 prometheus(프로메테우스) 설치 및 실행](https://velog.io/@ckstn0777/prometheus%ED%94%84%EB%A1%9C%EB%A9%94%ED%85%8C%EC%9A%B0%EC%8A%A4-%EC%84%A4%EC%B9%98-%EB%B0%8F-%EC%8B%A4%ED%96%89)
		* cadvisor는 도커 호스트에 컨테이너로서 실행되는 모니터링 툴로 도커 컨테이너 리소스를 모니터링 가능
		* wrk를 실행시킨 시작 시간 및 종료 시간을 측정하여 해당 기간 만큼의 메트릭을 저장
			*  1초 간격으로 측정하여 총 60초 동안 측정한 결과를 저장

* LLC & memory bandwidth 측정 툴
	* PCM (Processor Counter Monitor) 사용 
		* 실시간 모니터링을 위한 유틸리티, memory bandwidth, llc 등을 확인 가능 
		* pid별 측정은 되지 않고 코어별 전체 시스템에 대해 모니터링 
		* PCM을 사용한 이유
			* Intel RDT(resource development tool) 중 하나인 pqos라는 툴을 이용하여 LLC bandwidth 및 memory bandwidth(==LLC occupancy)를 측정할 수 있지만, perf와 cgroup과 유사한 인터페이스를 사요하기 때문에 RDT와 Linux perf, cgroup을 함께 사용하지 못한다고 함. 
			* cgroup을 사용하지 못하게 되면 kubernetes 환경에서 xtella 실험 시 CPU 예측 값을 넣어 실험할 때 cgroup을 이용하여 CPU 조절을 못하게 됨.
				* 참고로 FIRM과 PARTIES는 pqos 툴을 사용하는데 여기에서는 CPU 사용량 조절을 할 필요가 없었음. 
			* 그리하여, LLC & memory bandwidth는 각 마이크로서비스별로 측정하지 않고 통합으로 측정하는 것으로 결정 -> PCM 이용하여 측정

## 실험 결과
### Hotel reservation 워크로드의 구조
![t937P9Zn54Yu5VQGQ5GamAz6hvQQk12FS_4L7zfdfK9VekNEqjEkYzjTe6z74L_CyedXmpGXFdq6-Rw5J6WzasI2riMzeGiF6vDxkqLVSLgFpSZEffsDW5uartHYuQ8LBH-STdqG](https://user-images.githubusercontent.com/28219985/147912851-3b65c691-332d-481a-aa31-562c313c35a4.png)
* 각 마이크로 서비스는 frontend, business logic, caching & DB 로 구성
* 모든 http request는 frontend를 거쳐 전달되고 Search, User, Recommend, Reserve 중 요청하는 서비스에 따라 그 뒤에 실행되는 마이크로 서비스가 달라짐. 
* caching & DB는 memcached와 mongoDB로 이루어짐. memcached의 hit, miss 여부에 따라 mongoDB의 접근 여부가 달라짐. 
### 실험 결과 요약
![F35D3540-E531-4C98-B856-033A0BD4FE56](https://user-images.githubusercontent.com/28219985/147912891-dc5bc6d7-bd59-44c4-bda5-d84814ed8fb7.png)
![FC0DFF96-6EFC-4B2D-A820-FA4DCBF27E39](https://user-images.githubusercontent.com/28219985/147912895-0ccefc40-f36f-4120-9bdf-052f3f6f4d37.png)
* frontend: 
	* Frontend는 모든 HTTP request가 거쳐가므로 CPU 사용량은 전체 중 33%, 네트워크 처리량은 전체 중 47~55%로 높은 자원 사용량을 보임
* business logic: 
	* Wrk(HTTP load generator)는 DeathStarBench에서 제공하는 workload 스크립트인 workload.lua 파일을 실행하는데 스크립트에서 호출되는 서비스 비율에 따라 CPU 및 네트워크 사용량이 달라짐
	* Search 서비스가 가장 높은 비율(0.6) 으로 서비스 요청이 되어 Search 서비스에서 호출하는 Profile(CPU : 70.77%, 네트워크 : 11Mbps), Geo(CPU : 60.20%, 네트워크 : 3Mbps), Rate(CPU : 68.57%, 네트워크 : 12Mbps) 서비스에서 다른 서비스 대비 높은 CPU 및 네트워크 사용량을 보임
	* Reservation 서비스는 낮은 비율(Recommendation : 0.39, Reservation : 0.005)로 스크립트에서 호출됨에도 예약 정보를 저장하기 위해 MongoDB와 통신하므로 Recommendation 서비스의 자원 사용량(CPU: 33.20%, 네트워크 : 4.35Mbps)을 보임
* caching & DB : 
	* mongoDB는 예약된 정보 및 checkpoint를 파일 시스템에 기록하므로 disk bandwidth (write)가 발생하고 기록된 정보들 중 읽어오는 데이터는 없기 때문에 disk bandwidth (read)는 발생하지 않음
	* memcached의 경우, 데이터를 캐시처리하기 때문에 LLC bandwidth에 영향을 미침

## Trouble shooting 
### DeathStarBench의 grpc error
* 200 ok 가 나와야 하는데 wrk를 실행하였을 때 grpc error가 발생하여 non 2xx, 3xx라는 error가 발생
* jaeger를 실행해서 확인해봤을 때 rpc error = unavailable desc = transient error 를 발견하고 관련하여 찾아봤는데 포트 관련 이야기만 있었음
* 그래서 docker build를 다시 해봐도 에러가 발생하길래 다시 확인해보니 도커 이미지가 이미 있는데도 같은 이름의 이미지를 계속 다운받아서 덮어 씌웠던 것이 문제였음. 
* imagePullPolicy를 Never로 수정하여 build한 이미지를 사용할 수 있도록 함. 
### DeathStarBench timeout error
* timeout error는 기본으로 설정된 wrk의 단일 요청당 대기 시간이 2초인데 대부분의 서비스는 이 2초 안에 처리가 됨. 하지만, 큰 서비스의 경우에는 2초가 넘어갈 수 있기 때문에 이 timeout으로 설정된 시간보다 넘어가면 timeout error가 발생
* 그래서 timeout 시간을 늘리도록 커맨드에 추가하거나 해야됨. 

## 레퍼런스
* FIRM 논문 : https://www.csl.cornell.edu/~delimitrou/papers/2019.asplos.microservices.pdf
* FIRM 소스코드 : [DEPEND / firm · GitLab](https://gitlab.engr.illinois.edu/DEPEND/firm)
* PARTIES 논문 : https://dl.acm.org/doi/pdf/10.1145/3297858.3304005
* PARTIES 소스코드 : [GitHub - sc2682cornell/PARTIES: Scripts and code for PARTIES (ASPLOS’19)](https://github.com/sc2682cornell/PARTIES/tree/main)
* DeathStarBench 소스코드 :  https://github.com/delimitrou/DeathStarBench 
* Prometheus 소스코드 : https://github.com/prometheus/prometheus
* PCM 소스코드 : [GitHub - opcm/pcm: Processor Counter Monitor](https://github.com/opcm/pcm)
