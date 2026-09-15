{{ config(severity = 'warn') }}

select *
from {{ ref('fct_trips') }}
where trip_duration_minutes < 0
   or trip_duration_minutes > 1440