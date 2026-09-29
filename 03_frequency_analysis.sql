-- 03_frequency_analysis.sql
-- Reproduced from the project's Athena query history ("Frequency_Analysis").
--
-- Outcome 1 — Frequency & density analysis: which crime types put the most
-- pressure on city resources (patrol and administrative effort).
-- Verified result: THEFT (1,804,952) and BATTERY (1,547,900) lead by far.

SELECT "primary_type", COUNT(*) AS total_reports
FROM "crimedatabase"."chicago_crime_final"
GROUP BY "primary_type"
ORDER BY total_reports DESC;
