# YouTube Trending Data Pipeline – AWS

## Project Overview
An end-to-end AWS Data Engineering project that ingests YouTube Trending Video data across 10 regions, processes it using a Medallion Architecture (Bronze, Silver, Gold), performs data quality validation, and generates analytics-ready datasets.

## Architecture
YouTube API v3 / Kaggle → Amazon S3 (Bronze) → AWS Glue (Silver) → Data Quality Checks → AWS Glue (Gold) → Amazon Athena

AWS Step Functions orchestrates the workflow, Lambda handles serverless processing, and SNS manages pipeline notifications.

## Tech Stack
- **Storage:** Amazon S3
- **ETL:** AWS Glue, PySpark
- **Compute:** AWS Lambda
- **Orchestration:** AWS Step Functions
- **Scheduling:** Amazon EventBridge
- **Data Quality:** Lambda
- **Query Engine:** Amazon Athena
- **Catalog:** AWS Glue Data Catalog
- **Monitoring & Alerts:** CloudWatch, SNS
- **Security:** AWS IAM
- **Languages:** Python, PySpark, SQL

## Project Structure

```text
├── data/              # Historical datasets and reference data
├── data_quality/      # Data quality validation
├── glue_jobs/         # Bronze-to-Silver and Silver-to-Gold ETL
├── iam_permission/    # IAM policies and permissions
├── lambdas/           # Ingestion and transformation functions
├── scripts/           # Supporting scripts and configuration
└── step_functions/    # Pipeline orchestration
```

## Key Features
- Automated data ingestion across 10 regions.
- Bronze, Silver, and Gold data processing.
- PySpark-based ETL transformations.
- Data cleansing, deduplication, and derived metrics.
- Data quality checks for schema, nulls, row count, and freshness.
- Automated workflow orchestration with retry handling.
- SNS notifications for pipeline success and failures.
- Analytics-ready Trending, Channel, and Category tables.
- SQL-based analytics using Amazon Athena.

## Gold Layer Outputs
- **Trending Analytics:** Daily video views, likes, engagement, and regional metrics.
- **Channel Analytics:** Channel performance, trending frequency, and rankings.
- **Category Analytics:** Category-level views, engagement, and view share.

## Project Outcome
Successfully implemented a scalable, automated AWS data pipeline that transforms raw YouTube data into analytics-ready datasets using cloud-native data engineering services.
