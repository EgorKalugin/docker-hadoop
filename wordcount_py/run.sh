#!/bin/bash

mapred streaming -file $MAPPER_FILEPATH -mapper $MAPPER_FILEPATH \
 -file $REDUCER_FILEPATH -reducer $REDUCER_FILEPATH \
 -input /input -output /output
