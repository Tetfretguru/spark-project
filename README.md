# About this project

This project is designed to facilitate learning Apache Spark using PySpark, providing a convenient environment for running Spark pipelines. 
It utilizes Spark standalone mode with one master node and two worker nodes, enabling users to explore Spark's distributed computing capabilities. 
The project leverages spark-submit to execute Python Spark jobs, making it easy to submit and monitor Spark applications.

# Prerequisites
* [Required] Docker installed on your machine
* [Required] Docker Compose installed on your machine
* [Recommended] Minicoda or Anaconda installed on your machine. [Click here to download](https://docs.conda.io/en/latest/miniconda.html)
  * If you don't have Miniconda or Anaconda installed, you can use the provided Docker container to run the project.
* [Required] PySpark installed on your machine. [Click here to download](https://spark.apache.org/downloads.html)
  * Skip this if you have your environment set up using Docker or Miniconda/Anaconda.

# Getting Started

### Grant Execution Permissions
Before running the project, grant execution permissions to the `run_job.sh` script:
```bash
chmod +x spark-project.sh
```

### Initial Setup
To start the Docker containers and initialize the necessary directories, run:
```bash
./spark-project.sh start
```

### Running Tests
You can run the test job by executing the following command:
```bash
./spark-project.sh run test
```

### Running Spark Pipeline Job
To run a Spark pipeline, use the following command syntax:
```bash
./spark-project.sh run pipelines/<pipeline_path> [--show]
```
Where `<pipeline_path>` is the path to the Python file containing the Spark pipeline code.
Optionally, use the --show flag to display the pipeline output.

### Stopping the Docker Containers
To stop the Docker containers, run:
```bash
./spark-project.sh stop
```

# Project Structure
```
.
├── inputs/   # Directory containing input data
├── outputs/  # Directory containing output data (generated by Spark jobs)
├── pipelines/  # Directory containing Spark pipeline code
       ├── common.py  # Common functions used across pipelines
├── tests/  # Directory containing test data and test cases
       ├── test_pipeline.py  # Test cases for Spark pipelines
├── docker-compose.yml  # Docker Compose configuration file
├── spark-project.sh  # Bash script for managing the project
...
```

### Pipeline Example
```python
from pyspark.sql import SparkSession


def my_job():
    spark = SparkSession.builder.appName("TestApp").getOrCreate()
    # Your Spark pipeline code here
    spark.stop()
```

### E2E provided pipeline:
```bash
./spark-project.sh run pipelines/world_population_growth.py --show
```

Outputs is saved in `outputs/world_pipulation/world_population_growth.parquet`

# License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.