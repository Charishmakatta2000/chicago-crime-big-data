-- 05_arrest_rate_performance.sql
-- Reproduced from the project's Athena query history ("Arrest_Rate_Performance").
--
-- Outcome 3 — Performance metrics (KPIs): arrest rate per crime type, the key
-- law-enforcement effectiveness metric. "arrest" is stored as STRING
-- ('true'/'false'), so CAST + SUM logic converts it for the aggregation.
-- Verified finding: NARCOTICS has a near-100% arrest rate, while other crime
-- types are much lower — showing where enforcement is most/least successful.

SELECT "primary_type",
       COUNT(*) AS total_reports,
       SUM(CASE WHEN CAST("arrest" AS BOOLEAN) THEN 1 ELSE 0 END) AS total_arrests,
       ROUND(100.0 * SUM(CASE WHEN CAST("arrest" AS BOOLEAN) THEN 1 ELSE 0 END) / COUNT(*), 2) AS arrest_rate_pct
FROM "crimedatabase"."chicago_crime_final"
GROUP BY "primary_type"
ORDER BY arrest_rate_pct DESC;
