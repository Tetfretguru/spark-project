import os
import argparse

from pyspark.sql.window import Window
from pyspark.sql.functions import col, lag

from common import spark_session, get_logger, dataframe_to_parquet

INPUTS_DIR = os.getenv("INPUTS_PATH")
OUTPUT_DIR = os.getenv("OUTPUTS_PATH")
APPLICATION = "WorldPopulation"

logger = get_logger(APPLICATION)


def world_population_growth(show: bool = False):
    with spark_session(APPLICATION) as spark:
        source_name = f"{INPUTS_DIR}/world_population/world_population_by_year_1950_2023.csv"

        logger.info("Reading dataset: %s", repr(source_name))
        df = spark.read.csv(source_name, header=True, inferSchema=True)

        logger.info("Melting dataframe...")
        years = list(range(1950, 2024))
        year_population_stack = ", ".join([f"'{year}', `{year}`" for year in years])

        melted_df = df.selectExpr("country", f"stack({len(years)}, {year_population_stack}) as (year, population)")

        window_spec = Window.partitionBy("country").orderBy("year")
        melted_df = melted_df.withColumn("population_growth", col("population") - lag("population", 1).over(window_spec))

        if show:
            melted_df.show()

        logger.info("Saving parquet...")
        dataframe_to_parquet(melted_df, f"{OUTPUT_DIR}/world_population/world_population_growth.parquet")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="World population growth")
    parser.add_argument("--show", action="store_true", help="Show dataframe", default=False)
    args = parser.parse_args()

    world_population_growth(args.show)
