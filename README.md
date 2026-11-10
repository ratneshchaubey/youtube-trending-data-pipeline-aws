# YouTube Trending Data Pipeline | AWS

An end-to-end AWS Data Engineering project that ingests YouTube Trending Video data across 10 regions, processes it using a Medallion Architecture (Bronze, Silver, Gold), performs data quality validation, and generates analytics-ready datasets.

The workflow is orchestrated using AWS Step Functions, AWS Lambda handles serverless processing, and Amazon SNS supports pipeline notifications.

## Architecture

YouTube Data API v3 / Kaggle Historical Data  
→ Amazon S3 (Bronze)  
→ AWS Glue + PySpark (Silver)  
→ Data Quality Validation  
→ AWS Glue + PySpark (Gold)  
→ Amazon Athena

AWS Step Functions coordinates the workflow, while Amazon EventBridge can be used for scheduled execution.

![Step Functions workflow](images/step-functions-workflow.png)

## Tech Stack

| Category | Technologies |
|---|---|
| Storage | Amazon S3 |
| ETL and Processing | AWS Glue, PySpark |
| Serverless Compute | AWS Lambda |
| Orchestration | AWS Step Functions |
| Scheduling | Amazon EventBridge |
| Data Quality | AWS Lambda |
| Query Engine | Amazon Athena |
| Metadata Catalog | AWS Glue Data Catalog |
| Monitoring and Alerts | Amazon CloudWatch, Amazon SNS |
| Security | AWS IAM |
| Languages | Python, PySpark, SQL |

## Project Structure

```text
youtube-data-pipeline-2026/
├── data/              # Historical datasets and reference data
├── data_quality/      # Data quality validation
├── glue_jobs/         # Bronze-to-Silver and Silver-to-Gold ETL
├── iam_permission/    # IAM policies and permissions
├── lambdas/           # Ingestion and transformation functions
├── scripts/           # Supporting scripts and configuration
├── step_functions/    # Pipeline orchestration
├── images/            # AWS architecture and execution screenshots
└── README.md
```

## Pipeline Workflow

### 1. Bronze Layer – Data Ingestion

- Retrieves trending video and category information using YouTube Data API v3.
- Supports historical Kaggle datasets for backfilling and testing.
- Stores raw JSON and CSV data in Amazon S3, organized by region and ingestion date.

### 2. Silver Layer – Data Transformation

- Processes Bronze data using AWS Glue and PySpark.
- Applies schema enforcement and data type conversions.
- Handles null values, standardizes regional information, and removes duplicates.
- Derives metrics such as like ratio and engagement rate.
- Writes cleansed data in Parquet format.

Reference category data is transformed from JSON to Parquet using AWS Lambda.

### 3. Data Quality Validation

An AWS Lambda function validates Silver layer data before Gold processing. Checks include:

- Minimum row count.
- Null percentage on critical columns.
- Required schema columns.
- Views value sanity checks.
- Data freshness.

Failed validation prevents downstream Gold processing and can trigger an SNS alert.

### 4. Gold Layer – Business Analytics

AWS Glue and PySpark generate three analytics-ready datasets:

| Output table | Description |
|---|---|
| `trending_analytics` | Daily video views, likes, engagement, and regional metrics |
| `channel_analytics` | Channel performance, trending frequency, and rankings |
| `category_analytics` | Category-level views, engagement, and view share |

The Gold datasets are stored in Amazon S3 as Parquet and registered in the AWS Glue Data Catalog for querying through Amazon Athena.

## Step Functions Orchestration

AWS Step Functions coordinates the pipeline execution:

1. Invoke YouTube API ingestion Lambda.
2. Wait for S3 data consistency.
3. Run Silver transformations in parallel:
   - Reference data transformation Lambda.
   - Bronze-to-Silver AWS Glue job.
4. Run data quality validation.
5. Evaluate the data quality result.
6. Run the Silver-to-Gold AWS Glue job when validation passes.
7. Publish a success notification through Amazon SNS.

The workflow also includes failure-handling paths for ingestion, transformation, data quality, and Gold processing.

## Project Execution Screenshots

### 1. Step Functions – End-to-End Workflow

The execution graph shows the ingestion step, parallel Silver processing, data quality evaluation, Gold transformation, and the success notification path.

![Step Functions execution graph](images/step-functions-workflow.png)

### 2. Amazon S3 – Storage Buckets

The S3 console screenshot shows the project buckets for Bronze, Silver, Gold, Glue scripts/assets, and Athena query results in the Asia Pacific (Sydney) region.

![Amazon S3 buckets](images/s3-buckets.png)

### 3. AWS Glue – ETL Jobs

The Glue console lists the two ETL jobs used for the Bronze-to-Silver and Silver-to-Gold transformations.

![AWS Glue ETL jobs](images/glue-jobs.png)

### 4. AWS Lambda – Serverless Functions

The Lambda console lists the three project functions:

- `yt-data-pipeline-youtube-ingestion-dev`
- `yt-data-pipeline-json-to-parquet-dev`
- `yt-data-pipeline-data-quality-dev`

![AWS Lambda functions](images/lambda-functions.png)

### 5. Amazon Athena – SQL Analytics

The Athena screenshot shows a completed SQL query that groups trending analytics by region and calculates data points, average engagement, and cumulative views.

![Amazon Athena query](images/athena-query.png)

## Supported Regions

United States (US), United Kingdom (GB), Canada (CA), Germany (DE), France (FR), India (IN), Japan (JP), South Korea (KR), Mexico (MX), and Russia (RU).

## Key Features

- Multi-region YouTube trending data ingestion.
- Bronze, Silver, and Gold Medallion Architecture.
- PySpark-based ETL transformations using AWS Glue.
- Data cleansing, deduplication, and derived metrics.
- Data quality validation before Gold processing.
- Parallel workflow orchestration with AWS Step Functions.
- SNS notifications and failure-handling paths.
- Analytics-ready Trending, Channel, and Category datasets.
- SQL-based analytics using Amazon Athena.

## Project Outcome

Implemented an AWS-based data pipeline that transforms raw YouTube trending data into analytics-ready datasets using cloud-native data engineering services, with workflow orchestration and data quality validation.

## Data Sources

- YouTube Data API v3 – trending video and category data.
- Kaggle YouTube Trending Dataset – historical data for backfilling and testing.

