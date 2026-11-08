
# ==========================================
# YouTube Trending Data Pipeline
# Upload Regional Video Statistics CSV Files
# ==========================================

aws s3 cp CAvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=ca/ --region ap-southeast-2
aws s3 cp DEvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=de/ --region ap-southeast-2
aws s3 cp FRvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=fr/ --region ap-southeast-2
aws s3 cp GBvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=gb/ --region ap-southeast-2
aws s3 cp INvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=in/ --region ap-southeast-2
aws s3 cp JPvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=jp/ --region ap-southeast-2
aws s3 cp KRvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=kr/ --region ap-southeast-2
aws s3 cp MXvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=mx/ --region ap-southeast-2
aws s3 cp RUvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=ru/ --region ap-southeast-2
aws s3 cp USvideos.csv s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics/region=us/ --region ap-southeast-2

# ==========================================
# Upload Category Reference JSON Files
# ==========================================

aws s3 cp CA_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=ca/ --region ap-southeast-2
aws s3 cp DE_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=de/ --region ap-southeast-2
aws s3 cp FR_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=fr/ --region ap-southeast-2
aws s3 cp GB_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=gb/ --region ap-southeast-2
aws s3 cp IN_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=in/ --region ap-southeast-2
aws s3 cp JP_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=jp/ --region ap-southeast-2
aws s3 cp KR_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=kr/ --region ap-southeast-2
aws s3 cp MX_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=mx/ --region ap-southeast-2
aws s3 cp RU_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=ru/ --region ap-southeast-2
aws s3 cp US_category_id.json s3://youtube-data-pipeline-bronze-india-dev/youtube/raw_statistics_reference_data/region=us/ --region ap-southeast-2

Write-Host "All S3 upload commands completed. Check individual results above."
