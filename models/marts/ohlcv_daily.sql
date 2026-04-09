{{ config(materialized='table') }}

with stg as (
    select * from {{ ref('stg_ohlcv') }}
),

daily as (
    select
        symbol,
        date(open_time)             as trade_date,
        min(open_price)             as day_open,
        max(high_price)             as day_high,
        min(low_price)              as day_low,
        max(close_price)            as day_close,
        sum(volume)                 as total_volume,
        sum(trades_count)           as total_trades,
        count(*)                    as candle_count,
        avg(price_change_pct)       as avg_candle_change_pct
    from stg
    group by symbol, date(open_time)
)

select * from daily
