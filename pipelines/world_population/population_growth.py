from pyspark.sql import SparkSession
from pyspark.sql.window import Window
from pyspark.sql.functions import col, lag

DATASET = "inputs/world_population/world_population_by_year_1950_2023.csv"

print("######### JOB SCOPE BEGINS #########")
with SparkSession.builder.appName("WorldPopulation").getOrCreate() as spark

    print("Reading dataset", repr(DATASET))
    df = spark.read.csv(DATASET)

    print("Melting dataframe...")
    years = list(range(1950, 2024))
    year_stack = ", ".join(f"'{year}', {year}" for year in years)
    f"stack({len(years)}, {year_stack}) as (year, population)"
    
    melted_df = df.selectExpr("country", f"stack({len(years)}, {year_stack}) as (year, population)"")
    
    window_spec = Window.partitionBy("country").orderBy("year")
    
    melted_df = melted_df.withColumn("population_growth", col("population") - lag("population", 1).over(window_spec))

    print("Saving parquet...")
    melted_df.write.parquet("inputs/world_population/world_population_by_year_1950_2023.parquet") 

print("######### JOB SCOPE ENDS #########")