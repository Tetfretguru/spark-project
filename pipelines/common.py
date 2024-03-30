from contextlib import contextmanager
import logging

from pyspark.sql import SparkSession


@contextmanager
def spark_session(app_name: str):
    spark = SparkSession.builder.appName(app_name).getOrCreate()
    try:
        yield spark
    finally:
        spark.stop()


def get_logger(module_name: str = None):
    # use __name__ from the calling module
    logging.basicConfig(level=logging.INFO)
    return logging.getLogger(module_name if module_name else __name__)


def dataframe_to_parquet(df, path):
    df.write.parquet(path)
