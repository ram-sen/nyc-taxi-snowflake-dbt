{{ config(severity = 'warn') }}

select *
from {{ ref('fct_trips') }}
where fare_amount < 0
  and payment_type not in (3, 4)  -- exclude known refund/dispute/no-charge patterns