-- Data Engineering Zoomcamp course week-1 homework sql question answers
-- Ayse Arslanargin
-- 2022-01-24


-- Question 3. Count records 
SELECT COUNT(*)
FROM trips
WHERE CAST(tpep_pickup_datetime AS DATE) = '2021-01-15'
LIMIT 100;

-- Question 4. Largest tip for each day
SELECT CAST(tpep_pickup_datetime AS DATE),
    MAX(tip_amount)
FROM trips
GROUP BY CAST(tpep_pickup_datetime AS DATE)
ORDER BY MAX(tip_amount) DESC;

-- Question 5. Most popular destination
SELECT COALESCE(z_pick."Zone", 'Unknown') AS "pickup_zone",
    COALESCE(z_drop."Zone", 'Unknown') AS "dropoff_zone",
    COUNT(t."DOLocationID")
FROM trips t
    JOIN zones z_pick ON t."PULocationID" = z_pick."LocationID"
    JOIN zones z_drop ON t."DOLocationID" = z_drop."LocationID"
WHERE CAST(tpep_pickup_datetime AS DATE) = '2021-01-14'
GROUP BY z_pick."Zone",
    z_drop."Zone"
HAVING z_pick."Zone" = 'Central Park'
ORDER BY COUNT(t."DOLocationID") DESC
LIMIT 1;

-- Question 6. Most expensive locations
SELECT CONCAT(
        COALESCE(z_pick."Zone", 'Unknown'),
        '/',
        COALESCE(z_drop."Zone", 'Unknown')
    ) AS "pick_drop_pair",
    AVG(total_amount)
FROM trips t
    INNER JOIN zones z_pick ON t."PULocationID" = z_pick."LocationID"
    INNER JOIN zones z_drop ON t."DOLocationID" = z_drop."LocationID"
GROUP BY "pick_drop_pair",
    z_pick."Zone",
    z_drop."Zone"
ORDER BY AVG(total_amount) DESC
LIMIT 1;

-- Alternative solution to Question 6

SELECT CONCAT(
        COALESCE(z_pick."Zone", 'Unknown'),
        '/',
        COALESCE(z_drop."Zone", 'Unknown')
    ) AS "pick_drop_pair",
    t.avg
FROM (
        SELECT trips."PULocationID",
            trips."DOLocationID",
            AVG(trips.total_amount)
        FROM trips
        GROUP BY trips."PULocationID",
            trips."DOLocationID"
        ORDER BY AVG(trips.total_amount) DESC
        LIMIT 1
    ) AS t
    INNER JOIN zones z_pick ON t."PULocationID" = z_pick."LocationID"
    INNER JOIN zones z_drop ON t."DOLocationID" = z_drop."LocationID"

