with source as (

    select * from {{ source('raw', 'raw_yellow_tripdata') }}

),

renamed as (

    select
        raw_data:VendorID::integer                                      as vendor_id,
        to_timestamp_ntz(raw_data:tpep_pickup_datetime::number, 6)       as pickup_at,
        to_timestamp_ntz(raw_data:tpep_dropoff_datetime::number, 6)      as dropoff_at,
        raw_data:passenger_count::integer                                as passenger_count,
        raw_data:trip_distance::float                                    as trip_distance,
        raw_data:PULocationID::integer                                   as pickup_location_id,
        raw_data:DOLocationID::integer                                   as dropoff_location_id,
        raw_data:payment_type::integer                                   as payment_type,
        raw_data:fare_amount::float                                      as fare_amount,
        raw_data:tip_amount::float                                       as tip_amount,
        raw_data:total_amount::float                                     as total_amount

    from source

)

select * from renamed