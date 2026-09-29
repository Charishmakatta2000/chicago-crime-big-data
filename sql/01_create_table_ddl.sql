-- 01_create_table_ddl.sql
-- Reproduced from the project's Athena query history ("Initialize_Crime_Schema").
--
-- Custom DDL written after the AWS Glue crawler misfired: it had indexed hidden
-- system files in the S3 bucket, so the first queries returned technical
-- metadata ('hive', 'varchar', ...) instead of crime records.
--
-- Fix strategy (from the project documentation):
--   * Manual CREATE EXTERNAL TABLE using the OpenCSVSerde library, which safely
--     handles CSV text containing commas and quotes.
--   * Every column defined as STRING ("schema-on-read"). The Chicago file has
--     dirty data (e.g. empty coordinate fields); strings guarantee 100%
--     ingestion without numeric parsing crashes. Values are CAST to numbers
--     inside the analysis queries, only where needed.
--
-- Before running: point LOCATION at the S3 folder holding the raw CSV.

CREATE EXTERNAL TABLE IF NOT EXISTS "crimedatabase"."chicago_crime_final" (
  "id" STRING,
  "case_number" STRING,
  "date" STRING,
  "block" STRING,
  "iucr" STRING,
  "primary_type" STRING,
  "description" STRING,
  "location_description" STRING,
  "arrest" STRING,
  "domestic" STRING,
  "beat" STRING,
  "district" STRING,
  "ward" STRING,
  "community_area" STRING,
  "fbi_code" STRING,
  "x_coordinate" STRING,
  "y_coordinate" STRING,
  "year" STRING,
  "updated_on" STRING,
  "latitude" STRING,
  "longitude" STRING,
  "location" STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '"',
  'escapeChar' = '\\'
)
STORED AS TEXTFILE
LOCATION 's3://big-data-final-project-2/<csv-folder>/';
