{{ config(materialized='view') }}

with tripdata as 
(
  select *,
    row_number() over(partition by dispatching_base_num, pickup_datetime)
  from {{ source('staging','fhv_tripdata_external') }}
    where dispatching_base_num is not null
)
select
    -- identifiers
    {{ dbt_utils.surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    cast(pulocationid as integer) as pickup_locationid,
    cast(dolocationid as integer) as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,
    
    -- trip info
    sr_flag,
    dispatching_base_num    

from tripdata


-- dbt build --m <model.sql> --var 'is_test_run: false'
-- {% if var('is_test_run', default=true) %}

--   limit 100

-- {% endif %}
