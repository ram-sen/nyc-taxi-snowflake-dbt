{{
    config(
        materialized='incremental',
        unique_key='trip_id'
    )
}}

with trips as (

    select
        {{ dbt_utils.generate_surrogate_key(['vendor_id', 'pickup_at', 'dropoff_at', 'pickup_location_id', 'dropoff_location_id', 'trip_distance', 'fare_amount']) }} as trip_id,
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

    from {{ ref('stg_yellow_tripdata') }}

    {% if is_incremental() %}
    where pickup_at > (select max(pickup_at) from {{ this }})
    {% endif %}

)

select * from trips