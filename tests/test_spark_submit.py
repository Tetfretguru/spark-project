import logging

from pyspark.sql import SparkSession

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("TestApp")


def test_spark_submit():
    spark = SparkSession.builder.appName("TestApp").getOrCreate()

    rdd = spark.sparkContext.parallelize(range(1, 100))

    assert rdd.sum() == 4950
    logger.info("Test passed")
    spark.stop()


test_spark_submit()
