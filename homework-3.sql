-- Creating an external table for fhv-2019 data referring to gcs path

CREATE OR REPLACE EXTERNAL TABLE `rock-groove-339210.nytaxi.external_fhv_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://transfer-service-terraform-ayse/trip data/fhv_tripdata_2019-*.csv']
);

-- Question 1: 
-- What is count for fhv vehicles data for year 2019** 

SELECT COUNT(*) FROM `rock-groove-339210.nytaxi.external_fhv_tripdata`;

-- Answer: 42084899

-- Question 2: 
-- How many distinct dispatching_base_num we have in fhv for 2019**  

SELECT COUNT(DISTINCT(dispatching_base_num)) + 
COUNT(DISTINCT(CASE WHEN dispatching_base_num IS NULL THEN 1 ELSE NULL END))
FROM `rock-groove-339210.nytaxi.external_fhv_tripdata`;

-- Answer: 792

--  Question 3: 
--  Best strategy to optimise if query always filter by dropoff_datetime and order by dispatching_base_num**  

CREATE OR REPLACE TABLE `rock-groove-339210.nytaxi.fhv_tripdata_partitioned_clustered`
PARTITION BY DATE(dropoff_datetime)
CLUSTER BY dispatching_base_num AS 
SELECT * FROM `rock-groove-339210.nytaxi.external_fhv_tripdata`;

-- Answer: Partitioned by dropoff_datetime and clustered by dispatching_base_nume

-- Question 4: 
-- What is the count, estimated and actual data processed for query which counts trip between 2019/01/01 and 2019/03/31
--  for dispatching_base_num B00987, B02060, B02279**  

SELECT COUNT(*) FROM `rock-groove-339210.nytaxi.fhv_tripdata_partitioned_clustered`
WHERE dropoff_datetime BETWEEN '2019-01-01' AND '2019-03-31'
AND dispatching_base_num IN ('B00987', 'B02060', 'B02279');

-- Answer: Count: 26643, Estimated data processed: 400.1 MB, Actual data processed: 147.8 MB


-- Question 5: 
-- What will be the best partitioning or clustering strategy when filtering on dispatching_base_num and SR_Flag**  

-- Answer: Cluster by dispatching_base_num and SR_Flag


-- Question 6: 
-- What improvements can be seen by partitioning and clustering for data size less than 1 GB**  

-- Answer: No improvements, Can be worse due to metadata

-- Question 7: 
-- In which format does BigQuery save data

-- Answer: Columnar




