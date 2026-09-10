with trips as (

    select * from {{ ref('stg_yellow_tripdata') }}

)

select
    vendor_id,
    pickup_at,
    dropoff_at,
    datediff('minute', pickup_at, dropoff_at)  as trip_duration_minutes,
    passenger_count,
    trip_distance,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    tip_amount,
    total_amount

from trips