import snowflake.connector
import os

conn = snowflake.connector.connect(
    account=os.environ["SNOWFLAKE_ACCOUNT"],
    user=os.environ["SNOWFLAKE_USER"],
    password=os.environ["SNOWFLAKE_PASSWORD"],
    database="CRYPTO_DB",
    schema="RAW",
    warehouse=os.environ["SNOWFLAKE_WAREHOUSE"],
    role=os.environ["SNOWFLAKE_ROLE"],
)

cursor = conn.cursor()

# Snowflake tự track file nào đã load rồi → không bị duplicate
cursor.execute("""
    COPY INTO CRYPTO_DB.RAW.ohlcv_raw
    FROM @crypto_s3_stage
    FILE_FORMAT = (TYPE = PARQUET)
    MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
    ON_ERROR = CONTINUE
""")

rows = cursor.fetchall()
for row in rows:
    print(row)

cursor.close()
conn.close()