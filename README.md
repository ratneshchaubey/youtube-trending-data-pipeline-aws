# YouTube Trending Data Pipeline (AWS)

An automated, cloud-native ETL pipeline that ingests YouTube trending video data for 10 regions, processes it through a **Bronze → Silver → Gold** medallion architecture, enforces a **data quality gate**, and serves analytics-ready tables through Amazon Athena. Orchestrated end to end with AWS Step Functions.



```
YouTube API v3 / Kaggle ─> S3 Bronze ─> Glue (Silver) ─> DQ Lambda ─> Glue (Gold) ─> Athena
                                                             └─ fail ─> SNS alert (Gold blocked)
```

## Tech Stack

| Area | Tools |
|---|---|
| Storage | Amazon S3 (Parquet) |
| Processing | AWS Glue (PySpark), AWS Lambda (Python, Pandas, AWS Wrangler, Boto3) |
| Orchestration | AWS Step Functions, Amazon EventBridge (every 6 hours) |
| Catalog / Query | Glue Data Catalog, Amazon Athena |
| Monitoring | CloudWatch, SNS, IAM |

## Project Structure

```
├── lambdas/
│   ├── youtube_api_ingestion/   # Fetches trending videos + categories from the YouTube API
│   └── json_to_parquet/         # Converts category mappings to Parquet
├── glue_jobs/
│   ├── bronze_to_silver_statistics.py
│   └── silver_to_gold_analytics.py
├── data_quality/dq_lambda.py    # Data quality gate
├── step_functions/pipeline_orchestration.json
├── iam_permission/              # IAM policies
├── scripts/                     # aws_copy.sh (backfill upload), resource reference
└── data/                        # Kaggle historical CSVs + category ID mappings
```

## How It Works

**Bronze (raw):** The ingestion Lambda pulls the top 50 trending videos per region from the YouTube Data API v3 and stores raw JSON in S3, partitioned by `region/date/hour`. Historical Kaggle CSVs are loaded once for backfill.

**Silver (cleansed):** Two parallel steps:
- *Glue job* unifies API and Kaggle schemas, casts types, handles nulls, deduplicates (latest record per video/region/date), and derives `like_ratio` and `engagement_rate`. Output is Parquet partitioned by region.
- *Lambda* normalizes category mappings to partitioned Parquet.

**Data Quality Gate:** The DQ Lambda validates Silver before anything reaches Gold. On any failure the pipeline halts and SNS sends the details.

| Check | Rule |
|---|---|
| Row count | >= 10 rows |
| Nulls | <= 5% on critical columns |
| Schema | Required columns present |
| Value ranges | Views sanity check |
| Freshness | Latest data < 48 hours old |

**Gold (analytics):** A Glue job builds three partitioned Parquet tables registered in the Glue Data Catalog:

| Table | Contents |
|---|---|
| `trending_analytics` | Daily per-region videos, views, likes, avg like ratio and engagement, unique channels and categories |
| `channel_analytics` | Per-channel views, engagement, times trending, rank within region |
| `category_analytics` | Per-category video count, views, engagement, view share % |

**Orchestration:** Step Functions runs ingestion → Silver transforms (parallel) → DQ gate → Gold → SNS notification, with 3 retries and exponential backoff on each step.

## Design Decisions

- **Sources:** The live YouTube API is the primary source; Kaggle data is used for historical backfill and testing.
- **Idempotency:** Silver deduplicates on (video, region, date), so reruns do not create duplicates. Gold is written with **[overwrite per partition / append]**.
- **Format:** Partitioned Parquet with Snappy for cheap, fast Athena scans.

## Setup

**Prerequisites:** AWS account and CLI, YouTube Data API v3 key, Python 3.12+.

1. Create S3 buckets (`bronze`, `silver`, `gold`, `script`), three Glue databases, and an SNS topic with an email subscription.
2. Upload the Glue scripts to the script bucket and create both Glue jobs (Glue 4.0, G.1X).
3. Deploy the three Lambdas and set their environment variables:

| Lambda | Variables |
|---|---|
| Ingestion | `S3_BUCKET_BRONZE`, `YOUTUBE_REGIONS` (`US,GB,CA,DE,FR,IN,JP,KR,MX,RU`), API key via Secrets Manager / SSM |
| Data quality | `S3_BUCKET_SILVER`, `GLUE_DB_SILVER`, `SNS_ALERT_TOPIC_ARN`, `DQ_MIN_ROW_COUNT`, `DQ_MAX_NULL_PERCENT` |

4. Create the Step Functions state machine from `step_functions/pipeline_orchestration.json`.
5. Schedule it with an EventBridge rule (`rate(6 hours)`), or run manually:

```bash
aws stepfunctions start-execution --state-machine-arn <state-machine-arn>
```

6. *(Optional)* Backfill history: `cd data && bash ../scripts/aws_copy.sh`

## Example Query

```sql
-- Top trending channels in the US
SELECT channel_title, total_views, times_trending
FROM yt_pipeline_gold_dev.channel_analytics
WHERE region = 'US'
ORDER BY total_views DESC
LIMIT 10;
```

## Results

- Sample findings: **[top categories by region]**, **[engagement difference, e.g. US vs IN]**

## Future Improvements

Infrastructure as code (Terraform), CI with unit tests for the Lambdas, Glue Data Quality, and a QuickSight dashboard on the Gold layer.
