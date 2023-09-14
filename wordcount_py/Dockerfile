FROM wxwmatt/hadoop-base:2.1.1-hadoop3.3.1-java8

COPY mapper.py /opt/hadoop/applications/mapper.py
COPY reducer.py /opt/hadoop/applications/reducer.py
# COPY words.txt /opt/hadoop/applications/words.txt

ENV MAPPER_FILEPATH="/opt/hadoop/applications/mapper.py"
ENV REDUCER_FILEPATH="/opt/hadoop/applications/reducer.py"
# ENV WORDS_FILEPATH="/word_count_py/words.txt" TODO

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh", "hadoop dfsadmin -safemode leave"]
