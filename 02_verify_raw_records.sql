-- 02_verify_raw_records.sql
-- Reproduced from the project's Athena query history ("Verify_Raw_Records").
--
-- Data validation: run right after the DDL fix to prove the schema-on-read
-- mapping is correct. Real crime records (e.g. "THEFT", "DECEPTIVE PRACTICE")
-- must appear, perfectly aligned in their columns.

SELECT * FROM "crimedatabase"."chicago_crime_final" LIMIT 10;
