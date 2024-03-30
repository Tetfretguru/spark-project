#!/bin/bash

# Recieves the pipeline name as an argument and runs the pipeline, also accept --show flag to show the pipeline
# Usage: ./run_job.sh <pipeline_name> [--show]
# Example: ./run_job.sh my_pipeline --show
# Test: ./run_job.sh test

# Function to show usage information
usage() {
    echo "Usage: $0 <pipeline_name> [--show]"
    echo "Example: $0 my_pipeline --show"
    exit 1
}

# Check if the number of arguments is at least 1
if [ $# -lt 1 ]; then
    usage
fi

# Pipeline name is the first argument
pipeline_name=$1

# Check if the pipeline name is "test"
if [ "$pipeline_name" == "test" ]; then
    docker exec spark-project_spark-worker_1 spark-submit --master spark://spark-master:7077 tests/test_spark_submit.py
    exit 1
fi

# Check if the pipeline exists
if [ ! -f "pipelines/${pipeline_name}.py" ]; then
    echo "Pipeline '$pipeline_name' not found"
    exit 1
fi


# Check if the --show flag is provided
if [ "$2" == "--show" ]; then
    docker exec spark-project_spark-worker_1 spark-submit --master spark://spark-master:7077 $pipeline_name --show
else
    docker exec spark-project_spark-worker_1 spark-submit --master spark://spark-master:7077 $pipeline_name
fi
