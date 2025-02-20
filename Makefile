DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch = 2.1.1-hadoop3.3.1-java8
base:
	docker build -t wxwmatt/hadoop-base:$(current_branch) ./base

build:
	docker build -t wxwmatt/hadoop-release:$(current_branch) ./hadoop-release
	docker build -t wxwmatt/hadoop-base:$(current_branch) ./base
	docker build -t wxwmatt/hadoop-namenode:$(current_branch) ./namenode
	docker build -t wxwmatt/hadoop-datanode:$(current_branch) ./datanode
	docker build -t wxwmatt/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t wxwmatt/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t wxwmatt/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t wxwmatt/hadoop-submit:$(current_branch) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.3.1/README.txt /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -rm -r /input

clear:
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -rm -r /input


wordcount_py_run_test:
	echo "foo foo quux labs foo bar quux" | python ./wordcount_py/mapper.py | sort -k1,1 | python ./wordcount_py/reducer.py

run_wordcount_py:
	docker build -t hadoop-wordcount_py ./wordcount_py
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.3.1/README.txt /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount_py
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --rm -d --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} wxwmatt/hadoop-base:$(current_branch) hdfs dfs -rm -r /input