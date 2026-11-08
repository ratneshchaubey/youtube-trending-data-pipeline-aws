Bronze Bucket Name- youtube-data-pipeline-bronze-india-dev 

Silver Bucket Name- youtube-data-pipeline-silver-india-dev

Gold Bucket Name- youtube-data-pipeline-gold-india-dev

Script Bucket Name- youtube-data-pipeline-scripts-india-dev 

SNS ARN- arn:aws:sns:ap-southeast-2:617394174136:yt-data-pipeline-alerts-dev

Database
Glue Bronze- yt_pipeline_bronze_dev
Glue Silver- yt_pipeline_silver_dev
Glue Gold- yt_pipeline_gold_dev

Glue jobs Parameter
--bronze database- yt_pipeline_bronze_dev
--bronze table- raw_statistics
--silver bucket- youtube-data-pipeline-silver-india-dev
--silver database- yt_pipeline_silver_dev
--silver table- clean_statistics


--silver_database- yt_pipeline_silver_dev
--gold_bucket- youtube-data-pipeline-gold-india-dev
--gold_database- yt_pipeline_gold_dev