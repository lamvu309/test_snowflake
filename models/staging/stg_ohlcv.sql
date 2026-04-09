{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'ohlcv_raw') }}
),

renamed as (
    select
        symbol,
        open_time,
        close_time,
        open                                        as open_price,
        high                                        as high_price,
        low                                         as low_price,
        close                                       as close_price,
        volume,
        trades_count,

        -- derived
        close - open                                as price_change,
        round((close - open) / nullif(open, 0) * 100, 4) as price_change_pct,
        high - low                                  as candle_range,
        datediff('minute', open_time, close_time)   as candle_duration_min
    from source
    where open_time is not null
      and symbol is not null
)

select * from renamed
