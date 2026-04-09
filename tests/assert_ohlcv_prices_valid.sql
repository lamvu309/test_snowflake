-- Test fails if any row has invalid price logic
-- dbt expects this query to return 0 rows

select *
from {{ ref('stg_ohlcv') }}
where
    close_price <= 0
    or open_price <= 0
    or high_price < low_price
    or high_price < open_price
    or high_price < close_price
    or low_price > open_price
    or low_price > close_price
