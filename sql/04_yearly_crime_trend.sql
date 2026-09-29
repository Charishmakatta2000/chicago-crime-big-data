-- 04_yearly_crime_trend.sql
-- Reproduced from the project's Athena query history ("Yearly_Crime_Trend").
--
-- Outcome 2 — Temporal analysis: crime volume per year from 2001 to the
-- present. Shows the long-term "big data" trend — whether crime is rising or
-- falling — which feeds policy evaluation and historical reporting.
-- "year" is stored as STRING (schema-on-read), so it is cast for ordering.

SELECT CAST("year" AS INTEGER) AS crime_year, COUNT(*) AS total_reports
FROM "crimedatabase"."chicago_crime_final"
GROUP BY "year"
ORDER BY crime_year;
