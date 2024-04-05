#!/bin/bash


create-env() {
    conda create -n spark-project python=3.8
    conda activate spark-project -y
    conda install pyspark==3.3.0 -y
    conda install jupyterlab -y
    conda intall matplotlib -y
}

start() {
    _start() {
        mkdir -p inputs
        mkdir -p outputs
        echo "Creating inputs and outputs directories and initializing docker containers..."
        docker-compose up -d --remove-orphans
        echo "Docker containers are up and running!"
    }
    # Check if the spark-project conda environment exists
    if conda env list | grep -q "spark-project"; then
        echo "The spark-project conda environment already exists."
        _start
    else
        echo "The spark-project conda environment does not exist."
        read -p "Would you like to create the spark-project conda environment? (y/n) " create_env
        if [ "$create_env" == "y" ]; then
            create-env
            _start
        else
            echo "WARNING: Proceeding without creating the spark-project conda environment."
            _start
        fi
    fi
}

stop() {
    docker-compose down
}

# Recieves the pipeline name as an argument and runs the pipeline, also accept --show flag to show the pipeline
# Usage: ./run_job.sh <pipeline_name> [--show]
# Example: ./run_job.sh my_pipeline --show
# Test: ./run_job.sh test
run() {
    # Function to show usage information
    _usage() {
        echo "Usage: $0 <pipeline_name> [--show]"
        echo "Example: $0 my_pipeline --show"
        exit 1
    }

    # Check if the number of arguments is at least 1
    if [ $# -lt 1 ]; then
        _usage
    fi

    # Pipeline name is the first argument
    pipeline_name=$1

    # Check if the pipeline name is "test"
    if [ "$pipeline_name" == "test" ]; then
        docker exec spark-project_spark-master_1 spark-submit --master spark://spark-master:7077 tests/test_spark_submit.py
        exit 1
    fi

    # Check if the --show flag is provided
    if [ "$2" == "--show" ]; then
        docker exec spark-project_spark-master_1 spark-submit --master spark://spark-master:7077 "${pipeline_name}" --show
    else
        docker exec spark-project_spark-master_1 spark-submit --master spark://spark-master:7077 "${pipeline_name}"
    fi
}

usage() {
    echo "Usage: $0 <start|stop|run>"
    echo "Example: $0 start"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

if [ "$1" == "create-env" ]; then
    create-env
elif [ "$1" == "start" ]; then
    start
elif [ "$1" == "stop" ]; then
    stop
elif [ "$1" == "run" ]; then
    run "${@:2}"
else
    usage
fi