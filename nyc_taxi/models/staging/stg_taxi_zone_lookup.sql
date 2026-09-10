with source as (

    select * from {{ ref('taxi_zone_lookup') }}

),

renamed as (

    select
        locationid::integer   as location_id,
        borough::string       as borough,
        zone::string          as zone,
        service_zone::string  as service_zone

    from source

)

select * from renamed